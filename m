Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618224;
	b=2r2OlBG5j2+Kd3ta0tB8P242VeKTWyNntffKawdlig/8p+2gYu49g9mEfzs5zAGDL0Zq
	 v+mKgkgQDnzf0be42dLmNPfbtRpYB60hepvVeN4XpmXl/s7/UKpBdfgpQGM4eRRA/BgwF
	 JSwosRTBrA8KSJ81645ihFPGJ34TkuaW37AAF4GgNZtC7zesW4dYGz1rzitM9hqqwVb1o
	 0ia0sa3bk8WyalFuZYsJUnJ0bXsmH3IJAARuvemEy8jEdhPeV0rQvm95BO+yn/Ghngps5
	 Cvn/9789rxmApflmL0we1pgU65Fq9cUXY9PoulZLvyoQG1nmL5DksbfB/ShOOWV0hlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jC87emFLJ79PdZa8k5ARE5x90HdyZ5HDjeJ0hvXZPzQ=;
	b=LmRPG35USoN4lef4xNeeGZBdEj8Vry4wcYsAHqqHg3YXfuBAfMOFtOuUpyX1AUPrAo3w
	 NK9pskdf98WPjAYo6t6XjElk6uE4DqguK/Sg4YqgazhEKqxcWvQvMHUG+Wjm6LyVwzv4C
	 lh3c9zdg8dWgNA3MLlcfWv6rqUzdJHXKLA5WvbjxDozJt+XxJcahot0w4Ni452ImJMmop
	 pCubi8VnpC1t1Rjc9z70LckQRj7Ss+ySeaQPm96Y7KQN2RVUsbegsdCVk7Fp23drNk+/I
	 46RbQu0Hh99kIiKRE6Y4x/NAcuCR9gmQnXF6x0Z351t2E7FJRDrGpeWBc1xIdwKsYmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rihJdQon;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37187606A31E;
	Wed, 25 Nov 2026 14:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rihJdQon
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE041F000E6;
	Wed, 25 Nov 2026 14:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618224;
	bh=jC87emFLJ79PdZa8k5ARE5x90HdyZ5HDjeJ0hvXZPzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rihJdQongy/1xmes2u3J35RTQAvXSuHlswULFf+r5tMe96saThXheb7W1IvOT4Fvh
	 scXKy3KTF+jr2j+R3UlPC++4AUSgiPLDOs5xV0IQN1mzXP0BM7MUJk2Dql7NoeeWhy
	 6amJKUX5CZV2gRkwTEgBrtvpNwU3jz0lP0lqcPG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0209/1005] Bluetooth: SMP: Protect LTK encryption with RCU
Date: Wed, 25 Nov 2026 15:25:47 +0100
Message-ID: <20261125143826.637860262@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit add463a65802bb117e4a17b8c00d747fa70399fc ]

smp_ltk_encrypt() checks the security level of the LTK returned by
hci_find_ltk() and then starts encryption with its EDIV, Rand, value
and key size. The finder ends its RCU read-side section before
returning the borrowed entry, and neither caller holds hdev->lock: the
SMP Security Request handler runs from the receive path, and
setsockopt(BT_SECURITY) reaches smp_conn_security() with only the
socket and channel locks held.

MGMT_OP_LOAD_LONG_TERM_KEYS can therefore free the LTK in between:

  Socket security request          Management / RCU reclamation
  smp_ltk_encrypt()
    key = hci_find_ltk()
                                   load_long_term_keys()
                                     hci_dev_lock(hdev)
                                     hci_smp_ltks_clear(hdev)
                                       list_del_rcu(), kfree_rcu()
                                     hci_dev_unlock(hdev)
                                   grace period ends, key is freed
    smp_ltk_sec_level(key)
    hci_le_start_enc(hcon, key->ediv, key->rand, key->val, ...)

Keep an RCU read-side section across the lookup and every use of the
key. hci_le_start_enc() copies the key into the command and queues it
with a GFP_ATOMIC allocation, so the whole sequence can stay inside the
section.

