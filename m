Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1D8421A1D;
	Tue, 31 Mar 2026 16:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974892; cv=none; b=o/QErd+8wCL8oekBNvtbP/H7hgD1m1VmW1uMMNNOgy5rXHqA9NH3WVAqbE/zuus8KoJuI6ZvBd8CgG86SOoqqIrki/oVoNikkPRGl52ghOY7upIsxKJIIJxc411IRocEpAv3sJ/w8otNxZBYA4hbV06x200XgkRi12LXo5UKHmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974892; c=relaxed/simple;
	bh=B75+myYq6QfL89JD9+dXRiUTboD5cF9HYmedCNqV3g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEyHAGl7LKMgc1TpUKwo+VoQHoS5l1pbuJLUb0cU2v0xAqBlfOll5R/cHD/WXvyub+5+oXZiTRe1y0v8hIZoungY6cGWD6KYE5BRc9l+LB9dlT3CuNVcvDmfjprNZlReUyy9Bk1A1QWgKofsOl7PauPXIHmPJ4mTfOrEkvd5HTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOkDPEG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOkDPEG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2771C19423;
	Tue, 31 Mar 2026 16:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974892;
	bh=B75+myYq6QfL89JD9+dXRiUTboD5cF9HYmedCNqV3g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOkDPEG+s9tcNlYwey4460kTvRb61ZiiEH06yrU4Ryj+K1SU+hqlHb4YaybzSQOng
	 bbN6/3Wl/MN2aDJ+iwgOI7UWpsAelqcoyfQkqZjmQqM27m/JbhHw5vGCSQ2DsfF2HS
	 y2umijg8mARX6XukbRyFKAVdxOfmAoCIGeHcrmkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Long <me@imlonghao.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 083/342] xfrm: iptfs: fix skb_put() panic on non-linear skb during reassembly
Date: Tue, 31 Mar 2026 18:18:36 +0200
Message-ID: <20260331161802.078874332@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 0b352f83cabfefdaafa806d6471f0eca117dc7d5 ]

In iptfs_reassem_cont(), IP-TFS attempts to append data to the new inner
packet 'newskb' that is being reassembled. First a zero-copy approach is
tried if it succeeds then newskb becomes non-linear.

When a subsequent fragment in the same datagram does not meet the
fast-path conditions, a memory copy is performed. It calls skb_put() to
append the data and as newskb is non-linear it triggers
SKB_LINEAR_ASSERT check.

 Oops: invalid opcode: 0000 [#1] SMP NOPTI
 [...]
 RIP: 0010:skb_put+0x3c/0x40
 [...]
 Call Trace:
  <IRQ>
  iptfs_reassem_cont+0x1ab/0x5e0 [xfrm_iptfs]
  iptfs_input_ordered+0x2af/0x380 [xfrm_iptfs]
  iptfs_input+0x122/0x3e0 [xfrm_iptfs]
  xfrm_input+0x91e/0x1a50
  xfrm4_esp_rcv+0x3a/0x110
  ip_protocol_deliver_rcu+0x1d7/0x1f0
  ip_local_deliver_finish+0xbe/0x1e0
  __netif_receive_skb_core.constprop.0+0xb56/0x1120
  __netif_receive_skb_list_core+0x133/0x2b0
  netif_receive_skb_list_internal+0x1ff/0x3f0
  napi_complete_done+0x81/0x220
  virtnet_poll+0x9d6/0x116e [virtio_net]
  __napi_poll.constprop.0+0x2b/0x270
  net_rx_action+0x162/0x360
  handle_softirqs+0xdc/0x510
  __irq_exit_rcu+0xe7/0x110
  irq_exit_rcu+0xe/0x20
  common_interrupt+0x85/0xa0
  </IRQ>
  <TASK>

Fix this by checking if the skb is non-linear. If it is, linearize it by
calling skb_linearize(). As the initial allocation of newskb originally
reserved enough tailroom for the entire reassembled packet we do not
need to check if we have enough tailroom or extend it.

Fixes: 5f2b6a909574 ("xfrm: iptfs: add skb-fragment sharing code")
Reported-by: Hao Long <me@imlonghao.com>
Closes: https://lore.kernel.org/netdev/DGRCO9SL0T5U.JTINSHJQ9KPK@imlonghao.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_iptfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/xfrm/xfrm_iptfs.c b/net/xfrm/xfrm_iptfs.c
index 3b6d7284fc70a..4e270628fc347 100644
--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -901,6 +901,12 @@ static u32 iptfs_reassem_cont(struct xfrm_iptfs_data *xtfs, u64 seq,
 	    iptfs_skb_can_add_frags(newskb, fragwalk, data, copylen)) {
 		iptfs_skb_add_frags(newskb, fragwalk, data, copylen);
 	} else {
+		if (skb_linearize(newskb)) {
+			XFRM_INC_STATS(xs_net(xtfs->x),
+				       LINUX_MIB_XFRMINBUFFERERROR);
+			goto abandon;
+		}
+
 		/* copy fragment data into newskb */
 		if (skb_copy_seq_read(st, data, skb_put(newskb, copylen),
 				      copylen)) {
-- 
2.51.0



