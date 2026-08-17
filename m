Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA452BE7A7;
	Mon, 17 Aug 2026 13:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974904; cv=none; b=D1Z115czLKNyauR4ilpDUdjk4bNymgOvGqI3qjwb/UfoqJFxY0NkRGw5AoDnnFNc8zcJopSkj4q8xuluKPJYwTLA6fjw1dWkFj9WFNiftRpf/t7m7HCAIyGQx0/pV38tMkR+4jOo7d0oaMS0yECPCpdWR64x7U70VolFzIFUmqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974904; c=relaxed/simple;
	bh=AaTfNktrbFqmUzF1wtzIgqN/BHbbr8hHjhAafLlERLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3aymk3oLB2sOndx0wJdtVxF7vckUPxCvBlfEID+jmR9hKNlqzIiP8ggp0NfIHBzAYnp0Z6bdGnkrlOjvglYlQhAf10Gh3nYxEaDX8kQZLRYqiBKC3AmhwIT6bVtM7WIhp//uWMzNPPlFgeCwdjeJr02eifU5yxZoQHPH7F3byo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiofYPfi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiofYPfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1BA1F000E9;
	Mon, 17 Aug 2026 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974900;
	bh=jdqgcajSOUu4DDRogXOkRmfAzyig9o1xaMqcg8GqWRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NiofYPfiwALH2i2Be+H7xXXBeVYssQ1Wje/KRWpyHS/LBanRecwy79wU4VKfmZ2DV
	 ueWkyG1M/V3UUTxVyAWudxf/Cd+q+0xcQhJDqvmnTze4AEPZW55BwOK8/J1f7SsUTA
	 5CEr2Vtl+P7TzL1baZwPPLPSkwsOznXL6uuiW0Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/250] net/ncsi: fix heap OOB read in NCSI_CMD_SEND_CMD payload length
Date: Mon, 17 Aug 2026 15:30:54 +0200
Message-ID: <20260817132540.292543516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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



