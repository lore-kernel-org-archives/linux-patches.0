Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D014EF149;
	Tue, 13 Oct 2026 11:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892688; cv=none; b=YY9sNb0WPUFdss9lLYIYtBxf5I1qPQKaOf7ndtpHcKT/X4qVlfF+08GEVuckp3frjtemzX9g4Vf1bGrM3XMIE5iHQryDy0+Qtgz6kH2ijaY/49t6xZVytxPG2A7PjDMSdswHDvzh5t0ZoYuiktTlIsKAjoWg0QkgRgQ75M+1z2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892688; c=relaxed/simple;
	bh=S+avKDaq7dcwcrJ9nY5F63dm6IXErv2gx//hFMklDvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1RCWJHFL79GBN/66NAZdibcZyWxIzzEObPwAHtm2Au0y3DTwHQb9iJDWTo2UVmmDX2mZShurdNoO6Jfx62ZWuIRMoo14zerJ9LhgNS5SYx50CeLZ47AVaHhL/p/yv78XPKqUlK5z3oDbEN+Bk1sU74ZeBU6/PzsjsOhLqPgjdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9lYx+Rd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9lYx+Rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327F11F000FF;
	Tue, 13 Oct 2026 11:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892686;
	bh=OJ4G75IXulDCWTb2RgjYlt6GZzSRRqity5b5ZW3aA5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9lYx+RdyptodWILuG7QBmL1qOFEYEBtimX3uyisg087GY3ZZyTiKpUz1Pfd41ECG
	 p9L3bUGOdHI5bA9f64092x2XMdB9JonlEUMzNpgCO5n7EwKm/8fPcJNwGy7oE/YSA+
	 fYA6J+5j66LFR2yVllxcevb/AmqH1elH+BudvrDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 255/281] pfcp: make sure the SEID is linear before reading it
Date: Tue, 13 Oct 2026 13:39:31 +0200
Message-ID: <20261013112901.329876665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

[ Upstream commit 23609bce9e1de525d1d0e73fc68c6e7971d0b49e ]

pfcp_encap_recv() only makes sure that the UDP header and the 4 byte
PFCP header are in the linear area. When the S flag is set,
pfcp_session_recv() then reads the 8 byte SEID that follows, which is
not covered by the pskb_may_pull() check.

A short PFCP packet with the S flag set, or one whose session header
lies in a fragment, therefore makes pfcp_session_recv() read beyond the
end of the packet data, and whatever it finds there is stored in the
tunnel metadata that flower later classifies on.

Pull up to the end of the SEID before reading it, and drop packets
that are too short to contain it. Reload the header pointer afterwards
since pskb_may_pull() may reallocate the skb head.

Use offsetofend() rather than sizeof(struct pfcphdr_session): the
structure is not packed, so its size is 16 bytes because of the
alignment of the __be64 member, while the header on the wire is only 12
bytes, and valid session messages would be dropped.

Fixes: 6dd514f48110 ("pfcp: always set pfcp metadata")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Link: https://patch.msgid.link/20260930124818.114224-3-yanhaishuang@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pfcp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/pfcp.c b/drivers/net/pfcp.c
index 8bbaf167db759..08557c0381809 100644
--- a/drivers/net/pfcp.c
+++ b/drivers/net/pfcp.c
@@ -64,6 +64,13 @@ static int pfcp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		goto drop;
 
 	unparsed = pfcp_hdr(skb);
+	if (unparsed->flags & PFCP_SEID_FLAG) {
+		if (unlikely(!pskb_may_pull(skb, PFCP_HLEN +
+					    offsetofend(struct pfcphdr_session,
+							seid))))
+			goto drop;
+		unparsed = pfcp_hdr(skb);
+	}
 
 	ip_tunnel_flags_zero(flags);
 	tun_dst = udp_tun_rx_dst(skb, sk->sk_family, flags, 0,
-- 
2.53.0



