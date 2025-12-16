Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A72636D4F8;
	Tue, 16 Dec 2025 12:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887498; cv=none; b=ZwGzBZ9m3JkqoADZkgf93y/NHA3dEbc8qSBibng88Ie24ZmlLkj0IS66eNaM7qD1Jjr5D7UMHI2s93sfDSLLmrun/0duYW6iIIgHv0sq3UX41ZtecfciuYFjh/1WHlpSZhJO/Cv1yW2atTEY2kY8P1DyQrWuSLu8vGGB+DQ5UAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887498; c=relaxed/simple;
	bh=NDxrnmDtiwquoOqqq801htBjphgoFayhj9MjfolWUzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6gzUut0cft21V232j4Gly1229hQ5gRg61d4wq3ZwlNdXgCcifoiD3HL9Yk79D8Xve1THtZzMvkSBRSNbFHtWA0bCsCYWvaaykItIxdCqG3jzz+APUpvB5/Prf8ZXT/AARccImgnY2vXcUhRiv7ZwKdJ6Cr348PLfdc59iMUp1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJRF+UdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJRF+UdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA3EC4CEF1;
	Tue, 16 Dec 2025 12:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887497;
	bh=NDxrnmDtiwquoOqqq801htBjphgoFayhj9MjfolWUzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJRF+UdGTb+9uE2x9I5aKZSuAWYdT7xSAklIgU7nnSkwwevWt4yULxxm+qtUKwKL2
	 rNHJCx6egbRg8yy4KpPTupJtGiaWK79M5DZ7seL4y6RSUbvsYQBoVDv/12Yl/hXins
	 i/f2UOCtiFajeiGYJgQWomfuEgY2GJkmDRCi3WKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 249/614] net: export netdev_get_by_index_lock()
Date: Tue, 16 Dec 2025 12:10:16 +0100
Message-ID: <20251216111410.397527855@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: David Wei <dw@davidwei.uk>

[ Upstream commit c07a491c1b735e0c27454ea5c27a446d43401b1e ]

Need to call netdev_get_by_index_lock() from io_uring/zcrx.c, but it is
currently private to net. Export the function in linux/netdevice.h.

Signed-off-by: David Wei <dw@davidwei.uk>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b6c5f9454ef3 ("io_uring/zcrx: call netdev_queue_get_dma_dev() under instance lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 1 +
 net/core/dev.h            | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d1a687444b275..77c46a2823eca 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3401,6 +3401,7 @@ struct net_device *dev_get_by_index(struct net *net, int ifindex);
 struct net_device *__dev_get_by_index(struct net *net, int ifindex);
 struct net_device *netdev_get_by_index(struct net *net, int ifindex,
 				       netdevice_tracker *tracker, gfp_t gfp);
+struct net_device *netdev_get_by_index_lock(struct net *net, int ifindex);
 struct net_device *netdev_get_by_name(struct net *net, const char *name,
 				      netdevice_tracker *tracker, gfp_t gfp);
 struct net_device *netdev_get_by_flags_rcu(struct net *net, netdevice_tracker *tracker,
diff --git a/net/core/dev.h b/net/core/dev.h
index 900880e8b5b4b..df8a90fe89f8f 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -29,7 +29,6 @@ struct napi_struct *
 netdev_napi_by_id_lock(struct net *net, unsigned int napi_id);
 struct net_device *dev_get_by_napi_id(unsigned int napi_id);
 
-struct net_device *netdev_get_by_index_lock(struct net *net, int ifindex);
 struct net_device *__netdev_put_lock(struct net_device *dev, struct net *net);
 struct net_device *
 netdev_xa_find_lock(struct net *net, struct net_device *dev,
-- 
2.51.0



