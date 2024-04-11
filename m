Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81481145345;
	Thu, 11 Apr 2024 10:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829758; cv=none; b=gsj/YK69eCHJR3JbMeZDxnKwwRFuXJATX4vNBBeyIIx1L60AwEKvq07ipvqak4/C2NfVqW6FUrGoQ5sTSSwWwfXt9OggRZJEHGXaGPS/8g3tMGKQxJPg0iNMUGcO5SnNCOK6f89eepy5nfC4K54BXMEMkTmj9W4HZ8m2BxhxSOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829758; c=relaxed/simple;
	bh=msSXkVt2KKowmTsFN7Z98Y7v/mJ2lx64wTB37AVyCYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzU7VBzhfDodADbwsZ5Sb1GlF7Z22lfdAfs/YPvMJCR7aT6aaNs88PHZf+ERsWqbJYwp7jkT5o6euxYw6MI5+LicQV3TAJke36PNtm42fVRIAi7vXfIYR+/hyxMe+v4jxVBByqT19IjP+DKjZxrlk7zLTbZP/xeVJ0V+6gO7SfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJCrGxZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJCrGxZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EF1C43390;
	Thu, 11 Apr 2024 10:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829758;
	bh=msSXkVt2KKowmTsFN7Z98Y7v/mJ2lx64wTB37AVyCYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJCrGxZTBSyyB+QcCsLNk9qxksOf+9tlLe5nmKflUBUuk54Nk5OxDtqK/nyb9oNL5
	 oparV03PNzBxQgJwAVIci9fWi4t1/R3kKeN1cmDKXi+Q+IQ0Ci5h2U7kvcw2Qr+Zbd
	 9Ucj7y/8wUTwTmjGCJtl/X36Zw0aRWDmDGuyMawM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Schumacher <timschumi@gmx.de>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.19 096/175] efivarfs: Request at most 512 bytes for variable names
Date: Thu, 11 Apr 2024 11:55:19 +0200
Message-ID: <20240411095422.457238829@linuxfoundation.org>
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
@@ -440,7 +440,7 @@ int efivar_init(int (*func)(efi_char16_t
 		void *data, bool duplicates, struct list_head *head)
 {
 	const struct efivar_operations *ops;
-	unsigned long variable_name_size = 1024;
+	unsigned long variable_name_size = 512;
 	efi_char16_t *variable_name;
 	efi_status_t status;
 	efi_guid_t vendor_guid;
@@ -463,12 +463,13 @@ int efivar_init(int (*func)(efi_char16_t
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
@@ -512,9 +513,13 @@ int efivar_init(int (*func)(efi_char16_t
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


