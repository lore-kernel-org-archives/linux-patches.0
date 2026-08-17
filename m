Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7274418CB;
	Mon, 17 Aug 2026 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978470; cv=none; b=GllJ4nJyWTjMrNAtLsEus37XpXQGVRuC/IAyedRILE8SZMN9PvWI74S22OzK/HCiWLDoyIfv60KysRzmJXMUjjKfKoTiV1FE+qzOODtuaspN47Y0hpFL1PMYn2QnKLPvfKdBcFa6SCOv0rfP59ShIxhnDSVxDKGzp9CP7o/j+bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978470; c=relaxed/simple;
	bh=mCDhXsYaUFlqyaJrKzZscgi3+mpQlbBH2ihJ1MA9bNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLK1aSNsMjibhflDxkpdvkrPubHr0GYltRGh3AblMhlHpxQYHfDfZa+Dyxa88NRggMRb6LhHeNeCpE3AG5RGoDVLs2Xbxf4WDE8bRUrngTpRLICCNZO0cSr6uC9RnMeIL9ekdVoy2P3uQT9+o72K6uPdmvEKGbkwX3vY33S57rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muDdrEGp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muDdrEGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E781F000E9;
	Mon, 17 Aug 2026 14:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978467;
	bh=ALd42SE8iEr8F0miwHshJNij3+8kkUlVUdvqw71LNPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muDdrEGp/uk5pRB2lUAiFhlaF2CiZGVZXh2bhuN/k3a/FgMdrtHTEo4GnX774BLRE
	 TSFHtfjKy43FK46ISgo8X2fz6tacgKoh2he40sw4IjA4ASy19KSpB1XxyYgXBawlOL
	 uUhKx7g+UVWnMPyGGmOsw4AUHYYv/s31eRfjwSxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/156] net/ncsi: fix heap OOB read in NCSI_CMD_SEND_CMD payload length
Date: Mon, 17 Aug 2026 15:33:02 +0200
Message-ID: <20260817132536.473043697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit afa58b7384913c8773d837acdb07b035690ec5d2 ]

ncsi_send_cmd_nl() takes the number of bytes to copy from the
attacker-controlled ncsi_pkt_hdr.length field of the in-band packet
header, while the source buffer is the NCSI_ATTR_DATA netlink
attribute whose readable size is nla_len() - sizeof(ncsi_pkt_hdr).
The two length sources are never cross-checked: only
nla_len() >= sizeof(struct ncsi_pkt_hdr) is enforced.

With hdr->length set larger than the attribute payload (up to 65535
against at most 2032 readable bytes), ncsi_cmd_handler_oem() copies
past the end of the netlink attribute buffer with unsafe_memcpy(),
leaking up to ~64KB of kernel heap memory into the transmitted NCSI
command packet. The destination skb is sized by the declared payload,
so the write side does not overflow - this is a pure OOB read /
information leak, reachable with CAP_NET_ADMIN on systems with a
registered NCSI device (e.g. OpenBMC on Aspeed BMC SoCs, where
NET_NCSI=y is standard).

Reject commands whose declared payload extends past the end of the
data attribute.

The issue was found by the autokbug dynamic kernel fuzzer at Tencent
Yunding Lab.

Fixes: 9771b8ccdfa6 ("net/ncsi: Extend NC-SI Netlink interface to allow user space to send NC-SI command")
Reported-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://patch.msgid.link/20260803043618.3210301-1-bsdhenrymartin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/ncsi-netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
index 2f872d064396d..8cc538358f6a3 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -461,6 +461,10 @@ static int ncsi_send_cmd_nl(struct sk_buff *msg, struct genl_info *info)
 	nca.req_flags = NCSI_REQ_FLAG_NETLINK_DRIVEN;
 	nca.info = info;
 	nca.payload = ntohs(hdr->length);
+	if (nca.payload > len - sizeof(*hdr)) {
+		ret = -EINVAL;
+		goto out_netlink;
+	}
 	nca.data = data + sizeof(*hdr);
 
 	ret = ncsi_xmit_cmd(&nca);
-- 
2.53.0



