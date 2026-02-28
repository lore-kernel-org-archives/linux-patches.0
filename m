Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116D0332628
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301218; cv=none; b=rcvkMSskazP1osn8jEtUkQ5/x3sIx1wOjyBmo+m5JafzqaN5hA6bTx+P+zCR5Jv5pS5uZdVn2ZdfoqjRMlBeOuo0myNTlLvmhpXYc61VVEkn0wfSc57tzAIKvQBpqqc4uP2Z57D5hJuND1+TDmWv2LuAhXQsXcIri4TT8+WpQlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301218; c=relaxed/simple;
	bh=stzw8+O1qLWHpiBs5B6E30/TaFmQDt6Mst2++3fJidA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/166K4Vfzc8mmVmJ3OsJdCt1gZsGYc74Rx5rn30FG4YzTrPd+Oih1XNa37aJpcBYBAsaRYU9JoE6e4/yM+yO9mj2t5lr2kNk7OmjqrcpCQm6yKYdFoT7JqVrzHfT8hgFsEqyq7zDApni69DAagrIyy+IJuLL2LUlgDWNvkhnMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3wqq8Kt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3wqq8Kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7311EC116D0;
	Sat, 28 Feb 2026 17:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301218;
	bh=stzw8+O1qLWHpiBs5B6E30/TaFmQDt6Mst2++3fJidA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3wqq8KtmRcpiH8GVzaNa86P1dtEo7HlA6uAU6zKujmtZ1UnXihjIQQCnFVGxAZFE
	 IsFALO1Cauyo/U/buchQ8Y/m62Mld/TFs6PjMPiicdKSGdRg+9TA7lzKGPAv2Rc7/S
	 QTl42hpHndiMcqK40ukf2sLHpzJygQD8nLh5pZndmbJAEMMutsCwTQQYjbiU73tSyw
	 mFo5tdUuuIXO1p6Zk1+cOKzDLpOz5ovp/LrjB/yvMp6hJI+vNOmD14r4soYWwwexQ3
	 Xg3agDHlX4I8HrdTgdl5MM2PaWdpJ15NHoN55ICDTGewCyYrj6pllb7sgNID4wJRPc
	 UnZu4AScVLhYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Maciej Grochowski <Maciej.Grochowski@sony.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 394/752] ntb: ntb_hw_switchtec: Fix array-index-out-of-bounds access
Date: Sat, 28 Feb 2026 12:41:45 -0500
Message-ID: <20260228174750.1542406-394-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Maciej Grochowski <Maciej.Grochowski@sony.com>

[ Upstream commit c8ba7ad2cc1c7b90570aa347b8ebbe279f1eface ]

Number of MW LUTs depends on NTB configuration and can be set to MAX_MWS,
This patch protects against invalid index out of bounds access to mw_sizes
When invalid access print message to user that configuration is not valid.

Signed-off-by: Maciej Grochowski <Maciej.Grochowski@sony.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
index f851397b65d6e..f15ebab138144 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -1314,6 +1314,12 @@ static void switchtec_ntb_init_shared(struct switchtec_ntb *sndev)
 	for (i = 0; i < sndev->nr_lut_mw; i++) {
 		int idx = sndev->nr_direct_mw + i;
 
+		if (idx >= MAX_MWS) {
+			dev_err(&sndev->stdev->dev,
+				"Total number of MW cannot be bigger than %d", MAX_MWS);
+			break;
+		}
+
 		sndev->self_shared->mw_sizes[idx] = LUT_SIZE;
 	}
 }
-- 
2.51.0

