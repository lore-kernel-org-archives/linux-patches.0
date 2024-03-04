Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257E41C6AB;
	Mon,  4 Mar 2024 21:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589179; cv=none; b=oiZbplGi1xDtkvVrpHl06XoGI5im4Pc8YLUlokOeGgmSGTanWAU7AEZN3W43fXMg8TGbF+96vBxcTX0A9ySajeaaNJlXBJ6tgs5Bok8x2Fh70pMvPZzLuZ6VmQ/5doYqh/tLv0nqC3yU0v1bID1xzSZ3xvkoB3QLF0uG4aQxZgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589179; c=relaxed/simple;
	bh=3mVd6FmxEPYwbjvldeEGf+1fpKquUbZYkVlAY0RrHk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFJl0tFCW2y66WXCLfs+dGmOJKsgdHOh3hxKrxpQDFy2kFwtqjzFAXL6tViNjw7yjmcXHyWBNW6PjU57pUU3WsbebP8DRJ/FXLd+TIp7Eqjme3qA6ZrzjTC9F7NGsqFVYkUXU2IPJJvFzHG1WU7S0a4UJbqq4ArwLntuUpKBThs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8Z12UN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8Z12UN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBD2C433F1;
	Mon,  4 Mar 2024 21:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589179;
	bh=3mVd6FmxEPYwbjvldeEGf+1fpKquUbZYkVlAY0RrHk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8Z12UN7qgeGsXPKnctxse5fA1hfcDiunbHoiuIrCveUH1V1eeMBa40KHVM04TGLj
	 iMtC40ap+0h8r2Y3Djz2tyrCOaSsd5F7Tbv4u+TYt9O2qBRy+saxspI30WI3b1RcEC
	 GDL1gn75iytIK5Eu3estQKURTJr8YMW7wIj7Ja3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Averin <vvs@openvz.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/84] net: enable memcg accounting for veth queues
Date: Mon,  4 Mar 2024 21:23:43 +0000
Message-ID: <20240304211542.689475710@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@openvz.org>

[ Upstream commit 961c6136359eef38a8c023d02028fdcd123f02a6 ]

veth netdevice defines own rx queues and allocates array containing
up to 4095 ~750-bytes-long 'struct veth_rq' elements. Such allocation
is quite huge and should be accounted to memcg.

Signed-off-by: Vasily Averin <vvs@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 1ce7d306ea63 ("veth: try harder when allocating queue memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 85c3e12f83627..87cee614618ca 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1303,7 +1303,7 @@ static int veth_alloc_queues(struct net_device *dev)
 	struct veth_priv *priv = netdev_priv(dev);
 	int i;
 
-	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL);
+	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL_ACCOUNT);
 	if (!priv->rq)
 		return -ENOMEM;
 
-- 
2.43.0



