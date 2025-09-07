Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C027617BB21;
	Sun,  7 Sep 2025 20:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276433; cv=none; b=Ax/IgtXE3fELKBb8uLP6rWbD0DZwm5uEra4G+uq0vOIuysUYTg6GYWIvjCkqFowibbNcY1WZbiJxQOhdhsWVhC1R5u9a8uGz0R18uNx5As4CU7kkDPXJrQJXcQqtg2lxms6w4mosW45rKgOBQBZRdqQVrOnfZABOfKDqxkyU5bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276433; c=relaxed/simple;
	bh=xUev/Yg4HcEQKGeZM+9t3Abos9vo8HRaBP7uAQVau/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDURSeBF5g5wvxd5ZMamg/953qwo7w+WbwwCnq2umYSGxst56Obghw4nfioW2iFPK5gn3P3OlJjQKfwpUOxWHYHfoFKG0OfSZ4sC0Iy2IM85RLVKW5V47/vvjR602Zc3BmOkdZ5E7espc4zHXzYairo8XqmB9DWq3qG3A5P6z3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddEP2I+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddEP2I+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43453C4CEF0;
	Sun,  7 Sep 2025 20:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276433;
	bh=xUev/Yg4HcEQKGeZM+9t3Abos9vo8HRaBP7uAQVau/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddEP2I+GIKm45IiExNj59XSC5HFFoztusbgcHeWSYKIMU0CtCVu/XIpimqiG+own3
	 WEAzZSw/8utm4lHXw7dpEQeGX/My7Vpaq1hBzAVURy/+avU229G6GWExRBEN/qutYy
	 dlnkvTxj8v6TcFX0OJA81ffN9xqDfiwO8NBhJgUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronak Doshi <ronak.doshi@broadcom.com>,
	Guolin Yang <guolin.yang@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/104] vmxnet3: update MTU after device quiesce
Date: Sun,  7 Sep 2025 21:58:23 +0200
Message-ID: <20250907195609.389820111@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronak Doshi <ronak.doshi@broadcom.com>

[ Upstream commit 43f0999af011fba646e015f0bb08b6c3002a0170 ]

Currently, when device mtu is updated, vmxnet3 updates netdev mtu, quiesces
the device and then reactivates it for the ESXi to know about the new mtu.
So, technically the OS stack can start using the new mtu before ESXi knows
about the new mtu.

This can lead to issues for TSO packets which use mss as per the new mtu
configured. This patch fixes this issue by moving the mtu write after
device quiesce.

Cc: stable@vger.kernel.org
Fixes: d1a890fa37f2 ("net: VMware virtual Ethernet NIC driver: vmxnet3")
Signed-off-by: Ronak Doshi <ronak.doshi@broadcom.com>
Acked-by: Guolin Yang <guolin.yang@broadcom.com>
Changes v1-> v2:
  Moved MTU write after destroy of rx rings
Link: https://patch.msgid.link/20250515190457.8597-1-ronak.doshi@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ no WRITE_ONCE() in older trees ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3315,8 +3315,6 @@ vmxnet3_change_mtu(struct net_device *ne
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 	int err = 0;
 
-	netdev->mtu = new_mtu;
-
 	/*
 	 * Reset_work may be in the middle of resetting the device, wait for its
 	 * completion.
@@ -3330,6 +3328,7 @@ vmxnet3_change_mtu(struct net_device *ne
 
 		/* we need to re-create the rx queue based on the new mtu */
 		vmxnet3_rq_destroy_all(adapter);
+		netdev->mtu = new_mtu;
 		vmxnet3_adjust_rx_ring_size(adapter);
 		err = vmxnet3_rq_create_all(adapter);
 		if (err) {
@@ -3346,6 +3345,8 @@ vmxnet3_change_mtu(struct net_device *ne
 				   "Closing it\n", err);
 			goto out;
 		}
+	} else {
+		netdev->mtu = new_mtu;
 	}
 
 out:


