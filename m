Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE2D8BE8;
	Tue, 30 Jul 2024 16:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357262; cv=none; b=a9bqINGWk6wwCRoK3bbGVTKl7oI633bi0ySnmYQ2Ip457Hz2DT7NJnVVIe+tF5uuJqApvNh49ctnK1HaLyleWjPF4VhR9Q1k8+0QHAjIfr5Y1MhQtdswxmuK/s6hNMn5UX+sEy7qho/R4HRbr9rOGgYYYSGfpj/P1UeBTO3WgdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357262; c=relaxed/simple;
	bh=pfB4PnvCEIPb7jsNpNi2o6n5gU6T+3/GL+xAsfM5Ua0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXNulgaWZ0vxoy1xeR2i3P+wCf78B9YJtwKVi7hcy0bl1Jn40T1r78g14vS7TXWvGyvvLuA0ovdYHWxsib98PxEXN/uKdcixjSQKHi6P5lxO4UWRqB0ghdhPQg50iEI5jQAwKMinJnE/4YJzOW6ESxV/Tmet0FrAHX7DaH0sKEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKaDyK9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKaDyK9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9A7C32782;
	Tue, 30 Jul 2024 16:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357262;
	bh=pfB4PnvCEIPb7jsNpNi2o6n5gU6T+3/GL+xAsfM5Ua0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKaDyK9gwuUT2xd5YxhNqzTz21xp0hN0hVyAkI4FuKz60C+2vWCrtoHobeEP+4sOE
	 TIIhhOn4nESFrugU7UGc8AwiJ0+TukNT2TD0qCLkqzs4ruz0fmlhQpJR+eyiQwuoiv
	 mleMkpW0IOMZYC8chI87DI7ueyF8YMKDGG9iZ5oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 274/440] x86/efistub: Avoid returning EFI_SUCCESS on error
Date: Tue, 30 Jul 2024 17:48:27 +0200
Message-ID: <20240730151626.536410547@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit fb318ca0a522295edd6d796fb987e99ec41f0ee5 upstream.

The fail label is only used in a situation where the previous EFI API
call succeeded, and so status will be set to EFI_SUCCESS. Fix this, by
dropping the goto entirely, and call efi_exit() with the correct error
code.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/x86-stub.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -467,16 +467,13 @@ efi_status_t __efiapi efi_pe_entry(efi_h
 	/* Convert unicode cmdline to ascii */
 	cmdline_ptr = efi_convert_cmdline(image, &options_size);
 	if (!cmdline_ptr)
-		goto fail;
+		efi_exit(handle, EFI_OUT_OF_RESOURCES);
 
 	efi_set_u64_split((unsigned long)cmdline_ptr, &hdr->cmd_line_ptr,
 			  &boot_params.ext_cmd_line_ptr);
 
 	efi_stub_entry(handle, sys_table_arg, &boot_params);
 	/* not reached */
-
-fail:
-	efi_exit(handle, status);
 }
 
 static void add_e820ext(struct boot_params *params,


