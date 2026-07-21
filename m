Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7EB415F0C;
	Tue, 21 Jul 2026 22:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674515; cv=none; b=B8j2s+Yilnve10kkDhtIxr9QkI/gewY+M9lRV4QINjMVqjHbkY9rvQPXemibJkSmZwHdSDvFdDr+aoQFWnEqyXRNWVa3zhKXaznrHR4Cj+5xX+mBz+Uwwh1vJtnV62r6CFwFSqN1nqR8ABuGRhwH6uLG2nWMZ+Ypt6z1dMPZerw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674515; c=relaxed/simple;
	bh=JSGyaygI4w+7ez/I7QQSe1AemPZG2iJY5JJb3vryh9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtAU2wxLwWP/PIyFRsmBNZvVeiKeT/l+d7JlD68YWo1WTc69mYERw8j2ZYYma4DwlhaKT8DjY38JfaT0InG66x0hAdtd2a5DeKBpnACFK5hao444zYuDD8ypto0899xw796B+YTM9e4wJHcLP/3lvLZSDow3bUJAJeWBYwC2mrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZKfdUT/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZKfdUT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889CD1F00A3A;
	Tue, 21 Jul 2026 22:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674514;
	bh=Sl6zwBBZZpV8vUREHwlGQPwz5kd8/BJrMLFJPSFjLmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZKfdUT/zelcvIK68VJcOMfmw24PO7dunAhnS8qBMBpYJVbFsMXqQ0L5ny4OrW9ei
	 CriUJkfovBmR4mAxODhsO+cNx/sSISaJ5CC212p1+3qQaHdI/BjN+39KXqtj6of758
	 nrhUSCJ68B9fS3tOez/xMvYKNDmlAqEG5FlPTSoI=
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
Subject: [PATCH 5.10 570/699] wifi: mac80211: free ack status frame on TX header build failure
Date: Tue, 21 Jul 2026 17:25:29 +0200
Message-ID: <20260721152408.567119551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2516,6 +2516,18 @@ static u16 ieee80211_store_ack_skb(struc
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
@@ -2875,7 +2887,8 @@ static struct sk_buff *ieee80211_build_h
 		if (ieee80211_skb_resize(sdata, skb, head_need, ENCRYPT_DATA)) {
 			ieee80211_free_txskb(&local->hw, skb);
 			skb = NULL;
-			return ERR_PTR(-ENOMEM);
+			ret = -ENOMEM;
+			goto free;
 		}
 	}
 
@@ -2912,6 +2925,8 @@ static struct sk_buff *ieee80211_build_h
 
 	return skb;
  free:
+	if (info_id)
+		ieee80211_remove_ack_skb(local, info_id);
 	kfree_skb(skb);
 	return ERR_PTR(ret);
 }


