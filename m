Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F09157E6A;
	Mon, 29 Jan 2024 17:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548286; cv=none; b=CzyIv8sWtk7MO6PYUA4nGzevAXOhn4xz+WJtUNw5nZwCyVY/NYnhO3XC+YZ0FuZGYBpCa53UqpDRfalO2OUA85bCwr974pfuxree2Pri7U93SRaN2VsP2nynRX03ByqB1wuV1QOtQHQ/i2DbLjs2n9J4caoAvFNNJJRLPcxlapM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548286; c=relaxed/simple;
	bh=TxcpqFbfbTPuzJpH7Oeu9gt6+a5sRyKJk96GTguBTL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CT8FZgwKAjeXMhnDBMYE1SIKhc2UuloejrtQ3U/13KzUhfQj7LkqG9dquN+Sw5ql1rddjQt7+DaKIdyVVqUEFO1wMnJC0Q8OKg5FawB7CGOPcbD34oZsQRugit5kxLHk00YcBSkkL7DeKqt/Ctfc8fMJffjLxeXs9aNFjZ6svlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rC7+tJQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rC7+tJQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD7EC433C7;
	Mon, 29 Jan 2024 17:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548286;
	bh=TxcpqFbfbTPuzJpH7Oeu9gt6+a5sRyKJk96GTguBTL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rC7+tJQYL784vUQy0GMG3eTVTYKmdPq0uaTszOOhYyTX/ZjJ0i2FxnhPP4cpB/qwP
	 u8NsuRnR9guxP5tb7H59S6jjvZ8rVF70I1f94L+OsA3NsFPx+kC0ifgsabuO9fSSy3
	 lKuV5BZl4xSV3YkoP6cucSE508tfK9gyOu6BmNjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	George Shen <george.shen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 298/346] drm/amd/display: Disconnect phantom pipe OPP from OPTC being disabled
Date: Mon, 29 Jan 2024 09:05:29 -0800
Message-ID: <20240129170025.185481862@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Shen <george.shen@amd.com>

[ Upstream commit 7bdbfb4e36e34eb788e44f27666bf0a2b3b90803 ]

[Why]
If an OPP is used for a different OPTC without first being disconnected
from the previous OPTC, unexpected behaviour can occur. This also
applies to phantom pipes, which is what the current logic missed.

[How]
Disconnect OPPs from OPTC for phantom pipes before disabling OTG master.

Also move the disconnection to before the OTG master disable, since the
register is double buffered.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 3ba2a0bfd8cf ("drm/amd/display: Clear OPTC mem select on disable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn32/dcn32_optc.c | 19 +++++++++++++------
 .../gpu/drm/amd/display/dc/dcn35/dcn35_optc.c | 12 ++++++------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
index 91ea0d4da06a..1788eb29474b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
@@ -166,12 +166,6 @@ static bool optc32_disable_crtc(struct timing_generator *optc)
 {
 	struct optc *optc1 = DCN10TG_FROM_TG(optc);
 
-	/* disable otg request until end of the first line
-	 * in the vertical blank region
-	 */
-	REG_UPDATE(OTG_CONTROL,
-			OTG_MASTER_EN, 0);
-
 	REG_UPDATE_5(OPTC_DATA_SOURCE_SELECT,
 			OPTC_SEG0_SRC_SEL, 0xf,
 			OPTC_SEG1_SRC_SEL, 0xf,
@@ -179,6 +173,12 @@ static bool optc32_disable_crtc(struct timing_generator *optc)
 			OPTC_SEG3_SRC_SEL, 0xf,
 			OPTC_NUM_OF_INPUT_SEGMENT, 0);
 
+	/* disable otg request until end of the first line
+	 * in the vertical blank region
+	 */
+	REG_UPDATE(OTG_CONTROL,
+			OTG_MASTER_EN, 0);
+
 	REG_UPDATE(CONTROL,
 			VTG0_ENABLE, 0);
 
@@ -205,6 +205,13 @@ static void optc32_disable_phantom_otg(struct timing_generator *optc)
 {
 	struct optc *optc1 = DCN10TG_FROM_TG(optc);
 
+	REG_UPDATE_5(OPTC_DATA_SOURCE_SELECT,
+			OPTC_SEG0_SRC_SEL, 0xf,
+			OPTC_SEG1_SRC_SEL, 0xf,
+			OPTC_SEG2_SRC_SEL, 0xf,
+			OPTC_SEG3_SRC_SEL, 0xf,
+			OPTC_NUM_OF_INPUT_SEGMENT, 0);
+
 	REG_UPDATE(OTG_CONTROL, OTG_MASTER_EN, 0);
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c b/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c
index 08a59cf449ca..3d6c1b2c2b4d 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c
@@ -138,12 +138,6 @@ static bool optc35_disable_crtc(struct timing_generator *optc)
 {
 	struct optc *optc1 = DCN10TG_FROM_TG(optc);
 
-	/* disable otg request until end of the first line
-	 * in the vertical blank region
-	 */
-	REG_UPDATE(OTG_CONTROL,
-			OTG_MASTER_EN, 0);
-
 	REG_UPDATE_5(OPTC_DATA_SOURCE_SELECT,
 			OPTC_SEG0_SRC_SEL, 0xf,
 			OPTC_SEG1_SRC_SEL, 0xf,
@@ -151,6 +145,12 @@ static bool optc35_disable_crtc(struct timing_generator *optc)
 			OPTC_SEG3_SRC_SEL, 0xf,
 			OPTC_NUM_OF_INPUT_SEGMENT, 0);
 
+	/* disable otg request until end of the first line
+	 * in the vertical blank region
+	 */
+	REG_UPDATE(OTG_CONTROL,
+			OTG_MASTER_EN, 0);
+
 	REG_UPDATE(CONTROL,
 			VTG0_ENABLE, 0);
 
-- 
2.43.0



