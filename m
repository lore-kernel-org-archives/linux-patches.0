Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061709;
	b=XDyxcMr7dMRU5Nw0zcutTzw64yu+FS+2F/u1157EyY447crSL1pbRvrTMkWgry/FspYy
	 TY1Dyu0WRwS72pyytmuvPicVHSPRdLv2x01luY0zjbBYRPcoU4ZS4jUebkyWNFNKLJebr
	 TurOG7RvVMSHcHR7NqCT8HMXqFn/Bgoj0QPkGGpOh+jYq2RqMqMhmVnB3ooIB/mgzDC9T
	 uaBfSr6zXBoYatNzvmf6edNHo7wk0BBe9bAd/CMmJtlTpQX+MBybLp0X8UpoDtJ87EadN
	 U9HRJPQZC7ySBRLYwHOqkWnBUksw1YVWkPRwjlsmm3P7okepaz9IhEnGWUV9IvsVofQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dq+F8mouQC2wKatarbPUc6JFf3CasuZjInZCv6WoA/c=;
	b=4vpPc0xkYueyC8gjb/0+2rNHwD5s3hAqtvp6HMp7LlArMPNCEtmHQ9Z6B1lPlDKBkMC0
	 LMpTd3NBWdcVp2OwcmB0LGTf8o84QY+7h3JbUIB67/An4Gth1rYNcsDg5h4xXtUyVaCvq
	 IyX28aU9/vvpDQLbP+CCQhJ1R7t2XDDvvTK87Ve19h6erjzRp97OSO/Zlt32/SQx3jfYW
	 bwHiAF/avuJUrvR2DmeJmfKSY+3l/mq6wcWGV4qHpHSp6LGk/HuOhOfYw6sJTMCFP9Rk0
	 /svzWaw6E9EcD72u1a7dyKl5dyw8CcXfYi1HG3mOR2tlyEl3nhdFofkUA1Tw5LAe1gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hn/2ba7a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702D9606A325;
	Thu, 19 Nov 2026 04:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hn/2ba7a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADCF1F000C4;
	Thu, 19 Nov 2026 04:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061709;
	bh=dq+F8mouQC2wKatarbPUc6JFf3CasuZjInZCv6WoA/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hn/2ba7aLU9PfQUZSXjB2oJL5bHpvOesU/zAWPwVi7IdK74A2fudEb4yh7p0jKdan
	 di4krRrNLpyePbyfgA5Grrl6QWptXxgFaYhRfj1u6YJnzhv9Z+g7Hk6nkcIhmJlQSX
	 k2n7Tfj9yMWKL8neA/Kh5tIWGuRxBJFEx9va6mlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1651/1848] Bluetooth: hci_core: Keep RCU protection through LTK filtering
Date: Wed, 18 Nov 2026 16:01:29 +0100
Message-ID: <20261118150028.840209120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 834cefb43b74e..62d652635d4f9 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2378,16 +2378,16 @@ struct smp_ltk *hci_find_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
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



