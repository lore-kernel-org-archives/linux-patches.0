Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9D53A1E81;
	Tue, 13 Oct 2026 12:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893937; cv=none; b=dNs47M+/BQFjdc15nmrnzMlfDYR8I+vWDynBJWOHWxyCw75ihVTc7XpIbbTH1udjqPNzKPaIS0mkW6T89LPkvGgWiXj1+gNO7XLs0ZSz+85GNTIjdV67FNYVuMil+vW0Sib4czKxZBS/0eKsPnVb0mECOLulxb4mignj6VosUPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893937; c=relaxed/simple;
	bh=3CL2I3/gXkHbk8KgKzPSWAMh65U3PKvwlfmobHauIss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WA4jzxizZWbdeIYrXB7TavAcd2KgymJxF+jEXBNGTKy7pgiV6eUO/EceBlOIu93F7vrehD+8ZmqRX8JirV0JSBbnli7efEnKdVCgaxjBVvFEVHZ5QgJBRY7QRzS9J2FzU8Fz8TY4C68anBSYc4Z4dE3hjjKDdcOiCCr8ShsSqSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osHlEPRJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osHlEPRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526FA1F000FF;
	Tue, 13 Oct 2026 12:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893935;
	bh=WDJYYATJ8c7qlimpnOi5d6jWjWxCXtm0v5CyHKSVZeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osHlEPRJhFWs/OJR7uM2fHyoNfsdLSl0dSFVLQGwgaXzrMDk1StGpmeUlqocV+4zZ
	 WfKmEQTQo2xzFl8dxk01AH2LX0ti4j6FcQngltzjAgExRUtoJzkCl/tEgcH00eaukU
	 TGecJ9/EEw+l7CqDBMZBbmeXYN5A8PBNHsAiy7xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 349/621] ovpn: defer key slot crypto freeing to workqueue
Date: Tue, 13 Oct 2026 13:35:44 +0200
Message-ID: <20261013112929.133232875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit 2da3dfa1ddfe55a065f484750c83660e3bd4ac00 ]

Key slots are released through a kref and the existing release path
frees the AEAD transforms from an RCU callback. That is not safe for all
crypto implementations: crypto_free_aead can sleep, for example when an
async or hardware implementation has teardown work to complete.

Use queue_rcu_work for key-slot release. This keeps the RCU grace period
needed by lockless key-slot readers, but runs the actual crypto teardown
from workqueue context where sleeping is allowed. Once the rcu_work
callback runs, pre-existing RCU readers are gone, and the final kref put
already proves that no transform user remains, so the worker can release
the AEAD transforms and free the slot directly.

The previous patch drains ovpn_wq during module exit, so queued key-slot
teardown work cannot outlive module text.

Fixes: 8534731dbf2d ("ovpn: implement packet processing")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/crypto.c      | 10 +---------
 drivers/net/ovpn/crypto.h      |  4 +++-
 drivers/net/ovpn/crypto_aead.c | 19 ++++++++++++++-----
 drivers/net/ovpn/crypto_aead.h |  1 -
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ovpn/crypto.c b/drivers/net/ovpn/crypto.c
index 2e95f29514fc4..7e545428900a9 100644
--- a/drivers/net/ovpn/crypto.c
+++ b/drivers/net/ovpn/crypto.c
@@ -18,20 +18,12 @@
 #include "crypto_aead.h"
 #include "crypto.h"
 
