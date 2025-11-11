Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B2E2DA757;
	Tue, 11 Nov 2025 01:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823622; cv=none; b=Ob+oux7ly6Ovj03KyntNVVWMBmiOTz10oQtLofIrOVQT7rV5JFYEesAFEaFx/saB+N9iP0f9RARQ+v94Ulyn4szY5pJCdaQg7iRa6l+6XUDKP+YlaKVHmdHFA3I0D3cbM1HrBIS1zyaO13brKQbmdDdaHf4xrW9dLM15ixbSih0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823622; c=relaxed/simple;
	bh=0h4Pf7m1iCQJ7329t7/OJHrCvFYVsHLiXFNNUPajZm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUQ8rSBsFVTALjYimc18wQwd9vwlE/J9kHuOKhvEaXm/GP+5vUkJnrbIUY0DZ0eIDIT8Q6JNXTS3IND7QEW0GvydXfjXWFE07zMkrc8GJsR8/5G/HTkGPcyLm0YoXauPBdt+YrYZP7JBPnm4iMVZKNTEIy4/A4MO5Q6K9dpwB3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgPmBfg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgPmBfg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3079DC116B1;
	Tue, 11 Nov 2025 01:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823622;
	bh=0h4Pf7m1iCQJ7329t7/OJHrCvFYVsHLiXFNNUPajZm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgPmBfg+Qb2UVvcwvsI8fiWBjYM+UCF2N2gtLbP5AoE8r60ZeMRHVx7tnu789G1Vh
	 UFcwjjUPQTZCWgMIskbIAmIfhPzCb2igiPRetDSCHGo0pqmAf0DTHqIm4KMi96r9kj
	 RHNSnEFzInJbamA5g0RcmPbaFc+oE+0Hq7M+8Ad0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 288/565] selftests: drv-net: rss_ctx: make the test pass with few queues
Date: Tue, 11 Nov 2025 09:42:24 +0900
Message-ID: <20251111004533.355157115@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e2cf2d5baa09248d3d50b73522594b778388e3bc ]

rss_ctx.test_rss_key_indir implicitly expects at least 5 queues,
as it checks that the traffic on first 2 queues is lower than
the remaining queues when we use all queues. Special case fewer
queues.

Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250901173139.881070-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/rss_ctx.py | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/rss_ctx.py b/tools/testing/selftests/drivers/net/hw/rss_ctx.py
index 4a986a5524a30..e9f3ac7f0b8c8 100755
--- a/tools/testing/selftests/drivers/net/hw/rss_ctx.py
+++ b/tools/testing/selftests/drivers/net/hw/rss_ctx.py
@@ -161,8 +161,13 @@ def test_rss_key_indir(cfg):
     cnts = _get_rx_cnts(cfg)
     GenerateTraffic(cfg).wait_pkts_and_stop(20000)
     cnts = _get_rx_cnts(cfg, prev=cnts)
-    # First two queues get less traffic than all the rest
-    ksft_lt(sum(cnts[:2]), sum(cnts[2:]), "traffic distributed: " + str(cnts))
+    if qcnt > 4:
+        # First two queues get less traffic than all the rest
+        ksft_lt(sum(cnts[:2]), sum(cnts[2:]),
+                "traffic distributed: " + str(cnts))
+    else:
+        # When queue count is low make sure third queue got significant pkts
+        ksft_ge(cnts[2], 3500, "traffic distributed: " + str(cnts))
 
 
 def test_rss_queue_reconfigure(cfg, main_ctx=True):
-- 
2.51.0



