Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70961502787;
	Tue, 13 Oct 2026 12:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893416; cv=none; b=ovOqTjY3drCTuGmjQ3+TpABk74s0onPT4f3IPa+vbpqSMc+jD1nGGwpfTkpE1Euf4Wj4CRg61uz9VFNTuYk6+FqP6PW9p+ENzZbLBL3ldqJurRLRup3izunnUqPv/UIdpHy/xn1T9Z70njCh5FYb+yHtK9BJ4Uz6Kh/1dI7WQu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893416; c=relaxed/simple;
	bh=EucJailWohpNxXs+MPmojnQzFyEzgjOG5ePOtoi/6yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHMZLtBeEzdDul3xlG74L7uamULkKNA/9GBXMzDKEnBCCc2rnDvZCx0rJii8UwK0HQRew73728O/rwZ9T5g5BWy6iRFEvzFnLp9o7a702VHjRHijC60WNm2SBSPUMJnx6+qXvLib0wyL8GcaA0j3y6xzuXzJNsrsr+LjT8pe4ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlEl7Vc2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlEl7Vc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEEF1F00898;
	Tue, 13 Oct 2026 12:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893415;
	bh=pPNSSgOmUWdC5k6jufRWeQJ2oNxkFXFzyzkWiJrAO2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlEl7Vc2p2RKDonSwxeQdg1Mz5E0f3OK2CwSS/ZRgifV2yje/5mZ4XgTVPJfsWAEV
	 RQY3DHfKA2KotspnheZc0zv+9lUS2AKhrtrGFy3aF9mgcjCbEyzyFYDJqDHd5A5+eJ
	 UYzH3rJ+FWTb4ownSOBqUg1ooSK8QfeXqxKkKncw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 219/621] ptp: ocp: Make ptp_ocp_unregister_ext() NULL-aware
Date: Tue, 13 Oct 2026 13:33:34 +0200
Message-ID: <20261013112926.057758011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 590f5d1fa6ee22b1ec07283d5fa870326f47b2f6 ]

It's a common practice to make resource release functions be NULL-aware.
Make ptp_ocp_unregister_ext() NULL-aware.

Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20251124084816.205035-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 627366c51145 ("ptp: ocp: fix resource freeing order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 249bb3877f673..46cb06c2160f8 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2227,6 +2227,9 @@ ptp_ocp_ts_enable(void *priv, u32 req, bool enable)
 static void
 ptp_ocp_unregister_ext(struct ptp_ocp_ext_src *ext)
 {
+	if (!ext)
+		return;
+
 	ext->info->enable(ext, ~0, false);
 	pci_free_irq(ext->bp->pdev, ext->irq_vec, ext);
 	kfree(ext);
@@ -4558,21 +4561,14 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 	ptp_ocp_detach_sysfs(bp);
 	ptp_ocp_attr_group_del(bp);
 	timer_delete_sync(&bp->watchdog);
-	if (bp->ts0)
-		ptp_ocp_unregister_ext(bp->ts0);
-	if (bp->ts1)
-		ptp_ocp_unregister_ext(bp->ts1);
-	if (bp->ts2)
-		ptp_ocp_unregister_ext(bp->ts2);
-	if (bp->ts3)
-		ptp_ocp_unregister_ext(bp->ts3);
-	if (bp->ts4)
-		ptp_ocp_unregister_ext(bp->ts4);
-	if (bp->pps)
-		ptp_ocp_unregister_ext(bp->pps);
+	ptp_ocp_unregister_ext(bp->ts0);
+	ptp_ocp_unregister_ext(bp->ts1);
+	ptp_ocp_unregister_ext(bp->ts2);
+	ptp_ocp_unregister_ext(bp->ts3);
+	ptp_ocp_unregister_ext(bp->ts4);
+	ptp_ocp_unregister_ext(bp->pps);
 	for (i = 0; i < 4; i++)
-		if (bp->signal_out[i])
-			ptp_ocp_unregister_ext(bp->signal_out[i]);
+		ptp_ocp_unregister_ext(bp->signal_out[i]);
 	for (i = 0; i < __PORT_COUNT; i++)
 		if (bp->port[i].line != -1)
 			serial8250_unregister_port(bp->port[i].line);
-- 
2.53.0



