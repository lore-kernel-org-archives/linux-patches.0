Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328383BED23;
	Mon, 17 Aug 2026 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979652; cv=none; b=ePl3lRsjfj67PUkAM3BzpNI8qeHTl0M4H+MJKaY3tdFwDguvuaCaR+SoC+Wh0Ia0cJaG6vVvbC8uFobo5XqVkvRp8aV1wZ3MTuf4Hhbx5rcPXKlTP7uKlLdyGtaG/06lB/DaiDExJWZSWFiCOtDEqPcuR7tkI59rK4jPrfrs+Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979652; c=relaxed/simple;
	bh=UoiM5Tew99NK0zhR1NbgZ1QjLkU7ZmgVVHYGBy4Y5bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJzWPJz8UmUocbtHSO5lQzpnmb8v1XEK4Reeaian7Qn9Vgmcjr9C5QBQ/TKsbczvnKQz0Sfh+uqicGiqMnGcxxhwYG0qm2k6As+CGZoAnZzVTmSuHYgMSziegRcrmyo4ANtgCx+S08CTcRqbsNy/NtxYQPuDURf7qoFJv9lSTNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgoXwV8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgoXwV8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1FC1F000E9;
	Mon, 17 Aug 2026 15:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979651;
	bh=gx8ux8IwMYrGgRGXs43nJTEE71wJ/YjJKcIUZPBEVbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgoXwV8/myutz3fI/IOofJxSoPA5LPIVuqxbpXqdiLgM52PzL1xtcpj9eOW9Bkn8B
	 trNK1MiLnN0Seh8CPacFoIAe3ipA1Ojy+78JbDx9QiCVL4cpyGpXhxfYUw3untbTtk
	 WRJ7KDaX/Yvj+X8qr4kWKaYF14+u59W1F/Dhcv9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 300/609] net: mpls: initialize rtm_tos in mpls_getroute()
Date: Mon, 17 Aug 2026 15:29:56 +0200
Message-ID: <20260817132554.275852893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 295dd295e2137e10e9a5b1891d97e0f08de76f03 ]

mpls_getroute() builds the RTM_NEWROUTE reply to an RTM_GETROUTE
request by filling a struct rtmsg allocated from an skb whose data
area is not zeroed (alloc_skb(NLMSG_GOODSIZE, ...)). It sets every
field of the header except rtm_tos:

	r = nlmsg_data(nlh);
	r->rtm_family	 = AF_MPLS;
	r->rtm_dst_len	= 20;
	r->rtm_src_len	= 0;
	r->rtm_table	= RT_TABLE_MAIN;
	r->rtm_type	= RTN_UNICAST;
	r->rtm_scope	= RT_SCOPE_UNIVERSE;
	r->rtm_protocol = rt->rt_protocol;
	r->rtm_flags	= 0;

struct rtmsg has no padding, so the one uninitialised byte rtm_tos
(offset 3) is copied straight to user space on recvmsg(), leaking a
byte of uninitialised heap memory. This is in contrast to
mpls_dump_route(), which fills the very same header and does set
rtm_tos = 0.

Initialize rtm_tos to 0, matching mpls_dump_route().

Reproduced with KMSAN by adding an MPLS route and issuing a
non-RTM_F_FIB_MATCH RTM_GETROUTE for its label:

  BUG: KMSAN: kernel-infoleak in _copy_to_iter+0x36c/0x33f0
   _copy_to_iter+0x36c/0x33f0
   __skb_datagram_iter+0x196/0x12c0
   skb_copy_datagram_iter+0x5b/0x210
   netlink_recvmsg+0x37b/0xef0
   ...
  Uninit was created at:
   __alloc_skb+0x8ca/0x10e0
   mpls_getroute+0x1280/0x3a40
   rtnetlink_rcv_msg+0x1138/0x15a0
   ...
  Byte 19 of 64 is uninitialized

(byte 19 = nlmsghdr(16) + rtmsg offset 3 = rtm_tos)

Fixes: 397fc9e5cefe ("mpls: route get support")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20260723010830.289917-1-yhlee@isslab.korea.ac.kr
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 6369ff87f4b9..11131f6a5a94 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2483,6 +2483,7 @@ static int mpls_getroute(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	r->rtm_family	 = AF_MPLS;
 	r->rtm_dst_len	= 20;
 	r->rtm_src_len	= 0;
+	r->rtm_tos	= 0;
 	r->rtm_table	= RT_TABLE_MAIN;
 	r->rtm_type	= RTN_UNICAST;
 	r->rtm_scope	= RT_SCOPE_UNIVERSE;
-- 
2.53.0



