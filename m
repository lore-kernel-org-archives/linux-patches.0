Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835051494B8;
	Mon, 12 Aug 2024 16:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480626; cv=none; b=VEIY5wRqcc9pMnHuJuweVO4ovH/Bn0GF4tTl7DzBvZggU0VM2UbyhTnOlmRnEUjQAvt51rDfATbXqZCHYmsoxtTHCi6TWWa3u54GonD9+aS4jUhXYhAZof5RDxqbvsvlVowcZwC9V8QMikzLLddPpVQsauXWabtBnYt6C2VJ9SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480626; c=relaxed/simple;
	bh=xhbd65Vpkoc0j9X+jpYPRkMa0E8hamwDGxADU44cw0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaZTIFSO6/XT1RSWjP9T8PujguSvzfu9feeJ0aixhXUiZH6OaQn9tj7hThLoqCEcxNgRKakLHZfDLHSJUMu/H1r9tPrVGIrkcOwtIQjJkz/qgv95EK7rI8r7UVZGFbHXAt2JgGrPaCBdOAvUnYGpwkKbw5KjlUyNDo4gtYfB2bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/mjq/NO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/mjq/NO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A1BC32782;
	Mon, 12 Aug 2024 16:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480626;
	bh=xhbd65Vpkoc0j9X+jpYPRkMa0E8hamwDGxADU44cw0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/mjq/NOP7yEuj2DDj6ymPXLKnUTiacOBZNUja+XySe+cttc60kdjkrdJik5Z2PX5
	 NbFYaoqLYj72ugzGbjceg3aEQrrCWUoDi//8gHsgpw/LvgEibXYrin5pusaduDl3Zp
	 pTBlgBfHOQzdIIUdq+lPvSBrm6OEAFvm0vGeBgyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Miao Wang <shankerwangmiao@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.10 222/263] LoongArch: Enable general EFI poweroff method
Date: Mon, 12 Aug 2024 18:03:43 +0200
Message-ID: <20240812160155.036295718@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 
 #if defined(CONFIG_SYSFB) || defined(CONFIG_EFI_EARLYCON)


