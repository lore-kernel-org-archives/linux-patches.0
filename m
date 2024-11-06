Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025D9646;
	Wed,  6 Nov 2024 13:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899272; cv=none; b=WWnwW5sCTO8l7GhSwHhNh7yZsw2TTi0vAi45hHQW5vocTvQDQ0EMIQKP0UPYoPHh4RdIOfONUw+DRx4QSGAA1/A7WPSx10WXr/Zm0+Q7b2TdXMypp8KHqrKb45kfC2s7uEHw3bVEDzXnkUY0KMuHGYRCO1iZeDuAi5bXsN55J4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899272; c=relaxed/simple;
	bh=ZVsY64GMsWmST4zqkXJSlyHegOdTxjF/574iYcHbB+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvPF8/8w68uqKblTUKcgGITR6rUypPIrjTRXcD0dWCaf19Y9EgpTHm6tFtvXWXOKqsQy6QqXK2oAGhlnuv4hLUH1+tnc2Zx7yyvnj3xGZG6gZNHu33/dgwD32lLq7bzy2ZROc8dvFGH4hgSo2wXB0TBL9Wqtpn915rMeIib0fkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWpoZft1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWpoZft1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3117DC4CECD;
	Wed,  6 Nov 2024 13:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899271;
	bh=ZVsY64GMsWmST4zqkXJSlyHegOdTxjF/574iYcHbB+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWpoZft1dZVWNJH8W7FWCdJ9V2xvSPYgmv52hDJaAGAFLmI91uSmaaKHDpIkEpuut
	 0KcCgi2HgC/EKYCzDJ6PizhvsFm/PkYR16q6wGgqU4lO1OE8+wPt+E3rp0q8OYhq3P
	 13p49iYOPsmAKjTRXbzwGKkAYqd7u0x+rUPyabMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Yuying Ma <yuma@redhat.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 19/73] igb: Disable threaded IRQ for igb_msix_other
Date: Wed,  6 Nov 2024 13:05:23 +0100
Message-ID: <20241106120300.537177578@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit 338c4d3902feb5be49bfda530a72c7ab860e2c9f ]

During testing of SR-IOV, Red Hat QE encountered an issue where the
ip link up command intermittently fails for the igbvf interfaces when
using the PREEMPT_RT variant. Investigation revealed that
e1000_write_posted_mbx returns an error due to the lack of an ACK
from e1000_poll_for_ack.

The underlying issue arises from the fact that IRQs are threaded by
default under PREEMPT_RT. While the exact hardware details are not
available, it appears that the IRQ handled by igb_msix_other must
be processed before e1000_poll_for_ack times out. However,
e1000_write_posted_mbx is called with preemption disabled, leading
to a scenario where the IRQ is serviced only after the failure of
e1000_write_posted_mbx.

To resolve this, we set IRQF_NO_THREAD for the affected interrupt,
ensuring that the kernel handles it immediately, thereby preventing
the aforementioned error.

Reproducer:

    #!/bin/bash

    # echo 2 > /sys/class/net/ens14f0/device/sriov_numvfs
    ipaddr_vlan=3
    nic_test=ens14f0
    vf=${nic_test}v0

    while true; do
	    ip link set ${nic_test} mtu 1500
	    ip link set ${vf} mtu 1500
	    ip link set $vf up
	    ip link set ${nic_test} vf 0 vlan ${ipaddr_vlan}
	    ip addr add 172.30.${ipaddr_vlan}.1/24 dev ${vf}
	    ip addr add 2021:db8:${ipaddr_vlan}::1/64 dev ${vf}
	    if ! ip link show $vf | grep 'state UP'; then
		    echo 'Error found'
		    break
	    fi
	    ip link set $vf down
    done

Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
Reported-by: Yuying Ma <yuma@redhat.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index f3a433b4c7cdb..7b4d04d33154a 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -937,7 +937,7 @@ static int igb_request_msix(struct igb_adapter *adapter)
 	int i, err = 0, vector = 0, free_vector = 0;
 
 	err = request_irq(adapter->msix_entries[vector].vector,
-			  igb_msix_other, 0, netdev->name, adapter);
+			  igb_msix_other, IRQF_NO_THREAD, netdev->name, adapter);
 	if (err)
 		goto err_out;
 
-- 
2.43.0



