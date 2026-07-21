Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44A4472F9C;
	Tue, 21 Jul 2026 21:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667653; cv=none; b=b5EjRKrzNtrm5kKblZiHVCYipkv9i49QUrfrmYWZFhv7p4BM/sLLVUOVD/761Llr8JzZi2CnX3PlE9stjYi/TfotY6M2g0cJv12yePy1+XJEwO7pP+VOJo67zgWub1Jnn/feF99uF5xziOwnEa9DDQzrco9WKcLbBdzuatfRfhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667653; c=relaxed/simple;
	bh=y7gbqe9v6Oq7SABiItRkB6cOEX8FgXb14QIK65qk06Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7Os59ZcwsI/lY8QENH4wBwZg5Ri6d+7ll6p38a56LMJGXkWjecYMN5dNTnFhNECNGbL62S4YgN+F3Ocsg9F0Tnid/O9kFNJZMVcDC3akflrHWFimVpBfC5U76VHjg+XWt40JYntLkK4mcnQcRF8k/1G1jdKQOsogLvR9GqqNu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3U83+o7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3U83+o7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CD11F000E9;
	Tue, 21 Jul 2026 21:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667652;
	bh=Ra+bJBn6uZce/hdOAxWZmp0+W9UBmf6uWCEXP6h6y/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3U83+o7r3+0rzFb8F0xmLCIv/BzPYZrXLJoEShGoX1s0f6MiJTBCSVp4d3eN8T5n
	 57ywZWT42WGD0Ucoxt9ZkGVReYQYNyRj030I1K6dbKCI82BB1l+jyb7/eUZp3ip0Id
	 PpVbECFn1Lyh6pY0P+NvGm8rSySIjeECkh9T4vLA=
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
Subject: [PATCH 6.6 1141/1266] wifi: mac80211: free ack status frame on TX header build failure
Date: Tue, 21 Jul 2026 17:26:18 +0200
Message-ID: <20260721152507.321845932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2568,6 +2568,18 @@ static u16 ieee80211_store_ack_skb(struc
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
@@ -2925,7 +2937,8 @@ static struct sk_buff *ieee80211_build_h
 		if (ieee80211_skb_resize(sdata, skb, head_need, ENCRYPT_DATA)) {
 			ieee80211_free_txskb(&local->hw, skb);
 			skb = NULL;
-			return ERR_PTR(-ENOMEM);
+			ret = -ENOMEM;
+			goto free;
 		}
 	}
 
@@ -2990,6 +3003,8 @@ static struct sk_buff *ieee80211_build_h
 
 	return skb;
  free:
+	if (info_id)
+		ieee80211_remove_ack_skb(local, info_id);
 	kfree_skb(skb);
 	return ERR_PTR(ret);
 }


