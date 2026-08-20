Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFB53644C1;
	Thu, 20 Aug 2026 15:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238472; cv=none; b=lSzgQsxqS+6tH5NkISTtAWuM7xnRi825O3g+3eHe6M3bCVboM1q0kvsRgy04yawNkIPHIyiOu2AmjRCWJLaEK8btwPDl8NGWSdHjlMPNarm8x+jg/Hzzo7NxV5qDW6DnjNXPftKXNK/kL9ls7qUCcsZ5gGWy9eBHqzHsQtY5NO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238472; c=relaxed/simple;
	bh=9x9w+t8SSI+KNtpGbiJmP17XPGNdVzdiEoW/HxZmNDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amgklNUb36elI1ZgPtfSeJryQb2tmSOuCJerTnlxGYj4PHyEfcnPB+lVGjTwRKslB6hHKiIT5BuP1i2EJ9OlQw465tvXhKQWnN2i6r0DFDcWEPCu42GN8aWAsqqXQHGTvIw3Umdv3hX8nW8sqCtfdprjtM2GPPwxLhbSv4KnLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXRtM1aW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXRtM1aW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770531F000E9;
	Thu, 20 Aug 2026 15:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238471;
	bh=aakuKoiFNdQ+T7CPm0AJV7xotlNrS+Bd2cIj28TC8XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IXRtM1aWZHvzh7Xl7i8h3vksKYDBjRkT/INu0bA2juyJVMw35ehkluxL9P1mZxEn9
	 EzMQ/3UKSYEY03rLTw5mU5oAbw6QARZkygktNE8ovFKNjAm1n7rrYf75jlu4jRj1wT
	 GzQwJdhVknYg6HOivp0TbXqyVL3iBMuLdAk3P72Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a78926bdac2adb52dc0e@syzkaller.appspotmail.com,
	Simon Horman <horms@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 160/228] net: expect instance lock in netdev_queue_get_dma_dev()
Date: Thu, 20 Aug 2026 16:55:02 +0200
Message-ID: <20260820145249.534723695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 92465f46f3c3a92e4758af20d2363b7adc43e1f5 ]

netdev_queue_get_dma_dev() uses "compat" locking assert which wants
either the rtnl_lock or netdev instance lock. This is not right,
the callers are taking the instance lock unconditionally. All entry
points for queue config are purely instance locked.

In other words the callers use netdev_get_by_index_lock(), not
netdev_get_by_index_lock_ops_compat(). All the state we will
access is effectively instance lock protected (it's const for
devices which are not ops-locked).

Update the assert to avoid false positive warnings.

Cc: stable@vger.kernel.org
Fixes: b6c5f9454ef34 ("io_uring/zcrx: call netdev_queue_get_dma_dev() under instance lock")
Reported-by: syzbot+a78926bdac2adb52dc0e@syzkaller.appspotmail.com
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://patch.msgid.link/20260806225627.3998672-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netdev_queues.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/netdev_queues.c
+++ b/net/core/netdev_queues.c
@@ -40,7 +40,7 @@ struct device *netdev_queue_get_dma_dev(
 	struct netdev_rx_queue *hw_rxq;
 	struct device *dma_dev;
 
-	netdev_assert_locked_ops_compat(dev);
+	netdev_assert_locked(dev);
 
 	/* Only RX side supports queue leasing today. */
 	if (type != NETDEV_QUEUE_TYPE_RX || !netif_rxq_is_leased(dev, idx))


