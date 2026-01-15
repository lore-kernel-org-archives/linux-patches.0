Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8045A2C028F;
	Thu, 15 Jan 2026 17:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496620; cv=none; b=YNqqPEwcHceLjlErWH/tceqMQnuW67UFiG1d9sTEy+rikhehX6GDCWuMo560yH2EQwZ3LWdcUZHrCF0XN2/9+muiZL0QXe92Spfvo+V2+IzRNJ8CDQMZgju2VNAFE+cJjOohtXoojJBLADQFoDqW6azZw/9tCUMuHU6pRQiJvAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496620; c=relaxed/simple;
	bh=ihXOHmgARmb48A9B5wTwQpkdZwZE9E/F8dVnj60jJIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEmMDupjLESdT0c+q1T9vtobUCP5cTd7sp3JW5wMa4cu9eSq35LRY9XvXPwSQEN6ikfCLIW0DtAc0E10OH5rmY4v2o3Z5wqHf8WONSVbyIHglhJLmMGu7OqVEF4fMZ4ZMGYPqTFvd30DasbQoqhkRKRb8BUenebS1E1Riz6oid0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSK513ru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSK513ru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC3CC116D0;
	Thu, 15 Jan 2026 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496620;
	bh=ihXOHmgARmb48A9B5wTwQpkdZwZE9E/F8dVnj60jJIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSK513ru/CbXDSNSJBXKF7BxbtPDypwTZx1RcwF3Va52/9pIfokrLekwb6AjyVTHB
	 kGxYnrjUJvsz/tdqFKbQBaFdcoHrP7N4O7l4c08m/FlJD1Fm8DKk2CRv9WNjswyvKo
	 t3JCYdCE/OGfAK0R0e8puTi1lio6DP4uzCJaEInk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/119] idpf: keep the netdev when a reset fails
Date: Thu, 15 Jan 2026 17:48:12 +0100
Message-ID: <20260115164154.731137192@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit 083029bd8b445595222a3cd14076b880781c1765 ]

During a successful reset the driver would re-allocate vport resources
while keeping the netdevs intact. However, in case of an error in the
init task, the netdev of the failing vport will be unregistered,
effectively removing the network interface:

[  121.211076] idpf 0000:83:00.0: enabling device (0100 -> 0102)
[  121.221976] idpf 0000:83:00.0: Device HW Reset initiated
[  124.161229] idpf 0000:83:00.0 ens801f0: renamed from eth0
[  124.163364] idpf 0000:83:00.0 ens801f0d1: renamed from eth1
[  125.934656] idpf 0000:83:00.0 ens801f0d2: renamed from eth2
[  128.218429] idpf 0000:83:00.0 ens801f0d3: renamed from eth3

ip -br a
ens801f0         UP
ens801f0d1       UP
ens801f0d2       UP
ens801f0d3       UP
echo 1 > /sys/class/net/ens801f0/device/reset

[  145.885537] idpf 0000:83:00.0: resetting
[  145.990280] idpf 0000:83:00.0: reset done
[  146.284766] idpf 0000:83:00.0: HW reset detected
[  146.296610] idpf 0000:83:00.0: Device HW Reset initiated
[  211.556719] idpf 0000:83:00.0: Transaction timed-out (op:526 cookie:7700 vc_op:526 salt:77 timeout:60000ms)
[  272.996705] idpf 0000:83:00.0: Transaction timed-out (op:502 cookie:7800 vc_op:502 salt:78 timeout:60000ms)

ip -br a
ens801f0d1       DOWN
ens801f0d2       DOWN
ens801f0d3       DOWN

Re-shuffle the logic in the error path of the init task to make sure the
netdevs remain intact. This will allow the driver to attempt recovery via
subsequent resets, provided the FW is still functional.

The main change is to make sure that idpf_decfg_netdev() is not called
should the init task fail during a reset. The error handling is
consolidated under unwind_vports, as the removed labels had the same
cleanup logic split depending on the point of failure.

Fixes: ce1b75d0635c ("idpf: add ptypes and MAC filter support")
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 173ddc2488678..568b57cb2298e 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1500,6 +1500,10 @@ void idpf_init_task(struct work_struct *work)
 		goto unwind_vports;
 	}
 
+	err = idpf_send_get_rx_ptype_msg(vport);
+	if (err)
+		goto unwind_vports;
+
 	index = vport->idx;
 	vport_config = adapter->vport_config[index];
 
@@ -1512,15 +1516,11 @@ void idpf_init_task(struct work_struct *work)
 	err = idpf_check_supported_desc_ids(vport);
 	if (err) {
 		dev_err(&pdev->dev, "failed to get required descriptor ids\n");
-		goto cfg_netdev_err;
+		goto unwind_vports;
 	}
 
 	if (idpf_cfg_netdev(vport))
-		goto cfg_netdev_err;
-
-	err = idpf_send_get_rx_ptype_msg(vport);
-	if (err)
-		goto handle_err;
+		goto unwind_vports;
 
 	/* Once state is put into DOWN, driver is ready for dev_open */
 	np = netdev_priv(vport->netdev);
@@ -1558,11 +1558,6 @@ void idpf_init_task(struct work_struct *work)
 
 	return;
 
-handle_err:
-	idpf_decfg_netdev(vport);
-cfg_netdev_err:
-	idpf_vport_rel(vport);
-	adapter->vports[index] = NULL;
 unwind_vports:
 	if (default_vport) {
 		for (index = 0; index < adapter->max_vports; index++) {
-- 
2.51.0



