Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851903FAE19;
	Tue, 25 Aug 2026 13:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665698; cv=none; b=Eu7QMcL+9sWv86dkOpbRY5nYJemUju5lvSQTKxmNfml6k8ZTgq+kYiDk7XuVKmNUa6cz7OfR+5iqOyGwHpVjRNsy7tCf8WyJflE2lgUZ/UXz7r9wmM2tZQSUsiy+D42BofrYsfxAkdQi6AeqNIVL9R0RjPA78nIcwgG/8l+1ac0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665698; c=relaxed/simple;
	bh=YynlBfIOI218aR/XpgGKu5tcODV4b+aVRU6tus0FHUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4nMTXvDOFMNQ4nk87r7kWM9sz1oEEwAPMNM12amWM9/MGVOt5yk7+tTw1f/xWVP7Yk8S30VUAkvAJn0eQcZwedW8a2szxcwyPtoUU4J5GRi9FVfBSRlXj5VZAR28Ar+ta3sgMtNDtdkhVRLzg/vAXxHVsFEYPmnfqilCPzvrCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YexIXNmd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YexIXNmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C39F1F00A3A;
	Tue, 25 Aug 2026 13:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665697;
	bh=irisC69SCi8NqOSV/vcunHaG5MI0tOFrRKaUcI8orVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YexIXNmd1JP2pvQCRdEeY0GE4jmLgAwTw0ShqdtW5Hn4jssw8Mj7amOpEGDQQjnA/
	 cH0jkEAAxj+PGEEOxsSdJCYH//pw9oul4R4gD9MCYUOTnpcXIbl+cpqp5HYLK70yUG
	 jXJFgJgVvOqphkv8turk5HlcTgbayKuLLExvy6WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Paunovic <royalnet026@gmail.com>,
	Satyajit Roy <sroy14@alum.utk.edu>,
	Nathan Lucas <nlucasgit@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 36/87] drm/amd/display: fix BT.2020 YCbCr limited output CSC matrix
Date: Tue, 25 Aug 2026 15:25:59 +0200
Message-ID: <20260825132543.266710703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

From: Nathan Lucas <nlucasgit@gmail.com>

[ Upstream commit 2f9a5c0f018d4a1586ee892f81f1383219676415 ]

COLOR_SPACE_YCBCR2020_TYPE, which is selected for
COLOR_SPACE_2020_YCBCR_LIMITED color_space, has coefficients that are
incorrect for limited-range output. Its luma and chroma scaling is
full-range so output is too bright and colors are incorrect.

COLOR_SPACE_YCBCR2020_TYPE is closer to a full-range conversion matrix with
incorrect luma offset, so correct the luma offset for full-range and rename
it to COLOR_SPACE_YCBCR2020_FULL_TYPE.

Add COLOR_SPACE_YCBCR2020_LIMITED_TYPE with correct scaling and range for
limited-range output.

Fix related functions so COLOR_SPACE_YCBCR2020_LIMITED_TYPE and
COLOR_SPACE_YCBCR2020_FULL_TYPE are correctly selected based on
dc_color_space.

Derivation of both matrices follows ITU-T H.273:

Table 4, MatrixCoefficients 9, BT.2020-NCL weights:
KR = 0.2627, KB = 0.0593, KG = 1 - KR - KB = 0.6780.

Equations 45-47 in matrix form:
            [  KR             KG             KB            0 ]
M2020_NCL = [ -KR/(2(1-KB))  -KG/(2(1-KB))   1/2           0 ]
            [  1/2           -KG/(2(1-KR))  -KB/(2(1-KR))  0 ]
            [  0              0              0             1 ]

Limited and Full transforms based on equations 30-32 and 36-38 with bit
depth 10, normalized by 1023:

            [ 876/1023   0         0         64/1023  ]
MLimited  = [ 0          896/1023  0         512/1023 ]
            [ 0          0         896/1023  512/1023 ]
            [ 0          0         0         1        ]

            [ 1023/1023  0         0         0        ]
    MFull = [ 0          1023/1023 0         512/1023 ]
            [ 0          0         1023/1023 512/1023 ]
            [ 0          0         0         1        ]

M2020_NCL_Limited = MLimited x M2020_NCL
M2020_NCL_Full    = MFull x M2020_NCL

The upper three rows of M2020_NCL_* are stored in CR, Y, CB order. Each
M2020_NCL_* value is stored as Round(value * 8192) in its 16-bit
two's-complement representation.

