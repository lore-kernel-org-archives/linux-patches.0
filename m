Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2417F7CF;
	Mon,  8 Apr 2024 13:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584788; cv=none; b=uUnYgL5aXuIpoy7YasEVzoepr2dGhCQ73fyT1SpYrJKSbcx9QXShxRQF+X6AlvWAl+3RXj9vZG2ZPuJtkIWIGYiXajq7PFJ8AyNjOy33zbkVHDWDIZIB6t5jnTFxXhFHR2vrsbg7lp4jX3gvH0/ZjRRtBYy1wYqBezbLdinrCwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584788; c=relaxed/simple;
	bh=g+rDNstIi7P51QrcVkacs/ZAf5DqbMTWcSvfYgjJewo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cvtm00czF9oAgYgcMhdaPYKVBpERp73XkMyqbMl1f61OJUt2zYnFuR3lppmz6Tm9FUyrHY/k0tHw+mud6+AvgRweDzldUkRHw6XeqVpqe5dUEOkDFCwxnyo90sgDOqeBu5eUrTQJDFb6l/HDtmuorb/keGRobmXOomYUn3qVgaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vr4lcSjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vr4lcSjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03C6C43390;
	Mon,  8 Apr 2024 13:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584788;
	bh=g+rDNstIi7P51QrcVkacs/ZAf5DqbMTWcSvfYgjJewo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vr4lcSjyaQDoJv5IFf8KtbZXOK3uZCnxdAf3AzKfuU/dFBzmuVv6vOFtppqwjDwJt
	 X7iTVi3rcQErb3ljCSbmZBVGDKERwXrWrya/V5uVBdUausWVIGJf2OLSWliMdv9NGJ
	 +Zc6kOnUhnRMdxmCeKy2rux0WEcLEoR2ocL1j8l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Schumacher <timschumi@gmx.de>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.15 558/690] efivarfs: Request at most 512 bytes for variable names
Date: Mon,  8 Apr 2024 14:57:04 +0200
Message-ID: <20240408125419.838967102@linuxfoundation.org>
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

From: Tim Schumacher <timschumi@gmx.de>

commit f45812cc23fb74bef62d4eb8a69fe7218f4b9f2a upstream.

Work around a quirk in a few old (2011-ish) UEFI implementations, where
a call to `GetNextVariableName` with a buffer size larger than 512 bytes
will always return EFI_INVALID_PARAMETER.

There is some lore around EFI variable names being up to 1024 bytes in
size, but this has no basis in the UEFI specification, and the upper
bounds are typically platform specific, and apply to the entire variable
(name plus payload).

Given that Linux does not permit creating files with names longer than
NAME_MAX (255) bytes, 512 bytes (== 256 UTF-16 characters) is a
reasonable limit.

Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Tim Schumacher <timschumi@gmx.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
[timschumi@gmx.de: adjusted diff for changed context and code move]
Signed-off-by: Tim Schumacher <timschumi@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/vars.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -415,7 +415,7 @@ int efivar_init(int (*func)(efi_char16_t
 		void *data, bool duplicates, struct list_head *head)
 {
 	const struct efivar_operations *ops;
-	unsigned long variable_name_size = 1024;
+	unsigned long variable_name_size = 512;
 	efi_char16_t *variable_name;
 	efi_status_t status;
 	efi_guid_t vendor_guid;
@@ -438,12 +438,13 @@ int efivar_init(int (*func)(efi_char16_t
 	}
 
 	/*
-	 * Per EFI spec, the maximum storage allocated for both
-	 * the variable name and variable data is 1024 bytes.
+	 * A small set of old UEFI implementations reject sizes
+	 * above a certain threshold, the lowest seen in the wild
+	 * is 512.
 	 */
 
 	do {
-		variable_name_size = 1024;
+		variable_name_size = 512;
 
 		status = ops->get_next_variable(&variable_name_size,
 						variable_name,
@@ -491,9 +492,13 @@ int efivar_init(int (*func)(efi_char16_t
 			break;
 		case EFI_NOT_FOUND:
 			break;
+		case EFI_BUFFER_TOO_SMALL:
+			pr_warn("efivars: Variable name size exceeds maximum (%lu > 512)\n",
+				variable_name_size);
+			status = EFI_NOT_FOUND;
+			break;
 		default:
-			printk(KERN_WARNING "efivars: get_next_variable: status=%lx\n",
-				status);
+			pr_warn("efivars: get_next_variable: status=%lx\n", status);
 			status = EFI_NOT_FOUND;
 			break;
 		}


