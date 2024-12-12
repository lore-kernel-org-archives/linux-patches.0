Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632EA231A31;
	Thu, 12 Dec 2024 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021057; cv=none; b=IXX9wNGrTHHv0SxFDrDo5TlZRCmWsxdM3mX8hTvHU0UwVX+OMvykDCfl5nUQ50MbLIjKl7gxZImlSAHy3hLH6MDoFSXScc+QkVJPu1UVPqg+AosT16iYE5kWTDe6+SFvFP0f8Qj7PqTttME1kCk7X5+RlfdfeCTy1hTR/AeOVFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021057; c=relaxed/simple;
	bh=1nKZEmLvL1X1EiSmqza0ZnlAVzXWv0JO+7BGKu5D9Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HUO1Ba910INene55oaN0lrlK80WP5CNsakL5TxUzK9lc6GTthXHUFtWj14quF3O2XiGahwnKpxw10OqHUGP/tnGs0LMGGsnXjgXGsSXmxoBYSrIUYv0WhrBPVSTyJusWjWVBfu2nNCh3lEOc/uMq3yqPfgcz6xnBG6Ku7Lhhu7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYEIM5qb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYEIM5qb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A37DC4CECE;
	Thu, 12 Dec 2024 16:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021056;
	bh=1nKZEmLvL1X1EiSmqza0ZnlAVzXWv0JO+7BGKu5D9Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYEIM5qbMzYUTAsxfEK586AncpV1OI5BfLJvbCLWlWyZXLoy8WWmTgaden9uKBOrK
	 M98t3ftZQ7JL20qwyw/jYxCZ7bJk8g2ZWT3ITYL+y3VHYuIytgX97/djrPwHzkyowg
	 cjUXTdLv2ad2hYHSwJOIX8B39XIQQVSBpX5S/BXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordy Zomer <jordyzomer@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.1 634/772] xsk: fix OOB map writes when deleting elements
Date: Thu, 12 Dec 2024 15:59:39 +0100
Message-ID: <20241212144416.132327835@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

commit 32cd3db7de97c0c7a018756ce66244342fd583f0 upstream.

Jordy says:

"
In the xsk_map_delete_elem function an unsigned integer
(map->max_entries) is compared with a user-controlled signed integer
(k). Due to implicit type conversion, a large unsigned value for
map->max_entries can bypass the intended bounds check:

	if (k >= map->max_entries)
		return -EINVAL;

This allows k to hold a negative value (between -2147483648 and -2),
which is then used as an array index in m->xsk_map[k], which results
in an out-of-bounds access.

	spin_lock_bh(&m->lock);
	map_entry = &m->xsk_map[k]; // Out-of-bounds map_entry
	old_xs = unrcu_pointer(xchg(map_entry, NULL));  // Oob write
	if (old_xs)
		xsk_map_sock_delete(old_xs, map_entry);
	spin_unlock_bh(&m->lock);

The xchg operation can then be used to cause an out-of-bounds write.
Moreover, the invalid map_entry passed to xsk_map_sock_delete can lead
to further memory corruption.
"

It indeed results in following splat:

[76612.897343] BUG: unable to handle page fault for address: ffffc8fc2e461108
[76612.904330] #PF: supervisor write access in kernel mode
[76612.909639] #PF: error_code(0x0002) - not-present page
[76612.914855] PGD 0 P4D 0
[76612.917431] Oops: Oops: 0002 [#1] PREEMPT SMP
[76612.921859] CPU: 11 UID: 0 PID: 10318 Comm: a.out Not tainted 6.12.0-rc1+ #470
[76612.929189] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
[76612.939781] RIP: 0010:xsk_map_delete_elem+0x2d/0x60
[76612.944738] Code: 00 00 41 54 55 53 48 63 2e 3b 6f 24 73 38 4c 8d a7 f8 00 00 00 48 89 fb 4c 89 e7 e8 2d bf 05 00 48 8d b4 eb 00 01 00 00 31 ff <48> 87 3e 48 85 ff 74 05 e8 16 ff ff ff 4c 89 e7 e8 3e bc 05 00 31
[76612.963774] RSP: 0018:ffffc9002e407df8 EFLAGS: 00010246
[76612.969079] RAX: 0000000000000000 RBX: ffffc9002e461000 RCX: 0000000000000000
[76612.976323] RDX: 0000000000000001 RSI: ffffc8fc2e461108 RDI: 0000000000000000
[76612.983569] RBP: ffffffff80000001 R08: 0000000000000000 R09: 0000000000000007
[76612.990812] R10: ffffc9002e407e18 R11: ffff888108a38858 R12: ffffc9002e4610f8
[76612.998060] R13: ffff888108a38858 R14: 00007ffd1ae0ac78 R15: ffffc9002e4610c0
[76613.005303] FS:  00007f80b6f59740(0000) GS:ffff8897e0ec0000(0000) knlGS:0000000000000000
[76613.013517] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[76613.019349] CR2: ffffc8fc2e461108 CR3: 000000011e3ef001 CR4: 00000000007726f0
[76613.026595] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[76613.033841] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[76613.041086] PKRU: 55555554
[76613.043842] Call Trace:
[76613.046331]  <TASK>
[76613.048468]  ? __die+0x20/0x60
[76613.051581]  ? page_fault_oops+0x15a/0x450
[76613.055747]  ? search_extable+0x22/0x30
[76613.059649]  ? search_bpf_extables+0x5f/0x80
[76613.063988]  ? exc_page_fault+0xa9/0x140
[76613.067975]  ? asm_exc_page_fault+0x22/0x30
[76613.072229]  ? xsk_map_delete_elem+0x2d/0x60
[76613.076573]  ? xsk_map_delete_elem+0x23/0x60
[76613.080914]  __sys_bpf+0x19b7/0x23c0
[76613.084555]  __x64_sys_bpf+0x1a/0x20
[76613.088194]  do_syscall_64+0x37/0xb0
[76613.091832]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[76613.096962] RIP: 0033:0x7f80b6d1e88d
[76613.100592] Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 73 b5 0f 00 f7 d8 64 89 01 48
[76613.119631] RSP: 002b:00007ffd1ae0ac68 EFLAGS: 00000206 ORIG_RAX: 0000000000000141
[76613.131330] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f80b6d1e88d
[76613.142632] RDX: 0000000000000098 RSI: 00007ffd1ae0ad20 RDI: 0000000000000003
[76613.153967] RBP: 00007ffd1ae0adc0 R08: 0000000000000000 R09: 0000000000000000
[76613.166030] R10: 00007f80b6f77040 R11: 0000000000000206 R12: 00007ffd1ae0aed8
[76613.177130] R13: 000055ddf42ce1e9 R14: 000055ddf42d0d98 R15: 00007f80b6fab040
[76613.188129]  </TASK>

Fix this by simply changing key type from int to u32.

Fixes: fbfc504a24f5 ("bpf: introduce new bpf AF_XDP map type BPF_MAP_TYPE_XSKMAP")
CC: stable@vger.kernel.org
Reported-by: Jordy Zomer <jordyzomer@google.com>
Suggested-by: Jordy Zomer <jordyzomer@google.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20241122121030.716788-2-maciej.fijalkowski@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xdp/xskmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -216,7 +216,7 @@ static int xsk_map_delete_elem(struct bp
 	struct xsk_map *m = container_of(map, struct xsk_map, map);
 	struct xdp_sock __rcu **map_entry;
 	struct xdp_sock *old_xs;
-	int k = *(u32 *)key;
+	u32 k = *(u32 *)key;
 
 	if (k >= map->max_entries)
 		return -EINVAL;


