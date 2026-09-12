Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB826457E7A;
	Sat, 12 Sep 2026 11:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211576; cv=none; b=HVV2zW0ndEAx5WJv2W8TQZUitYEQIgW1dSjq+kVzU0xvNUMPvBpbi++w1l+OzjUnXTaR+yNjp7697hTgz3G46Ge0BpqpfQPosMErn7sxWU07du870KiWQqj4R/Op2E/N3BCa7un5pqqtKQJOJafvSzI5iAwXQoeE/z5yb+eQ/Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211576; c=relaxed/simple;
	bh=q4WmeedPr1Zjku5VWiwvRKke98pR+XJ8aup/OCnl6tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hu6ZNH/10fS7t9q6S4Siv9f8nJG+IwJS9xZHXc6akIhSgafrZhaLJDLIjFPTUCnlr927ZRq9tFcE3mh+r8tFjwn/dF8iqUIqgV3F10DsuezPoxJxDH3jWFjVywcmi1k7lcjQLttxZs3NLFVyEPReOR1/o5l+hQjFKASIVFeyK0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiEMgCqM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiEMgCqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2521F000FF;
	Sat, 12 Sep 2026 11:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211575;
	bh=OeGgc6E55mtms8cKrGu8Po5OqyzOVWpQIOlipimIh2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiEMgCqMyudkjSuWuWZYB0/+eB/WoheNwirJL8jm4VlYqsQ2BjhA8Rz9ME/Y278ci
	 NIy+vmUWlhjqQrim3oobWTP/bPDOC2UYt9dQbGV/+1fapSDz0AWK9c4g6qeOpl1w76
	 T3coECWKoCzxFrPbJrbLWKf8iCICJ9k/9g0v+07s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1259/1518] ptp: netc: skip PEROUT disable if channel is not enabled
Date: Sat, 12 Sep 2026 08:57:08 +0200
Message-ID: <20260912065651.993222506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 273480bb836e515353f30a1e70b21a2382de666e ]

When userspace calls ioctl(PTP_PEROUT_REQUEST) with period = 0 to disable
a PEROUT channel that is not enabled, the driver incorrectly enters the
disable path. Since the channel's struct netc_pp was previously zeroed,
pp->alarm_id evaluates to 0, causing priv->fs_alarm_bitmap &= ~BIT(0) to
silently revoke the alarm 0 allocation from whichever channel is actively
using it. This can cause two channels conflict over the same hardware
alarm configuration and corrupt their periodic output signals.

Therefore, guard the disable path with a check on pp->enabled and return
early if the channel is not enabled.

Fixes: 671e266835b8 ("ptp: netc: add periodic pulse output support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/message/20260809031908.46EBF1F00A3A%40smtp.kernel.org
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260811083614.3589967-1-wei.fang@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_netc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ptp/ptp_netc.c b/drivers/ptp/ptp_netc.c
index 1c20d7efab929..59db08e189e6e 100644
--- a/drivers/ptp/ptp_netc.c
+++ b/drivers/ptp/ptp_netc.c
@@ -482,6 +482,9 @@ static int net_timer_enable_perout(struct netc_timer *priv,
 
 		netc_timer_enable_periodic_pulse(priv, channel);
 	} else {
+		if (!pp->enabled)
+			goto unlock_spinlock;
+
 		netc_timer_disable_periodic_pulse(priv, channel);
 		priv->fs_alarm_bitmap &= ~BIT(pp->alarm_id);
 		memset(pp, 0, sizeof(*pp));
-- 
2.53.0



