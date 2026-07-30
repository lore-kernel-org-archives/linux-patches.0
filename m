Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902E243C7A6;
	Thu, 30 Jul 2026 15:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424388; cv=none; b=nC97jp+ltWwu/1l/hK19FR962yoqz7gl/nxubPsWZtOdRcSqi3rRQzsnDcD/2nmU4bUW3LfZWhLunkpYtYtC/gaN8WzYOfPodt6SET764FhrJdUMstfV4Zez2x6XfRV9SDM2wx7FWl2lf27oh1KWkFnauEnl/58qOjMTVVI4SEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424388; c=relaxed/simple;
	bh=vgzghuzz7LPhBfGuCSqYYoyOMzDcG7/IA9b8LmeZqeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPrOO4Lx7tRRZINSVDRP2XP1pDGazF5JnS5kiKn9alFWhA+0bE9136s2s+i9FnmKgtt5NTOT8b4FvVJX6yfX04fSXv8us4vA+0VEXAhBBSzEivXXxjfuf3MoZz8ncpsYpTKf2NVpG6T22u/+zj6fBQ873bZ1NyGBssMSTV/xb8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pT8CJDxR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pT8CJDxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDC61F000E9;
	Thu, 30 Jul 2026 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424387;
	bh=/4+L0YHhezuRSD+is/Sh/645cLBaEqIIjwyX0mfStsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pT8CJDxRiW7c4Y451hneG9UnKqja/OxEwz9Z9GhNY6x6JBFhnzbmFwMOOGJ1XR0q4
	 GNMgTvhQqLivLSArU2qyKkUHgFChvxtMkTokeFn5C5s5cnD0XA4J22dN2c18PDgFIk
	 9l2cfxn/07WX3M4MDWAuB9M9zHwniUfA1KvjM0oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.18 377/675] drm/amdgpu: Release VFCT ACPI table reference
Date: Thu, 30 Jul 2026 16:11:47 +0200
Message-ID: <20260730141453.150252681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -361,13 +361,14 @@ static bool amdgpu_acpi_vfct_bios(struct
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
@@ -380,13 +381,13 @@ static bool amdgpu_acpi_vfct_bios(struct
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
@@ -401,15 +402,19 @@ static bool amdgpu_acpi_vfct_bios(struct
 
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


