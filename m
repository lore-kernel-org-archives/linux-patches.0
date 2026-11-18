Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026734;
	b=cBhBuzZU5BHhzPTsCLn/PLIXNKE9SGMqHb1kcKj8Mn9iU1O6feu56ED4TsxJc4O6HCEy
	 juBN9jSONCotBXeoA0h/px246M+n5NXF0f08c/RNt98UfxUeChKjEqv3FgAR9+HPFm/E4
	 OgnZRpbyYuTpUrZSj5pzxnp2zDo85pdGOMeEbIe0d3zhEjpwzfxPGADfBU579bNduqYHT
	 IbOiaTnG7ggD7UtNRA5XXWRlvlyK8xUFbBUGp/ibljsDZonctAmUQw4fLV7bK4pbA6CAO
	 H4X3aT4kFgOKOAQQkmYAlkf5UwBBBHORckGLEBWCo1avAn5GguqJJJlmv2wND1sGApQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eKH/chOb8Alc5HHSd5OjBAHaQVq6eRBuSXuvaHV/Ggg=;
	b=xrCgYmbwbmPXT0P3rT/zYLkrsw+e7oNUwGLdBUuDrx+tCupHfdgQ0f6GQUmE29fLymH+
	 0znUNnb8TsuUdqKAy5C28s/+J2y4ltpm+jJF65MChL3A18B/6BIdNtpdxhh80YuPSgFTW
	 QC+hJZhqPZEfLAO/zIxJgGVES4IHzmvkVAXxvQK4YnWke2OgZ4XHWseJTrHGVbzm96AYz
	 PYy4C1Gb7FI6OR6WNxEmdoATMHdfgIOTyUEBMJc7uDDBL3U+0TmhtfemXxwJtcAFSibsw
	 FIZSmCft2ogm12QDt/P+NeSVc9Jake2Ir9YeswbRtjMhx3nEzgE8rCtt7yWbUIGyRug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ph3N7eEq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFC2606A31C;
	Wed, 18 Nov 2026 18:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ph3N7eEq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3691F000C4;
	Wed, 18 Nov 2026 18:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026733;
	bh=eKH/chOb8Alc5HHSd5OjBAHaQVq6eRBuSXuvaHV/Ggg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ph3N7eEqs1RTUb1/WR9OYpvz97biCUdU++AkxaWC5Tc2mHW5ptBnb8qLgyWkh/0BG
	 yAwq7uGnxj1vyXy2PT0olyUFdbJuATRFDjjrA+TFar8VawPrRmNz/HZI27J7rFuQBq
	 tcmQt20S5ZkkPQMFgyodooggrjBIKfm6YzOzO798=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1539/2151] Bluetooth: hci_core: Keep RCU protection through LTK filtering
Date: Wed, 18 Nov 2026 15:54:34 +0100
Message-ID: <20261118150217.934236840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 817cbcab91fe870e5b69c835cbd708242c9f8c8e ]

The LTK selected by hci_find_ltk() must remain allocated while its
value is checked against the blocked-key list. The finder releases RCU
before passing k->val to hci_is_blocked_key(). The helper's own RCU
section protects the blocked-key list, but the selected LTK may already
have been reclaimed before that section starts.

An LE ATT socket security request can reach smp_ltk_encrypt() without
holding hdev->lock. With a matching stored LTK and an LTK-type
blocked-key entry present, a concurrent MGMT_OP_LOAD_LONG_TERM_KEYS can
remove the selected LTK in the following order:

  Socket security                 Management / RCU reclamation
  hci_find_ltk()
    rcu_read_lock()
    select k
    rcu_read_unlock()
                                  load_long_term_keys()
                                    hci_dev_lock(hdev)
                                    hci_smp_ltks_clear(hdev)
                                      list_del_rcu(&k->list)
                                      kfree_rcu(k, rcu)
                                  grace period ends; k is freed
    hci_is_blocked_key(..., k->val)
      memcmp(b->val, val, ...)

The final comparison reads freed LTK bytes. Entering a new RCU section
in hci_is_blocked_key() cannot protect a pointer obtained before the
completed grace period.

Keep the finder's RCU read-side section active through the blocked-key
comparison and the warning that reads k->bdaddr. Release it before
returning on either matched-key path. This delays reclamation until the
finder has finished using the selected record, following the existing
IRK lookup pattern.

KFENCE report as below:

    ==================================================================
    BUG: KFENCE: use-after-free read in hci_is_blocked_key+0xdf/0x240

    Use-after-free read at 0x00000000b9ee38e4 (in kfence-#249):
     hci_is_blocked_key+0xdf/0x240
     blocked_key_wrapper+0xc5/0x140 [pmbd_ltk_probe]
     hci_find_ltk+0x1aa/0x3e0
     smp_ltk_encrypt.isra.0+0xad/0x340
     smp_conn_security+0x3b8/0x8c0
     l2cap_sock_setsockopt+0x1c4b/0x2270
     do_sock_setsockopt+0x1fb/0x430
     __sys_setsockopt+0x106/0x180
     __x64_sys_setsockopt+0xc2/0x160
     do_syscall_64+0x115/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    kfence-#249: 0x00000000121f2ad9-0x000000005b5bfb3d, size=72, cache=kmalloc-96

    allocated by task 495 on cpu 0 at 36.722380s (2.603973s ago):
     hci_add_ltk+0x1f5/0x3a0
     load_long_term_keys+0x6d0/0x860
     hci_sock_sendmsg+0x128b/0x22e0
     __sys_sendto+0x425/0x470
     __x64_sys_sendto+0xe5/0x1c0
     do_syscall_64+0x115/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    freed by task 533 on cpu 0 at 36.993097s (2.339769s ago):
     __rcu_free_sheaf_prepare+0x261/0x2a0
     rcu_free_sheaf+0x1f/0xe0
     rcu_core+0x661/0x1d10
     handle_softirqs+0x201/0x930
     __irq_exit_rcu+0x110/0x1e0
     irq_exit_rcu+0xe/0x20
     sysvec_apic_timer_interrupt+0x6c/0x80
     asm_sysvec_apic_timer_interrupt+0x1a/0x20
     srso_alias_return_thunk+0x0/0xfbef5
     __asan_memcpy+0x23/0x60
     create_monitor_ctrl_event+0x1a2/0x460
     mgmt_cmd_complete+0x2da/0x580
     load_long_term_keys+0x741/0x860
     hci_sock_sendmsg+0x128b/0x22e0
     __sys_sendto+0x425/0x470
     __x64_sys_sendto+0xe5/0x1c0
     do_syscall_64+0x115/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    CPU: 1 UID: 0 PID: 495 Comm: python3 Tainted: G           O        7.2.0-rc6-pmb-bt-functional-v1+ #1 PREEMPT(lazy)
    Tainted: [O]=OOT_MODULE
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    ==================================================================

Fixes: 600a87490ff9 ("Bluetooth: Implementation of MGMT_OP_SET_BLOCKED_KEYS.")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e407ff39254ec..bb5bbeefcc67e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1189,16 +1189,16 @@ struct smp_ltk *hci_find_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			continue;
 
 		if (smp_ltk_is_sc(k) || ltk_role(k->type) == role) {
-			rcu_read_unlock();
-
 			if (hci_is_blocked_key(hdev, HCI_BLOCKED_KEY_TYPE_LTK,
 					       k->val)) {
 				bt_dev_warn_ratelimited(hdev,
 							"LTK blocked for %pMR",
 							&k->bdaddr);
+				rcu_read_unlock();
 				return NULL;
 			}
 
+			rcu_read_unlock();
 			return k;
 		}
 	}
-- 
2.53.0



