Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8269F1CA9D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCu4LfFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55A1C433C8;
	Wed,  4 Oct 2023 18:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443976;
	bh=7dLdA8FsOIGwG1qdlfsfC5VjAsKlNapptSaGFAC/2jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCu4LfFlnWqmcpuPUfPi3w2NjaJvNzwYtTvK4rDLsJrLA5ozhTGo7RknGA9iMQep2
	 8Fs4WWyiJJue+5HB4jN99HOnn7m3rh8/X8LzYOpIWsagbADHz0xY+vAci4/FT39+cN
	 laPriuWI1dmv1UwUIAkTNa1bVUfSLV745RCocRMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radoslaw Tyl <radoslawx.tyl@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 058/321] iavf: do not process adminq tasks when __IAVF_IN_REMOVE_TASK is set
Date: Wed,  4 Oct 2023 19:53:23 +0200
Message-ID: <20231004175231.860735902@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

[ Upstream commit c8de44b577eb540e8bfea55afe1d0904bb571b7a ]

Prevent schedule operations for adminq during device remove and when
__IAVF_IN_REMOVE_TASK flag is set. Currently, the iavf_down function
adds operations for adminq that shouldn't be processed when the device
is in the __IAVF_REMOVE state.

Reproduction:

echo 4 > /sys/bus/pci/devices/0000:17:00.0/sriov_numvfs
ip link set dev ens1f0 vf 0 trust on
ip link set dev ens1f0 vf 1 trust on
ip link set dev ens1f0 vf 2 trust on
ip link set dev ens1f0 vf 3 trust on

ip link set dev ens1f0 vf 0 mac 00:22:33:44:55:66
ip link set dev ens1f0 vf 1 mac 00:22:33:44:55:67
ip link set dev ens1f0 vf 2 mac 00:22:33:44:55:68
ip link set dev ens1f0 vf 3 mac 00:22:33:44:55:69

echo 0000:17:02.0 > /sys/bus/pci/devices/0000\:17\:02.0/driver/unbind
echo 0000:17:02.1 > /sys/bus/pci/devices/0000\:17\:02.1/driver/unbind
echo 0000:17:02.2 > /sys/bus/pci/devices/0000\:17\:02.2/driver/unbind
echo 0000:17:02.3 > /sys/bus/pci/devices/0000\:17\:02.3/driver/unbind
sleep 10
echo 0000:17:02.0 > /sys/bus/pci/drivers/iavf/bind
echo 0000:17:02.1 > /sys/bus/pci/drivers/iavf/bind
echo 0000:17:02.2 > /sys/bus/pci/drivers/iavf/bind
echo 0000:17:02.3 > /sys/bus/pci/drivers/iavf/bind

modprobe vfio-pci
echo 8086 154c > /sys/bus/pci/drivers/vfio-pci/new_id

qemu-system-x86_64 -accel kvm -m 4096 -cpu host \
-drive file=centos9.qcow2,if=none,id=virtio-disk0 \
-device virtio-blk-pci,drive=virtio-disk0,bootindex=0 -smp 4 \
-device vfio-pci,host=17:02.0 -net none \
-device vfio-pci,host=17:02.1 -net none \
-device vfio-pci,host=17:02.2 -net none \
-device vfio-pci,host=17:02.3 -net none \
-daemonize -vnc :5

Current result:
There is a probability that the mac of VF in guest is inconsistent with
it in host

Expected result:
When passthrough NIC VF to guest, the VF in guest should always get
the same mac as it in host.

Fixes: 14756b2ae265 ("iavf: Fix __IAVF_RESETTING state usage")
Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 9610ca770349e..1d24a71905d06 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1421,7 +1421,8 @@ void iavf_down(struct iavf_adapter *adapter)
 	iavf_clear_fdir_filters(adapter);
 	iavf_clear_adv_rss_conf(adapter);
 
-	if (!(adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)) {
+	if (!(adapter->flags & IAVF_FLAG_PF_COMMS_FAILED) &&
+	    !(test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))) {
 		/* cancel any current operation */
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		/* Schedule operations to close down the HW. Don't wait
-- 
2.40.1



