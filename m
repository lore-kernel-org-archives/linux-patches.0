Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAEF1DF736;
	Wed,  6 Nov 2024 12:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895839; cv=none; b=D56OcEcrCIBIBIRTbejF/FgSAen6hjrlNKO4geE9PSuNy+9v1SfVHxJwQ+VGqQCeiXG5LYtP4vNhGNS1/Kub41cs6B6De6u8b2Ot/cBx0K7kU20NbXtmqNBbfuCqENxV4GLBAhl/stgoaWv2NGy03x/CITLNGoKKFGu+xmMWKnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895839; c=relaxed/simple;
	bh=9Yc5cuSV+2Nbo7mNRmEy430ECOvNpY2crLO9WmpbnWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6z4xgsnRF0tNfvOU0QBa5vgF2QKXZWUzw0i7ivqIOvKxZal6r0yft2SwMqntcbl1He/EdwXrTJ3p8E3SAopgCcEXO2bQfYeSHql6lS3+Y0lWCHgwl/n+rQ1nr8X1qmnN+GceQebG/J1sM/tRQ/+hcpeDMNfM533Wa/pEG8NZdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7uknraj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7uknraj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3AAC4CECD;
	Wed,  6 Nov 2024 12:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895838;
	bh=9Yc5cuSV+2Nbo7mNRmEy430ECOvNpY2crLO9WmpbnWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7uknrajm7S9UMrsgUEs/vYQz0Uo499gvo/gebZrcZQIHV2b4m4hRjNTlQvB8VcSO
	 IA2HQvlb6RMynaq8QWaYxM8C4iTbtzoSWmS3u27xchDPzvBsQhB9U6DvBEnPZL/m5C
	 zMsiD9w13m7lrT/EoJHD/Z5oSUiGpIRs13vbeTU8=
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
Subject: [PATCH 4.19 328/350] igb: Disable threaded IRQ for igb_msix_other
Date: Wed,  6 Nov 2024 13:04:16 +0100
Message-ID: <20241106120328.830089279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3a65dccc08ba8..5867e2db17fd5 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -943,7 +943,7 @@ static int igb_request_msix(struct igb_adapter *adapter)
 	int i, err = 0, vector = 0, free_vector = 0;
 
 	err = request_irq(adapter->msix_entries[vector].vector,
-			  igb_msix_other, 0, netdev->name, adapter);
+			  igb_msix_other, IRQF_NO_THREAD, netdev->name, adapter);
 	if (err)
 		goto err_out;
 
-- 
2.43.0



