Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B12329CA;
	Mon, 12 Aug 2024 16:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479624; cv=none; b=JbcKIf1uIMGxZ5cUCtrFx1IzeFFhxeKyXizkG0veHHmYsWtppiZUmIeONM3lDW6Mz30MdYx+NlxRb93v8dh7x7nzNL77z40ZDaQt6NdweeMIpihCoxliQjcqEl3TggAnMzISD8uU8X4ROZ96os6omAoBQt5Vy3BH1FN/GtMW6lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479624; c=relaxed/simple;
	bh=6J20SP2mn4hoP/RLrLF/WBD+6ox6kSlhJKFGUfizfnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHpFAVvhMdq4MoioWwyqms9oQtO810xTGmouXydmS3mdL8RxQM0MkCWOI0X94jkapt1IDNBKomLtp0wdLjGlM4HayArbVC6ZxW1PqzspgkCmb8aludaCPVepashn1CgJ0xfDwnJ11FTPevQ3YLQAC7p3INAyfqHbaMt9Qg/ZRAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNq/MRrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNq/MRrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF95BC32782;
	Mon, 12 Aug 2024 16:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479624;
	bh=6J20SP2mn4hoP/RLrLF/WBD+6ox6kSlhJKFGUfizfnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNq/MRrWp1K1GeRncaP24Ock9kgHQ8H9iPRc1oe2tFdPEUX9jBVvXC+XvJVfdc/wP
	 wRw0wq76WSlF5JAndj6HChQZwOmCBmiC6mcJav5KAcSavQEqr7PtU/hbZ4bUfkjBpz
	 HhZMQJ26AIscN7gM2I0TZRRiiNRPB3slqz+Ax5B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Miao Wang <shankerwangmiao@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 144/189] LoongArch: Enable general EFI poweroff method
Date: Mon, 12 Aug 2024 18:03:20 +0200
Message-ID: <20240812160137.685856084@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Wang <shankerwangmiao@gmail.com>

commit e688c220732e518c2eb1639e9ef77d4a9311713c upstream.

efi_shutdown_init() can register a general sys_off handler named
efi_power_off(). Enable this by providing efi_poweroff_required(),
like arm and x86. Since EFI poweroff is also supported on LoongArch,
and the enablement makes the poweroff function usable for hardwares
which lack ACPI S5.

We prefer ACPI poweroff rather than EFI poweroff (like x86), so we only
require EFI poweroff if acpi_gbl_reduced_hardware or acpi_no_s5 is true.

Cc: stable@vger.kernel.org
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/efi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/loongarch/kernel/efi.c
+++ b/arch/loongarch/kernel/efi.c
@@ -66,6 +66,12 @@ void __init efi_runtime_init(void)
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 }
 
+bool efi_poweroff_required(void)
+{
+	return efi_enabled(EFI_RUNTIME_SERVICES) &&
+		(acpi_gbl_reduced_hardware || acpi_no_s5);
+}
+
 unsigned long __initdata screen_info_table = EFI_INVALID_TABLE_ADDR;
 
 static void __init init_screen_info(void)


