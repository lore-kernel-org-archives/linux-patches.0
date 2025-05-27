Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331E71E89C;
	Tue, 27 May 2025 17:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366081; cv=none; b=STqFzqxC6VFqZg0uwA58geZJ/ueCu04rqmjLDoi4TsF4wHuh5Bt3l8UbBcSjbSJMlBY9gulIwxWoDo6nq+lf6NCuwxxgvDrgizi16OmR5KK0YfiMorUt0OlfA7ODVUVdba69+1OI7+Qt45w63tLH8kg07FD3DtDGuS+ssGkNQr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366081; c=relaxed/simple;
	bh=F2WdEw663rO0VlnLoVV+1UJq1beun9cCcUrNvDN/hv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFmWdjwGQ8rx7x82COd1mWF30pX2nOq6w0U3MEPhmhkhfHVFeU0JHio6BD3ykHPmctdZkSGvi5REMou14yWOYOVTtcQWUhLvxR375xPsEIL6C5ZTExjGsHpYkHTEZre0hGH3yD/0LoZN9xphSsrekPf/P8rhjnIWW9OKPrds578=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOTGkVfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOTGkVfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CEAC4CEE9;
	Tue, 27 May 2025 17:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366081;
	bh=F2WdEw663rO0VlnLoVV+1UJq1beun9cCcUrNvDN/hv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOTGkVfydGwgwdj+G/EF7Lvm9/WQodg2GDGFEvm0PltpMOFvnE8PR9Y/ZVd5Mk/ba
	 vu2RuqysslhH4zXANf03u0i/fppNuSqwAxzx+KF0F+3OttK70/MJWrZf+jnZ0hudpS
	 2c7qWDX5Z+kN9G+rt2HZxYwcJsnL+DADgM591VJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronak Doshi <ronak.doshi@broadcom.com>,
	Guolin Yang <guolin.yang@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 585/626] vmxnet3: update MTU after device quiesce
Date: Tue, 27 May 2025 18:27:58 +0200
Message-ID: <20250527162508.748751439@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronak Doshi <ronak.doshi@broadcom.com>

commit 43f0999af011fba646e015f0bb08b6c3002a0170 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3599,8 +3599,6 @@ vmxnet3_change_mtu(struct net_device *ne
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 	int err = 0;
 
-	WRITE_ONCE(netdev->mtu, new_mtu);
-
 	/*
 	 * Reset_work may be in the middle of resetting the device, wait for its
 	 * completion.
@@ -3614,6 +3612,7 @@ vmxnet3_change_mtu(struct net_device *ne
 
 		/* we need to re-create the rx queue based on the new mtu */
 		vmxnet3_rq_destroy_all(adapter);
+		WRITE_ONCE(netdev->mtu, new_mtu);
 		vmxnet3_adjust_rx_ring_size(adapter);
 		err = vmxnet3_rq_create_all(adapter);
 		if (err) {
@@ -3630,6 +3629,8 @@ vmxnet3_change_mtu(struct net_device *ne
 				   "Closing it\n", err);
 			goto out;
 		}
+	} else {
+		WRITE_ONCE(netdev->mtu, new_mtu);
 	}
 
 out:


