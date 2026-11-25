Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619023;
	b=av/kM8FE8pxkHeR57/aQ/wQBpNy+qqqWwbFRPIYA2D7dq7GH6Gw6P8srEK8vISpzXrt8
	 EjghMrmK9fjKKvhW9eco5Oe5A3+CPRKElCQQNBfDRm4xe4V0TV1JEmoauK0hGJZhQSmJ3
	 IM1myohPmwb2C2y1Loo9GLCdHwMJZGgJqpeMKy+DVriewdgY21xZUzJG8EzS9PZTjObk1
	 l7qux9NBhp28Rg1qc5+OOcqn7zHZDncfPdHkJ2tWJ0+GaUzrRKZe62OsuHCFN5IdGiRZO
	 oWZD7U7/yBeQ5W7ZKzdJjG5wHVJGuG8gbO/Jt+haIxwubghs7YcgX23Yz7tooCubTjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fWZs48gb74tLQ+r7tiYS0Bnf9eRc22x/fGjBvua+x0M=;
	b=gN3nsQGy0ejVvrk4ihzdptktNmcOGXaq4r5e2kRzBBUSNqvEgJ7PBvdxHAMz2GEoRrtg
	 fKrD83kCDGmHluTY40evFgyKlji9fjPDQ/LbRjH6g+pM2m7QBMENoT1ez5FjDdm8IdBj8
	 OvzGLOQAeNzXxe/YL3ZnNF0q8qESL3y3hluZ/NfT7NftN+UzKFSUQRHjBmlSUZHOXFrAT
	 rwMe7hZhIEfLUHOBmmGZr8ME7PVwv+oNgEg04MPis1FFqjVALMW1aL2sabmmzNT+9bNhm
	 jWqK2DGUcEl7+PSlQXwAp0scVsAqNvg0STAz5wsz4dev7D00asXgz/4iLwJ2F1dlY5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M47XWCGx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF8B606A323;
	Wed, 25 Nov 2026 15:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M47XWCGx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EDB1F000C0;
	Wed, 25 Nov 2026 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619023;
	bh=fWZs48gb74tLQ+r7tiYS0Bnf9eRc22x/fGjBvua+x0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M47XWCGxBVPZWMujnSBhhHCkrbd1P3tWwbkzskT9REJE7UQU81XM/caowI24KU/q/
	 xgC9qB+Yz2f8Tyc3SP0QmJvodwX2URv8icc/s3aFIuHramwXo8NAJwUmnfhxd2t1sJ
	 teDsUQzKSesUVujNQfQiIc9qgCtOJ6OAh9Qd/t1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0465/1005] wifi: mac80211: mesh: dont linearize SKBs unnecessarily
Date: Wed, 25 Nov 2026 15:30:03 +0100
Message-ID: <20261125143832.637808201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6a6db144d96352967623f38692dfc4b4fb814518 ]

If mesh fast-xmit cannot be used due to aggregation not
being fully set up yet, there's no need to linearize the
SKB. Avoid that, which addresses a stale pointer issue
in the caller.

Change-Id: I6b93e6c7587faf8749f8366ed574ee2b79fd47a5
Fixes: 8b0f5cb6bc7c ("wifi: mac80211: use mesh header cache to speed up mesh forwarding")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index aa8e3e375e075..e66a8b66d6a4c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2930,9 +2930,6 @@ ieee80211_rx_mesh_fast_forward(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return false;
 
-	if (skb_linearize(skb))
-		return false;
-
 	tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
 	if (tid_tx) {
@@ -2943,6 +2940,10 @@ ieee80211_rx_mesh_fast_forward(struct ieee80211_sub_if_data *sdata,
 			tid_tx->last_tx = jiffies;
 	}
 
+	/* this function must not fail after this */
+	if (skb_linearize(skb))
+		return false;
+
 	ieee80211_aggr_check(sdata, sta, skb);
 
 	if (ieee80211_get_8023_tunnel_proto(skb->data + hdrlen,
-- 
2.53.0



