Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACBF3C07A;
	Thu, 20 Aug 2026 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239531; cv=none; b=q5SyYkkUyrXwk0w4b5rH6GuAijIrXxzmOpG1uFLS6LCWrJaaYQYI5B/aaqQYjqqJjc5PALXmYMDxbk5P2vlyZcfxNfoOyEYE5OItrWQ1oty/zdYLxF3v1Z5GVf5wQVLiRnsJiLze23/Ld660wfhbl3mx5d/0JkmakgyZXnsQco8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239531; c=relaxed/simple;
	bh=QydmORL4xYtya3aEW5JypXNQ0VdBU0ulWosQuILEqsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJtZGkiCRP8+cHBbWt0uLNZVWMYop43taYEqqaLX8oYHd77m3Hav70nrFm42RZeQj/TcebK6i29ncKUJIzyM3gu4TLtWhosFsAwza/wBxat5PAA+duXqs9hPSvK04zyau+fAqB7POUybl2mP4f78ZvcBieMzJPR/poTUhFFHsf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCbkjLVG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCbkjLVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F98D1F000E9;
	Thu, 20 Aug 2026 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239530;
	bh=XURolEGw71Kb4ozNnzstmFLb6iEilewaE/XL2nGjIj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCbkjLVGRdjf0wXIVDHdu9xP6k6gP5hzO0bB44ew6dFc92X+rf81zodNif8DJMbJT
	 0z6hMlWhTToXjCp/sAxs4sTOJ1nBVAkUlmMkEW0ohEXyfJLDMBTjl5DF1H9hJjmd0a
	 Wm4diRNfxaXX7xehny5Hk7xzNBJN7kUBh04HF5r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Paunovic <royalnet026@gmail.com>,
	Satyajit Roy <sroy14@alum.utk.edu>,
	Nathan Lucas <nlucasgit@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 081/220] drm/amd/display: fix BT.2020 YCbCr output CSC matrices for DCE
Date: Thu, 20 Aug 2026 16:54:31 +0200
Message-ID: <20260820145225.919183925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


