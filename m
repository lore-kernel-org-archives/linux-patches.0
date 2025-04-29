Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AA5252914;
	Tue, 29 Apr 2025 18:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950788; cv=none; b=uipVoWDTPhY7nodM585+5xiOCUfU3QLXxy16vCRlLDYb7kJ1MKcknJC93LL/3Ei1cmVe5nLrgkQLjUh0RVWR9nWk9lyyAW7D4Pzkn2KbxMJ7kQuHkeAIhwcJkpfBjAZpwpYiO3OnNShVff1TQHlHM3v22hKsuf3NRZlmCbYycSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950788; c=relaxed/simple;
	bh=BEX5dMg3k70BB5cGcjGLoBlB8yIzvXFPO+Vk4gKBFpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOtnVdEwcaaHLlSaToWbzKRcodGjuEwtxFqilxWysXA0KFIAv57KSW+qZF1qDcE/f1EyUfMvxMUbm1YsR5cXBJKhAjuns5CpOnY89qKyjTipAUC9IfkuzRALKcMtcSYixgGNYf6xLGhqbXo0kQM6QAFTVajUj8xw7hvtxW4DE8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfc5DCAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfc5DCAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94666C4CEE3;
	Tue, 29 Apr 2025 18:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950788;
	bh=BEX5dMg3k70BB5cGcjGLoBlB8yIzvXFPO+Vk4gKBFpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfc5DCAVZtJ/OuY5wm/NJG/Kttt6/ew81kwD4rLL4HkUT73oq4dEjM8/hzocAlBvd
	 4Rch5SWKyQFSILD96XNYTXej72CiZEkmPqyXrbx0zuOkGedXF5jJWpjvyDJA9WGXA9
	 h25ly3/jL2DsdnttxamoMUQ0Wm4Ct0CWYCqkh6zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrew Sauber <andrew.sauber@isovalent.com>,
	Anton Protopopov <aspsk@isovalent.com>,
	William Tu <witu@nvidia.com>,
	Martin Zaharinov <micron10@gmail.com>,
	Ronak Doshi <ronak.doshi@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 193/204] vmxnet3: Fix malformed packet sizing in vmxnet3_process_xdp
Date: Tue, 29 Apr 2025 18:44:41 +0200
Message-ID: <20250429161107.272017996@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

commit 4c2227656d9003f4d77afc76f34dd81b95e4c2c4 upstream.

vmxnet3 driver's XDP handling is buggy for packet sizes using ring0 (that
is, packet sizes between 128 - 3k bytes).

We noticed MTU-related connectivity issues with Cilium's service load-
balancing in case of vmxnet3 as NIC underneath. A simple curl to a HTTP
backend service where the XDP LB was doing IPIP encap led to overly large
packet sizes but only for *some* of the packets (e.g. HTTP GET request)
while others (e.g. the prior TCP 3WHS) looked completely fine on the wire.

In fact, the pcap recording on the backend node actually revealed that the
node with the XDP LB was leaking uninitialized kernel data onto the wire
for the affected packets, for example, while the packets should have been
152 bytes their actual size was 1482 bytes, so the remainder after 152 bytes
was padded with whatever other data was in that page at the time (e.g. we
saw user/payload data from prior processed packets).

We only noticed this through an MTU issue, e.g. when the XDP LB node and
the backend node both had the same MTU (e.g. 1500) then the curl request
got dropped on the backend node's NIC given the packet was too large even
though the IPIP-encapped packet normally would never even come close to
the MTU limit. Lowering the MTU on the XDP LB (e.g. 1480) allowed to let
the curl request succeed (which also indicates that the kernel ignored the
padding, and thus the issue wasn't very user-visible).

Commit e127ce7699c1 ("vmxnet3: Fix missing reserved tailroom") was too eager
to also switch xdp_prepare_buff() from rcd->len to rbi->len. It really needs
to stick to rcd->len which is the actual packet length from the descriptor.
The latter we also feed into vmxnet3_process_xdp_small(), by the way, and
it indicates the correct length needed to initialize the xdp->{data,data_end}
parts. For e127ce7699c1 ("vmxnet3: Fix missing reserved tailroom") the
relevant part was adapting xdp_init_buff() to address the warning given the
xdp_data_hard_end() depends on xdp->frame_sz. With that fixed, traffic on
the wire looks good again.

Fixes: e127ce7699c1 ("vmxnet3: Fix missing reserved tailroom")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Andrew Sauber <andrew.sauber@isovalent.com>
Cc: Anton Protopopov <aspsk@isovalent.com>
Cc: William Tu <witu@nvidia.com>
Cc: Martin Zaharinov <micron10@gmail.com>
Cc: Ronak Doshi <ronak.doshi@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250423133600.176689-1-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vmxnet3/vmxnet3_xdp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/vmxnet3/vmxnet3_xdp.c
+++ b/drivers/net/vmxnet3/vmxnet3_xdp.c
@@ -397,7 +397,7 @@ vmxnet3_process_xdp(struct vmxnet3_adapt
 
 	xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
 	xdp_prepare_buff(&xdp, page_address(page), rq->page_pool->p.offset,
-			 rbi->len, false);
+			 rcd->len, false);
 	xdp_buff_clear_frags_flag(&xdp);
 
 	xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);


