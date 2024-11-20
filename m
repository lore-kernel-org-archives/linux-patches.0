Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B071B1BE23C;
	Wed, 20 Nov 2024 12:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107572; cv=none; b=UKOO7PtBCOqQtjbj8KMnxF+KRkXArRMtzz1f81k4B5XjLsJUM24IMq4WnTnCSNJfyzd/JZPWH4S/QBmQBGs7B/u+VlZeCdrYJuGmzg5RjQtAqycj9SZsKrP2es6Hc8PgQqJmlVaZBfqLDfxyllMY1WngeyrDObqYCJA5Qxkp+8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107572; c=relaxed/simple;
	bh=MSEg/5C9EizcOgf1EjtJHeJQu7TAlYlViVI3tGjDnLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9m1H0sLhVnG4eTfGORagzhiTZEB/1Xyz1WGHLWgUjsc0OtXWgYU8JyHm53OBRo6W+L1qyjdn/il0g9kY/EyftzEDPYQt9Zg1HlzJNA3XrNe4HN8Cj11SVBNGthSEnrHUL5q4wkofXm2rP4RIYPW3TFB8dyt+B8NzbEWSg5duEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbVi1JC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbVi1JC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF70C4CECD;
	Wed, 20 Nov 2024 12:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107572;
	bh=MSEg/5C9EizcOgf1EjtJHeJQu7TAlYlViVI3tGjDnLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbVi1JC50jTEnqUxskqH0IrXEl1GAYw2HhhfT2kCxxlSNUwYCoX4iaWQMwgkuL7gM
	 0JXEpgNgOuv91yZAltBAHH2ZmHzHJ+1ITbiHUEUiGe60k234c/YSbgJgwZqA3x8tv0
	 HuWxMQph2KdpVo3b+xa3sYNVNNGrYYBivlNWgPgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 12/82] Revert "RDMA/core: Fix ENODEV error for iWARP test over vlan"
Date: Wed, 20 Nov 2024 13:56:22 +0100
Message-ID: <20241120125629.893785883@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 6abe2a90808192a5a8b2825293e5f10e80fdea56 ]

The citied commit in Fixes line caused to regression for udaddy [1]
application. It doesn't work over VLANs anymore.

Client:
  ifconfig eth2 1.1.1.1
  ip link add link eth2 name p0.3597 type vlan protocol 802.1Q id 3597
  ip link set dev p0.3597 up
  ip addr add 2.2.2.2/16 dev p0.3597
  udaddy -S 847 -C 220 -c 2 -t 0 -s 2.2.2.3 -b 2.2.2.2

Server:
  ifconfig eth2 1.1.1.3
  ip link add link eth2 name p0.3597 type vlan protocol 802.1Q id 3597
  ip link set dev p0.3597 up
  ip addr add 2.2.2.3/16 dev p0.3597
  udaddy -S 847 -C 220 -c 2 -t 0 -b 2.2.2.3

[1] https://github.com/linux-rdma/rdma-core/blob/master/librdmacm/examples/udaddy.c

Fixes: 5069d7e202f6 ("RDMA/core: Fix ENODEV error for iWARP test over vlan")
Reported-by: Leon Romanovsky <leonro@nvidia.com>
Closes: https://lore.kernel.org/all/20241110130746.GA48891@unreal
Link: https://patch.msgid.link/bb9d403419b2b9566da5b8bf0761fa8377927e49.1731401658.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/addr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index fd78d678877c4..f253295795f0a 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -269,8 +269,6 @@ rdma_find_ndev_for_src_ip_rcu(struct net *net, const struct sockaddr *src_in)
 		break;
 #endif
 	}
-	if (!ret && dev && is_vlan_dev(dev))
-		dev = vlan_dev_real_dev(dev);
 	return ret ? ERR_PTR(ret) : dev;
 }
 
-- 
2.43.0



