Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019C2200CD;
	Mon,  4 Mar 2024 21:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588442; cv=none; b=llfMggAXBu0L68novVSUheuuFpOEYw9L1KQ/7Q9enkhFLABBsr9WYIgDluvMGhrmlhoZBj1lx0HPvsUXzmbJLJZsyGr2kvKqHWtC/CHZNxJshGDuwWuOGeurL/vviM3M7TsENvzTN8VDhkWVWgyKWlt4xYjnIwHJodZzGYE6QNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588442; c=relaxed/simple;
	bh=XjQASu1lE01OguX3stwaMpBwnS7Ji0oPMlMokAp7I3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1rX0gPKozWEVgRHgbZe3Y81jozUOniXErw86UUbb4Vp2AVD9F5MDKuty3PKmaEWTp92qzf4rNu2p4VsZ4kOtS27iYKgMfQ7IjGLFJv/KI+ULTkke6VcXt+Pbcfmv0jv2KZQUeEKZVu+LCOFsbOiTPo01ygNmD6r7p7rQqflUBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/a2tWxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/a2tWxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8891EC433F1;
	Mon,  4 Mar 2024 21:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588441;
	bh=XjQASu1lE01OguX3stwaMpBwnS7Ji0oPMlMokAp7I3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/a2tWxkJw1ljx+DuWYGb2ZYrXMnn/CZBMv7YSKtQv8GWahxBEii0tvJ/Iu0qbHlO
	 q3I7pmfn3Jpt+OSdepaXLsPsUA0op2Bs0SRodLp9MdQ+Wg3JTOUD755Xo8cW7t8zAY
	 HAe68QR+oGhgXiOhTLEZlEmi3dhkn5/ZCI9fJbYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Schumacher <timschumi@gmx.de>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 101/143] efivarfs: Request at most 512 bytes for variable names
Date: Mon,  4 Mar 2024 21:23:41 +0000
Message-ID: <20240304211553.137734231@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/efivarfs/vars.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/fs/efivarfs/vars.c
+++ b/fs/efivarfs/vars.c
@@ -372,7 +372,7 @@ static void dup_variable_bug(efi_char16_
 int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		void *data, bool duplicates, struct list_head *head)
 {
-	unsigned long variable_name_size = 1024;
+	unsigned long variable_name_size = 512;
 	efi_char16_t *variable_name;
 	efi_status_t status;
 	efi_guid_t vendor_guid;
@@ -389,12 +389,13 @@ int efivar_init(int (*func)(efi_char16_t
 		goto free;
 
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
 
 		status = efivar_get_next_variable(&variable_name_size,
 						  variable_name,
@@ -431,9 +432,13 @@ int efivar_init(int (*func)(efi_char16_t
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


