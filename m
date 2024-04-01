Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAB863E;
	Mon,  1 Apr 2024 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990440; cv=none; b=PiRF+RwSHfFjhmhrR3uCdcxl3nNbvojc9h8RB0aEO6Q4kebWWSfbWC4g9YvD2xsscLtM9Jc3dqzHZAL8NQEij/FTEd139PxXVt++IpYVAdsLKnARenzvUI92+ejNsMO0TfqfiAd+LaeUDBaPqAdozu9szM08oT4vu6kzcccjmSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990440; c=relaxed/simple;
	bh=jwhJiLk6twmUVf/L02gB/A+o6ITLxPsWZN70+59VzIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baJMKY7STS0uCtmQnig4RZcT2K8IWeD5fwi4EbWpshrvhBNvoWAmcmXXkNlMF70qyM8gxJ8asdUkvNXkKbkg6vo01uCTKb2v4bwVDJEYFDjXV2MN3lobmEOb+i2580CY1WrnJlktV/m/f81zOwRKB9YpTdXudubOrnmBggNO4iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpegzF1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpegzF1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F3CC433C7;
	Mon,  1 Apr 2024 16:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990439;
	bh=jwhJiLk6twmUVf/L02gB/A+o6ITLxPsWZN70+59VzIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpegzF1EbfSZOIj70JT1+UPpTb6eoP71PaVRLnWkeIwSMnFq5DxFK6vUimJaSX/Uc
	 l5jptS9Q62mhHFmj2reIPIL59FaNCKutngEBc7R1X12+sM/LodZfLlacAhqEVhsfz/
	 mcCrwJkwfli1gBa/U8QLID5NxmbUKcCT+ayC1hkQ=
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
Subject: [PATCH 6.6 353/396] drm/amd/display: Disconnect phantom pipe OPP from OPTC being disabled
Date: Mon,  1 Apr 2024 17:46:42 +0200
Message-ID: <20240401152558.446091398@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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
Stable-dep-of: b4e05bb1dec5 ("drm/amd/display: Clear OPTC mem select on disable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn32/dcn32_optc.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
index b1fcc91b65a32..93592e8051fb7 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
@@ -142,12 +142,6 @@ static bool optc32_disable_crtc(struct timing_generator *optc)
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
@@ -155,6 +149,12 @@ static bool optc32_disable_crtc(struct timing_generator *optc)
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
 
@@ -181,6 +181,13 @@ static void optc32_disable_phantom_otg(struct timing_generator *optc)
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
 
-- 
2.43.0



