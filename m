Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27A426D4DF;
	Tue, 11 Nov 2025 01:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823814; cv=none; b=l3OX8KJeWl2X9OZd2HQpnbmqk9dzLnJD2AMQjxqja5rvUbcXUW0tq1do4hQ3FZe3no8l4iWRhQQSd/sBfvaiUSElzEx4oalfJ2NukBknIInLtbZBpubFsILA//xw81dFDgGWiaVaTNLI3UcFeI4QYlNPlF+e00YatthDvJMrpyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823814; c=relaxed/simple;
	bh=IHOv4QrwKicMPElzoOMMLcFOik2a2YFcPciqSX72IEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hejEV/j43r6gSaoOQs9zuO3aHKlskkQS5/yo5w0rfEC4c6dIso2U7H4SlMTB6/k++n0mihkR9Wy81dnO8WOOxwzNABp1O8NFUgUyJA5ZmnLawunGNn7TBgU7GRl4yI/L4KcmSMCRERBVsQivGUj6LSu7z7HNfOUrPPvX3+mH/nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFaOA2z6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFaOA2z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F99AC19421;
	Tue, 11 Nov 2025 01:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823813;
	bh=IHOv4QrwKicMPElzoOMMLcFOik2a2YFcPciqSX72IEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFaOA2z63jtPFQ1iixziHPMadWfsxWmhJMpf/iPOSHD2EdUgRa2TZYZBtGt7RALMp
	 qdanjcw//plakF0QsC9rgsUEi5M05kGPtx+vxty9yMDOQzzB7oZPVbe61u2z/Td3mI
	 6/gQnQTVk1gExoTBCaqXOhz55Eu562E6AwejtNqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <Dillon.Varone@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Wenjing Liu <Wenjing.Liu@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 377/849] drm/amd/display: Consider sink max slice width limitation for dsc
Date: Tue, 11 Nov 2025 09:39:07 +0900
Message-ID: <20251111004545.548043338@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit 6b34e7ed4ba583ee77032a4c850ff97ba16ad870 ]

[WHY&HOW]
The sink max slice width limitation should be considered for DSC, but
was removed in "refactor DSC cap calculations".
This patch adds it back and takes the valid minimum between the sink and
source.

Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c b/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
index 1f53a9f0c0ac3..e4144b2443324 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
+++ b/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
@@ -1157,6 +1157,11 @@ static bool setup_dsc_config(
 	if (!is_dsc_possible)
 		goto done;
 
+	/* increase miniumum slice count to meet sink slice width limitations */
+	min_slices_h = dc_fixpt_ceil(dc_fixpt_max(
+			dc_fixpt_div_int(dc_fixpt_from_int(pic_width), dsc_common_caps.max_slice_width), // sink min
+			dc_fixpt_from_int(min_slices_h))); // source min
+
 	min_slices_h = fit_num_slices_up(dsc_common_caps.slice_caps, min_slices_h);
 
 	/* increase minimum slice count to meet sink throughput limitations */
-- 
2.51.0



