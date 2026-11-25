Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626029;
	b=4T7XOgYorL20aCqOMtNPCIHhfAO12zZY7vd+mp/QMu8QR6G/TCAjzNU0E89qttfysEDK
	 e6PthPtOP5qS1L1/R5epNV/7kbhCkRNeNCUQc93885MbhdNa0070quDYmpU/tAD1IIRHm
	 BIWP++JYSrz/d1DpJCL/CvCRfLkPDnbWid1DY70Zgclxct7XccZemHjQJIywYA0smZwSM
	 pHghCkQWv1i9eYbSJ2tq3z0JKW++oIpbdJPmm+xD4U8VI+Rl5SGS1Be2xmQkaPBlwddoB
	 pvY2BcPao6vqQHoatcco99X4OZRPCABdZdEk1lCUDBqWXrpKNHLgBinMqMiYrIM3cZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X82Z9LtdQrF2GUEBdtwx2FdD1axmCpviqyWWgkPc7YA=;
	b=4K2GRAiCejiecefJ1CuGF+4E2fRgt3VsqEZ9bLs67ML9qIrWQ9foQ/coDze6pLnDjDGY
	 1tzSfv9URHtE6vZ+A5q677R7i4Cpve/DlZQiFZxvwSCCYMBEV10V+7UKwl6Qj23yLQ8cj
	 +KqF8UsFvtEypIaYs0cjvoJi8h/uycgPK1tNhdjLcKYnTKACBpCRcMvRIGwLlNxMw7Lu0
	 L0qCubYZ/VyCW2lLROj5vvm3ktWi/rYUM5xLQssNYbobNVG2fgtvqAtRq6T8icZBWFYG1
	 i+BAquzKmpwPBFhdl4/3DlQwAPk6QjqkUIdJ05zzWFYMjuVoR89eE7CqRjVBw6YZuRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rzJWHbV+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325BC606A321;
	Wed, 25 Nov 2026 17:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rzJWHbV+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DCF1F000C0;
	Wed, 25 Nov 2026 17:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626029;
	bh=X82Z9LtdQrF2GUEBdtwx2FdD1axmCpviqyWWgkPc7YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzJWHbV+B10qTlnKaj2uXC+AejGsleD+PB8QewWxoGvwNoixzZ0TEXi8h6Yx8WDmo
	 3ESCpjolCnNsjbqu1Kvue1PnsHB6TxRDIKdaDN7rWJE6oL6jyzJyvdyzHZ9R998dvO
	 TKKmh6jJAdI8oXLWSZZiKOTeFyQtvYE+uHo6xpMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 663/816] wifi: mac80211: fix use-after-free when MLO link setup is rolled back
Date: Wed, 25 Nov 2026 15:36:51 +0100
Message-ID: <20261125143904.524777611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit a155ef2ef79531c139244289c5b8f15c05d16a0e upstream.

Rolling back an MLO link addition can free link containers while RCU
readers still hold pointers to them. ieee80211_vif_update_links()
publishes new links before checking for duplicate addresses and calling
drv_change_vif_links(). If either fails, it restores the old pointers
and frees the new containers without waiting for readers.

During a non-MLO to MLO transition, the published link 0 replaces the
deflink, so existing link 0 users can acquire the new container. Readers
such as ieee80211_csa_finish() and
ieee80211_obss_color_collision_notify() can also queue work embedded in
the link. If they queue after ieee80211_link_stop() cancels that work,
it remains queued when the container is freed.

Wait for RCU readers after restoring the old pointers and before
stopping the new links, so their work is queued before it is cancelled.

Fixes: d3e2439b0f33 ("wifi: mac80211: fix link manipulation")
Cc: stable@vger.kernel.org # 7.2.x
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261026152654.80697-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/link.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -380,6 +380,8 @@ static int ieee80211_vif_update_links(st
 		memcpy(sdata->link, old_data, sizeof(old_data));
 		memcpy(sdata->vif.link_conf, old, sizeof(old));
 		ieee80211_set_vif_links_bitmaps(sdata, old_links, dormant_links);
+		/* drain RCU readers before cancelling work they may queue */
+		synchronize_rcu();
 		for_each_set_bit(link_id, &add, IEEE80211_MLD_MAX_NUM_LINKS) {
 			ieee80211_link_debugfs_remove(&links[link_id]->data);
 			ieee80211_link_stop(&links[link_id]->data);


