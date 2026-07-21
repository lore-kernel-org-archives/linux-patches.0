Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308C346D0B2;
	Tue, 21 Jul 2026 18:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659376; cv=none; b=PjA0ztsHSnk8QQqYp1zn6TXBbbm16p6tEXwrEsfaQ771EgOIvMLFO10UjbmDgIfw6UjVT+IlO17slIYYQ0Nu1ZZ8y03fJWgRDxLGJNcbXnQ1o0xn1YkRdwiU57KwhlJsHysnkIxOfLAz8hOltDeH/h7Hn3fvWA1LRvHGXl9/wFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659376; c=relaxed/simple;
	bh=aU2pCL0RPGN4eLBmVtIDUDYhn5a6n4sLepwODCboJ08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQFavFSwmaOasvBbNs0C333y/lr4tcrQJy5IlCM8YuH7EUoq2SUBc7Bcl0zNhZXCliC54PlOCoJyGw5Z0yPaXMAf9slgf3in2WOAun0XxJ93AEw070P2ajN1vg12Sw3p2fUHfHurip1ajxDfhH92wh2Jd9304DgYWfJnybrNpO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWR+GV+S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWR+GV+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF841F000E9;
	Tue, 21 Jul 2026 18:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659375;
	bh=fn/l7I9lwJElYlCNG83DJ1ztVUVbb8cfhyxN55O2p3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eWR+GV+SRfe5X83bi0RKjwuZH7faZQ4NKu1C2KByYHDUbhvdVeE8mQlgLhV5IfX+o
	 0ffjOQrl1R5xozSAv3Qez6p/Piqd2cS1ua1PXPUAHWfcZmaADOtnYyr3S4Opb/XdXZ
	 2TLC7qfJ/W9bWKxwJNLqKuL2Qr9n2l5W6MWL9vR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 1498/1611] wifi: mac80211: free ack status frame on TX header build failure
Date: Tue, 21 Jul 2026 17:26:54 +0200
Message-ID: <20260721152549.136291142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Zhiling Zou <roxy520tt@gmail.com>

commit 2c51457d930f723e5f2903af90f5847f7df53f42 upstream.

ieee80211_build_hdr() stores an ACK status frame before it has
finished all validation and header construction. If a later error path
is taken, the transmit skb is freed but the stored ACK status frame
remains in local->ack_status_frames.

This can happen for control port frames when the requested MLO link ID
does not match the link selected for a non-MLO station. Repeated
failures can fill the ACK status IDR and leave pending ACK frames until
hardware teardown.

Remove any stored ACK status frame before returning an error after it
has been inserted into the IDR.

Fixes: a729cff8ad51 ("mac80211: implement wifi TX status")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/9de0423da840e92084915b8f92e66a421245c4b8.1782462409.git.roxy520tt@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/tx.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2578,6 +2578,18 @@ static u16 ieee80211_store_ack_skb(struc
 	return info_id;
 }
 
+static void ieee80211_remove_ack_skb(struct ieee80211_local *local, u16 info_id)
+{
+	struct sk_buff *ack_skb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&local->ack_status_lock, flags);
+	ack_skb = idr_remove(&local->ack_status_frames, info_id);
+	spin_unlock_irqrestore(&local->ack_status_lock, flags);
+
+	kfree_skb(ack_skb);
+}
+
 /**
  * ieee80211_build_hdr - build 802.11 header in the given frame
  * @sdata: virtual interface to build the header for
@@ -2934,7 +2946,8 @@ static struct sk_buff *ieee80211_build_h
 		if (ieee80211_skb_resize(sdata, skb, head_need, ENCRYPT_DATA)) {
 			ieee80211_free_txskb(&local->hw, skb);
 			skb = NULL;
-			return ERR_PTR(-ENOMEM);
+			ret = -ENOMEM;
+			goto free;
 		}
 	}
 
@@ -3002,6 +3015,8 @@ static struct sk_buff *ieee80211_build_h
 
 	return skb;
  free:
+	if (info_id)
+		ieee80211_remove_ack_skb(local, info_id);
 	kfree_skb(skb);
 	return ERR_PTR(ret);
 }


