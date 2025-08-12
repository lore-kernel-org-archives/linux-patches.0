Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2364B2FE57A;
	Tue, 12 Aug 2025 18:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023396; cv=none; b=AfHoA7i65/lpcUjvGZmvE7zIOSJSExF/DsS55qEHkdpCYx/txe8Yhzl9CmDHDEe4L96w0r90RNCMt4plYSZNaE7QaUCVmro1o9SAGfKogd+LTn1qND+l/z93qZ3oZsOfZu826AYcsmvAT1IqG+oQbjusCom2/y1yX4Zrxb5lpsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023396; c=relaxed/simple;
	bh=1v8tLvJg1xGQcNkUsZaaZbeaiWB2Y7bVQ5ItcvvlC1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eu0x6g1l2OqVrvRwwRX6mrRLMLjFNrmPq5yWyd2FqvPApYl6IgeUIo6RegaCGr2PJMvq6TUdmJdrTDOcOGqOgnFSvfN4lgXTESeWy7pqwzUxCytURhgL6VLgZnRtO+aoY4CzhhfkPp0+VcUp1SUDyyKifumE3niqJmlXGHV7Yyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amFRAaHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amFRAaHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA97C4CEF0;
	Tue, 12 Aug 2025 18:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023396;
	bh=1v8tLvJg1xGQcNkUsZaaZbeaiWB2Y7bVQ5ItcvvlC1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amFRAaHaSSNS9DX1SWE+3hd069Jpk+AXMkBT7KG9wmsoUGpr7kwSpdoBuKbM7vpoE
	 Ufw6Ig+eKiQHRUAt+mFfJq3MW3d/CCnrJSvh9xxnFAYlfv42p3+jXG2Z+VH6KRFbm9
	 jqeQu+FDYfcaqMCol7lJLYwOF7jBqpKWTkyV29m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 060/627] firmware: arm_scmi: Fix up turbo frequencies selection
Date: Tue, 12 Aug 2025 19:25:55 +0200
Message-ID: <20250812173421.610240805@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



