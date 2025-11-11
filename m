Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431AF340280;
	Tue, 11 Nov 2025 01:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824034; cv=none; b=VPxQwzAfWm1mJLynvCurkZeEOi+pzQcqmiSJgcjEdpoFvRiYjn2uZuOFk6rK7qJFqQbTzvfOEOhq144AG1DjRAKdRqcnSCqj74p/ru+cKP7PIcmcOErS65uMCPHF6XziL6UN4/jVzWoNamc+rWSsDGsuUAkRJ1SpTZfks3uHOoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824034; c=relaxed/simple;
	bh=ftAywpmBI83f6xE7mAC7Q1j1nMjGaIFlHfKWPOeILvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q59EfiBfJCrGcD7hzrrObkZJo/Qc+YEBg2QUxJtEZN2q/XH+ofP4xGsKkFD4t36cd88ldeVPgqOELazr++tweh4yjuRnwQXTtdZVFreaVf1xDtpCJMBTy9ZYIg6k5vOrPvh2822Qq65WrlCvgwSOMom89nIt8xgctLSY4uF5TqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tknZWmFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tknZWmFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6976C4CEFB;
	Tue, 11 Nov 2025 01:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824034;
	bh=ftAywpmBI83f6xE7mAC7Q1j1nMjGaIFlHfKWPOeILvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tknZWmFld2xLT0lRueuAgMjiGg+5DoxEBcFKExFLvSdXpWglDDCSqu5+xec1UHB0N
	 Io4nPD7cu1iSu7gzg6L3p2jQz1WYY1FA4vp70CkudBqv5EcoiCeWXEJXpOKP5uXuaW
	 PpdDe14w/6bjqPOPGCv6veC+IfJSEIC6pxRXugCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 424/849] selftests: drv-net: rss_ctx: make the test pass with few queues
Date: Tue, 11 Nov 2025 09:39:54 +0900
Message-ID: <20251111004546.689757081@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 9838b8457e5a6..4206212d03a65 100755
--- a/tools/testing/selftests/drivers/net/hw/rss_ctx.py
+++ b/tools/testing/selftests/drivers/net/hw/rss_ctx.py
@@ -178,8 +178,13 @@ def test_rss_key_indir(cfg):
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



