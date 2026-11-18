Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055401;
	b=tHHsUauD8zsSMg8nq7ltij5ZqCIP3a0FBge3GahguAgXah0BvbZiJK+fPoNwuCPqiXLJ
	 9b+BISeo0yANWJ/fkaiYpaJXu/ib//zcTw5guVOLyUXDa+uzn4WzatjYWnvk0utXOyJZp
	 J6ISD3Y2/JS8clDUvz13pmZbFX3kkdbEQm54oafv2wdeh5KIx6p5lcRLa2fCtGcQ/WXSW
	 /TbbPz5ZoXOxddbbMEC8E/aRxIKkN/EPO1EEv/NEVog2yli8WQkf5nrty51xiucV/dhf1
	 X4tkDZWVPdLTHtbHxulu4VOp1DKtaeLydFQY8RdSMSFMJqB+sIxodez9/n6lLEe13GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jpEKDIdEN38ZUk+nPyXj5t87do8Dr3A5T1Vhlim3tRw=;
	b=cmltt5GD9aFh3R9KRxmr0CLal0x3c1YnzTnTjIIWlvYmx2Dsk95gCfPT+qMEfRJ4xcDO
	 XTWO/FV2aMpLfdVAkXG19YftN/LzAWZAuETIzNQ2fJzPbqy/+6MXLyGlR7Qe3IrJul8Ze
	 KtNX4NPdMo1/Fvwg1hssoyt1qBCvRB3H2XxynADR0K/uffPOhZDLP/GsOhMG+FtaM0Wx3
	 rUttd7f+ZUkRUHOGHQGN3SEdJY+ExC5ejZ47IKCVynFUAK2a2eUV/NRSpuZglTBSvnClC
	 2DjmjD71ymloaxn0hwRu/Igoy1MXVjmwc4p4cLlyn94ytURcfuqCDc9lScBZQyxC1hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f2dcEiq2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8CF606A32C;
	Thu, 19 Nov 2026 02:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f2dcEiq2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B3F1F000C4;
	Thu, 19 Nov 2026 02:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055401;
	bh=jpEKDIdEN38ZUk+nPyXj5t87do8Dr3A5T1Vhlim3tRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2dcEiq2FPihqcrN2oBTnClj7ghpNveF18tLQb9x5vFt4vUgqQj6wNrLQ8YDA4yPn
	 q4kXJDEvPbJY8RuxGr2IBeKo32eThbxjgn7SQHMAcK4lf5OTHtkt5HpCLGrUPFnI7D
	 F93WEn7bZwAn8I+XWx4UHFuhc9Ro3H2gJdsgTfbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d729df28d933979e017a@syzkaller.appspotmail.com,
	syzbot+2eac7d175baf21e6a5d5@syzkaller.appspotmail.com,
	syzbot+7155b2fe09e033c91381@syzkaller.appspotmail.com,
	syzbot+adeb387cede15eb11607@syzkaller.appspotmail.com,
	syzbot+ae7f2423f3648100506d@syzkaller.appspotmail.com,
	Kyle Zeng <kylebot@openai.com>,
	Bruno Produit <bruno.produit@trailofbits.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1618/2214] hfs/hfsplus: serialize B-tree close against folio release
Date: Wed, 18 Nov 2026 15:54:54 +0100
Message-ID: <20261118150116.713159313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruno Produit <bruno.produit@trailofbits.com>

[ Upstream commit dce0e0248205bb3dc5b4c6793cd2ecb453152259 ]

B-tree nodes with a zero reference count remain in the node hash until
folio reclaim or tree teardown frees them.  The folio release callbacks
remove nodes while holding hash_lock, but hfs_btree_close() walks and
frees the same hash without that lock.  Reclaim can therefore unhash and
free a node after close has loaded its pointer, causing a use-after-free
or double-free.

The following syzkaller crashes seem to be the same UAF in
{hfs,hfsplus}_btree_close() (or {hfs,hfsplus}_bnode_unhash()) and follow
the same pattern, but do not contain a reproducer to confirm.

Detach each node with hfs_bnode_unhash() while holding hash_lock before
inspecting and freeing it.  Drop the lock before hfs_bnode_free() so a
large tree is not freed while holding a spinlock.  Apply the same fix to
the matching HFS+ implementation.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+d729df28d933979e017a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d729df28d933979e017a
Reported-by: syzbot+2eac7d175baf21e6a5d5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2eac7d175baf21e6a5d5
Reported-by: syzbot+7155b2fe09e033c91381@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7155b2fe09e033c91381
Reported-by: syzbot+adeb387cede15eb11607@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=adeb387cede15eb11607
Reported-by: syzbot+ae7f2423f3648100506d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ae7f2423f3648100506d
Assisted-by: Codex:gpt-5.6-sol
Reported-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Bruno Produit <bruno.produit@trailofbits.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260921153729.600313-1-bruno.produit@trailofbits.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/btree.c     | 7 +++++--
 fs/hfsplus/btree.c | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index f9ccfe0fc5748..5553de925448f 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -143,15 +143,18 @@ void hfs_btree_close(struct hfs_btree *tree)
 		return;
 
 	for (i = 0; i < NODE_HASH_SIZE; i++) {
+		spin_lock(&tree->hash_lock);
 		while ((node = tree->node_hash[i])) {
-			tree->node_hash[i] = node->next_hash;
+			hfs_bnode_unhash(node);
+			spin_unlock(&tree->hash_lock);
 			if (atomic_read(&node->refcnt))
 				pr_err("node %d:%d still has %d user(s)!\n",
 				       node->tree->cnid, node->this,
 				       atomic_read(&node->refcnt));
 			hfs_bnode_free(node);
-			tree->node_hash_cnt--;
+			spin_lock(&tree->hash_lock);
 		}
+		spin_unlock(&tree->hash_lock);
 	}
 	iput(tree->inode);
 	kfree(tree);
diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index d4b2591046474..926398b135929 100644
--- a/fs/hfsplus/btree.c
+++ b/fs/hfsplus/btree.c
@@ -264,16 +264,19 @@ void hfs_btree_close(struct hfs_btree *tree)
 		return;
 
 	for (i = 0; i < NODE_HASH_SIZE; i++) {
+		spin_lock(&tree->hash_lock);
 		while ((node = tree->node_hash[i])) {
-			tree->node_hash[i] = node->next_hash;
+			hfs_bnode_unhash(node);
+			spin_unlock(&tree->hash_lock);
 			if (atomic_read(&node->refcnt))
 				pr_crit("node %d:%d "
 						"still has %d user(s)!\n",
 					node->tree->cnid, node->this,
 					atomic_read(&node->refcnt));
 			hfs_bnode_free(node);
-			tree->node_hash_cnt--;
+			spin_lock(&tree->hash_lock);
 		}
+		spin_unlock(&tree->hash_lock);
 	}
 	iput(tree->inode);
 	kfree(tree);
-- 
2.53.0



