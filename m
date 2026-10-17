Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3013A1D01;
	Sat, 17 Oct 2026 17:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259031; cv=none; b=YyTOtEbi2rWCC72ltjVe4il5E9VXWteXxf0e/XEBxzQgELO/D24209yJqu3pxFIds7XbG+VE6Ty07BMTjQk/Vh2d9m9f1fcmcg6e1wNcj6tnR/E4Yf7hpSDAl+yGjYdM8lwFV/+KFV90WTxZCBVivMst60c0EsEq0RDZlMYyHYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259031; c=relaxed/simple;
	bh=7EFts1kiF0jH+wrTeDPIEpKrDyjZyjwPRbwqWntzo2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXfuYP6ILDtX1kGYeS1PPB5SIKef1YLwEYiNV7brPfIimERTQlrlviFmbM1cu5g1In/NckCM4FZFhQhaA6tgOjxPRTO7RttbI+3d9rzH1CG4G7FFZAREgM1im0IIfquZ5NI8OoJRXUaU2rJPTvsrX8FbQP5sE7PdOAbw0BRQeOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZAo8gtP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZAo8gtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87A51F000C4;
	Sat, 17 Oct 2026 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259030;
	bh=Is6PMq8oPEiUWQSV2aHG2D3sYEy2rsyTWNqk2OCXL8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZAo8gtPgcBAGObqq4s3XI5huwI4aKrhuiMDNGzgBwml6Dak0yXGrrfy7yOoF4mBg
	 YPu4OqQf9A+3JGlQGXt/FZsvvr3/znaLyRUmE+UNyPJmYYV7rT4hFFEucc6pDCAOtz
	 cE6gkqUe1/VaQfRx1JurErG2XJMKj2BcdcXMXr+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1079/1674] drm/amdgpu: Release VFCT ACPI table reference
Date: Sat, 17 Oct 2026 17:55:51 +0200
Message-ID: <20261017160458.820171272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 65bff26617607c1331283232016c0e89088c5b78 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index ad90b1dbdb905..1564cc68fab8e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -416,13 +416,14 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
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
@@ -435,13 +436,13 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
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
@@ -452,15 +453,19 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
 
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
-- 
2.53.0



