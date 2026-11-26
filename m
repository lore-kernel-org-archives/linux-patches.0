Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704748;
	b=l1fkk2A5OJC8DLnQLqJA+Dv0gYpkChw1f7Mypl3eMe2ZnA2yNJiSQ/McQea8iU8xLsbP
	 c+fjSxut58VL08+SpzO/rDgVkT0B4BDDXtzWyT2Fa/dg+MIZhHxMsEVmn2s/zI1npv6Is
	 xfdaGmrHHL9uqlE6LXy/s+CRMc/gfVKJeAhNmdgvRCVCoQVtK9PPKq/yqHIcJ4NTFyJXJ
	 dlqaCxDsRVcolLCSVNnFXklViillU/1E+HQlu6LFcb16aPubibN9k5Xt1ga4awzebOV83
	 lEghnKdpXM8z7qv3TXErwb43XjK1xjh7/ByKwMFRWHUpOZF/075Ywcngn1c6dTVkG1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P8GFfA1+QsFBYBpCpcu/HVOjzf93gtbbaS/56wh0qS8=;
	b=1FkdyKOZuSV4ajwtaITEfzDwKS55Jq5fardXEv/eyk3ihJt1A7CxKp851ev7b+scfKQ7
	 X3kjBWeP5H42o6wW+MCpPB15zwr2ZJhdEYm1PFmN24BmvAw28q4KZ3n6EDmf0D0YYLLZ5
	 BOpaOrzCWmFjBf4ePbwgsdGSvwRAZX48MmYpSK3rEb3xoTfiaFiA+R72Ew8fxGj60Uen8
	 mKSFEzH7qe0tyfP7AgqRt47b1qHMrFeeB1LjUpM9b4vbpqLFgW66NR9n4969btKVTEQ7d
	 /chlxzlW+tZy8ippPlB15pve/O9GCSIh/0oQsipxXiT9ftfO6rZstg+NHjSZ/LQ04vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDLMOKCK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67B6606A323;
	Thu, 26 Nov 2026 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDLMOKCK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33F41F000D1;
	Thu, 26 Nov 2026 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704748;
	bh=P8GFfA1+QsFBYBpCpcu/HVOjzf93gtbbaS/56wh0qS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDLMOKCKnXIvFwhsSuK7kc/kEhjASA+tZP/OUHUtLbVFDDeF5ABxKGbl+a8RxhjiX
	 gvTSNuQY4kVqVwKoFZVCJQAjGIFc72ROXH9TOSjuBOuW9Y3sWtWbQpElWaDsJwIGHd
	 3cmQXL9bLTq2DStA8ShLp+xo9wN5EiVXN1cUKowQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 193/265] wifi: mac80211: recheck the OCB station limit before insertion
Date: Thu, 26 Nov 2026 15:38:43 +0100
Message-ID: <20261126143618.683109742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 27e29a077b4887d0e0a813337f8b7e06bd020c81 upstream.

Frames from successive unknown OCB peers can make the deferred worker
install more than 128 stations.

The receive path checks local->num_sta before allocating each station,
but pending stations are not included in that count. Several allocations
can therefore pass before the worker inserts any of them, and the worker
then drains the list without rechecking the limit.

Recheck the installed-station limit in the worker under the wiphy mutex
and free entries that no longer fit.

LLM assistance was used to find the bug and review.

Fixes: 239281f803e2 ("mac80211: 802.11p OCB mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142302.16634-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ocb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -138,8 +138,12 @@ void ieee80211_ocb_work(struct ieee80211
 		list_del(&sta->list);
 		spin_unlock_bh(&ifocb->incomplete_lock);
 
-		ieee80211_ocb_finish_sta(sta);
-		rcu_read_unlock();
+		if (sdata->local->num_sta >= IEEE80211_OCB_MAX_STA_ENTRIES) {
+			sta_info_free(sdata->local, sta);
+		} else {
+			ieee80211_ocb_finish_sta(sta);
+			rcu_read_unlock();
+		}
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);


