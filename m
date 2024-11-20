Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2941AB6C0;
	Wed, 20 Nov 2024 12:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107566; cv=none; b=XWtnFts38OCTL5JvZuLaw9ViMU8wgDZ0902L7S81uYSw8ZhFrjyfrJTvS7a98P50c+OsA8G216bsXPPIEBPHZVV5SjXDnIS3nVIDyi559A3CBWXI+F68aAj7W5Clso2zBjkKX5QMh5TGp9K4VHh9MB+lQVQAO/xrHrgpb4qmqEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107566; c=relaxed/simple;
	bh=/dWrNQjiMtd72JFYl9pcaIm6HxvttB5gOoGblkzHzs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvYREKbCApoVZnM6I9Er1XVsyUUyLi2VHCagEcOyIsU8H/LK+hwsBmxTo+LEqy0mRGaDDuwJemwg+22OIkK7O2UzbWqstyGV+hj2fQYHIu1dCe3OXR3rMFw3QsBfS+vi8zxVBmGoZGvFM6HTjwAPBz67idTCG/56pTFc0c+7dgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMIi56xB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMIi56xB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E890C4CECD;
	Wed, 20 Nov 2024 12:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107566;
	bh=/dWrNQjiMtd72JFYl9pcaIm6HxvttB5gOoGblkzHzs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMIi56xBcwF86YY4FXQ1MuZM4RrkeMpc2p1Fj2Uayr+xwv5OlfQKOJvI+XrVXNWLX
	 VhQlniNAjM7Qflb/G3vLLSeqLdPm0DGYv7bjLyRXUH9rx56NS087VSWjEfc93+BP2Y
	 3sqk+lMNfQ2GSMnRe81ZL/uN3xW1w3RttkzHDVuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.11 080/107] firmware: arm_scmi: Skip opp duplicates
Date: Wed, 20 Nov 2024 13:56:55 +0100
Message-ID: <20241120125631.487673871@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

commit 5d8a766226587d111620df520dd9239c009cb154 upstream.

Buggy firmware can reply with duplicated PERF opps descriptors.

Ensure that the bad duplicates reported by the platform firmware doesn't
get added to the opp-tables.

Reported-by: Johan Hovold <johan+linaro@kernel.org>
Closes: https://lore.kernel.org/lkml/ZoQjAWse2YxwyRJv@hovoldconsulting.com/
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: stable@vger.kernel.org
Message-ID: <20241030125512.2884761-3-quic_sibis@quicinc.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/perf.c |   40 +++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -373,7 +373,7 @@ static int iter_perf_levels_update_state
 	return 0;
 }
 
-static inline void
+static inline int
 process_response_opp(struct device *dev, struct perf_dom_info *dom,
 		     struct scmi_opp *opp, unsigned int loop_idx,
 		     const struct scmi_msg_resp_perf_describe_levels *r)
@@ -386,12 +386,16 @@ process_response_opp(struct device *dev,
 		le16_to_cpu(r->opp[loop_idx].transition_latency_us);
 
 	ret = xa_insert(&dom->opps_by_lvl, opp->perf, opp, GFP_KERNEL);
-	if (ret)
+	if (ret) {
 		dev_warn(dev, "Failed to add opps_by_lvl at %d for %s - ret:%d\n",
 			 opp->perf, dom->info.name, ret);
+		return ret;
+	}
+
+	return 0;
 }
 
-static inline void
+static inline int
 process_response_opp_v4(struct device *dev, struct perf_dom_info *dom,
 			struct scmi_opp *opp, unsigned int loop_idx,
 			const struct scmi_msg_resp_perf_describe_levels_v4 *r)
@@ -404,9 +408,11 @@ process_response_opp_v4(struct device *d
 		le16_to_cpu(r->opp[loop_idx].transition_latency_us);
 
 	ret = xa_insert(&dom->opps_by_lvl, opp->perf, opp, GFP_KERNEL);
-	if (ret)
+	if (ret) {
 		dev_warn(dev, "Failed to add opps_by_lvl at %d for %s - ret:%d\n",
 			 opp->perf, dom->info.name, ret);
+		return ret;
+	}
 
 	/* Note that PERF v4 reports always five 32-bit words */
 	opp->indicative_freq = le32_to_cpu(r->opp[loop_idx].indicative_freq);
@@ -415,13 +421,21 @@ process_response_opp_v4(struct device *d
 
 		ret = xa_insert(&dom->opps_by_idx, opp->level_index, opp,
 				GFP_KERNEL);
-		if (ret)
+		if (ret) {
 			dev_warn(dev,
 				 "Failed to add opps_by_idx at %d for %s - ret:%d\n",
 				 opp->level_index, dom->info.name, ret);
 
+			/* Cleanup by_lvl too */
+			xa_erase(&dom->opps_by_lvl, opp->perf);
+
+			return ret;
+		}
+
 		hash_add(dom->opps_by_freq, &opp->hash, opp->indicative_freq);
 	}
+
+	return 0;
 }
 
 static int
@@ -429,16 +443,22 @@ iter_perf_levels_process_response(const
 				  const void *response,
 				  struct scmi_iterator_state *st, void *priv)
 {
+	int ret;
 	struct scmi_opp *opp;
 	struct scmi_perf_ipriv *p = priv;
 
-	opp = &p->perf_dom->opp[st->desc_index + st->loop_idx];
+	opp = &p->perf_dom->opp[p->perf_dom->opp_count];
 	if (PROTOCOL_REV_MAJOR(p->version) <= 0x3)
-		process_response_opp(ph->dev, p->perf_dom, opp, st->loop_idx,
-				     response);
+		ret = process_response_opp(ph->dev, p->perf_dom, opp,
+					   st->loop_idx, response);
 	else
-		process_response_opp_v4(ph->dev, p->perf_dom, opp, st->loop_idx,
-					response);
+		ret = process_response_opp_v4(ph->dev, p->perf_dom, opp,
+					      st->loop_idx, response);
+
+	/* Skip BAD duplicates received from firmware */
+	if (ret)
+		return ret == -EBUSY ? 0 : ret;
+
 	p->perf_dom->opp_count++;
 
 	dev_dbg(ph->dev, "Level %d Power %d Latency %dus Ifreq %d Index %d\n",


