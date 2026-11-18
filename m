Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042621;
	b=L2IC/hFM1Mlv1Wd6HJYNmTizeBT98q/mqtw/CWv+rQRw0dDg9DKKpEubxPR3YrrgtKHc
	 2zEde58e1j5aJnOdn9VxqiewBDXQAkDry4mlFoZuSeWFcIcO2BNei2aw+APhKVqiTNdU4
	 +JRPmQY3ihY2HJg6EV5yOnlCa+51yc++8yltMHT4hwW+0mHzwBfjiJOKCQ/7m+1Kl0W61
	 4gch0clcrgnsPTsf7MQfZrXG1PgkoH5MVTeuSlGzaf532Wp7ST2L9KfSjsv1/kGlIqZx1
	 /cwrOUGgCNopcc6KS0rE843NMkBlAZ8i1q3IpU74ZduGV8gGk3Fqbs1yBUn6cJuO4pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZJlkEuNHYC/2e3MuIt7t7VSQVn9VVIw3qOgl7OceiLg=;
	b=oR4KSvE3treg2OUp4MP7dH939Z2I61iPrRDmN+to5QhESipNon4qR9rTkjRNHCKiYvJB
	 AnH60nrQVbP8ZvnfrDd9/38INUybnEi4gqB65Ih2YO0Wbc2JSgzYJikNy65NsLQ/+2zhv
	 50P+fbj8ca+cn7F3fRiCc49SNaVBy7dWYCLbLkAv/dOtz1TjwAMwShHW9t+xnyTDT+/ct
	 i4aTRs/Ehz2tsmvrd6jxFemYiX44pqlnuYdZScH2N3HYoGwcRu0qqU3RDsq4v/ZI3yGyy
	 MBs5Qr4P6faqgkEvardOE63wuLsMFCrwt17kKcn/toPd7h4aoqTvWruvhvXHsUpbyBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kf8LzwSE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC757606A320;
	Wed, 18 Nov 2026 22:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kf8LzwSE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEE31F000C4;
	Wed, 18 Nov 2026 22:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042621;
	bh=ZJlkEuNHYC/2e3MuIt7t7VSQVn9VVIw3qOgl7OceiLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kf8LzwSEabKI/bkrqJ614JoIyLVglCSdjIs1TQ9Y3bmOzZw20Au9XrV3Au/O+FY2o
	 kNWPHIC2yjo3oRMeWCTWMqmupHr8z9dRCIGvD4NgiZsmyUYOn39a+Sw63QCfqzgldi
	 PCAnS3CET8ccSmlf6ITw5gvHnjKE0of6H4LJKHG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3235/3318] net: dcb: initialize PFC value before calling getpfccfg
Date: Wed, 18 Nov 2026 16:04:17 +0100
Message-ID: <20261118150456.746358268@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit ca87a2dffbb550fc934647d5e8d1c4ae85590132 ]

dcbnl_getpfccfg() and dcbnl_cee_fill() pass the address of an
uninitialized stack u8 to the driver's getpfccfg() op and then put it
into the netlink reply unconditionally.  The op returns void, so the
core cannot tell whether the driver wrote the value.

i40e_dcbnl_get_pfc_cfg() and ice_dcbnl_get_pfc_cfg() return without
writing *setting unless the DCBX agent is host managed and in CEE mode.
Both drivers normally run with firmware managed DCBX
(DCB_CAP_DCBX_LLD_MANAGED), and i40e with FW LLDP disabled runs host
managed in IEEE mode, so on a DCB capable i40e/ice port the PFC values
in DCB_CMD_PFC_GCFG and DCB_CMD_CEE_GET replies, and in the CEE part of
RTNLGRP_DCB notifications, come from uninitialized stack.  The same u8
is reused for all eight priorities, so this is one byte per reply.

dcb_doit() only requires CAP_NET_ADMIN for RTM_SETDCB, so the GET
commands are available to unprivileged users.

Set the value to 0 before each call, like the PG config path already
presets its outputs to DCB_ATTR_VALUE_UNDEFINED.  0 is also what the
reply contains today on kernels built with CONFIG_INIT_STACK_ALL_ZERO,
so nothing changes for those.

Found by code inspection, compile-tested only (W=1).  I don't have
i40e/ice hardware to check the reply.

Fixes: b94b013eb626 ("ice: Implement DCBNL support")
Fixes: 5effa78e7c94 ("i40e: Add netlink callbacks support for software based DCB")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Link: https://patch.msgid.link/179289284460.50470.572724041164324949@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dcb/dcbnl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 2e6b8c8fd2ded..1d82a9cbc2c4c 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -281,6 +281,7 @@ static int dcbnl_getpfccfg(struct net_device *netdev, struct nlmsghdr *nlh,
 		if (!getall && !data[i])
 			continue;
 
+		value = 0;
 		netdev->dcbnl_ops->getpfccfg(netdev, i - DCB_PFC_UP_ATTR_0,
 		                             &value);
 		ret = nla_put_u8(skb, i, value);
@@ -1396,6 +1397,7 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 			goto nla_put_failure;
 
 		for (i = DCB_PFC_UP_ATTR_0; i <= DCB_PFC_UP_ATTR_7; i++) {
+			value = 0;
 			ops->getpfccfg(netdev, i - DCB_PFC_UP_ATTR_0, &value);
 			if (nla_put_u8(skb, i, value))
 				goto nla_put_failure;
-- 
2.53.0



