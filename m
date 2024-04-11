Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D4B146A90;
	Thu, 11 Apr 2024 10:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830891; cv=none; b=QxDp9X8ae7GOyZm9o4arhJIhSjjSqR4BNFTv50otjHvnjj7D/VGomOKLmLb32+M51dlk8mlnUVffhAmjcRXTKuUDObf4Bkvb3crETLMAvEXU/vI8UQTcrJ/FgbZ9T8EsqKCrdtaUkCye3r1/xe6U6FV9YVyYy9NVlXVu4Ez7qNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830891; c=relaxed/simple;
	bh=A8yYUqrenb/ctc03J5kXKv2bcaZ6AiOMZ0Hb7VJxAOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBpsBNPkPjXJPv+iNkAeBpMDg/leaih3CDnZUc16vTQROnd/VGKjW94EQezmvLdm2x0yoLXmgjxPB71f95iTvf/Cfw3g1BAMWKIG8hfWb4T61sqrqD3Bs+myGZ42DD8DC4ZkprQ2wV2QIQZfgDlJ897h2HnGulQTO/BF4KvUYEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlD5G9EC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlD5G9EC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3C0C433C7;
	Thu, 11 Apr 2024 10:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830891;
	bh=A8yYUqrenb/ctc03J5kXKv2bcaZ6AiOMZ0Hb7VJxAOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlD5G9EC26BHD6o0B1D2SOkLvcOk8Cij2h85qS38waQ/J/weNMEyA675zQBxNh7m/
	 LDdcka+S66ujY0rmpDkpe87SGMcM+KEC3+zimGS/IOm35HUsJIlKiU5pqy1UsULwDb
	 bUx6TkP9dRUlYIq7Y+Mud0VE4AzvlSa5WoqJDq0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 114/215] exec: Fix NOMMU linux_binprm::exec in transfer_args_to_stack()
Date: Thu, 11 Apr 2024 11:55:23 +0200
Message-ID: <20240411095428.333138002@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -836,6 +836,7 @@ int transfer_args_to_stack(struct linux_
 			goto out;
 	}
 
+	bprm->exec += *sp_location - MAX_ARG_PAGES * PAGE_SIZE;
 	*sp_location = sp;
 
 out:


