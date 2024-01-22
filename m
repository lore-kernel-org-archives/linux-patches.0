Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D90215445E;
	Tue, 23 Jan 2024 00:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969393; cv=none; b=G2X2svQpsxIfkvlrxkU6cMH/Fm2e4S2n1NAehhaAsISwYJuj1YtwF/G3yNfXiCa2P2Wqll+4otGv6Ufom9wl5bh+kK8ERkI5d+bJSiSqVan82hZ9PYNTiHVEv7360M6tVnbtzqb88GbZwdGbP4OunO/jaoDL/tWe1vDsqepPAYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969393; c=relaxed/simple;
	bh=HXXVt66m1WxdXfJC4cKw/k6UIYNiJO8NCeM9iuxxtDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlGmn6ftOeQwj7vgD/3NyoLkWUSwNtkSmouKVc4BAPxkpe4EdeYtDEb/NqLs/Gnw197b5tCJSBLz4P+o+iBGT3+OpW3ispABKAXf+p5pniknvIu1fqAnr8D0OuGItME455Rv93FCwnqho0GSLsoknsgYnSgLiCG+s08VnphAnIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSrLAFAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSrLAFAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD55C43394;
	Tue, 23 Jan 2024 00:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969393;
	bh=HXXVt66m1WxdXfJC4cKw/k6UIYNiJO8NCeM9iuxxtDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSrLAFATVOnOmbaR4KkdS8+gelaiA+6vqY+fKvFVrhBKae8H9mBS1PePxF918ZbbQ
	 jxLWxOA1GJt6P6o/PXnCfWfsr4rCOYIUIoCZ0cyYFJISelqMqSutB4obzQc/aF1Erx
	 GnQzlqFidgwNXYkU8PJzJ842EZMO13CdM+LTDr8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atul Dhudase <quic_adhudase@quicinc.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 192/641] soc: qcom: llcc: Fix dis_cap_alloc and retain_on_pc configuration
Date: Mon, 22 Jan 2024 15:51:36 -0800
Message-ID: <20240122235823.980057538@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Atul Dhudase <quic_adhudase@quicinc.com>

[ Upstream commit eed6e57e9f3e2beac37563eb6a0129549daa330e ]

Commit c14e64b46944 ("soc: qcom: llcc: Support chipsets that can
 write to llcc") add the support for chipset where capacity based
allocation and retention through power collapse can be programmed
based on content of SCT table mentioned in the llcc driver where
the target like sdm845 where the entire programming related to it
is controlled in firmware. However, the commit introduces a bug
where capacity/retention register get overwritten each time it
gets programmed for each slice and that results in misconfiguration
of the register based on SCT table and that is not expected
behaviour instead it should be read modify write to retain the
configuration of other slices.

This issue is totally caught from code review and programming test
and not through any power/perf numbers so, it is not known what
impact this could make if we don't have this change however,
this feature are for these targets and they should have been
programmed accordingly as per their configuration mentioned in
SCT table like others bits information.

This change brings one difference where it keeps capacity/retention
bits of the slices that are not mentioned in SCT table in unknown
state where as earlier it was initialized to zero.

Fixes: c14e64b46944 ("soc: qcom: llcc: Support chipsets that can write to llcc")
Signed-off-by: Atul Dhudase <quic_adhudase@quicinc.com>
Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/1701876771-10695-1-git-send-email-quic_mojha@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/llcc-qcom.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index 674abd0d6700..2e32a0e521d5 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -941,15 +941,15 @@ static int _qcom_llcc_cfg_program(const struct llcc_slice_config *config,
 		u32 disable_cap_alloc, retain_pc;
 
 		disable_cap_alloc = config->dis_cap_alloc << config->slice_id;
-		ret = regmap_write(drv_data->bcast_regmap,
-				LLCC_TRP_SCID_DIS_CAP_ALLOC, disable_cap_alloc);
+		ret = regmap_update_bits(drv_data->bcast_regmap, LLCC_TRP_SCID_DIS_CAP_ALLOC,
+					 BIT(config->slice_id), disable_cap_alloc);
 		if (ret)
 			return ret;
 
 		if (drv_data->version < LLCC_VERSION_4_1_0_0) {
 			retain_pc = config->retain_on_pc << config->slice_id;
-			ret = regmap_write(drv_data->bcast_regmap,
-					LLCC_TRP_PCB_ACT, retain_pc);
+			ret = regmap_update_bits(drv_data->bcast_regmap, LLCC_TRP_PCB_ACT,
+						 BIT(config->slice_id), retain_pc);
 			if (ret)
 				return ret;
 		}
-- 
2.43.0



