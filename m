Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A80515F339;
	Mon, 29 Jan 2024 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548285; cv=none; b=GUXkiTizLwg5jGgv/9vyppw7TimkLhgRVDky6tTGkNmJvMYQE/LgalwIh1cxvYKZ4FgeTAwaWXPpQJLBKfnX7NfnCpnex9anI9xBaWHKZkX6OlZ6Hf+j3j1usesBrf+2NBVsGGq6NxUmjIDU+wEFmNXHAl7uzcKSztNFQps/ba8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548285; c=relaxed/simple;
	bh=kIQjJzqDnHyHIZn5u1Oo3TrFW7j/SlZBJAa29IeuPNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulT/sUGswSibLLnWmgH9zXWPwkWbxC3g3exc9dC8wjm9uytOtoSYD7FFazuYPY9GHqJPtQPIW3eDvaWKjlykx0ZJXHVN3JJ386NnclnzGARr2yijD6nVX/kvVNx8bumQqvi9QWJCs5VBxJK4jCURp/C97XTvNFMgFw2Vvh8ew/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgxZs7HB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgxZs7HB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8423C43390;
	Mon, 29 Jan 2024 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548284;
	bh=kIQjJzqDnHyHIZn5u1Oo3TrFW7j/SlZBJAa29IeuPNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgxZs7HBPAkiRb8rOeTkCKglvokUdWjIH7ibLiFX6StG+Pu6+lHS7m9ONd/MxoBQA
	 ke7UGM+G0eM2mNdr9jslgOYG668QrnwTLDl902suHtpVYKYhMVcxH7uXHd3GwVqfcr
	 PlayGu6XAnd+MvoYFwxjeBUgOKt9kAsenAmTRy44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Ilya Bakoulin <ilya.bakoulin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 297/346] drm/amd/display: Fix hang/underflow when transitioning to ODM4:1
Date: Mon, 29 Jan 2024 09:05:28 -0800
Message-ID: <20240129170025.152389120@linuxfoundation.org>
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

From: Ilya Bakoulin <ilya.bakoulin@amd.com>

[ Upstream commit e7b2b108cdeab76a7e7324459e50b0c1214c0386 ]

[Why]
Under some circumstances, disabling an OPTC and attempting to reclaim
its OPP(s) for a different OPTC could cause a hang/underflow due to OPPs
not being properly disconnected from the disabled OPTC.

[How]
Ensure that all OPPs are unassigned from an OPTC when it gets disabled.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Ilya Bakoulin <ilya.bakoulin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 3ba2a0bfd8cf ("drm/amd/display: Clear OPTC mem select on disable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c | 7 +++++++
 drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
index a2c4db2cebdd..91ea0d4da06a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
@@ -172,6 +172,13 @@ static bool optc32_disable_crtc(struct timing_generator *optc)
 	REG_UPDATE(OTG_CONTROL,
 			OTG_MASTER_EN, 0);
 
+	REG_UPDATE_5(OPTC_DATA_SOURCE_SELECT,
+			OPTC_SEG0_SRC_SEL, 0xf,
+			OPTC_SEG1_SRC_SEL, 0xf,
+			OPTC_SEG2_SRC_SEL, 0xf,
+			OPTC_SEG3_SRC_SEL, 0xf,
+			OPTC_NUM_OF_INPUT_SEGMENT, 0);
+
 	REG_UPDATE(CONTROL,
 			VTG0_ENABLE, 0);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c b/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c
index a4a39f1638cf..08a59cf449ca 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c
@@ -144,6 +144,13 @@ static bool optc35_disable_crtc(struct timing_generator *optc)
 	REG_UPDATE(OTG_CONTROL,
 			OTG_MASTER_EN, 0);
 
+	REG_UPDATE_5(OPTC_DATA_SOURCE_SELECT,
+			OPTC_SEG0_SRC_SEL, 0xf,
+			OPTC_SEG1_SRC_SEL, 0xf,
+			OPTC_SEG2_SRC_SEL, 0xf,
+			OPTC_SEG3_SRC_SEL, 0xf,
+			OPTC_NUM_OF_INPUT_SEGMENT, 0);
+
 	REG_UPDATE(CONTROL,
 			VTG0_ENABLE, 0);
 
-- 
2.43.0



