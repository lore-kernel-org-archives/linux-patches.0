Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBB1431488;
	Thu, 30 Jul 2026 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422474; cv=none; b=JAdHzDzAoy614pKIGCXUtYHYYlvUUL4z5SKcdL8svA59Hkr1I3RKRBeXRMV2XO1NtcyNlA0bE63KotKRYqdIXg6/7ogcMOTuBrsw6jUnYAUf2Cst//klRMX1qruZ/LCGMWGCHtLiUrKNJPTJfi6hr7zdZd2xqKZj3Wty+5NZxB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422474; c=relaxed/simple;
	bh=kFPnW0beEtsn4Y8u7Gx0ekpkQaRR8C+JuLk4a86+LBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/n5b6sIpZbQHG7FmQTY7mupSV0mWkmTv9pjA5lPF73wmcY8h2rXkqEGH0PJ5rHnAz4jTPOQie37MdyzEDe6xuDWVsJVNYV8ssG8rnlTkar7uItxOuMybD/cYntF7TtfaUdPGejdP0pvOgmsxJYFQNiNHZmhFIjo2Cztctx8b8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljNq3K3R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljNq3K3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCA51F000E9;
	Thu, 30 Jul 2026 14:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422473;
	bh=hiT8QmS0bBg2kIFlzfBQ+W9G8teYtr/svhOXiOWoU14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljNq3K3RxwJrile3KHrhOqm3fsQpSUk1XKi+3E61fzgpm8HY5FRjjTxzmNXVWNuob
	 IUUzwqGPrmYrm3BKRkLuVBPWnoWOVu5tDosJsjtuGLio0Q9/liMf3M25XTO3Eml/v0
	 l0vrLlang0pfKT8301S90DYjECfUyt+9epStQwJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 7.1 449/744] drm/amdgpu: Release VFCT ACPI table reference
Date: Thu, 30 Jul 2026 16:12:02 +0200
Message-ID: <20260730141453.840259744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 65bff26617607c1331283232016c0e89088c5b78 upstream.

amdgpu_acpi_vfct_bios() fetches the VFCT table with acpi_get_table()
but never releases it. acpi_get_table() takes a reference on the
table (incrementing its validation_count and mapping it on the 0->1
transition); without a paired acpi_put_table() the mapping is leaked
on every call, whether or not a matching VBIOS image is found.

Route all exit paths after the table is acquired through a common
acpi_put_table(). The VBIOS image is copied out with kmemdup() before
the table is released, so it remains valid for the caller.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patch.msgid.link/20260708193518.702584-3-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ca5988682b4cba4cd125a0fa99b2de1239164ae4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -377,13 +377,14 @@ static bool amdgpu_acpi_vfct_bios(struct
 	acpi_size tbl_size;
 	UEFI_ACPI_VFCT *vfct;
 	unsigned int offset;
+	bool r = false;
 
 	if (!ACPI_SUCCESS(acpi_get_table("VFCT", 1, &hdr)))
 		return false;
 	tbl_size = hdr->length;
 	if (tbl_size < sizeof(UEFI_ACPI_VFCT)) {
 		dev_info(adev->dev, "ACPI VFCT table present but broken (too short #1),skipping\n");
-		return false;
+		goto out;
 	}
 
 	vfct = (UEFI_ACPI_VFCT *)hdr;
@@ -396,13 +397,13 @@ static bool amdgpu_acpi_vfct_bios(struct
 		offset += sizeof(VFCT_IMAGE_HEADER);
 		if (offset > tbl_size) {
 			dev_info(adev->dev, "ACPI VFCT image header truncated,skipping\n");
-			return false;
+			goto out;
 		}
 
 		offset += vhdr->ImageLength;
 		if (offset > tbl_size) {
 			dev_info(adev->dev, "ACPI VFCT image truncated,skipping\n");
-			return false;
+			goto out;
 		}
 
 		if (vhdr->ImageLength &&
@@ -417,15 +418,19 @@ static bool amdgpu_acpi_vfct_bios(struct
 
 			if (!check_atom_bios(adev, vhdr->ImageLength)) {
 				amdgpu_bios_release(adev);
-				return false;
+				goto out;
 			}
 			adev->bios_size = vhdr->ImageLength;
-			return true;
+			r = true;
+			goto out;
 		}
 	}
 
 	dev_info(adev->dev, "ACPI VFCT table present but broken (too short #2),skipping\n");
-	return false;
+
+out:
+	acpi_put_table(hdr);
+	return r;
 }
 #else
 static inline bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)


