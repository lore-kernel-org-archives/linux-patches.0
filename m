Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19A838AC92;
	Sat, 12 Sep 2026 09:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204401; cv=none; b=TviGIGwTP2zd7osRE1Ndedg2tQn+e3KtWHnLHc8BW0E+uU0Lqc8dh7jy5I9mfUeI3cUTOHXjlmaiqJeu7GHW62zAkkHIXTJOrmvv+z2i0+Ek2nNHtbSe8+gq+PDlCyOwLwHzJdljQ3mpHn05K0BV8PUi1x8USxqeCm3VBojXonM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204401; c=relaxed/simple;
	bh=czc5V36fV8lowgR9Wa2aexw/+BjS0uyKcURU45OMQ54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oxfxaj4lUL7kY29fq+ebktSC+ApRwkP4fGxq6zfX3q9wrNKjypl4pBp/J/86H9AGiYNzMItkxP/bVCxO3MsI3i07+JBAISyMA9slzhPK93Hqqb7Z43aZUdWz269iuIac2xHv/zPb5jHlzYl2jNqvsgzJSyVIcI28jS57gKcT/yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhQU1XmJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhQU1XmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41751F000FF;
	Sat, 12 Sep 2026 09:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204399;
	bh=/Sh3F+6eCJ0NQTJE+5tWCC/9QagKrKL/DAxS2fRdp5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhQU1XmJEAkS0ZgYWnQSRrQW7sS6/ytMHdBPqwm9w0EAh6bEMvE/cTfMRFnIZionT
	 Uuj52a3HpO//q09CSC2GqDic0ioECRwCAZsgFnAbcT4bUyYrXc/VB1QU9tIVM5XWVR
	 MYnlHp4KRLZurCEQ859wx4uy790QL97FZOKcytsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1562/1815] ptp: netc: skip PEROUT disable if channel is not enabled
Date: Sat, 12 Sep 2026 08:55:12 +0200
Message-ID: <20260912065725.664247553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



