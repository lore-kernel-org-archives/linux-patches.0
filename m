Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD573382C7;
	Mon, 20 Apr 2026 15:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700063; cv=none; b=JM5DVsm8oSwy1mjGRjlbWPalWFq03bU8+LDpqWs408nzjJtMfMtJFBtZd0nsYmaX+3EQAu56sQKtbwAuydJZ6MsYIAX19Hc8cW5kcoPXBgkJ0KToQT8bMQjzhQMn7LXSTLpkrr1XWfeUJoD/gf7dVXrL2RwKRhhDzNHjEOG+paY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700063; c=relaxed/simple;
	bh=fPVLSU4niD/mdSmbBR1xSOJJoZE6NddwTlUf3TxDqkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mjj3HtHH4u82yv1DdD9aAWIEH/dwByDIqvMB+FO2E4phGr0/06B2l5vG0qlQ+OTPQr3Y2ZT79p6vU0wAd8m9q65YjKusurLG4NLr8gSFzwGzi+5sjQ0ubyE08ODFLZeSLtnGbL4wqYLWl0tqWOHoa+dz10AKNrWhwt9OCts0+/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vK6u4IL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vK6u4IL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970D3C19425;
	Mon, 20 Apr 2026 15:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700062;
	bh=fPVLSU4niD/mdSmbBR1xSOJJoZE6NddwTlUf3TxDqkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vK6u4ILxBknNoZnbIF+4MXr6RteiQXDan1DlMIp7PqB7HRQUrutUedYT0rFN7D0Q
	 12RC6ZRh6KceRJdejHz3boA+fK+LWfk7t/C06MsdEluxGpq4MyOf9Mk9zAbPB/pRA/
	 hF/x2rg1fFRIkpYpOViZinR972zxyFN16bJzIWn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 027/220] wifi: wl1251: validate packet IDs before indexing tx_frames
Date: Mon, 20 Apr 2026 17:39:28 +0200
Message-ID: <20260420153935.007394572@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 0fd56fad9c56356e7fa7a7c52e7ecbf807a44eb0 ]

wl1251_tx_packet_cb() uses the firmware completion ID directly to index
the fixed 16-entry wl->tx_frames[] array. The ID is a raw u8 from the
completion block, and the callback does not currently verify that it
fits the array before dereferencing it.

Reject completion IDs that fall outside wl->tx_frames[] and keep the
existing NULL check in the same guard. This keeps the fix local to the
trust boundary and avoids touching the rest of the completion flow.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260323080845.40033-1-pengpeng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl1251/tx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index adb4840b04893..c264d83e71d9c 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
@@ -402,12 +402,14 @@ static void wl1251_tx_packet_cb(struct wl1251 *wl,
 	int hdrlen;
 	u8 *frame;
 
-	skb = wl->tx_frames[result->id];
-	if (skb == NULL) {
-		wl1251_error("SKB for packet %d is NULL", result->id);
+	if (unlikely(result->id >= ARRAY_SIZE(wl->tx_frames) ||
+		     wl->tx_frames[result->id] == NULL)) {
+		wl1251_error("invalid packet id %u", result->id);
 		return;
 	}
 
+	skb = wl->tx_frames[result->id];
+
 	info = IEEE80211_SKB_CB(skb);
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
-- 
2.53.0