KFENCE reported this on a test kernel where the socket thread was
paused after the lookup until the RCU callback had freed the key.

KFENCE report as below:

    ==================================================================
    BUG: KFENCE: use-after-free read in smp_ltk_encrypt.isra.0+0xf3/0x370

    Use-after-free read at 0x00000000c45332eb (in kfence-#128):
     smp_ltk_encrypt.isra.0+0xf3/0x370
     smp_conn_security+0x489/0x9d0
     l2cap_sock_setsockopt+0x1bbe/0x2300
     do_sock_setsockopt+0x1fb/0x430
     __sys_setsockopt+0x106/0x180
     __x64_sys_setsockopt+0xc2/0x160
     do_syscall_64+0x115/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    kfence-#128: 0x00000000d45af9b0-0x0000000053c1365e, size=72, cache=kmalloc-96

    allocated by task 533 on cpu 0 at 50.484258s (0.449177s ago):
     hci_add_ltk+0x1f5/0x3a0
     load_long_term_keys+0x6ea/0x930
     hci_sock_sendmsg+0x128b/0x22e0
     sock_write_iter+0x4c0/0x550
     vfs_write+0x637/0x1010
     ksys_write+0x1b7/0x200
     do_syscall_64+0x115/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    freed by task 0 on cpu 0 at 50.846944s (0.093664s ago):
     __rcu_free_sheaf_prepare+0x261/0x2a0
     rcu_free_sheaf_nobarn+0x1d/0x50
     rcu_core+0x661/0x1d10
     handle_softirqs+0x201/0x930
     __irq_exit_rcu+0x110/0x1e0
     irq_exit_rcu+0xe/0x20
     sysvec_apic_timer_interrupt+0x6c/0x80
     asm_sysvec_apic_timer_interrupt+0x1a/0x20
     pv_native_safe_halt+0xf/0x20
     default_idle+0x9/0x10
     default_idle_call+0x6c/0xb0
     do_idle+0x3a7/0x650
     cpu_startup_entry+0x54/0x60
     rest_init+0x15e/0x2b0
     start_kernel+0x412/0x4b0
     x86_64_start_reservations+0x18/0x30
     x86_64_start_kernel+0x111/0x120
     common_startup_64+0x13e/0x158

    CPU: 2 UID: 0 PID: 534 Comm: l2cap-ltk-actor Not tainted 7.2.0-rc6-pmb-bt-functional-v1+ #5 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    ==================================================================

Fixes: 988c5997d320 ("Bluetooth: Use the LTK after receiving a LE Security Request")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/smp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index d783126076ee7..4af7fa7f4a8e1 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2207,16 +2207,20 @@ static bool smp_ltk_encrypt(struct l2cap_conn *conn, u8 sec_level)
 {
 	struct smp_ltk *key;
 	struct hci_conn *hcon = conn->hcon;
+	bool ret = false;
+
+	rcu_read_lock();
 
 	key = hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type, hcon->role);
 	if (!key)
-		return false;
+		goto unlock;
 
 	if (smp_ltk_sec_level(key) < sec_level)
-		return false;
+		goto unlock;
 
+	ret = true;
 	if (test_and_set_bit(HCI_CONN_ENCRYPT_PEND, hcon->flags))
-		return true;
+		goto unlock;
 
 	hci_le_start_enc(hcon, key->ediv, key->rand, key->val, key->enc_size);
 	hcon->enc_key_size = key->enc_size;
@@ -2224,7 +2228,9 @@ static bool smp_ltk_encrypt(struct l2cap_conn *conn, u8 sec_level)
 	/* We never store STKs for initiator role, so clear this flag */
 	clear_bit(HCI_CONN_STK_ENCRYPT, hcon->flags);
 
-	return true;
+unlock:
+	rcu_read_unlock();
+	return ret;
 }
 
 bool smp_sufficient_security(struct hci_conn *hcon, u8 sec_level,
-- 
2.53.0



