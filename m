Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CCE442FCB;
	Mon, 17 Aug 2026 15:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980295; cv=none; b=cswJeRx7cXidg3yMa9/AR9vxX2E4HAodHK3xO+I7gqZQj10b2tASQYMvh024xLq+oRKjXcLy5hspk2aMGmdL2bf7OglJc1ur/FkB/tdI65VE9zE3z05dQTYUnfeGvscYRVm4ozuhYPkZKlGhUXj99r/opFaF91r/fW3RxFue7rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980295; c=relaxed/simple;
	bh=8LCuv3njx4vmIO65rUhxKM58B+GvQAiHW2GXib5/rR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7YDnsA6dWohQ7Jv0EDsxS9Lpav143UPG7oSxkmNGDdOEmBz8C4/2Auq9PTdqhf3xgmRGz9eV5PQ1mdYcg2db7C1KY9kzcQexfK+8emREq8DMu/zuVB9z5MQWBS0OcF2zD2r7mPiLHOFdsi37NKZJ+oeq1l1Y5JkRSsCesHY3o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFvHtFEP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFvHtFEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E8A1F00A3D;
	Mon, 17 Aug 2026 15:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980294;
	bh=xd7cRITpvlblDdzW4XfEBeNXtpnRynejYP4E/v9CpwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFvHtFEPy9mKNFkBkm0YTSLhoiDlMvlpdBnyAwppW3tfwkUpFEnHXxhLEncuENq6E
	 9jQiap9on+ClrzT76UkMyT+Vk3SgyHxwjAlq/MwPcnTgHlSPUB3cCeQoXNTCq3sWJc
	 S2atr8GL1EgxS1gw4ID9gKwBYhGX3oUXeASdiEOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 522/609] net/ncsi: fix heap OOB read in NCSI_CMD_SEND_CMD payload length
Date: Mon, 17 Aug 2026 15:33:38 +0200
Message-ID: <20260817132601.288757762@linuxfoundation.org>
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
index fe681680b5d91..a4ba1f6c9d228 100644
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



