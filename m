Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AEF1B2194;
	Wed, 19 Mar 2025 14:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394847; cv=none; b=il4X637QK06lbwn0eFUl4EZ2PgTpTkNCzBsH/f8Nm/triC+4hW9LoumFBYy+QGCaTSYckC0jxQf1+lRJa62FvmqIiLZUXRuTIqOMAOlSTnNkEE9TZUcZRiTsa9sn5wkhrvzbKObLkUAWqZ4jSEmLjNCuOFkCv6ptTK/rtCGwmS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394847; c=relaxed/simple;
	bh=PS+NbjJaJhAvxo+GbQ4F8F+YVK9OC3AhB4W82JaV3fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfL7e2hkRf8xdJxzb8kPkC/GBVLzcG1i1UyCZcExf34hex+1TRrpk307/Q14KOZHGhWbSy4ecA6DenOw0zhU4Mr0XMZXFbE99ASJHNRY0hvuFuvfuCOdQKzYolJ2tCSNhRin7KvBscDUNQsqN14L5rZ3gFD2Cl3ERcY6pqSPOBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYpnLN+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYpnLN+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A77DC4CEE4;
	Wed, 19 Mar 2025 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394847;
	bh=PS+NbjJaJhAvxo+GbQ4F8F+YVK9OC3AhB4W82JaV3fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYpnLN+rwJcw4wmxQnVttpkuC3xejltV63RWN6Cfjqc2hv0CgaS9F9oZJp821fhEu
	 4ZubUA9VLRW0MdpaRaNNa65pvo92Ks1fHFaRsEcWVfJGWIZkGJ/8Bw0eW1IHBrbesl
	 /5Q4QNV0Ia4842qAwVS0+3eoxorwFu5+v3WsB43A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 033/241] eth: bnxt: return fail if interface is down in bnxt_queue_mem_alloc()
Date: Wed, 19 Mar 2025 07:28:23 -0700
Message-ID: <20250319143028.537686643@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit ca2456e073957781e1184de68551c65161b2bd30 ]

The bnxt_queue_mem_alloc() is called to allocate new queue memory when
a queue is restarted.
It internally accesses rx buffer descriptor corresponding to the index.
The rx buffer descriptor is allocated and set when the interface is up
and it's freed when the interface is down.
So, if queue is restarted if interface is down, kernel panic occurs.

Splat looks like:
 BUG: unable to handle page fault for address: 000000000000b240
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 3 UID: 0 PID: 1563 Comm: ncdevmem2 Not tainted 6.14.0-rc2+ #9 844ddba6e7c459cafd0bf4db9a3198e
 Hardware name: ASUS System Product Name/PRIME Z690-P D4, BIOS 0603 11/01/2021
 RIP: 0010:bnxt_queue_mem_alloc+0x3f/0x4e0 [bnxt_en]
 Code: 41 54 4d 89 c4 4d 69 c0 c0 05 00 00 55 48 89 f5 53 48 89 fb 4c 8d b5 40 05 00 00 48 83 ec 15
 RSP: 0018:ffff9dcc83fef9e8 EFLAGS: 00010202
 RAX: ffffffffc0457720 RBX: ffff934ed8d40000 RCX: 0000000000000000
 RDX: 000000000000001f RSI: ffff934ea508f800 RDI: ffff934ea508f808
 RBP: ffff934ea508f800 R08: 000000000000b240 R09: ffff934e84f4b000
 R10: ffff9dcc83fefa30 R11: ffff934e84f4b000 R12: 000000000000001f
 R13: ffff934ed8d40ac0 R14: ffff934ea508fd40 R15: ffff934e84f4b000
 FS:  00007fa73888c740(0000) GS:ffff93559f780000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000000000000b240 CR3: 0000000145a2e000 CR4: 00000000007506f0
 PKRU: 55555554
 Call Trace:
  <TASK>
  ? __die+0x20/0x70
  ? page_fault_oops+0x15a/0x460
  ? exc_page_fault+0x6e/0x180
  ? asm_exc_page_fault+0x22/0x30
  ? __pfx_bnxt_queue_mem_alloc+0x10/0x10 [bnxt_en 7f85e76f4d724ba07471d7e39d9e773aea6597b7]
  ? bnxt_queue_mem_alloc+0x3f/0x4e0 [bnxt_en 7f85e76f4d724ba07471d7e39d9e773aea6597b7]
  netdev_rx_queue_restart+0xc5/0x240
  net_devmem_bind_dmabuf_to_queue+0xf8/0x200
  netdev_nl_bind_rx_doit+0x3a7/0x450
  genl_family_rcv_msg_doit+0xd9/0x130
  genl_rcv_msg+0x184/0x2b0
  ? __pfx_netdev_nl_bind_rx_doit+0x10/0x10
  ? __pfx_genl_rcv_msg+0x10/0x10
  netlink_rcv_skb+0x54/0x100
  genl_rcv+0x24/0x40
...

Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 2d694c27d32e ("bnxt_en: implement netdev_queue_mgmt_ops")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250309134219.91670-3-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6357126b87c3f..d5d91bbc67924 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15394,6 +15394,9 @@ static int bnxt_queue_mem_alloc(struct net_device *dev, void *qmem, int idx)
 	struct bnxt_ring_struct *ring;
 	int rc;
 
+	if (!bp->rx_ring)
+		return -ENETDOWN;
+
 	rxr = &bp->rx_ring[idx];
 	clone = qmem;
 	memcpy(clone, rxr, sizeof(*rxr));
-- 
2.39.5



