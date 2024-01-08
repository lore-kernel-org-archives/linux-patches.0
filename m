Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D721D5102B;
	Mon,  8 Jan 2024 15:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFX7uWDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456F4C433C7;
	Mon,  8 Jan 2024 15:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728544;
	bh=FOg9qWnZ9rmVrY44ALRzF6i+R+s0IZgpfjGRaVSZgWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFX7uWDtRjclh4JlX6UHnwj4LP1bmTzX9E49duV3GMPQKEuFTH8R4gETY7DBadluF
	 4Ec9lYPK1ztPIWYj4QWiAVc3Ki3YHxb+mn64IQ8NwlDIHkdTOz5olwr5iLmv4Fnxc8
	 OOqTS+gwNbXzg9JuLa3m00ZKPMOXH6OiOiwbENM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/150] firmware: arm_scmi: Fix frequency truncation by promoting multiplier type
Date: Mon,  8 Jan 2024 16:36:01 +0100
Message-ID: <20240108153516.253176114@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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
index 431bda9165c3d..2775bcafe40f6 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -131,7 +131,7 @@ struct perf_dom_info {
 	u32 opp_count;
 	u32 sustained_freq_khz;
 	u32 sustained_perf_level;
-	u32 mult_factor;
+	unsigned long mult_factor;
 	char name[SCMI_MAX_STR_SIZE];
 	struct scmi_opp opp[MAX_OPPS];
 	struct scmi_fc_info *fc_info;
@@ -223,8 +223,8 @@ scmi_perf_domain_attributes_get(const struct scmi_protocol_handle *ph,
 			dom_info->mult_factor =	1000;
 		else
 			dom_info->mult_factor =
-					(dom_info->sustained_freq_khz * 1000) /
-					dom_info->sustained_perf_level;
+					(dom_info->sustained_freq_khz * 1000UL)
+					/ dom_info->sustained_perf_level;
 		strscpy(dom_info->name, attr->name, SCMI_SHORT_NAME_MAX_SIZE);
 	}
 
-- 
2.43.0



