Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD7412CDA5;
	Tue, 30 Apr 2024 10:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473845; cv=none; b=LgH9HnOnWSVu2/MR42Gyk2QZXO833HgUFoYNhXm5Q61qp4a1dS0aq66u91uEde68b0ANePifghKs1gk5muyFka+OIVrQ42yvTfRNdlCWBkDKWDQk+oGUYsQGcn8CPWkC6GzlzheeDxuIfOKQERHqGikDqc8JBAakOTHgMZxwYLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473845; c=relaxed/simple;
	bh=OxXseO1Qkdite7mGXlN1pH0zpXM2Wy/Bqxc8VpptDa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOsyCoj2wTMj8Zd8MUpY2NLK9aX9Lv6gzmiwnhZuKCrOMeyFPBkADhN6phyCa1a5IjtbCruvEB/VYVB7mOS+Q2WFVnuNUHp+ygIJWqHN5gOwdbjXLWowKsk5cZmjwLMkmK09/B9GZeSEIYXYIPC6QbWQNL0CicTTKU/aZ3Dazgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDhl79sE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDhl79sE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66678C4AF14;
	Tue, 30 Apr 2024 10:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473844;
	bh=OxXseO1Qkdite7mGXlN1pH0zpXM2Wy/Bqxc8VpptDa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDhl79sEyAKu3UMAyK6ljxBQ0liyWvyeRLEf04WlyzbPtRd/4269LyOVIfO9Oy1uE
	 iuprVxSW73WKVb8HMUvKFl2tz0lHMh/UZSCNucVUBPt5cQR298fvuLO3zsjONxhOUZ
	 BMTagaHc9lW68EudROx2hmcfb29qbECKbCdNUAoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Chen <lei.chen@smartx.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/77] tun: limit printing rate when illegal packet received by tun dev
Date: Tue, 30 Apr 2024 12:38:58 +0200
Message-ID: <20240430103041.694052409@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei Chen <lei.chen@smartx.com>

[ Upstream commit f8bbc07ac535593139c875ffa19af924b1084540 ]

vhost_worker will call tun call backs to receive packets. If too many
illegal packets arrives, tun_do_read will keep dumping packet contents.
When console is enabled, it will costs much more cpu time to dump
packet and soft lockup will be detected.

net_ratelimit mechanism can be used to limit the dumping rate.

PID: 33036    TASK: ffff949da6f20000  CPU: 23   COMMAND: "vhost-32980"
 #0 [fffffe00003fce50] crash_nmi_callback at ffffffff89249253
 #1 [fffffe00003fce58] nmi_handle at ffffffff89225fa3
 #2 [fffffe00003fceb0] default_do_nmi at ffffffff8922642e
 #3 [fffffe00003fced0] do_nmi at ffffffff8922660d
 #4 [fffffe00003fcef0] end_repeat_nmi at ffffffff89c01663
    [exception RIP: io_serial_in+20]
    RIP: ffffffff89792594  RSP: ffffa655314979e8  RFLAGS: 00000002
    RAX: ffffffff89792500  RBX: ffffffff8af428a0  RCX: 0000000000000000
    RDX: 00000000000003fd  RSI: 0000000000000005  RDI: ffffffff8af428a0
    RBP: 0000000000002710   R8: 0000000000000004   R9: 000000000000000f
    R10: 0000000000000000  R11: ffffffff8acbf64f  R12: 0000000000000020
    R13: ffffffff8acbf698  R14: 0000000000000058  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #5 [ffffa655314979e8] io_serial_in at ffffffff89792594
 #6 [ffffa655314979e8] wait_for_xmitr at ffffffff89793470
 #7 [ffffa65531497a08] serial8250_console_putchar at ffffffff897934f6
 #8 [ffffa65531497a20] uart_console_write at ffffffff8978b605
 #9 [ffffa65531497a48] serial8250_console_write at ffffffff89796558
 #10 [ffffa65531497ac8] console_unlock at ffffffff89316124
 #11 [ffffa65531497b10] vprintk_emit at ffffffff89317c07
 #12 [ffffa65531497b68] printk at ffffffff89318306
 #13 [ffffa65531497bc8] print_hex_dump at ffffffff89650765
 #14 [ffffa65531497ca8] tun_do_read at ffffffffc0b06c27 [tun]
 #15 [ffffa65531497d38] tun_recvmsg at ffffffffc0b06e34 [tun]
 #16 [ffffa65531497d68] handle_rx at ffffffffc0c5d682 [vhost_net]
 #17 [ffffa65531497ed0] vhost_worker at ffffffffc0c644dc [vhost]
 #18 [ffffa65531497f10] kthread at ffffffff892d2e72
 #19 [ffffa65531497f50] ret_from_fork at ffffffff89c0022f

Fixes: ef3db4a59542 ("tun: avoid BUG, dump packet on GSO errors")
Signed-off-by: Lei Chen <lei.chen@smartx.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/20240415020247.2207781-1-lei.chen@smartx.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 625525275539a..5d1502772fb8e 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2168,14 +2168,16 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 					    tun_is_little_endian(tun), true,
 					    vlan_hlen)) {
 			struct skb_shared_info *sinfo = skb_shinfo(skb);
-			pr_err("unexpected GSO type: "
-			       "0x%x, gso_size %d, hdr_len %d\n",
-			       sinfo->gso_type, tun16_to_cpu(tun, gso.gso_size),
-			       tun16_to_cpu(tun, gso.hdr_len));
-			print_hex_dump(KERN_ERR, "tun: ",
-				       DUMP_PREFIX_NONE,
-				       16, 1, skb->head,
-				       min((int)tun16_to_cpu(tun, gso.hdr_len), 64), true);
+
+			if (net_ratelimit()) {
+				netdev_err(tun->dev, "unexpected GSO type: 0x%x, gso_size %d, hdr_len %d\n",
+					   sinfo->gso_type, tun16_to_cpu(tun, gso.gso_size),
+					   tun16_to_cpu(tun, gso.hdr_len));
+				print_hex_dump(KERN_ERR, "tun: ",
+					       DUMP_PREFIX_NONE,
+					       16, 1, skb->head,
+					       min((int)tun16_to_cpu(tun, gso.hdr_len), 64), true);
+			}
 			WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
-- 
2.43.0



