Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623304;
	b=fmNwufurVNeYN6Lw5NYxfL9kzKQV1PmjUKnMMq+my+G7uwGesRxh5Ank/gPoMz2TuNO7
	 GsDq9GE9Lq3xKwvqV9DHP4/lF4QJ8rVeXOFdtIFxkRucjBJfTLL72/dNWrNZT4IpN1zL1
	 Y4g4cG+2jVVBwyXwP2oln9uUZG4Ws7S1dLAgnfeEDvULvIRtJK0tLDzJwAdPnxAAvpzUx
	 iq/jPtRfxSH3xeyRFIBY+q5ZMM/q2zDr6Z5EWLMe20xi96qUppw6+tZlQdWdxi6/07v1Q
	 k8mU/i6Gbj5jcRy6hddG3o2bSKEmZakj0zDUqKxHiHvayFej8W2GxFqtHal4YMo9t9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f6dILdqbXWhJ58jxHxXGoxNplDAU+tniwKf7gViBACg=;
	b=Ou2+G2mekHu2r7l5XfiuUXueERWi7iM5AeIXq6+LDqGavxrFDiHiCAgKV1Pzhut7JToz
	 rjLq9MYIUZQwOKkkguHro6BgPNhNHSilmi9OZVF1hJGljLCY1R8P5Ek1gUUo9uUjzE41x
	 VuenlM1tCIlehsEWq+ePWkCxzvYZZu4ZzDJFvMofzE42iJrwBT+ca6vEUitxPV1oXoUf7
	 6IcGddVJRzuJEXAlqobX4mtoEUu9Is8RabuJejv8KmrgV8nL9KCYhx1CP99VKW/IGQzZu
	 tRmotq6cYMkPTcBE/3XWMzn91g3hH98bG2I9Rw9ob7sozH12E7txAEPbrtu9DHHXFAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZkqVtJc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D10606A323;
	Wed, 25 Nov 2026 16:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZkqVtJc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC951F000CA;
	Wed, 25 Nov 2026 16:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623304;
	bh=f6dILdqbXWhJ58jxHxXGoxNplDAU+tniwKf7gViBACg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZkqVtJcgck4PbdYJS9W0dHweDrHTMEsUgf+6ZEHf/OnyWugdaRoynFRn57A2JzWx
	 4REQoVyCFqvbF5YDutozZ9b4TtbAFNnpV/KeuhkRkqYwAr8tfhwzb6F7ZT9KJwxaNg
	 HBBrFq8UhRK9v/A+TFejnWB3SmajbH2mQR7uOrG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 814/990] wifi: mac80211: fix use-after-free when MLO link setup is rolled back
Date: Wed, 25 Nov 2026 15:36:21 +0100
Message-ID: <20261125143841.108875125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -385,6 +385,8 @@ static int ieee80211_vif_update_links(st
 		memcpy(sdata->link, old_data, sizeof(old_data));
 		memcpy(sdata->vif.link_conf, old, sizeof(old));
 		ieee80211_set_vif_links_bitmaps(sdata, old_links, dormant_links);
+		/* drain RCU readers before cancelling work they may queue */
+		synchronize_rcu();
 		for_each_set_bit(link_id, &add, IEEE80211_MLD_MAX_NUM_LINKS) {
 			ieee80211_link_debugfs_remove(&links[link_id]->data);
 			ieee80211_link_stop(&links[link_id]->data);


