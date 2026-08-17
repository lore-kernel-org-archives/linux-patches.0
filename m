Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A842E7BD6;
	Mon, 17 Aug 2026 15:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979119; cv=none; b=c6SN+5cDg6mjGebuoC3s0KjPHRYJP96q2lKdc2VIYERr2XkEOKpfIdl4c8LO0Q52uxR8yU32B2ZWmucNGwn34/oiSgOb2v+s4GmDQ0osuZ8EsvkJfEwwKOuiu00M4YQ/lBQFAR6Xv/QoX/0XcXpoSymOius3QC7ETj3Y9bzBWg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979119; c=relaxed/simple;
	bh=NqtsN2r04lxh0lA3q09QnRa0V0Lj0YU9DSmT894pWO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGdNNHFIuszJs7wGC8MJIJHm7jH/WHoNIXvcUXfnqoTb5YyPo0F1fs5adKFKsEE7MRCeS/ECnjdy+9kVpgAxZxEwQIJ5JqefzPFEALmxQPAERrfjAnWz/d1aWM/4esfh5V5NeVUZyqflESavH3R9ZJIZb/13QC6KKI9aig0miTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eJDtg58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eJDtg58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1478E1F000E9;
	Mon, 17 Aug 2026 15:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979118;
	bh=cq+2gzLKzD6vsbLZDTwrU0Y+xjZBgz1PHyL28U+qIls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0eJDtg58ewqWYNL7qcGrsMhg43FBTvDYZhnUla1D253IsukTHIiVx/7DxI/c1qaJN
	 FT1+jxvcy/sBxGkAkUzSGN1HBud8nQRmozWHwQ37uqcw02hDJIAvsQD/cRXPEww/eF
	 MWlVPJMBtBv++q4z2Dlvrbr4PhMWIK9ofRlxyQ50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/609] wifi: ath6kl: fix OOB read from firmware IE lengths in connect event
Date: Mon, 17 Aug 2026 15:26:44 +0200
Message-ID: <20260817132547.352918301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