-static void ovpn_ks_destroy_rcu(struct rcu_head *head)
-{
-	struct ovpn_crypto_key_slot *ks;
-
-	ks = container_of(head, struct ovpn_crypto_key_slot, rcu);
-	ovpn_aead_crypto_key_slot_destroy(ks);
-}
-
 void ovpn_crypto_key_slot_release(struct kref *kref)
 {
 	struct ovpn_crypto_key_slot *ks;
 
 	ks = container_of(kref, struct ovpn_crypto_key_slot, refcount);
-	call_rcu(&ks->rcu, ovpn_ks_destroy_rcu);
+	queue_rcu_work(ovpn_wq, &ks->free_work);
 }
 
 /* can only be invoked when all peer references have been dropped (i.e. RCU
diff --git a/drivers/net/ovpn/crypto.h b/drivers/net/ovpn/crypto.h
index 0e284fec3a75a..e3feb16d54985 100644
--- a/drivers/net/ovpn/crypto.h
+++ b/drivers/net/ovpn/crypto.h
@@ -10,6 +10,8 @@
 #ifndef _NET_OVPN_OVPNCRYPTO_H_
 #define _NET_OVPN_OVPNCRYPTO_H_
 
+#include <linux/workqueue.h>
+
 #include "pktid.h"
 #include "proto.h"
 
@@ -45,8 +47,8 @@ struct ovpn_crypto_key_slot {
 
 	struct ovpn_pktid_recv pid_recv ____cacheline_aligned_in_smp;
 	struct ovpn_pktid_xmit pid_xmit ____cacheline_aligned_in_smp;
+	struct rcu_work free_work;
 	struct kref refcount;
-	struct rcu_head rcu;
 };
 
 struct ovpn_crypto_state {
diff --git a/drivers/net/ovpn/crypto_aead.c b/drivers/net/ovpn/crypto_aead.c
index 2cca759feffac..aa3cd9837cc03 100644
--- a/drivers/net/ovpn/crypto_aead.c
+++ b/drivers/net/ovpn/crypto_aead.c
@@ -9,6 +9,7 @@
 
 #include <crypto/aead.h>
 #include <linux/skbuff.h>
+#include <linux/workqueue.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/udp.h>
@@ -294,13 +295,19 @@ static struct crypto_aead *ovpn_aead_init(const char *title,
 	return ERR_PTR(ret);
 }
 
-void ovpn_aead_crypto_key_slot_destroy(struct ovpn_crypto_key_slot *ks)
+static void ovpn_aead_crypto_key_slot_free(struct ovpn_crypto_key_slot *ks)
 {
-	if (!ks)
-		return;
-
 	crypto_free_aead(ks->encrypt);
 	crypto_free_aead(ks->decrypt);
+}
+
+static void ovpn_aead_crypto_key_slot_free_work(struct work_struct *work)
+{
+	struct ovpn_crypto_key_slot *ks;
+
+	ks = container_of(to_rcu_work(work), struct ovpn_crypto_key_slot,
+			  free_work);
+	ovpn_aead_crypto_key_slot_free(ks);
 	kfree(ks);
 }
 
@@ -334,6 +341,7 @@ ovpn_aead_crypto_key_slot_new(const struct ovpn_key_config *kc)
 
 	ks->encrypt = NULL;
 	ks->decrypt = NULL;
+	INIT_RCU_WORK(&ks->free_work, ovpn_aead_crypto_key_slot_free_work);
 	kref_init(&ks->refcount);
 	ks->key_id = kc->key_id;
 
@@ -367,7 +375,8 @@ ovpn_aead_crypto_key_slot_new(const struct ovpn_key_config *kc)
 	return ks;
 
 destroy_ks:
-	ovpn_aead_crypto_key_slot_destroy(ks);
+	ovpn_aead_crypto_key_slot_free(ks);
+	kfree(ks);
 	return ERR_PTR(ret);
 }
 
diff --git a/drivers/net/ovpn/crypto_aead.h b/drivers/net/ovpn/crypto_aead.h
index 65a2ff3078986..fae3b585a43b3 100644
--- a/drivers/net/ovpn/crypto_aead.h
+++ b/drivers/net/ovpn/crypto_aead.h
@@ -22,7 +22,6 @@ int ovpn_aead_decrypt(struct ovpn_peer *peer, struct ovpn_crypto_key_slot *ks,
 
 struct ovpn_crypto_key_slot *
 ovpn_aead_crypto_key_slot_new(const struct ovpn_key_config *kc);
-void ovpn_aead_crypto_key_slot_destroy(struct ovpn_crypto_key_slot *ks);
 
 enum ovpn_cipher_alg ovpn_aead_crypto_alg(struct ovpn_crypto_key_slot *ks);
 
-- 
2.53.0