Fixes: 973a9c810c78 ("drm/amd/display: Fix COLOR_SPACE_YCBCR2020_TYPE matrix")
Assisted-by: OpenAI-Codex:GPT-5.6-Sol
Tested-by: Igor Paunovic <royalnet026@gmail.com>
Tested-by: Satyajit Roy <sroy14@alum.utk.edu>
Signed-off-by: Nathan Lucas <nlucasgit@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3b906e1dc7e3c9ff9f7940f6828b367a6a9ec73c)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c |   31 +++++++++++-------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -47,7 +47,8 @@ enum dc_color_space_type {
 	COLOR_SPACE_RGB_LIMITED_TYPE,
 	COLOR_SPACE_YCBCR601_TYPE,
 	COLOR_SPACE_YCBCR709_TYPE,
-	COLOR_SPACE_YCBCR2020_TYPE,
+	COLOR_SPACE_YCBCR2020_LIMITED_TYPE,
+	COLOR_SPACE_YCBCR2020_FULL_TYPE,
 	COLOR_SPACE_YCBCR601_LIMITED_TYPE,
 	COLOR_SPACE_YCBCR709_LIMITED_TYPE,
 	COLOR_SPACE_YCBCR709_BLACK_TYPE,
@@ -99,9 +100,15 @@ static const struct out_csc_color_matrix
 		{ 0xE00, 0xF349, 0xFEB7, 0x1000,
 		  0x6CE, 0x16E3, 0x24F,  0x200,
 		  0xFCCB, 0xF535, 0xE00, 0x1000} },
-	{ COLOR_SPACE_YCBCR2020_TYPE,
+	/* Corrected. Not included in the TODO above. */
+	{ COLOR_SPACE_YCBCR2020_LIMITED_TYPE,
+		{ 0x0E04, 0xF31D, 0xFEDF, 0x1004,
+		  0x0733, 0x1294, 0x01A0, 0x0201,
+		  0xFC16, 0xF5E6, 0x0E04, 0x1004} },
+	/* Corrected. Not included in the TODO above. */
+	{ COLOR_SPACE_YCBCR2020_FULL_TYPE,
 		{ 0x1000, 0xF149, 0xFEB7, 0x1004,
-		  0x0868, 0x15B2, 0x01E6, 0x201,
+		  0x0868, 0x15B2, 0x01E6, 0,
 		  0xFB88, 0xF478, 0x1000, 0x1004} },
 	{ COLOR_SPACE_YCBCR709_BLACK_TYPE,
 		{ 0x0000, 0x0000, 0x0000, 0x1000,
@@ -168,14 +175,14 @@ static bool is_ycbcr709_type(
 	return ret;
 }
 
-static bool is_ycbcr2020_type(
-	enum dc_color_space color_space)
+static bool is_ycbcr2020_limited_type(enum dc_color_space color_space)
 {
-	bool ret = false;
+	return color_space == COLOR_SPACE_2020_YCBCR_LIMITED;
+}
 
-	if (color_space == COLOR_SPACE_2020_YCBCR_LIMITED || color_space == COLOR_SPACE_2020_YCBCR_FULL)
-		ret = true;
-	return ret;
+static bool is_ycbcr2020_full_type(enum dc_color_space color_space)
+{
+	return color_space == COLOR_SPACE_2020_YCBCR_FULL;
 }
 
 static bool is_ycbcr709_limited_type(
@@ -204,8 +211,10 @@ static enum dc_color_space_type get_colo
 		type = COLOR_SPACE_YCBCR601_LIMITED_TYPE;
 	else if (is_ycbcr709_limited_type(color_space))
 		type = COLOR_SPACE_YCBCR709_LIMITED_TYPE;
-	else if (is_ycbcr2020_type(color_space))
-		type = COLOR_SPACE_YCBCR2020_TYPE;
+	else if (is_ycbcr2020_limited_type(color_space))
+		type = COLOR_SPACE_YCBCR2020_LIMITED_TYPE;
+	else if (is_ycbcr2020_full_type(color_space))
+		type = COLOR_SPACE_YCBCR2020_FULL_TYPE;
 	else if (color_space == COLOR_SPACE_YCBCR709)
 		type = COLOR_SPACE_YCBCR709_BLACK_TYPE;
 	else if (color_space == COLOR_SPACE_YCBCR709_BLACK)


