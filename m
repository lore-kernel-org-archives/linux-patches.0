Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AE74596E;
	Mon,  1 Apr 2024 16:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989096; cv=none; b=PN9ZyhKDoP+GKwaUL3HBrzWMGcTFhUsrXKbxQxMN351/MJdLLVI09SoVxPR9OczueNBPd78EyreUBHpAQ8ScrW7LclmxTRsGV27DWymHPdIjC9cyZ0uNdwToDOAhezTvI4/ENgbwwJe8Z08z4xzHp8BAXCjcB59TlKa362yFnQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989096; c=relaxed/simple;
	bh=5OW/yPxCA2atmX09UF+deHocdDoQ7Ns25knZecGrfJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfAgRZajcU0FQKIeD/Y4QcX9xlKI/jiToLsaxnBRpwOcIv8M3Mco7Hw1Yln3DLGqTVTm1A9hmaJXMxAMA3E+h05knl3sOfpHOdcm+q/tAWQ2cqzJ3h5aEr7ucc5Q5Mq+JV6EFNC4A+1kuJqp7RJ9ZlzTkwgwEq1o5NnGMbaMNJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBg5sfuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBg5sfuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07245C433C7;
	Mon,  1 Apr 2024 16:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989096;
	bh=5OW/yPxCA2atmX09UF+deHocdDoQ7Ns25knZecGrfJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBg5sfuGjwUfjPDFxDaZMyrAugvryjbSqon0ZoIVs74RyKz7F7lo/Q0VDIZihgNPK
	 SQHuNTOcaP6mMYIpHnPyiJ2iQWE4GSHC/eqvafYPa/UZvqQK+rHAEDJ341DHb/JScV
	 qgvsAPV7wK+57w24J3wy002Fbl+Fy4icCbXRE2O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.7 352/432] exec: Fix NOMMU linux_binprm::exec in transfer_args_to_stack()
Date: Mon,  1 Apr 2024 17:45:39 +0200
Message-ID: <20240401152603.747467997@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,6 +894,7 @@ int transfer_args_to_stack(struct linux_
 			goto out;
 	}
 
+	bprm->exec += *sp_location - MAX_ARG_PAGES * PAGE_SIZE;
 	*sp_location = sp;
 
 out:


