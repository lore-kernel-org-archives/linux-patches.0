Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591095;
	b=4ZHVTlhJFQRLcSOXWaeyzz6PylaY+liz75hH9PeitxnNQ3SwSx0GaPTP8O/OZpemVjnP
	 NZa9gcCIg1X/iagLaVPkydyVjecm4L3in33On4qPgwnupI4SHoOwiTo4EwBHXjxEL8/M4
	 jPgr3k8+tjX2T/6VN2i+SZTnOZzu+wHfrm1Nhqp99CGY+42Pyq/oRa/30sp5gGrACUy/k
	 pU7YVIxwtYmp3NntAgtGu8oildklM5k744dbmmspnep4zvXaXIHgLfjVxlyTZGK8mbR7h
	 E3hRxkPxf24lyZeDesI/ZC3w1UZJ2N/UdLg4rDccFETgPHDYP2Z6LOL+2QfpK0nQJ9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fch+7l9qbGfJM+pXYfoz57fUh7i3r7+g6Tjs5hEkbH0=;
	b=maNeulimqVt42ca9JlahJpd30cZh408gJmoMq3NRo/7bkASVPnMISWIch+hkZcavZALz
	 CnK5J/uUFjUArq2LF7NLdoXu2q/DEwQGB7N9ZN7JI0usegDz/XnAXV9Ol03GcBYTi9Hij
	 m0K8wVMv6Z4F4XkR9QrGIe085yzyn0i5aG4Zt+0i9NDJtKWWiGTQKqYNPFHcm9BH4mZu3
	 lZb3I8oLWoDNVn7lTu3SLLglfNMu2kw/9IuYvMVI1h/IA3Hd4x86H2990XSc/MagBlssn
	 Z0hIErIe+q8a5aj5z7gYOLbEx2/glP7MZQjBAqg4tVgNvqdXqfRPDA8OvkU4BRIxYHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a65h9XfE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D5A606A880;
	Fri, 13 Nov 2026 17:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a65h9XfE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D581F000C4;
	Fri, 13 Nov 2026 17:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591094;
	bh=Fch+7l9qbGfJM+pXYfoz57fUh7i3r7+g6Tjs5hEkbH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a65h9XfErPKr5JaCDq1caJX/j8SeDfs3BqE+Q/GYDid4AFdl/k/DMiDKZmX+0CdTX
	 L/+aC+6PAH+XNG/N/wvHpnRFqVAQAekz0S9sIBbDhu1MR5YwHXb+RX3+CR3td4uEsz
	 Hh6sDCHnb2BAo+wtlBlgIDVff1rgxho3pq0m9qeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 198/670] batman-adv: stop originator purge worker before freeing TT
Date: Fri, 13 Nov 2026 10:46:02 -0500
Message-ID: <20261113153818.690783459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit f89eda5a9ccf82cba06b085b42ebc4886b8dfe9e ]

batadv_mesh_free() releases the translation tables via batadv_tt_free()
before batadv_originator_free() stops orig_work. The purge worker can
therefore still run while the TT is torn down. When an originator times
out, batadv_purge_orig_ref() calls batadv_tt_global_del_orig(), which
loads tt.global_hash and walks all buckets while taking their locks:

  CPU0                          CPU1
  batadv_tt_free()              batadv_purge_orig()
                                  batadv_tt_global_del_orig()
                                    hash = ...tt.global_hash;
    batadv_tt_global_table_free()
      batadv_hash_destroy(hash);
                                    spin_lock_bh(&hash->list_locks[i]);

Disable orig_work at the beginning of batadv_mesh_free(), directly after
the mesh was marked as deactivating. The second
disable_delayed_work_sync() in batadv_originator_free() is harmless because
it is free'd anyway.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260708091821.314516-1-sw%40simonwunderlich.de?part=3
Fixes: 9d31b3ce8168 ("batman-adv: fix potential TT client + orig-node memory leak")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 55055d3290e74..ccfe1c7f33edc 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -263,6 +263,11 @@ void batadv_mesh_free(struct net_device *soft_iface)
 
 	atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
 
+	/* the originator purge worker accesses (among others) the TT tables
+	 * and must therefore be stopped before any of them are freed
+	 */
+	disable_delayed_work_sync(&bat_priv->orig_work);
+
 	batadv_purge_outstanding_packets(bat_priv, NULL);
 	batadv_tp_stop_all(bat_priv);
 
-- 
2.53.0



