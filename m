Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403BC37F72E;
	Thu, 20 Aug 2026 15:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238933; cv=none; b=mKWjWKrgk+9rb1tRu4eafBaRqA5VqjZ0w+BB5LVWCAIAKtTCqWWIsq/QPmKWVyUehrR1AxiUs9dvEcRDxtZXiFxScz8Qzti0rFI15KQ1ZR9P1SwtlEIywWeWj5fkDzur74JwGea6OXowp0svv+KyWI1z/YQ+wdLKGqmOVwfjgZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238933; c=relaxed/simple;
	bh=dECMC6ZPsKD8LauQ7nb8IZyWdTISYxrifZUcwRunchc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DG87Y0CZxhfx33MtMS6M9HJ+IaDtxdO6zH5RLsktbuqMYxgnUlQksPqyzezdIFrIbB9tYMoIxerTTvsR6yMIjzmvazXyud6c1wh6NJM+Uv5iTT+inhPIMCtUuccNM38tr71Gx30AXahyXegkTps0UYxpdQQULULcchvuGiNou+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0lFr7oV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0lFr7oV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6440B1F000E9;
	Thu, 20 Aug 2026 15:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238931;
	bh=+e0ZKNRl5U7j0XHnxkJ1UUP+Y//tC99BOaNvnB4LzrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0lFr7oVTilaJFt3JYVRklW4Q1ctykUydUPlpgHGWGEBwP/Vt8W491E3cjrPn3zTm
	 CExzwaLVC/v7lpUMt2A0O2ZBlLRl5GGiNnJP5kHW46MXPtVx5X3J3I9NCfcU+X/6ME
	 8cVUOlDjv9kcaMoglBya6pfi428Toadfymr8Zcos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Paunovic <royalnet026@gmail.com>,
	Satyajit Roy <sroy14@alum.utk.edu>,
	Nathan Lucas <nlucasgit@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 092/217] drm/amd/display: fix BT.2020 YCbCr output CSC matrices for DCE
Date: Thu, 20 Aug 2026 16:54:20 +0200
Message-ID: <20260820145240.520268794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Nathan Lucas <nlucasgit@gmail.com>

commit cd22349e86faf6e15e6c622d70c0efc57d43201e upstream.

The commit cited by the Fixes tag added separate limited and full-range
BT.2020 YCbCr entries to the DCE output CSC tables, but populated both
entries with the same matrix copied from the common DC table. That
matrix combined full-range scaling with limited-range luma offset and was
incorrect for both limited and full-range output.

Replace the coefficients in both entries in the DCE paths with those from
the new COLOR_SPACE_YCBCR2020_LIMITED_TYPE
and COLOR_SPACE_YCBCR2020_FULL_TYPE entries in the preceding commit
("drm/amd/display: fix BT.2020 YCbCr limited output CSC matrix").

Fixes: 51e6668ab4ba ("drm/amd/display: add missing CSC entries for BT.2020 for DCE IPs")
Assisted-by: OpenAI-Codex:GPT-5.6-Sol
Tested-by: Igor Paunovic <royalnet026@gmail.com>
Tested-by: Satyajit Roy <sroy14@alum.utk.edu>
Signed-off-by: Nathan Lucas <nlucasgit@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 14c8726b79d19934d6eb6d35c612e3f7204af2c6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c       |    7 ++++---
 drivers/gpu/drm/amd/display/dc/dce110/dce110_opp_csc_v.c |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
@@ -115,10 +115,11 @@ static const struct out_csc_color_matrix
 	{ 0x2000, 0, 0, 0, 0, 0x2000, 0, 0, 0, 0, 0x2000, 0} },
 { COLOR_SPACE_2020_RGB_LIMITEDRANGE,
 	{ 0x1B67, 0, 0, 0x201, 0, 0x1B67, 0, 0x201, 0, 0, 0x1B67, 0x201} },
-{ COLOR_SPACE_2020_YCBCR_LIMITED, { 0x1000, 0xF149, 0xFEB7, 0x1004, 0x0868,
-	0x15B2, 0x01E6, 0x201, 0xFB88, 0xF478, 0x1000, 0x1004} },
+/* COLOR_SPACE_2020_YCBCR_* values corrected. Not included in the TODO above. */
+{ COLOR_SPACE_2020_YCBCR_LIMITED, { 0x0E04, 0xF31D, 0xFEDF, 0x1004, 0x0733,
+	0x1294, 0x01A0, 0x201, 0xFC16, 0xF5E6, 0x0E04, 0x1004} },
 { COLOR_SPACE_2020_YCBCR_FULL, { 0x1000, 0xF149, 0xFEB7, 0x1004, 0x0868, 0x15B2,
-	0x01E6, 0x201, 0xFB88, 0xF478, 0x1000, 0x1004} }
+	0x01E6, 0, 0xFB88, 0xF478, 0x1000, 0x1004} }
 };
 
 static bool setup_scaling_configuration(
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_opp_csc_v.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_opp_csc_v.c
@@ -93,10 +93,11 @@ static const struct out_csc_color_matrix
 	{ 0x2000, 0, 0, 0, 0, 0x2000, 0, 0, 0, 0, 0x2000, 0} },
 { COLOR_SPACE_2020_RGB_LIMITEDRANGE,
 	{ 0x1B67, 0, 0, 0x201, 0, 0x1B67, 0, 0x201, 0, 0, 0x1B67, 0x201} },
-{ COLOR_SPACE_2020_YCBCR_LIMITED, { 0x1000, 0xF149, 0xFEB7, 0x1004, 0x0868,
-	0x15B2, 0x01E6, 0x201, 0xFB88, 0xF478, 0x1000, 0x1004} },
+/* COLOR_SPACE_2020_YCBCR_* values corrected. Not included in the TODO above. */
+{ COLOR_SPACE_2020_YCBCR_LIMITED, { 0x0E04, 0xF31D, 0xFEDF, 0x1004, 0x0733,
+	0x1294, 0x01A0, 0x201, 0xFC16, 0xF5E6, 0x0E04, 0x1004} },
 { COLOR_SPACE_2020_YCBCR_FULL, { 0x1000, 0xF149, 0xFEB7, 0x1004, 0x0868, 0x15B2,
-	0x01E6, 0x201, 0xFB88, 0xF478, 0x1000, 0x1004} }
+	0x01E6, 0, 0xFB88, 0xF478, 0x1000, 0x1004} }
 };
 
 enum csc_color_mode {


