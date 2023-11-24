Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A1D3307D;
	Fri, 24 Nov 2023 19:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryrsAv4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1826C433C7;
	Fri, 24 Nov 2023 19:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853838;
	bh=eXjY279WWgAy1d22BgvbDT8XsMNmXiCsefhBgPua85M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryrsAv4F9FmMEtQRPs7ZVBa/6gNPA55KH74SlkOXIRO0iHEIL5YpyHRW+Tf+Cq30G
	 1/hz/dES5Vh+HcIB5Vr/UcawHq6BtT7N8mAVCv4B4znuycNWOsK1XIHP2eqOpgh+Ik
	 ajRP19TPbN3yIi6sdKLZEYfQY5dxe0HE/lzvk/Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6177e1f90d92583bcc58@syzkaller.appspotmail.com,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/159] ppp: limit MRU to 64K
Date: Fri, 24 Nov 2023 17:54:28 +0000
Message-ID: <20231124171944.071381198@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit c0a2a1b0d631fc460d830f52d06211838874d655 ]

ppp_sync_ioctl allows setting device MRU, but does not sanity check
this input.

Limit to a sane upper bound of 64KB.

No implementation I could find generates larger than 64KB frames.
RFC 2823 mentions an upper bound of PPP over SDL of 64KB based on the
16-bit length field. Other protocols will be smaller, such as PPPoE
(9KB jumbo frame) and PPPoA (18190 maximum CPCS-SDU size, RFC 2364).
PPTP and L2TP encapsulate in IP.

Syzbot managed to trigger alloc warning in __alloc_pages:

	if (WARN_ON_ONCE_GFP(order > MAX_ORDER, gfp))

    WARNING: CPU: 1 PID: 37 at mm/page_alloc.c:4544 __alloc_pages+0x3ab/0x4a0 mm/page_alloc.c:4544

    __alloc_skb+0x12b/0x330 net/core/skbuff.c:651
    __netdev_alloc_skb+0x72/0x3f0 net/core/skbuff.c:715
    netdev_alloc_skb include/linux/skbuff.h:3225 [inline]
    dev_alloc_skb include/linux/skbuff.h:3238 [inline]
    ppp_sync_input drivers/net/ppp/ppp_synctty.c:669 [inline]
    ppp_sync_receive+0xff/0x680 drivers/net/ppp/ppp_synctty.c:334
    tty_ldisc_receive_buf+0x14c/0x180 drivers/tty/tty_buffer.c:390
    tty_port_default_receive_buf+0x70/0xb0 drivers/tty/tty_port.c:37
    receive_buf drivers/tty/tty_buffer.c:444 [inline]
    flush_to_ldisc+0x261/0x780 drivers/tty/tty_buffer.c:494
    process_one_work+0x884/0x15c0 kernel/workqueue.c:2630

With call

    ioctl$PPPIOCSMRU1(r1, 0x40047452, &(0x7f0000000100)=0x5e6417a8)

Similar code exists in other drivers that implement ppp_channel_ops
ioctl PPPIOCSMRU. Those might also be in scope. Notably excluded from
this are pppol2tp_ioctl and pppoe_ioctl.

This code goes back to the start of git history.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+6177e1f90d92583bcc58@syzkaller.appspotmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_synctty.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index d5af6b06a66a4..55641e01192dd 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -463,6 +463,10 @@ ppp_sync_ioctl(struct ppp_channel *chan, unsigned int cmd, unsigned long arg)
 	case PPPIOCSMRU:
 		if (get_user(val, (int __user *) argp))
 			break;
+		if (val > U16_MAX) {
+			err = -EINVAL;
+			break;
+		}
 		if (val < PPP_MRU)
 			val = PPP_MRU;
 		ap->mru = val;
-- 
2.42.0



