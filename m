Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604C41C8621;
	Tue, 12 Aug 2025 18:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022322; cv=none; b=cmwou0vCkbivBk0RovKlwzkzhHQEaOLFyyPhS6eRfIIa0ZrOHliz/iD68O7y+43q5mSmWhpwpiUkvWpzpFwXN/29n3hxnG8wvzXAj1Wj4dAQexICwVJSFi+CCR/eAPiotu2RHJnCL0UH5T3ufhc3VOL167uZ9AyB8WAYZFEIHFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022322; c=relaxed/simple;
	bh=0nO6TdEhY1YUrNkzEZn7lZ7oquang42w3Ru+jSSl19A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUrOUdc3JDYRVViPxwCjipTEl3sC7jYIWssZ2BGH9nZxN5LKuEzYRiYgTaug8J6DMumDz/tOGbcE85P0KeRBQo+VtzEVVv044v4uHI8HASU+RA0x7xQa97Z1HU27bD9AuPgY5KkAD5Go3vyfMvJPBowbV2lLASIvp7CuKXW5UTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cX2le/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cX2le/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D58BC4CEF0;
	Tue, 12 Aug 2025 18:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022322;
	bh=0nO6TdEhY1YUrNkzEZn7lZ7oquang42w3Ru+jSSl19A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cX2le/QJ+DDUgSm57oSuho8fIBKqmkmjNsOMacHhmviDmJJVJkdta5pFEA2blJvL
	 rezhEKZ+AecY9b4DnnX8nut2R6MF5b9zHJovi03vcG3kVE7wSORQnd6lbET4DeWrMk
	 8E8vrcPJg0LQU7z2O/mEiD24BiLiAKgQ/W0HaSZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/369] wifi: mac80211: Dont call fq_flow_idx() for management frames
Date: Tue, 12 Aug 2025 19:26:58 +0200
Message-ID: <20250812173019.318852239@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexander Wetzel <Alexander@wetzel-home.de>

[ Upstream commit cb3bb3d88dfcd177a1050c0a009a3ee147b2e5b9 ]

skb_get_hash() can only be used when the skb is linked to a netdev
device.

Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
Fixes: 73bc9e0af594 ("mac80211: don't apply flow control on management frames")
Link: https://patch.msgid.link/20250717162547.94582-3-Alexander@wetzel-home.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0386810be520..16f8b24820ae 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1437,7 +1437,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 {
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
-	u32 flow_idx = fq_flow_idx(fq, skb);
+	u32 flow_idx;
 
 	ieee80211_set_skb_enqueue_time(skb);
 
@@ -1453,6 +1453,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 			IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
 		__skb_queue_tail(&txqi->frags, skb);
 	} else {
+		flow_idx = fq_flow_idx(fq, skb);
 		fq_tin_enqueue(fq, tin, flow_idx, skb,
 			       fq_skb_free_func);
 	}
-- 
2.39.5



