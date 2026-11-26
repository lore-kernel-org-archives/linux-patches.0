Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704682;
	b=n7emtROAQMcySPz5eNA2exLb6eRVdjTZzbQz63C2fQcxyq/iDIsfqbrXitX9qAc7np71
	 nyqFAwAEvz08g6YQXrTIMivlWdxmRHqtIzeAFJwNHwb0B0e3T1kh/Av4mpp03ZlY2/sJH
	 rqtFksPpwLeqbmBlGP9Z9OORbLqdFvofqGRWK8ivIr2858RIJz3kglpXcsG2fXfUNbxNR
	 GGdTPfHgOtnEpmb30/8RZpCr1Tc01B6vp0iJsN/hrGRzMg+yDrRdWYmf/iIh+Y4hseuy+
	 nxBBW6w1hgIvvjcnqB5AXqrAtfEAJHROJF4X9geHiap/uegI38F9H87dMiOwy4s55sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QIO/btPqKTMYSUdU+JbrdEqf7iiLLH2DHix6ak4xgxo=;
	b=AKzHMZD1l711dnw/dvqTtCkKxXALCf9VXJ75DZhzT4ZAtkptwuV5vaFjViveLD/tvGKk
	 y7LbHLz6Y7JVYVTo+ueASGTTeNGAZYPaIiBpHUGpvuS2DlJ7fzYQD1fDSSxm1KWqTjlHT
	 urfeWVxTIGmq002aV6kQ0FF3P54Lu1LhwPmGV1iia/4tYI9PebTUN3ldpyyVh/wajZdp+
	 bpI3OI0hY6yUopTYn4dmJBt7rE6azoDLHCwQiVRovSZCi0U8IduySDxo+RromUUXFhb+2
	 P7JWKx/9BJqciykMRNclItVDrYqElGCSOEFnYg6DGJTsyJ5enVT5KnLpjYYx7imSXpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOrFXZDt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D204C606A321;
	Thu, 26 Nov 2026 14:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOrFXZDt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6F21F000CF;
	Thu, 26 Nov 2026 14:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704682;
	bh=QIO/btPqKTMYSUdU+JbrdEqf7iiLLH2DHix6ak4xgxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOrFXZDtxe0yaAcuOEvSwXRj5dvYdrmosZUctOEHbQC5aOpm9sIe0KFq4tBzbIPyT
	 Y6BepG3zSfXvw+4zsJYOeNREaOd/yCclppWw9f+PnmQKkor1uZW++sjGWw/RcvzIiq
	 c2N5SR8yDbEvbIF1di1SSO3oCMgdwnoq1FPSHzOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 191/265] wifi: mac80211: recheck injected headers after removing FCS
Date: Thu, 26 Nov 2026 15:38:41 +0100
Message-ID: <20261126143618.539399000@linuxfoundation.org>
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

commit 339564c7ac50464695dfed847f89d118f4cc1dc5 upstream.

Injecting a short frame with IEEE80211_RADIOTAP_F_FCS on a monitor
interface can pass a truncated 802.11 header to transmit handlers.

ieee80211_monitor_start_xmit() validates the linear 802.11 header before
parsing radiotap. Radiotap parsing then removes the four-byte FCS without
rechecking the remaining header length. Software encryption can subtract
the larger header length and pass the resulting negative length as an
unsigned size.

Recheck the required linear header length after pulling the radiotap
header and before handing the frame to the transmit path. Require at
least addr1, which the transmit path reads even for extension frames
whose header is shorter.

LLM assistance was used to find the bug and review.

Fixes: bddc0c411a45 ("mac80211: Fix NULL ptr deref for injected rate info")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142101.11994-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/tx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2400,6 +2400,12 @@ netdev_tx_t ieee80211_monitor_start_xmit
 	/* remove the injection radiotap header */
 	skb_pull(skb, len_rthdr);
 
+	/* FCS removal may have shortened the 802.11 header. */
+	hdrlen = max_t(int, hdrlen,
+		       offsetofend(struct ieee80211_hdr, addr1));
+	if (skb_headlen(skb) < hdrlen)
+		goto fail_rcu;
+
 	ieee80211_xmit(sdata, NULL, skb);
 	rcu_read_unlock();
 


