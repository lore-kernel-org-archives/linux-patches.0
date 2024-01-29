Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A6715A493;
	Mon, 29 Jan 2024 17:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548635; cv=none; b=V5ejCxV2RnUyMdZwxhPTqNvnrl9NFH8mmsVreE4SfzHUch1ZR8rIGO3Ly5CHIV+TBhREVg7WZOdBZE21g7SxlNPD3trq3pJgz51vnUe9S2CYiipYjab6gs4QG4ncWEbBOSJG3XL9HMk8sM/aETzKfsUGO9zemaXEiOwtO5QZxAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548635; c=relaxed/simple;
	bh=Xf6ns8vRCpjhGi24XbVeybunRxrVYseBySXW2rNEhFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/waLcyqT1ohFZUQaq/9QcJ7VlmIqJYyGZAYH+09jUovV2BiSNhnxhgYH2YYvffKntIOx4Wn5du7+qVEqP5h12wj0pG2TjA7YtNjvUgCuyQT1VQh3yMKr4F0+7A5+hi2CPg6bREuMo+9HNcCNjkZplJ+a6ASFtFo+HeYodUE0b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KosvWFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KosvWFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A843C433C7;
	Mon, 29 Jan 2024 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548635;
	bh=Xf6ns8vRCpjhGi24XbVeybunRxrVYseBySXW2rNEhFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KosvWFI4iWMQVCyIzaGXMx0EkdP8FvB4qSdam0fpG7UfgdXyIjY11z/xbIXGS51v
	 QdF2aB6xqyytvjCjyBSAGJM5etIKgmDIxSC44E7qcIEBcHNka3YIm5Z3l1ov+7Zg3m
	 Bkheag8R+raEoCSgebC0HMFiuSibEqqPUy9RLuJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 310/331] firmware: arm_scmi: Use xa_insert() to store opps
Date: Mon, 29 Jan 2024 09:06:14 -0800
Message-ID: <20240129170023.950516817@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit e8ef4bbe39b9576a73f104f6af743fb9c7b624ba ]

When storing opps by level or index use xa_insert() instead of xa_store()
and add error-checking to spot bad duplicates indexes possibly wrongly
provided by the platform firmware.

Fixes: 31c7c1397a33 ("firmware: arm_scmi: Add v3.2 perf level indexing mode support")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20240108185050.1628687-1-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/perf.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/arm_scmi/perf.c b/drivers/firmware/arm_scmi/perf.c
index e887fd169043..dd344506b0a3 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -347,8 +347,8 @@ process_response_opp(struct scmi_opp *opp, unsigned int loop_idx,
 }
 
 static inline void
-process_response_opp_v4(struct perf_dom_info *dom, struct scmi_opp *opp,
-			unsigned int loop_idx,
+process_response_opp_v4(struct device *dev, struct perf_dom_info *dom,
+			struct scmi_opp *opp, unsigned int loop_idx,
 			const struct scmi_msg_resp_perf_describe_levels_v4 *r)
 {
 	opp->perf = le32_to_cpu(r->opp[loop_idx].perf_val);
@@ -359,10 +359,23 @@ process_response_opp_v4(struct perf_dom_info *dom, struct scmi_opp *opp,
 	/* Note that PERF v4 reports always five 32-bit words */
 	opp->indicative_freq = le32_to_cpu(r->opp[loop_idx].indicative_freq);
 	if (dom->level_indexing_mode) {
+		int ret;
+
 		opp->level_index = le32_to_cpu(r->opp[loop_idx].level_index);
 
-		xa_store(&dom->opps_by_idx, opp->level_index, opp, GFP_KERNEL);
-		xa_store(&dom->opps_by_lvl, opp->perf, opp, GFP_KERNEL);
+		ret = xa_insert(&dom->opps_by_idx, opp->level_index, opp,
+				GFP_KERNEL);
+		if (ret)
+			dev_warn(dev,
+				 "Failed to add opps_by_idx at %d - ret:%d\n",
+				 opp->level_index, ret);
+
+		ret = xa_insert(&dom->opps_by_lvl, opp->perf, opp, GFP_KERNEL);
+		if (ret)
+			dev_warn(dev,
+				 "Failed to add opps_by_lvl at %d - ret:%d\n",
+				 opp->perf, ret);
+
 		hash_add(dom->opps_by_freq, &opp->hash, opp->indicative_freq);
 	}
 }
@@ -379,7 +392,7 @@ iter_perf_levels_process_response(const struct scmi_protocol_handle *ph,
 	if (PROTOCOL_REV_MAJOR(p->version) <= 0x3)
 		process_response_opp(opp, st->loop_idx, response);
 	else
-		process_response_opp_v4(p->perf_dom, opp, st->loop_idx,
+		process_response_opp_v4(ph->dev, p->perf_dom, opp, st->loop_idx,
 					response);
 	p->perf_dom->opp_count++;
 
-- 
2.43.0



