Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B83EEB8;
	Mon, 11 Dec 2023 18:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kxmigx2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2498C433C7;
	Mon, 11 Dec 2023 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319458;
	bh=FvKfFRzWp36QIHgxqXiXeckhoDnp+II9c+P7NKJRNWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kxmigx2Fvrfe6vFaWFo7s8tBbLfq+hya1dVtndfTJaYOagEwD/VGcY9ntmQZfQNyT
	 zFsAAK93bgP+JdwbH1ZklYflZRCX2X+xVosnB7wcjbzLYq3uXGCAK34J8xyZ/Uidr8
	 QjCwK6lJm2tMCoU29yIbKd5Sidc6lNppO6Fw268A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/244] firmware: arm_scmi: Simplify error path in scmi_dvfs_device_opps_add()
Date: Mon, 11 Dec 2023 19:19:58 +0100
Message-ID: <20231211182050.467342335@linuxfoundation.org>
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

[ Upstream commit 033ca4de129646e9969a6838b44cca0fac38e219 ]

Let's simplify the code in scmi_dvfs_device_opps_add() by using
dev_pm_opp_remove_all_dynamic() in the error path.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20230925131715.138411-8-ulf.hansson@linaro.org
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 77f5032e94f2 ("firmware: arm_scmi: Fix possible frequency truncation when using level indexing mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/perf.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/arm_scmi/perf.c b/drivers/firmware/arm_scmi/perf.c
index 7aa9b4ff48d61..596316e6e1ba3 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -799,7 +799,6 @@ static int scmi_dvfs_device_opps_add(const struct scmi_protocol_handle *ph,
 {
 	int idx, ret, domain;
 	unsigned long freq;
-	struct scmi_opp *opp;
 	struct perf_dom_info *dom;
 
 	domain = scmi_dev_domain_id(dev);
@@ -810,23 +809,16 @@ static int scmi_dvfs_device_opps_add(const struct scmi_protocol_handle *ph,
 	if (IS_ERR(dom))
 		return PTR_ERR(dom);
 
-	for (opp = dom->opp, idx = 0; idx < dom->opp_count; idx++, opp++) {
+	for (idx = 0; idx < dom->opp_count; idx++) {
 		if (!dom->level_indexing_mode)
-			freq = opp->perf * dom->mult_factor;
+			freq = dom->opp[idx].perf * dom->mult_factor;
 		else
-			freq = opp->indicative_freq * 1000;
+			freq = dom->opp[idx].indicative_freq * 1000;
 
 		ret = dev_pm_opp_add(dev, freq, 0);
 		if (ret) {
 			dev_warn(dev, "failed to add opp %luHz\n", freq);
-
-			while (idx-- > 0) {
-				if (!dom->level_indexing_mode)
-					freq = (--opp)->perf * dom->mult_factor;
-				else
-					freq = (--opp)->indicative_freq * 1000;
-				dev_pm_opp_remove(dev, freq);
-			}
+			dev_pm_opp_remove_all_dynamic(dev);
 			return ret;
 		}
 
-- 
2.42.0



