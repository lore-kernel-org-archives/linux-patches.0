Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59067C2D0;
	Mon, 11 Dec 2023 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqOnYYys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D56C433C7;
	Mon, 11 Dec 2023 18:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319487;
	bh=hOnh1VbBRUGttmA7reYgIbPSBGi7IyJDrkCzOZbIErE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqOnYYys66jPG7+6BvqgQW7xEqjD9yBKVHVcYObndVOiI1K6GcIQyJl+/YSSj7Tl+
	 mdW7P/DcuXOGkIB9F6rCRVTtapt7OKXQMM98oA5Svb+akEzsM9cAX+ZPjSAduS3kdd
	 bXcViKnUKPJBt9WTB2/t8v3G0LKBT8WDJ9ifs3Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/244] firmware: arm_scmi: Fix possible frequency truncation when using level indexing mode
Date: Mon, 11 Dec 2023 19:19:59 +0100
Message-ID: <20231211182050.516617150@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 77f5032e94f244ba08db51e17ca8f37bd7ff9acb ]

The multiplier is already promoted to unsigned long, however the
frequency calculations done when using level indexing mode doesn't
use the multiplier computed. It instead hardcodes the multiplier
value of 1000 at all the usage sites.

Clean that up by assigning the multiplier value of 1000 when using
the perf level indexing mode and update the frequency calculations to
use the multiplier instead. It should fix the possible frequency
truncation for all the values greater than or equal to 4GHz on 64-bit
machines.

Fixes: 31c7c1397a33 ("firmware: arm_scmi: Add v3.2 perf level indexing mode support")
Reported-by: Sibi Sankar <quic_sibis@quicinc.com>
Closes: https://lore.kernel.org/all/20231129065748.19871-3-quic_sibis@quicinc.com/
Cc: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20231130204343.503076-2-sudeep.holla@arm.com
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/perf.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/arm_scmi/perf.c b/drivers/firmware/arm_scmi/perf.c
index 596316e6e1ba3..e887fd1690434 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -268,7 +268,8 @@ scmi_perf_domain_attributes_get(const struct scmi_protocol_handle *ph,
 		dom_info->sustained_perf_level =
 					le32_to_cpu(attr->sustained_perf_level);
 		if (!dom_info->sustained_freq_khz ||
-		    !dom_info->sustained_perf_level)
+		    !dom_info->sustained_perf_level ||
+		    dom_info->level_indexing_mode)
 			/* CPUFreq converts to kHz, hence default 1000 */
 			dom_info->mult_factor =	1000;
 		else
@@ -813,7 +814,7 @@ static int scmi_dvfs_device_opps_add(const struct scmi_protocol_handle *ph,
 		if (!dom->level_indexing_mode)
 			freq = dom->opp[idx].perf * dom->mult_factor;
 		else
-			freq = dom->opp[idx].indicative_freq * 1000;
+			freq = dom->opp[idx].indicative_freq * dom->mult_factor;
 
 		ret = dev_pm_opp_add(dev, freq, 0);
 		if (ret) {
@@ -862,7 +863,8 @@ static int scmi_dvfs_freq_set(const struct scmi_protocol_handle *ph, u32 domain,
 	} else {
 		struct scmi_opp *opp;
 
-		opp = LOOKUP_BY_FREQ(dom->opps_by_freq, freq / 1000);
+		opp = LOOKUP_BY_FREQ(dom->opps_by_freq,
+				     freq / dom->mult_factor);
 		if (!opp)
 			return -EIO;
 
@@ -896,7 +898,7 @@ static int scmi_dvfs_freq_get(const struct scmi_protocol_handle *ph, u32 domain,
 		if (!opp)
 			return -EIO;
 
-		*freq = opp->indicative_freq * 1000;
+		*freq = opp->indicative_freq * dom->mult_factor;
 	}
 
 	return ret;
@@ -919,7 +921,7 @@ static int scmi_dvfs_est_power_get(const struct scmi_protocol_handle *ph,
 		if (!dom->level_indexing_mode)
 			opp_freq = opp->perf * dom->mult_factor;
 		else
-			opp_freq = opp->indicative_freq * 1000;
+			opp_freq = opp->indicative_freq * dom->mult_factor;
 
 		if (opp_freq < *freq)
 			continue;
-- 
2.42.0



