Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046609;
	b=KD+9BGIbVZmaWX8zexojNpGexGUQYdfRexPTK7jfnmSj3qIiuyrCe8TFW9XjqSbJ8isI
	 3nY7vU3OHlYLxez4o3TeMbnR/174woY0bLaXmhx5mJVkqVMnWgl8YVvGheifcdPdNzH+j
	 i/XbRf9mrV11bA8UuGpCjSufHTJFsAuu4d9o7JKBGfSQartW3Qv//Pe630APiwo3z2C29
	 k0+LKWMfIUfzuDx3NQ5XrwzHlLal2Kobbnh49sps7YYfbNrcRxapSUjSNfbzTVQfBygMm
	 1AVdeKovrYCRwvl/VNZ9Gj80kMX+DlqqNTprz943wMuzpfqyxryv2ML7iEC96WUVcng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JAIXh+NIXcTLYSYIeQpCmra3stVpcK51R/9Nlz6moe8=;
	b=i8cnZFsAIceJBsDZM7B7Fc8WOkYcGmxsAkASwVXwsISO3JPSwozggX7eFlqhlcHB0Fjz
	 G6LffmNoxYmF/beUpOnPViKLA1HwpJ/J3r3AdarvyR4fnyRDSS88DkJImBuYstCbZeljd
	 A5S0TSF4BimufuBQHygMf2r+oDvqeG9qc8hT5LQk2LaAjUux+qY0sIhirv7VGklfCa4aR
	 hIh2nNWAywO8qa4FI7UTZyNl745RZ6lzYqkTKLwnm/wiZF3TLjkB19KZOjdnFNP6l/dgo
	 +q+cQY2ssPlKbH6vMMOOgY6Ud15YtIeoZOgS8SbAP4cmj2MLOWBomce84EXuhPW8+Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y+NGF+mS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5E8606A335;
	Thu, 19 Nov 2026 00:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y+NGF+mS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED591F000C4;
	Thu, 19 Nov 2026 00:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046608;
	bh=JAIXh+NIXcTLYSYIeQpCmra3stVpcK51R/9Nlz6moe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+NGF+mSduJkmhIi4OZlo5nvT29Sfn0DY2tLskyYfTxMELF0uNLGvQzHJcp9s9xx5
	 tnjeaaCbDQV8JaDHfFDag4g7r3UQsXOXF4KG2lXAxM0ZSk1wkiVBqSpE0QKU6RZc7s
	 H9nZGvPRKz9CZt+huFytJ29Eds8pqhVh+AeRCLL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1343/2857] batman-adv: stop originator purge worker before freeing TT
Date: Wed, 18 Nov 2026 15:39:37 +0100
Message-ID: <20261118150249.780373479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit f89eda5a9ccf82cba06b085b42ebc4886b8dfe9e upstream.

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
[ Switch to cancel_delayed_work_sync() ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 48065fd09e1a8..fb8964d867349 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -262,6 +262,11 @@ void batadv_mesh_free(struct net_device *soft_iface)
 
 	atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
 
+	/* the originator purge worker accesses (among others) the TT tables
+	 * and must therefore be stopped before any of them are freed
+	 */
+	cancel_delayed_work_sync(&bat_priv->orig_work);
+
 	batadv_purge_outstanding_packets(bat_priv, NULL);
 	batadv_tp_stop_all(bat_priv);
 
-- 
2.53.0



