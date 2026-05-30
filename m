Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A9A349CC3;
	Sat, 30 May 2026 16:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158232; cv=none; b=RaTU65NmuKDvfTLeGR08V8PZQurBIzfoSCRcS+ys85N/81xoVh03y9yJtE3XAczv10vuP35aYB9k6szN/YGUyoPyYRdImaXn6eQwqBFUJ0oq/VX+tzB6TivqjwU0oYtw/NQJEnikGmIDv3IrgRoQpeFALId9jHSxhmS7OdklVBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158232; c=relaxed/simple;
	bh=ztcWN9xa8vS8DFb/pabBy1eRQg0wLU/PbvkJQDNtdl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dL4c1wBIxoCMB5qreaE9JtB/+Z/u5kmzlIxS82nqzUGFYEqfcSsQXJWL8YgA7k4qyw6C/sytQw7TaTU0rPZz4oMdcF2Zp1T+4EhMYWcC0qrX17iL8YixGIOcbz0fI8cMDsc8AhAut8U2oD3vsS1sfHFIqoW4iPyBorwS0b6a7Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4LVY2KU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4LVY2KU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876901F0089E;
	Sat, 30 May 2026 16:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158223;
	bh=HEcvzJ/p+FT4ZmFB9vSdw30AJ3eUGAIQHNUEE8ZJKCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4LVY2KUtjDQ7+NiT/q73nIWtLwUWbqP1/12qQjP0GA2trG+uvgZYPegwZOThjZ+U
	 z8Id32/XXY9gQ5WXlCkrDQY1FAbZZADHXvMtM7OF94ezD0vHgR//S+xbjngUusEKs5
	 QZPG07A77TcfGNlD5lujnIteIUmcTk3C736HeDjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/969] wifi: wl1251: validate packet IDs before indexing tx_frames
Date: Sat, 30 May 2026 17:52:16 +0200
Message-ID: <20260530160300.813967700@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 06dc74cc6cb52..2b316c78eefc9 100644
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



