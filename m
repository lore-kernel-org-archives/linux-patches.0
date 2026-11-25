Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623958;
	b=FwM9MwTMuwauxan4EsvGfio1ZPSplblXS/ZmY9k8IrTaJgqcRNNd3LMb6HdLGvomo3Jm
	 gsYY1hdnGBdPb7EcGUesCi//VwzmosRK6sYtWr6oot2PVxUVHOnYnyvT8wppM4woWY8ZK
	 ahVCe45dz5Oecy/rl14EJgSpT9UjIpMvlA+HxK8zicuJfPaXaF1CJVv3WLrxGL2HLqNKI
	 AXMukv8D8s0T40M/c7rfKSBnjsocld1eGvn84nF2ZS7p0YcNWSt5ZjuaPscddTuux0EnU
	 BPzwVZJb78DkE0/PaajGKZDIUSb+rvWELEA2JOIgy4Soi/luiSzdBpiemoPUqT6txJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uAydZ4RvG0uz1oPhnOS3Ii0Ye0F3mHvPBswLbQuznlE=;
	b=OKR2ZEkf1PhoLxBcn1OL0k0LdRFMXE3qiigR3WVky11JawMAO//7qpPtxV2Ir2eNQXRF
	 ucsyBgeyZikZsUeM1wLPVn9xuKwGGJT96L7EW0X8eUsSIw1UwM49xFLDgsTHv1fiudzkJ
	 nzUdc8Z7m/Bl8k3LDEdcYSP2/sx78qVegGYWz3CeOXtQ0S9pp7KOXgKGbePfqAmOt4r95
	 R3Bh+/dvXOGkLJ1AV5UP1Rn4nBPBZkxcErxr0ZSH9UWQxdxi3/MIgQQ9jcoRuW2d5fqtq
	 GMKNeTMK6RG1YbRgQsCKpp0HL56oTO5Og3VxW3y4+7TI49T7j8WRL1rkqphuZKc60Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vxnr8sPS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28CC606A321;
	Wed, 25 Nov 2026 16:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vxnr8sPS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEBD1F000C4;
	Wed, 25 Nov 2026 16:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623958;
	bh=uAydZ4RvG0uz1oPhnOS3Ii0Ye0F3mHvPBswLbQuznlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxnr8sPSHRIez9kJEM12slZbiyQJFMI4UJq7BbJxdcsx2BvaVoO43ARw3sfW3+mYq
	 oH9XEYR856o870v5vTDbAbAzjt2nKud1iAnZX3fvf3wVm+2L8nE7KpelQ93Si8Lx32
	 h9GkuM+DzzONZXlIXGCSiwKF132BTysyNaAArNNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/816] bpqether: set both addresses or none in SIOCSBPQETHADDR
Date: Wed, 25 Nov 2026 15:26:29 +0100
Message-ID: <20261125143850.172330427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

SIOCSBPQETHADDR copies the destination address straight into the
device, then the accepted source address. When the second copy faults,
the ioctl returns -EFAULT but the destination address has already been
changed, and copy_from_user() has zero-filled the part of the accepted
address it could not read.

With the accepted address left as 00:00:00:00:00:00, bpq_rcv() drops
every frame whose source is not that address: the device silently
stops receiving although the ioctl reported a failure.

Copy the whole struct bpq_ethaddr to the stack first and only update
the device once it has been read in full.

Tested in a QEMU guest (6.12.94, KASAN) by placing the struct so that
its accept field falls in an unmapped page. Before the change
/proc/net/bpqether showed the new destination and an accepted address
of 00:00:00:00:00:00 after the -EFAULT; after it, both addresses are
unchanged, and a valid call still sets them.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 431bb7f4a7d347ccda32319aa346346664858289)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/bpqether.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index ea6bee45e2a4d..4a04c3b4bdb93 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -319,8 +319,8 @@ static int bpq_set_mac_address(struct net_device *dev, void *addr)
 static int bpq_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 			      void __user *data, int cmd)
 {
-	struct bpq_ethaddr __user *ethaddr = data;
 	struct bpqdev *bpq = netdev_priv(dev);
+	struct bpq_ethaddr ethaddr;
 	struct bpq_req req;
 
 	if (!capable(CAP_NET_ADMIN))
@@ -340,10 +340,10 @@ static int bpq_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 			break;
 
 		case SIOCSBPQETHADDR:
-			if (copy_from_user(bpq->dest_addr, ethaddr->destination, ETH_ALEN))
-				return -EFAULT;
-			if (copy_from_user(bpq->acpt_addr, ethaddr->accept, ETH_ALEN))
+			if (copy_from_user(&ethaddr, data, sizeof(ethaddr)))
 				return -EFAULT;
+			memcpy(bpq->dest_addr, ethaddr.destination, ETH_ALEN);
+			memcpy(bpq->acpt_addr, ethaddr.accept, ETH_ALEN);
 			break;
 
 		default:
-- 
2.53.0



