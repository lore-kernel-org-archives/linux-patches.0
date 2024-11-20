Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7354019F487;
	Wed, 20 Nov 2024 12:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107495; cv=none; b=YLeYyLW9MvhgubccGTNxWxNrdkG2iVdVJsvSpl8n42g1SAjCvJsCgIjF0WDNfeeI4RRWOZY3ABFkNP+qrPVm3ps33ARTkH4OqZuPKDbNDWSxDz0tOjHDKp16IaWYqHAe/GJIWzLxTZeCEIbLx2xfCbzI7Mly+V2ZF9z18pDvD4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107495; c=relaxed/simple;
	bh=QfcN1vLjk5Zvaw7Rq/TPZu0NMfBzqSnMZijSLJ9/bgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbAGulZZHKqGZaAEKQX0NgxpaX4qBDjaUKPUBffIAQW4/acbBKMlHQ8E91n8VF5ZutlHAW8/pxTjC2RAtnkHs5whJAW58jJ6SJT2NJ7nkwhgWOF2NKJBR1JbFx+sSAKPOGEIZXj6MfmkfBu2nWF09BuTZd183vujeakTQ20c88M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/7OMCIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/7OMCIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481D0C4CED6;
	Wed, 20 Nov 2024 12:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107495;
	bh=QfcN1vLjk5Zvaw7Rq/TPZu0NMfBzqSnMZijSLJ9/bgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/7OMCICKmcBgA3wAqnuLRG+S9MhczT5q3n77VUOQdZDZ4AzuErrnK+nydbA9w3c0
	 TYpk+Rsmxea50xExdS7XgYZQIGxQBuxD3mOuponxwC2AlOp2xG8qNInJHWsuqKndGX
	 nhfBUDFHane2rwb7IPtoaaubidSl5JfJhNEjOmjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 018/107] Revert "RDMA/core: Fix ENODEV error for iWARP test over vlan"
Date: Wed, 20 Nov 2024 13:55:53 +0100
Message-ID: <20241120125630.088591891@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index c4cf26f1d1496..be0743dac3fff 100644
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



