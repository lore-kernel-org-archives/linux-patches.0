Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD3B390CB0;
	Thu, 30 Jul 2026 15:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423825; cv=none; b=m6t1wIIQ6ziQVW0cLlx2Rcxl5OJQNQ0tKYp/nJggRy3zh0oe3JRaLfoCSu3mEY/9yOeWkXLJgSZnYP9fqcLdNpTvKlr/fc0dhPxwbhuhspPC9ZCRcYPXB12C/VdxWzgnfPHmZQlp/OAzAQco296d9CYkJn725k1R5Ys+Axgy9p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423825; c=relaxed/simple;
	bh=rAVLaRVPFV1O9ywgRdGKubvttVpNL1N3aM+19EC48lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=La8hP64YomNTVnNJPHRld034zmK+Yjzx8Nz26WY/UsDqne+li0aVjofjqR/9PQaasqCymNJx7CzSre/cARlG4ATjVLkq/Ewy3OU0/wUoARP7gjN6rjG0vR1BZBvzfPPgQaZ/Vv29TSXV6Jb0Mx0vXY46p3y/Edo0PMCSZbUSpOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+JWW73B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+JWW73B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D4D1F000E9;
	Thu, 30 Jul 2026 15:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423824;
	bh=aIiBBtPFUS2OPm5AUjXSRu2rsDmHQmX1vTgOgpOLlYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+JWW73BatoW2vMftE7DhNJhopI5PL0cHmfmVWmvh9gUSKA0TfwoyfVnCGUe97ziW
	 lpE81SWi4+7VVDK8kL71sz1qEt2Q0Tt/soISe3Y0F3gW1pZVzowW69yt7bJyb/zuWi
	 RnEUZovB0wThF8WWD8hWYgiBi6KpTpYEKc7UpNGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 180/675] wifi: ath6kl: fix OOB read from firmware IE lengths in connect event
Date: Thu, 30 Jul 2026 16:08:30 +0200
Message-ID: <20260730141448.963641581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index aab1ad80a8b6c2..0cdcbc3c77966a 100644
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



