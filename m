Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827180;
	b=mkv7KXRHRViyjsMZslRu8ywTaOFNFy4N46nH7zhxGk8wczNTxqd1WVa1ygElfgNH/HW+
	 lrlc6H1LhuqQNdgQd002y77xQ08LtynjPt0lj3AouocB2vcRG/awrgOnizVU49/9Wakq8
	 S7a6ol2TE1DbqxU6XVqLw1/uQ9fpQh0mr0lbx8lHZC5lmKN5Sl9yTicMg4qkGuCIE9mSn
	 BOFus7n/rxv/ovCdtqfwjiqmJ785yaes3QuCPM9SNra5Lb2npffWy/lNgg3/DWnXYDr0z
	 YgJN732ABFtzXUAR+Y3yXyKyK37L35Bh9+G/zits5uR+ow+HBj65Hj/qg1CKMFUAIpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G+qFyCrIfMGiWXVVHZ4eMJipSoVBCvaJn1DuK8mj4j4=;
	b=RB5lFHsIoYhXWoWyr7Q/ft4XbWLCLnsO/N3X6nUF2ltyhTVUfzVxN2TyzYPdjFg17C1c
	 brfDr8WOix27Y2CCSYrNMOWGrXO+JokD+25Jtd/ZEaAkg1Im2fgg3RWsArJQaD3prkao/
	 sESHCbKSDwGAdtWINalNrE8STWWQNwyVfFG0Z7InztLvV+Kjw+hQ34/+K1FiWwX1WJhL1
	 qWNEXxQMl1NNLAtj8crGaRUinoPGH3QEAlt15OCkLrnBn+JbZlnFZX0RP/GFVFVvPJPxo
	 Tkebs9Y9S1ZGO7oQh810g1e3EoQ5YMxAwHejoTbrsy6MpTkojjqP4WH9XV5osAJ5Fyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7uGHBUi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71626606A846;
	Wed,  4 Nov 2026 21:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7uGHBUi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFF31F000C1;
	Wed,  4 Nov 2026 21:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827180;
	bh=G+qFyCrIfMGiWXVVHZ4eMJipSoVBCvaJn1DuK8mj4j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7uGHBUi0W6/SZ+bm5CLBa3C4kl7jC6qkvNNVryuDC3zjQVdD9z/+DJQFO31epgm/
	 lRodje6ytP84Ck1ibBqdFoyvnhKGVg4GJ9oCN6I1h7IMopy5OqPGbgdUhvdq1dNued
	 yhp3FVBUhD/YCjATDe7mT/GbvMpTl9R5OBLReEcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.3 242/547] mtd: virt-concat: unlink discarded items before freeing
Date: Wed,  4 Nov 2026 16:07:06 -0500
Message-ID: <20261104211045.047222070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

commit 112a666bd82e96e4a01e0cd8a0fb9c88dd0bce38 upstream.

mtd_virt_concat_destroy_items() frees each item without removing it
from concat_node_list. list_for_each_entry_safe() protects the
current traversal, but concat_node_list still points to the freed
items afterward.

The function also unwinds errors from mtd_virt_concat_node_create().

A later initialization can traverse a freed item in
mtd_is_part_concat(), causing a use-after-free.

Unlink each item before freeing it.

Fixes: 43db6366fc2d ("mtd: Add driver for concatenating devices")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6, smatch
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtd_virt_concat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/mtd_virt_concat.c b/drivers/mtd/mtd_virt_concat.c
index 4fad0967a96e..637219e20b80 100644
--- a/drivers/mtd/mtd_virt_concat.c
+++ b/drivers/mtd/mtd_virt_concat.c
@@ -202,6 +202,7 @@ void mtd_virt_concat_destroy_items(void)
 	int i;
 
 	list_for_each_entry_safe(item, temp, &concat_node_list, head) {
+		list_del(&item->head);
 		for (i = 0; i < item->count; i++)
 			of_node_put(item->nodes[i]);
 
-- 
2.56.0



