Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E232AF07;
	Wed,  7 Aug 2024 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043317; cv=none; b=B/zMMhi+YzNWWH2MNlKOKn2Whx8P0BZiMqUXi0LHQrxhDX2axRzcarScg+Gfm1u7/06+Ecmu7ZkbPBCfxd1L8xaCbGfjbji3jRHc9PrWqVw8S/4ivRHBf/K0A5gI1OguNCnkOG9mTQgFU9JFJ94bX275OYTkpIzMxpxYX3TEgdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043317; c=relaxed/simple;
	bh=wP7rlVbUQemhRIsy3NjnaynGocFbptrb1a4W9Ipgt4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZsWj63+vndgmGku0KIJG30RSksEjjLr4J/EArAyzE7Rw/hUqiLWm8o/AUtfIfMCqkTWmfJiy0pVCflUdk9Pns8tEj4OFn7r3Lb7oB1D+p4IFRXqt/RvI49ZD63RttuBKemeFLGtKwO96c6bXKpmrtLldwV49DDiJVeinHuPF8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3N+C/uW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3N+C/uW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C76C32781;
	Wed,  7 Aug 2024 15:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043317;
	bh=wP7rlVbUQemhRIsy3NjnaynGocFbptrb1a4W9Ipgt4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3N+C/uWReSE+tD3MfP7ZTUkbr4CnwdPlkueiE3Oe4JlmVu1/hpy3/XAVt66A4ao5
	 M77XEDuGMSEeTsuUEk7mhuXkwV291RNnbzLqNGEYCnx+GyosX/gzCvqQrP7+mkPc2Y
	 fXMKiOESbyb14H5R4GcrglB+YYbQCDksplNSL58E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/121] perf: imx_perf: fix counter start and config sequence
Date: Wed,  7 Aug 2024 16:59:38 +0200
Message-ID: <20240807150020.901845183@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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
index 5cf770a1bc312..4f6eade522024 100644
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



