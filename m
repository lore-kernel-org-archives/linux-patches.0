Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585422;
	b=hzxwAEKAu6plXbiVVd92M+CyjBBKwOfXgPASvL+c7IjAe8Dpnw0yl0izMOQAqpkwSGdG
	 8691Pq/4pXyY+/UhrG+8jCrf15kxWPB5JXDg+pmZsGqCFqdYxZ01e8ccSuVlfgc3TDEoe
	 EFjFtDY3+t8FZi08MthPub8F5GbwgntOIgje0bQF3LZHwgi3Hdz0A6GmZ/W2J1EcpSluy
	 2e2V24g74+j2IPj1GRn1coMWArYVJ49hJdfa28WHhTGQL77rzvzuZXwNVO3jfIjgeLAdy
	 UdP2RCudIkmFFUWnnYQpflmUTH0LAFNhO85GFmlcVBe8WSuEOHrSqQO/qbaMbGlgeKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tJlMPt9x10tuKOmpcTrzniY3LJu3MDM/McAk6wVcskg=;
	b=RLYkLry7LdXT3beIMJcZV5lFKh30n+Gi4UIevRPc9IT0h+cofwpEhDx0gXvpV/VKfjUN
	 f4pBlhEXtK7Zfq59/nDU2SY/UdloEYdHDEKHyT7MiakglV/q9/yvMK/GSxeCnpAR9ERqI
	 SNXgMuSbitJQBsnsj8cMXI3QjRRAmrdOIuRL54R8cmDHSgMgsEgQ4DZHCHnA7C3qhZicW
	 AgIFizCGoJt+jPgWOnl+5Ro9hmKbGujiE3j9ERLlYxOehsG29L4LoCYhXR2S9gubNUsLQ
	 sf61TRjt/fabQiL4pVqqilas6nAUGLmoOSoLbh9tVxobJES6h4kzfyCGVPzuX7kjWtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="D/k1KyYX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D3760A383C;
	Fri, 13 Nov 2026 15:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D/k1KyYX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADBB1F000C4;
	Fri, 13 Nov 2026 15:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585422;
	bh=tJlMPt9x10tuKOmpcTrzniY3LJu3MDM/McAk6wVcskg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/k1KyYX8BFa5avvJwML4ZgQb1uywCg46y5Ab6Nq7OibVYvipC8jY/PJSnM3i77xi
	 5dRy02MCe+esyfG0lHsLZ8RTm6VoTAqE5IOttoDSiCy4Ar2i5HVhTzvykgfhjfLcNC
	 mJJ7KX5xOoG8WWZjSKHWDCYmbHMhbzMxdWXtRQMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 086/507] batman-adv: stop originator purge worker before freeing TT
Date: Fri, 13 Nov 2026 10:46:30 -0500
Message-ID: <20261113153756.822475822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index eec28e7f82b51..5d5a0be323e60 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -294,6 +294,11 @@ void batadv_mesh_free(struct net_device *mesh_iface)
 
 	WRITE_ONCE(bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
 
+	/* the originator purge worker accesses (among others) the TT tables
+	 * and must therefore be stopped before any of them are freed
+	 */
+	disable_delayed_work_sync(&bat_priv->orig_work);
+
 	batadv_purge_outstanding_packets(bat_priv, NULL);
 	batadv_tp_stop_all(bat_priv);
 
-- 
2.53.0



