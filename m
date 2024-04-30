Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DE212C462;
	Tue, 30 Apr 2024 11:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475069; cv=none; b=i/d9S88Qvs9hNi6frb1IZcqHbPQ+1JcLAbjAWCP8Bqy2iK0CKBJF/w6tuM5H0jOIRo5GY8WvSPA6xxA3ZON6J1SR51rE9bpwbTBLf06JYP+d+Uh3c2NlcqE8rp2o7Wn0tWpRiTs8+B5QeLUs4TqmTMMpg5014s2lPzjeP/B4kxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475069; c=relaxed/simple;
	bh=yYeHXK5+DjZADydlmiK0NGtbiuFwPmr6ZLzwyEqLuo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQDLr/84eTqJu9SxUSY4HxBDzIIT5iH/rd0QQpOjaWdAE9U8c+hXDXk8nRcGzNyQAf9y/urJnO3XcquozIxZFIm0i+4KSXeYBdgvWZDKHeaH2lyY/lTUDjkOcQ3HFZjjOhc0zQWk80QthpfQI51VQDWlmLyJlbV4GmrXFtnX5Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijs/JrVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijs/JrVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73FFC2BBFC;
	Tue, 30 Apr 2024 11:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475069;
	bh=yYeHXK5+DjZADydlmiK0NGtbiuFwPmr6ZLzwyEqLuo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijs/JrVDFKu8Z61g30n5SUsOEo0pJxFAKFTLy+mdZ5G1JCpP+VefSYxt119eU2ApJ
	 15n3LDGSZf+iw5NKS3MkQDjMQxU9HHrUH3mGRz2ExW+vF3Ob1gcET57vFqVQD9wbBU
	 gyMfYvHFzjh7l72/jvmaf8BZjrtIujGR610PmYds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	David Bauer <mail@david-bauer.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/138] vxlan: drop packets from invalid src-address
Date: Tue, 30 Apr 2024 12:39:30 +0200
Message-ID: <20240430103051.923014156@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Bauer <mail@david-bauer.net>

[ Upstream commit f58f45c1e5b92975e91754f5407250085a6ae7cf ]

The VXLAN driver currently does not check if the inner layer2
source-address is valid.

In case source-address snooping/learning is enabled, a entry in the FDB
for the invalid address is created with the layer3 address of the tunnel
endpoint.

If the frame happens to have a non-unicast address set, all this
non-unicast traffic is subsequently not flooded to the tunnel network
but sent to the learnt host in the FDB. To make matters worse, this FDB
entry does not expire.

Apply the same filtering for packets as it is done for bridges. This not
only drops these invalid packets but avoids them from being learnt into
the FDB.

Fixes: d342894c5d2f ("vxlan: virtual extensible lan")
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David Bauer <mail@david-bauer.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 3096769e718ed..b173497a3e0ca 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1778,6 +1778,10 @@ static bool vxlan_set_mac(struct vxlan_dev *vxlan,
 	if (ether_addr_equal(eth_hdr(skb)->h_source, vxlan->dev->dev_addr))
 		return false;
 
+	/* Ignore packets from invalid src-address */
+	if (!is_valid_ether_addr(eth_hdr(skb)->h_source))
+		return false;
+
 	/* Get address from the outer IP header */
 	if (vxlan_get_sk_family(vs) == AF_INET) {
 		saddr.sin.sin_addr.s_addr = ip_hdr(skb)->saddr;
-- 
2.43.0



