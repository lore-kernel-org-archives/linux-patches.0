Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5855FEEB8;
	Mon, 11 Dec 2023 18:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FiFZ4KTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFD3C433C8;
	Mon, 11 Dec 2023 18:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319434;
	bh=mcDp1oTI91lJUHMy9Mo/OglR/LOxLKR6vwzEDCbcRPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiFZ4KTLpqh8KJO1QccXq/yhwxqoKaSATk/HomvsY6TCO5/s66+BEjBMKpW9MzqzB
	 Cjxkqn8Hg1naRGTEs1FaUaXZ4XhpWXZp0UL78rqvh7nZZGy3twCdb5brcNKhbK98iP
	 7lZv/03AEwJbUE6O16EjVBRzdIUAywI1HNYKNHjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/244] firmware: arm_scmi: Extend perf protocol ops to get number of domains
Date: Mon, 11 Dec 2023 19:19:55 +0100
Message-ID: <20231211182050.361350527@linuxfoundation.org>
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

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit e9090e70e618cd62ab7bf2914511e5eea31a2535 ]

Similar to other protocol ops, it's useful for an scmi module driver to get
the number of supported performance domains, hence let's make this
available by adding a new perf protocol callback. Note that, a user is
being added from subsequent changes.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20230825112633.236607-2-ulf.hansson@linaro.org
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 8e3c98d9187e ("firmware: arm_scmi: Fix frequency truncation by promoting multiplier type")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/perf.c | 8 ++++++++
 include/linux/scmi_protocol.h    | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/firmware/arm_scmi/perf.c b/drivers/firmware/arm_scmi/perf.c
index 30dedd6ebfde6..da901c65388a6 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -423,6 +423,13 @@ scmi_perf_describe_levels_get(const struct scmi_protocol_handle *ph,
 	return ret;
 }
 
+static int scmi_perf_num_domains_get(const struct scmi_protocol_handle *ph)
+{
+	struct scmi_perf_info *pi = ph->get_priv(ph);
+
+	return pi->num_domains;
+}
+
 static int scmi_perf_msg_limits_set(const struct scmi_protocol_handle *ph,
 				    u32 domain, u32 max_perf, u32 min_perf)
 {
@@ -948,6 +955,7 @@ scmi_power_scale_get(const struct scmi_protocol_handle *ph)
 }
 
 static const struct scmi_perf_proto_ops perf_proto_ops = {
+	.num_domains_get = scmi_perf_num_domains_get,
 	.limits_set = scmi_perf_limits_set,
 	.limits_get = scmi_perf_limits_get,
 	.level_set = scmi_perf_level_set,
diff --git a/include/linux/scmi_protocol.h b/include/linux/scmi_protocol.h
index e6fe4f73ffe62..71b39cbbdace0 100644
--- a/include/linux/scmi_protocol.h
+++ b/include/linux/scmi_protocol.h
@@ -101,6 +101,7 @@ struct scmi_clk_proto_ops {
  * struct scmi_perf_proto_ops - represents the various operations provided
  *	by SCMI Performance Protocol
  *
+ * @num_domains_get: gets the number of supported performance domains
  * @limits_set: sets limits on the performance level of a domain
  * @limits_get: gets limits on the performance level of a domain
  * @level_set: sets the performance level of a domain
@@ -120,6 +121,7 @@ struct scmi_clk_proto_ops {
  *	or in some other (abstract) scale
  */
 struct scmi_perf_proto_ops {
+	int (*num_domains_get)(const struct scmi_protocol_handle *ph);
 	int (*limits_set)(const struct scmi_protocol_handle *ph, u32 domain,
 			  u32 max_perf, u32 min_perf);
 	int (*limits_get)(const struct scmi_protocol_handle *ph, u32 domain,
-- 
2.42.0



