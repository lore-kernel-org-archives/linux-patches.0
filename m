Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565EC1422C4;
	Thu, 11 Apr 2024 10:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829832; cv=none; b=SelSj7JCeNFdgzNOw1i5a8DMg4Vuquq3T0UGGvszHRmc/JQbi1pAEqKCYYyE/3SwcqRY7MUAPyB/gil7gl8ewxCkasBNPeDE1HY40A1iUTSrRZKMeWlLA+Nl5PPTQhmpyCUtnRqGj3EchzGYDTcTPjWb87TF8UBf0NIaemojUIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829832; c=relaxed/simple;
	bh=gY/ywS09wo5lT7oqShNhI0ZYFETI8848Vyycf0wMdHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRLjCQLUTZiJlIP/5i4X+os6NmzE2XvIqvSjF8qlvHRrrdFsMaklATcUfOqyR0yrVeKSRRGQC8AxYCjCuG+/YdJbQNOyC5RKNLgbbL1w1AOG1kfPFJD9UTlfn0BctfRX2qFJkkICzOTdFUvONgHK4X32sUme8KXHjq+X3UO9PpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlMcldXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlMcldXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDEDC433F1;
	Thu, 11 Apr 2024 10:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829832;
	bh=gY/ywS09wo5lT7oqShNhI0ZYFETI8848Vyycf0wMdHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlMcldXDFOfiGMytwVnfq7w3LyTuoK3VUUWoQa+EknHDTuwNIYeQAynRQ1UCW7iPJ
	 JuNN6Wg+anb2/hUWeMQ5jUzjDhtld5MhhCscWamC2IgDfqBfUVSfM26Ll3UU2IKSKo
	 QAVuOZp53tWA7nuLCFd4DNkG9B6eCc2DAuNQNq9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.19 083/175] exec: Fix NOMMU linux_binprm::exec in transfer_args_to_stack()
Date: Thu, 11 Apr 2024 11:55:06 +0200
Message-ID: <20240411095422.061715739@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit 2aea94ac14d1e0a8ae9e34febebe208213ba72f7 upstream.

In NOMMU kernel the value of linux_binprm::p is the offset inside the
temporary program arguments array maintained in separate pages in the
linux_binprm::page. linux_binprm::exec being a copy of linux_binprm::p
thus must be adjusted when that array is copied to the user stack.
Without that adjustment the value passed by the NOMMU kernel to the ELF
program in the AT_EXECFN entry of the aux array doesn't make any sense
and it may break programs that try to access memory pointed to by that
entry.

Adjust linux_binprm::exec before the successful return from the
transfer_args_to_stack().

Cc: <stable@vger.kernel.org>
Fixes: b6a2fea39318 ("mm: variable length argument support")
Fixes: 5edc2a5123a7 ("binfmt_elf_fdpic: wire up AT_EXECFD, AT_EXECFN, AT_SECURE")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Link: https://lore.kernel.org/r/20240320182607.1472887-1-jcmvbkbc@gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -823,6 +823,7 @@ int transfer_args_to_stack(struct linux_
 			goto out;
 	}
 
+	bprm->exec += *sp_location - MAX_ARG_PAGES * PAGE_SIZE;
 	*sp_location = sp;
 
 out:


