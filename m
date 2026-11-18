Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060807;
	b=taxpfbyBlNpgwZGgaq45VRm6FM2VozwJYJx29BajHHommV6pEIy3KCaa8C4ntoDDc0go
	 zTgMN82q2FHK4dD8KoNOwjKySOFv54br6T5r7j5vuRonaiPf42XvbdATn5ZBDZXc99DZ5
	 nI1mH64cN32W5VjBro+Y4/Nb7Yfk8MEOe/4DD17Wo901lrFaZ8SSNyYVQi+nfG4+zLv8a
	 kbqXPPSmDOKEMry1KFF32T4Y660M2TnezJDXl9sD/dBPUPcVi0WjtiNAq+QS7TG/rN633
	 nBVmExqQcGFIovDKKZHnztEo5LutP+6tgM/QNHecwul0isb3ac3OAgSZwF2iuQF1xQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qtYpB2ZTGPLNL9BGjhz0ZRUMDJjd1X80+/Nl6+MlrPE=;
	b=n9RKM6OtsDvCV4xXdrK9v7L8iFZo85+MieMylDPP4k4C0nXKL/JuRubbhEH1SsHPmrgW
	 zksHty0eDUdwWIiYzCMKSXAnBqx3Th/WLqfliLE8n41CrpmX06hH6SrwUgHM+2zp9Uh0W
	 ctFtXEy1MOt35W/ZdKcyCnR8yxobjUTtUThOaVR3/1ipXAbzmpT8z2g7RjYWSjP5DVWvO
	 HyJ6Y3B03n2QD7SfXMXHxnheskKyP1bIhPkt0DHnHK9KNMCdY0njq0gwHwsr6m+vD3kTS
	 sOVgHLWNcFuT0PBVHVus0/EI5DQ3zSNectVPJ+MAEcnyuA1P2q9y5PKb9tIfSGglZwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GoWMN9jK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0DE606A325;
	Thu, 19 Nov 2026 04:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GoWMN9jK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7FE1F000C4;
	Thu, 19 Nov 2026 04:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060807;
	bh=qtYpB2ZTGPLNL9BGjhz0ZRUMDJjd1X80+/Nl6+MlrPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GoWMN9jKzkdjHkcmHgECvAop4qhUq8xZMOWUlv5e1OBJ0xUWuIbdv4MjpCtCMhbTP
	 toUB6mbVaQSmOmjpbbd1WHzr9mYdVl/n5QmQr2kx6DJRKYOzpGQZGaPPENGzta/dJp
	 nsKXRIBN+NMX7Hnw+CiSN5TnCFO5O38eEDlf0Lcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1291/1848] RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb
Date: Wed, 18 Nov 2026 15:55:29 +0100
Message-ID: <20261118150013.605085501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit b63d21631f836528ef660d7b5a0d84890ff6dbd5 ]

rdma_build_skb() constructs a synthetic IPv6 header for LAG slave
selection and copies the flow label from the AH attribute:

	memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
	       sizeof(*ip6h->flow_lbl));

ipv6hdr.flow_lbl is __u8[3], so sizeof(*ip6h->flow_lbl) dereferences the
array to a single __u8 and yields 1.  The memcpy therefore copies only
the first byte of the flow label, leaving flow_lbl[1] and flow_lbl[2]
uninitialised in the skb buffer (alloc_skb() does not zero the data).
The resulting LAG hash is computed over one byte of real flow-label
data and two bytes of kmalloc residue, so IPv6 RoCEv2 traffic on a
bonded interface can be steered to the wrong slave.

Use sizeof(ip6h->flow_lbl) (the array, 3 bytes) so the whole flow label
is copied.

Fixes: bd3920eac1331 ("RDMA/core: Add LAG functionality")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260916120926.1761-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index 7063e41eaf261..fc1dd6b5bf5ef 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -60,7 +60,7 @@ static struct sk_buff *rdma_build_skb(struct ib_device *device,
 		ip6h->version = 6;
 		ip6h->nexthdr = IPPROTO_UDP;
 		memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
-		       sizeof(*ip6h->flow_lbl));
+		       sizeof(ip6h->flow_lbl));
 		memcpy(&ip6h->saddr, ah_attr->grh.sgid_attr->gid.raw,
 		       sizeof(struct in6_addr));
 		memcpy(&ip6h->daddr, ah_attr->grh.dgid.raw,
-- 
2.53.0



