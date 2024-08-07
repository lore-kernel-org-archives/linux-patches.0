Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A979923CE;
	Wed,  7 Aug 2024 15:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042880; cv=none; b=hJfknqn9G4nASJYf1JJJK0d+t4VFKjoRf1rJpMmclMbECx3zlZgc+ZK01Iog1lNC/+eMHiRiStSbDWK4V9HvDzV8m6gEhkm90Run3J0591haMi9Il6QMvJCUJ9X7VRAJ3fepbEwDxuScUXDP+PgY1S8U5q6IP7utpBO0Os7403g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042880; c=relaxed/simple;
	bh=rv8l++BqyePrThnuzhglHTtBlme03FANyq16wu5djUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wvhu9Bblupo008oXwJrvFgJxCgvZGGBWxzMJgACbRf1NXgdA1Jr4ToEXuY+xQ3/zleMQlljDK8v3yqu3Ohm2qJSmKGu/VSL8IikygmXdrikH94TYiFUI05J0EIsnF4Rd3EefeLz+WEQWMELlhy+ZLr2LCTGY7hIq6eyDkuwkAyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x32jh1K9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x32jh1K9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AFEC32781;
	Wed,  7 Aug 2024 15:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042880;
	bh=rv8l++BqyePrThnuzhglHTtBlme03FANyq16wu5djUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x32jh1K9JPztudDT4OUJYXBlulU9ifp8+L7411lflyNtVU0vjYkLLzAn2Tiyugif3
	 zjz3U0zPUSOHqpByiAV5mmoZbrzhU38e4KmUpgYbD/FEGWxqMAYcHdJCaMKeNDH8IH
	 7x9bZEL637NQ4NRJRzXRWs6/ru+o8bdcpG6iDlEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 010/123] perf: imx_perf: fix counter start and config sequence
Date: Wed,  7 Aug 2024 16:58:49 +0200
Message-ID: <20240807150021.152170628@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit ac9aa295f7a89d38656739628796f086f0b160e2 ]

In current driver, the counter will start firstly and then be configured.
This sequence is not correct for AXI filter events since the correct
AXI_MASK and AXI_ID are not set yet. Then the results may be inaccurate.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Fixes: 55691f99d417 ("drivers/perf: imx_ddr: Add support for NXP i.MX9 SoC DDRC PMU driver")
cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240529080358.703784-5-xu.yang_2@nxp.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/fsl_imx9_ddr_perf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/perf/fsl_imx9_ddr_perf.c b/drivers/perf/fsl_imx9_ddr_perf.c
index 72c2d3074cded..98af97750a6e3 100644
--- a/drivers/perf/fsl_imx9_ddr_perf.c
+++ b/drivers/perf/fsl_imx9_ddr_perf.c
@@ -476,12 +476,12 @@ static int ddr_perf_event_add(struct perf_event *event, int flags)
 	hwc->idx = counter;
 	hwc->state |= PERF_HES_STOPPED;
 
-	if (flags & PERF_EF_START)
-		ddr_perf_event_start(event, flags);
-
 	/* read trans, write trans, read beat */
 	ddr_perf_monitor_config(pmu, cfg, cfg1, cfg2);
 
+	if (flags & PERF_EF_START)
+		ddr_perf_event_start(event, flags);
+
 	return 0;
 }
 
-- 
2.43.0



