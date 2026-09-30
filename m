Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7337C36A033;
	Wed, 30 Sep 2026 18:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793323; cv=none; b=e4tbWLnJThE2uA9VgWnDM7LvVibnUUgFCLjPpsK25wh3yWHTj11HuD7B5EeoMKCJv2FXS9ye7jJ6Uk1CUOCwrhXuaZ0FBc6gVs785HVp0S+UfdqAiGNwFyepnFFdmBclFx12MZyI4jPgjKNL0EyngHG4i9bRhiQwxUNB48awPB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793323; c=relaxed/simple;
	bh=WlaY2W4vimLrBiThcNg9pCPXIc4/ZxCCLNzEdPUtDi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciAsAklYoNsSCtr3PrajKnz0zPdfStwaJ6LBuRUwuM8r66trtJUMswI3fAVvjFdgk9MY/AcOopfgDnylkJ9BVLJQRaSkgfpRDLGxRkSvd9xAUDDfnYB7CGsOAww9Zv1ug7VkSMcC8C+e3jWEXOmGYvmwgSfsP6cEO6Gdj0XBg7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPXmTOSg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPXmTOSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735801F000FF;
	Wed, 30 Sep 2026 18:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793322;
	bh=THeqjRWQk5uOHpl03tvcPZM9m3J9x0A3DU3Kj+ETRJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPXmTOSgi8fZIvqS9UR+fQQoyisQzfCKfOlHeQHK31kwUKEk0Ax2JxngIhBzqZ1Nx
	 6hRENzD9Ql5kP9Rlam+4x3r1pAkRycWlhktFLL8dPWb0C9o9qm+ZCoj4B7DWEcJhy0
	 WhIzzA/UeBKkmKpp9YNSLb3vv5jpG8PwQLU+cKaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dairui Zhang <zhangdairui@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 212/395] af_packet: fix integer overflow in prb_calc_retire_blk_tmo()
Date: Wed, 30 Sep 2026 17:27:54 +0200
Message-ID: <20260930152345.253647264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Dairui Zhang <zhangdairui@gmail.com>

commit 56d82862a0a243ac14ba11b6d7b57ddc2d064b95 upstream.

prb_calc_retire_blk_tmo() computes in 32-bit int arithmetic:

        mbits = (blk_size_in_bytes * 8) / (1024 * 1024);

If I'm reading the validation right, tp_block_size is user
controlled and packet_set_ring() only rejects values that are <= 0
as int or not page aligned, so a 256MiB block goes right through
(and alloc_one_pg_vec_page() even has a vzalloc fallback for it).
0x10000000 * 8 wraps to INT_MIN, and on a NIC reporting 1 Gbps
(div == 1) the function ends up returning -2047.

The condition is actually (8 * size) mod 2^32 >= 2^31 && div == 1,
so the trigger set is [256,512), [768,1024), [1280,1536) and
[1792,2048) MiB. Other sizes wrap to non-negative values and faster
links divide the unsigned value back below 2^31, which is why this
doesn't blow up for everyone.

What makes it fatal is what happens next in init_prb_bdqc():

        p1->interval_ktime = ms_to_ktime(prb_calc_retire_blk_tmo(...));
        hrtimer_start(&p1->retire_blk_timer, p1->interval_ktime,
                      HRTIMER_MODE_REL_SOFT);

A negative relative timeout expires immediately. The callback
unconditionally returns HRTIMER_RESTART, and hrtimer_forward() turns
the negative interval into hrtimer_resolution:

        if (interval < hrtimer_resolution)
                interval = hrtimer_resolution;

So the SOFT timer re-fires at the maximum rate forever, holding
sk_receive_queue.lock each pass. One CPU spins in softirq until the
socket is closed. Repeat with more rings and the machine is gone.

The overflow itself is ancient - it was introduced together with
TPACKET_V3 in f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer
implementation."). Its effect prior to f7460d2989fa ("net:
af_packet: Use hrtimer to do the retire operation", v6.18) was not
as clear-cut, though: the return value was stored into an unsigned
short retire_blk_tov, so a negative result was truncated, and a
0-jiffy delay loop could be programmed as well. Neither is nearly
as detrimental as the immediate maximum-rate spin the hrtimer
conversion turned it into.

(Unrelated to CVE-2019-20812 - that one was the ethtool failure path
returning 0, which now returns DEFAULT_PRB_RETIRE_TOV.)

Reproducer, needs CAP_NET_RAW (a --network host container has it by
default) and a 1 Gbps NIC (QEMU e1000 works):

        int fd = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
        bind(fd, ...);
        int v = TPACKET_V3;
        setsockopt(fd, SOL_PACKET, PACKET_VERSION, &v, sizeof(v));
        struct tpacket_req3 req = {
                .tp_block_size = 0x10000000,
                .tp_block_nr = 1,
                .tp_frame_size = 2048,
                .tp_frame_nr = 0x10000000 / 2048,
                .tp_retire_blk_tov = 0,
        };
        setsockopt(fd, SOL_PACKET, PACKET_RX_RING, &req, sizeof(req));

Compute in 64 bits instead. The operands are already bounded by the
existing validation, so nothing else changes. If you'd prefer a
different fix, just say so and I'll respin.

Fixes: f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer implementation.")
Cc: stable@vger.kernel.org
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260923050101.1510064-1-zhangdairui@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -615,7 +615,7 @@ static int prb_calc_retire_blk_tmo(struc
 		return DEFAULT_PRB_RETIRE_TOV;
 
 	div = ecmd.base.speed / 1000;
-	mbits = (blk_size_in_bytes * 8) / (1024 * 1024);
+	mbits = (u64)blk_size_in_bytes * 8 / (1024 * 1024);
 
 	if (div)
 		mbits /= div;


