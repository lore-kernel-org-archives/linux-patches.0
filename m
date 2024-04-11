Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B2779FD;
	Thu, 11 Apr 2024 10:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831877; cv=none; b=FwxZITI1NYhr+9T+HKoAPxoLnvLApQqvaJClMhQDZrKj9Abw5e6xvAMJ0UKlIo/FTHlZZWk7jiRMNUHbaIgy8voFYN1y7RwmlvEOzB9H32C0xb0ek/xXBuYkYjCop5gHHManFhK15cZZJgNPYIfVld1oJdPOTHA6LArSXDKuT30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831877; c=relaxed/simple;
	bh=pa5ifUJVGuZZi/e9KY40uH5azdmCySH5u/dk19D5wqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KssnNJAc9MgdlaAZoGYJENI1Ct07sd02p5wXs+TBAS5tpH2Lz/veT6rsyWuJSNbrfH5hl2x2udCtpcs7YCIFDYiQKHiEhnVDhW7zb4vNC1uY+2W+D60/jVZM8IJgsQZAMxxbrXPugS05FDj/77z9F9Cw5juPmm3w4zc5nHCeGr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hN3uW3Fq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hN3uW3Fq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4F9C433F1;
	Thu, 11 Apr 2024 10:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831877;
	bh=pa5ifUJVGuZZi/e9KY40uH5azdmCySH5u/dk19D5wqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hN3uW3Fq60o9sDUSxYFIGNhM4gku3Dz4HCw7ZRalgleuTiFRj0X9jxFvOQLVxkmhu
	 n7e8CXC/pGxV6Dte1L6qyHhlPlk3IJEbbxEoSil1eDto4FDv9ayK/HraVtWImzRnJl
	 j7YLtqKyMIB+J6P+CMR0GlWwYBAXOIx+jHOm1aSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 157/294] exec: Fix NOMMU linux_binprm::exec in transfer_args_to_stack()
Date: Thu, 11 Apr 2024 11:55:20 +0200
Message-ID: <20240411095440.374192716@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


