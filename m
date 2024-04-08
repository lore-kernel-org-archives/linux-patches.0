Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057877A15C;
	Mon,  8 Apr 2024 14:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584833; cv=none; b=c/xIg7woKxTSSjAUjRoi/PMnu2DEZ6H0eBTZsntymlnPVuW5IUOGu+v0CMNs0HbDSu8Frt+HfVKOQkxHjjhPwCzW+6kQeONFyr3eucAoAYWoUOW8IKReKZn5SVeZWwWLxhC5uYXPRmzWa/XvYIhymLXsKWvcAcEfBVSoqPNi/is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584833; c=relaxed/simple;
	bh=AdDgtgVKir0MMPIs9G5Hyr5PTPJJ7L1b77fIJ9uoaWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJNAkqVqbfANNZusFlC9Y+6M8IzYRrRkQpi8T8STHEJY7PNK1oQcNUhl4vv/20qhLPiVyE8+t3suUusDU+L4z5A4gAqP+xXqS9m85906rQ1K+dEcX1/6MZWOWQsz/WfCv+P1O2zrYmhYpKYm2cH0mlMdFHezAVBBuVvaF07EKik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ae+YpD1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ae+YpD1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AD3C433F1;
	Mon,  8 Apr 2024 14:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584832;
	bh=AdDgtgVKir0MMPIs9G5Hyr5PTPJJ7L1b77fIJ9uoaWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ae+YpD1HkSB/u5rnAPgIdF/H6svbTodFz7qerkc93zG5gf2Fycva+sSjfOc5W2fbK
	 oXBdbiVFsIrJyVf8fn5uqY7KUEVPTu8B84pIchI7JUhJvTo703+wLIx6Rr9EVAISs3
	 oNb7dt6Q1Po8mp7MhTT2+ZL8Tlmkua+Pz9k3Smt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 572/690] exec: Fix NOMMU linux_binprm::exec in transfer_args_to_stack()
Date: Mon,  8 Apr 2024 14:57:18 +0200
Message-ID: <20240408125420.333409232@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -888,6 +888,7 @@ int transfer_args_to_stack(struct linux_
 			goto out;
 	}
 
+	bprm->exec += *sp_location - MAX_ARG_PAGES * PAGE_SIZE;
 	*sp_location = sp;
 
 out:


