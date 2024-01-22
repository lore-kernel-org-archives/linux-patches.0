Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792F760253;
	Tue, 23 Jan 2024 00:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970845; cv=none; b=MQnWfyEwEpN6e4ugD3uzIo21gFrPCU6Q1GvpbsXyTHBIReaH2Xf3hi6kOrfwCDIzzAL6qCmiCQM66YeNeok7JbP2MvqAyxbpjyMITVpt+J2c77NU+seMHp/gIMSuq0YPItODT4SSI9I+hujgQru35hvXMVOQSrFmEOYfqQULG7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970845; c=relaxed/simple;
	bh=nXsRDvxALK9l8icRHc09fMJ28GeEm6VlmPNJTWgiY7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GH2Os7MOUmH4dq+lfIeogAnozQylES4NzwGc9f9fY1ofiM4nGYLvbTspo56fuct29Uolwo5qfZIZdK8vAAo8REVE8UVSd8tUpmxejRzM10cPf2dCmhY9rVcr+JADfAjXZvSnjk/7F6HRyW+7U+IBgemCobKkQmvmWCIaSw8pFVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pz5sWF2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pz5sWF2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A6FC433C7;
	Tue, 23 Jan 2024 00:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970845;
	bh=nXsRDvxALK9l8icRHc09fMJ28GeEm6VlmPNJTWgiY7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pz5sWF2KYfBcpKg0HC6kmTwCXbIcpiT0ha5ZTY45TTjHhDJyYgjX7RuWdx/kiuVL4
	 MvwSYx1cXgvyuN2uO8SBKNIVeiZnrzmoB0SmGoITVaCBNT2LnSzvFG866jyhGcfxt1
	 Vvjai5LWWNItsqXIqeM52NAwCMnixuNXL2EmJX1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atul Dhudase <quic_adhudase@quicinc.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/417] soc: qcom: llcc: Fix dis_cap_alloc and retain_on_pc configuration
Date: Mon, 22 Jan 2024 15:54:52 -0800
Message-ID: <20240122235756.103230348@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bc400669ee02..16a05143d0d6 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -680,14 +680,14 @@ static int _qcom_llcc_cfg_program(const struct llcc_slice_config *config,
 		u32 disable_cap_alloc, retain_pc;
 
 		disable_cap_alloc = config->dis_cap_alloc << config->slice_id;
-		ret = regmap_write(drv_data->bcast_regmap,
-				LLCC_TRP_SCID_DIS_CAP_ALLOC, disable_cap_alloc);
+		ret = regmap_update_bits(drv_data->bcast_regmap, LLCC_TRP_SCID_DIS_CAP_ALLOC,
+					 BIT(config->slice_id), disable_cap_alloc);
 		if (ret)
 			return ret;
 
 		retain_pc = config->retain_on_pc << config->slice_id;
-		ret = regmap_write(drv_data->bcast_regmap,
-				LLCC_TRP_PCB_ACT, retain_pc);
+		ret = regmap_update_bits(drv_data->bcast_regmap, LLCC_TRP_PCB_ACT,
+					 BIT(config->slice_id), retain_pc);
 		if (ret)
 			return ret;
 	}
-- 
2.43.0



