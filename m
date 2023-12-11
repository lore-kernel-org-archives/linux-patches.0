Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEC0C2D0;
	Mon, 11 Dec 2023 18:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n42WuCE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6119DC433C7;
	Mon, 11 Dec 2023 18:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319541;
	bh=S9eAJkm0jjF4O8LvJAzSIQ0bj0FzxJkx02XaQ7G0xUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n42WuCE9EhfewX8IFz1g3ANn1DQfb16/vaj1GPLmh3pNmI/tLGrmRI1+FMNoTCLx6
	 /Wrb7QUZgm4SEHo+ZrWr0PQ4RdVvLcDXnZZACZnhrVQRT55j1XKRNBhfaqE9uG0YSq
	 LLpgmSqBpAFvzFW66FldxelYq+qk1aSawpUVKfko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/244] firmware: arm_scmi: Fix frequency truncation by promoting multiplier type
Date: Mon, 11 Dec 2023 19:19:57 +0100
Message-ID: <20231211182050.427373320@linuxfoundation.org>
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

[ Upstream commit 8e3c98d9187e09274fc000a7d1a77b070a42d259 ]

Fix the possible frequency truncation for all values equal to or greater
4GHz on 64bit machines by updating the multiplier 'mult_factor' to
'unsigned long' type. It is also possible that the multiplier itself can
be greater than or equal to 2^32. So we need to also fix the equation
computing the value of the multiplier.

Fixes: a9e3fbfaa0ff ("firmware: arm_scmi: add initial support for performance protocol")
Reported-by: Sibi Sankar <quic_sibis@quicinc.com>
Closes: https://lore.kernel.org/all/20231129065748.19871-3-quic_sibis@quicinc.com/
Cc: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20231130204343.503076-1-sudeep.holla@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/perf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/perf.c b/drivers/firmware/arm_scmi/perf.c
index 6677caefb36bc..7aa9b4ff48d61 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -152,7 +152,7 @@ struct perf_dom_info {
 	u32 opp_count;
 	u32 sustained_freq_khz;
 	u32 sustained_perf_level;
-	u32 mult_factor;
+	unsigned long mult_factor;
 	struct scmi_perf_domain_info info;
 	struct scmi_opp opp[MAX_OPPS];
 	struct scmi_fc_info *fc_info;
@@ -273,8 +273,8 @@ scmi_perf_domain_attributes_get(const struct scmi_protocol_handle *ph,
 			dom_info->mult_factor =	1000;
 		else
 			dom_info->mult_factor =
-					(dom_info->sustained_freq_khz * 1000) /
-					dom_info->sustained_perf_level;
+					(dom_info->sustained_freq_khz * 1000UL)
+					/ dom_info->sustained_perf_level;
 		strscpy(dom_info->info.name, attr->name,
 			SCMI_SHORT_NAME_MAX_SIZE);
 	}
-- 
2.42.0



