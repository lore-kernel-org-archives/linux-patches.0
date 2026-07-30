Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065DB443E3E;
	Thu, 30 Jul 2026 15:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425659; cv=none; b=RYKKilimSUnqw1LveQSPjBxUsENlWV3V2KNwqhLFuA++ZohDCsVjuEHwsvPURndoFYG/OyiBvTpJzJF3Xznlfm+bKhgxr1AfGpshaHHPLO3C8Phf7z3VzgfuLNVPA0sYpg6qDSMIxtHV4L/96R6zCXuNZZY0QE3Snky3+RvAy8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425659; c=relaxed/simple;
	bh=a8cnTO3evSkYtqA23+uiOEcSpRbq3kuvVVbiXGKMaS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXC27lf7k5a/H4yhBdvmD2rCU10AQ9Zz6WFicK0PIbBFkndmUaG3sEf1PPCb3+uGdr4MylD1H4QIynE6y6YnY6UiOh/Dsg6lG56cM12NHa4HkkAxZbNaGziR1OviJcnEuE94go9D/1Q+bgl53gHTFuV54ja5jbma78v3PK2a+rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gOaOnJA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gOaOnJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE521F000E9;
	Thu, 30 Jul 2026 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425657;
	bh=tpYY1D+ogbdXTcvyozt4KeNCU0oA4zeZKkGxe+4Tg20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1gOaOnJALGlKddY7LRaFJdSzXDVOJGREAFhSAIT9lmv5oG3bgybC8x3iveK4fUXxU
	 JdR7MzFymdQPlmFaQyPDFd+PE5cyYwq1rzssJi7xnYDswfWQlkg3seXDu+OfuqpRBJ
	 TtI+3zf+P/tqRTSEYQQfW497qOO4pfkS82baJY4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/602] wifi: ath6kl: fix OOB read from firmware IE lengths in connect event
Date: Thu, 30 Jul 2026 16:08:59 +0200
Message-ID: <20260730141439.068730087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 6b47b29730de3232b919d8362749f6814c5f2a33 ]

The firmware-controlled beacon_ie_len, assoc_req_len, and assoc_resp_len
fields in ath6kl_wmi_connect_event_rx() are not validated against the
buffer length. Their sum (up to 765) can exceed the actual WMI event
data, causing out-of-bounds reads during IE parsing and state corruption
of wmi->is_wmm_enabled.

Add a check that the total IE length fits within the buffer.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260421135009.348084-3-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index a572952dd4b903..447896b871c3e2 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -874,6 +874,14 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len,
 
 	ev = (struct wmi_connect_event *) datap;
 
+	if (len < sizeof(*ev) + ev->beacon_ie_len +
+	    ev->assoc_req_len + ev->assoc_resp_len) {
+		ath6kl_dbg(ATH6KL_DBG_WMI,
+			   "connect event: IE lengths %u+%u+%u exceed buffer %d\n",
+			   ev->beacon_ie_len, ev->assoc_req_len,
+			   ev->assoc_resp_len, len);
+		return -EINVAL;
+	}
 	if (vif->nw_type == AP_NETWORK) {
 		/* AP mode start/STA connected event */
 		struct net_device *dev = vif->ndev;
-- 
2.53.0



