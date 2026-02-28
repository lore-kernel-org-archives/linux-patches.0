Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE11E3314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301252; cv=none; b=EwSwhNPU9kYs0/tcWsgIpX/jsxPkMW+iPk0w1Gm2ko5wa6zeUO+uhVN+6iIre3y7wZPSO+4wI1IGFjXeXl9Qj6FeeakObddFagNso1rYD6CqgglHrcZ6IE6Emm0dJhIs9bFTkJzLOoq51dXDIsb+aT+2zDw3zQD4yT6TxtAHMb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301252; c=relaxed/simple;
	bh=yH2Z9AcWUq5d8W1YQjCN4M2P2vtr+m3C/YvoCnfwbgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJsqgZ7+jYUiFW1rpm3ulyicxMtnGOSNTAKD7t4mwODGcDgnuy4W0vjbgrFbigJtbkRjrLR0+ypRyCLrodN1zZBPEgX/90FqowqRRQpjFzshupk1Wxijkg8L5eef3IZ9v4wsYyANmUl4yARSfueO6Bb2/iIX9eWYQxtbQEXbpUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tJnnAMpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJnnAMpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE2BC19424;
	Sat, 28 Feb 2026 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301252;
	bh=yH2Z9AcWUq5d8W1YQjCN4M2P2vtr+m3C/YvoCnfwbgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJnnAMpf5Jpa7ZS3ozIn/402dJ0OT/ZizQVnUZth6f+z4mtxeOaD/XeFJ75bLG1HE
	 nl+WuZIxou1x6HbdTfWsEvyVv4PrhO9pZa2cpS72jnFsXs7i/eQNuztGrGbrMRBVp8
	 eqR367cFlBta0CX+kLlj6G1P4pdOvH3vY+ZMlTavctbOrJdOEcC91DogpnCjz7Crnq
	 ypcq06xjsBsG5QX8cfxKNXMEOoQGc5r3ZhIjo4sRYVmNSrxs1o/bUtff67C/7BgAFW
	 tCtQuS6Gh3cH1aMqMwmJQ+n2JSOK6q8D9i0LRyTOb1pJDbkGoq/ECIUcGZiUzUo8xc
	 Xh2s+itulgyvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kamal Heib <kheib@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 435/752] RDMA/ionic: Fix potential NULL pointer dereference in ionic_query_port
Date: Sat, 28 Feb 2026 12:42:26 -0500
Message-ID: <20260228174750.1542406-435-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kamal Heib <kheib@redhat.com>

[ Upstream commit fd80bd7105f88189f47d465ca8cb7d115570de30 ]

The function ionic_query_port() calls ib_device_get_netdev() without
checking the return value which could lead to NULL pointer dereference,
Fix it by checking the return value and return -ENODEV if the 'ndev' is
NULL.

Fixes: 2075bbe8ef03 ("RDMA/ionic: Register device ops for miscellaneous functionality")
Signed-off-by: Kamal Heib <kheib@redhat.com>
Link: https://patch.msgid.link/20260220222125.16973-2-kheib@redhat.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/ionic/ionic_ibdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.c b/drivers/infiniband/hw/ionic/ionic_ibdev.c
index 164046d00e5d4..bd4c73e530d08 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.c
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.c
@@ -81,6 +81,8 @@ static int ionic_query_port(struct ib_device *ibdev, u32 port,
 		return -EINVAL;
 
 	ndev = ib_device_get_netdev(ibdev, port);
+	if (!ndev)
+		return -ENODEV;
 
 	if (netif_running(ndev) && netif_carrier_ok(ndev)) {
 		attr->state = IB_PORT_ACTIVE;
-- 
2.51.0

