Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E4D26FA77;
	Tue, 12 Aug 2025 19:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025473; cv=none; b=qIm2p/lVlTAJVT1L0k8rJs4AghHjfMNaBhGlOQBhX3SGjUpnWQW+If/llEZzCcSCQOgQFMqUp4Ccu2gCd3XGD4iZymnlRb+R8/s7KFRaj6WLs1ZpmGaL7Dhk9RTUr+m6uCPv/qIMgL/anmiwuqVXZlAiknqngLmF6UDb52nqwdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025473; c=relaxed/simple;
	bh=/uySv6vS2E//jwIUuVY55K+Nw38SxuaXhg4yTXKL9EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HL80FTn1GlVMdXpvKuVgcTg9sdaWU0Rv3ie44gvK8uHBagbziJYr5CrQMHUNXmgkRdCp7aSFmW37xaXmVNjQPz9wP/6Q1Db2Tz4BQClW/J7sbZBgTdOdCM/U2AaCIMLJGqCijp9ss3GewHGUsvBLe3ji4Dx3IBcl6XkIaWiTqOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IaYNtS3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IaYNtS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99095C4CEF0;
	Tue, 12 Aug 2025 19:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025473;
	bh=/uySv6vS2E//jwIUuVY55K+Nw38SxuaXhg4yTXKL9EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IaYNtS3aI0xWl00bCIJfwp4soPxPRgGbxaPxlga9sh6lTnoNvzLBMjEahLJmV/ob
	 4OKku/ht3TRJOnNuT+UlKXSzaORpAC2o8/hJBYXiwXkkmGE/t7kjuc55xYY+WR6eIF
	 +oGmCdwzT83JleNg9KGFawmSAc6I+LtiOJAwU9cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 052/480] firmware: arm_scmi: Fix up turbo frequencies selection
Date: Tue, 12 Aug 2025 19:44:20 +0200
Message-ID: <20250812174359.555848033@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sibi Sankar <quic_sibis@quicinc.com>

[ Upstream commit ad28fc31dd702871764e9294d4f2314ad78d24a9 ]

Sustained frequency when greater than or equal to 4Ghz on 64-bit devices
currently result in marking all frequencies as turbo. Address the turbo
frequency selection bug by fixing the truncation.

Fixes: a897575e79d7 ("firmware: arm_scmi: Add support for marking certain frequencies as turbo")
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Message-Id: <20250514214719.203607-1-quic_sibis@quicinc.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/perf.c b/drivers/firmware/arm_scmi/perf.c
index c7e5a34b254b..683fd9b85c5c 100644
--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -892,7 +892,7 @@ static int scmi_dvfs_device_opps_add(const struct scmi_protocol_handle *ph,
 			freq = dom->opp[idx].indicative_freq * dom->mult_factor;
 
 		/* All OPPs above the sustained frequency are treated as turbo */
-		data.turbo = freq > dom->sustained_freq_khz * 1000;
+		data.turbo = freq > dom->sustained_freq_khz * 1000UL;
 
 		data.level = dom->opp[idx].perf;
 		data.freq = freq;
-- 
2.39.5



