Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B26749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52177C433EF;
	Thu, 12 Jan 2023 14:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532387;
	bh=PkUnGoys68mFwGXTPYFUZIY4WKg1Wyb7DiBs2Byqdz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxjBB5LCfTwuI9pclbsxHCcVCrgUdHpfChf24yk4ewQKwcJoXWS3wb3JwrgCJ2F12
	 W+lAE7Di7eOOkwFEErS8RkxN7JjvSizHkRr+sHFd1V3PAQrI3Og+2xn5P1nHMNGjU1
	 je5rHQ02V+zuE5q8vJ1HjbbLbKnkrM1XILgoSoYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hanjun Guo <guohanjun@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/783] drm/radeon: Add the missed acpi_put_table() to fix memory leak
Date: Thu, 12 Jan 2023 14:47:42 +0100
Message-Id: <20230112135531.106863124@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hanjun Guo <guohanjun@huawei.com>

[ Upstream commit 10276a20be1115e1f76c189330da2992df980eee ]

When the radeon driver reads the bios information from ACPI
table in radeon_acpi_vfct_bios(), it misses to call acpi_put_table()
to release the ACPI memory after the init, so add acpi_put_table()
properly to fix the memory leak.

v2: fix text formatting (Alex)

Fixes: 268ba0a99f89 ("drm/radeon: implement ACPI VFCT vbios fetch (v3)")
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_bios.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index bb29cf02974d..34d2cb929c06 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -612,13 +612,14 @@ static bool radeon_acpi_vfct_bios(struct radeon_device *rdev)
 	acpi_size tbl_size;
 	UEFI_ACPI_VFCT *vfct;
 	unsigned offset;
+	bool r = false;
 
 	if (!ACPI_SUCCESS(acpi_get_table("VFCT", 1, &hdr)))
 		return false;
 	tbl_size = hdr->length;
 	if (tbl_size < sizeof(UEFI_ACPI_VFCT)) {
 		DRM_ERROR("ACPI VFCT table present but broken (too short #1)\n");
-		return false;
+		goto out;
 	}
 
 	vfct = (UEFI_ACPI_VFCT *)hdr;
@@ -631,13 +632,13 @@ static bool radeon_acpi_vfct_bios(struct radeon_device *rdev)
 		offset += sizeof(VFCT_IMAGE_HEADER);
 		if (offset > tbl_size) {
 			DRM_ERROR("ACPI VFCT image header truncated\n");
-			return false;
+			goto out;
 		}
 
 		offset += vhdr->ImageLength;
 		if (offset > tbl_size) {
 			DRM_ERROR("ACPI VFCT image truncated\n");
-			return false;
+			goto out;
 		}
 
 		if (vhdr->ImageLength &&
@@ -649,15 +650,18 @@ static bool radeon_acpi_vfct_bios(struct radeon_device *rdev)
 			rdev->bios = kmemdup(&vbios->VbiosContent,
 					     vhdr->ImageLength,
 					     GFP_KERNEL);
+			if (rdev->bios)
+				r = true;
 
-			if (!rdev->bios)
-				return false;
-			return true;
+			goto out;
 		}
 	}
 
 	DRM_ERROR("ACPI VFCT table present but broken (too short #2)\n");
-	return false;
+
+out:
+	acpi_put_table(hdr);
+	return r;
 }
 #else
 static inline bool radeon_acpi_vfct_bios(struct radeon_device *rdev)
-- 
2.35.1



