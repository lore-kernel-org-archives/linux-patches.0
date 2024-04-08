Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F708565D;
	Mon,  8 Apr 2024 13:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583006; cv=none; b=H58ks1xZuyILsIn5kj08k3PktQHzHDhwGIDfpt/SCYZdN2jhLlsgn3In/h49OJHwdk66Y3/KBJXka/tF6wcg1e9Sl9b8ClSsi0r3JYEUwJFKZFGylcEUsfFFiTMy4+O2qq+xGDiUJzTw5IDPgH22R+XvUkUeQKZNtAcBGXxoT6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583006; c=relaxed/simple;
	bh=4xlH7dgwgF/T/tqLyohBG/gULchcy6RcAc3bDr6orM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/kZQtUNkmusev6qwKeLnTUb/YLdpa2AIF7O0TK5QM0aL0hDWAX2FJtTW7YF/eIMjprqoXsYW47bBXUZegLUp10IUiyd0idEKiGxT9fCfHsqo5rQJPRObKIVNIsm1AsfW4DIaUCwBIlybPXQ4SYjZp6spS1F5MDzq5E2oNZRirM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=teCt+k/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="teCt+k/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9A8C43394;
	Mon,  8 Apr 2024 13:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583005;
	bh=4xlH7dgwgF/T/tqLyohBG/gULchcy6RcAc3bDr6orM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=teCt+k/M33I2c3YfPxochYiMNvDSWTZrKFwnwngDSOf4Ovoh8H1ksJKF2LxIV/Jhi
	 q0eKXpVgnfCOuE6ez5NzAGnO0hG0nX3NtqVRf4btFCs9VAgW0T0rb2WJUUrmC14lzv
	 ZZyufh6IBQ/H/iFBerRzVqzckNbhuiQMM2I5XoAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 147/252] i40e: Remove circular header dependencies and fix headers
Date: Mon,  8 Apr 2024 14:57:26 +0200
Message-ID: <20240408125311.216619305@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 56df345917c09ffc00b7834f88990a7a7c338b5c ]

Similarly as for ice driver [1] there are also circular header
dependencies in i40e driver:
i40e.h -> i40e_virtchnl_pf.h -> i40e.h

Another issue is that i40e header files does not contain their own
dependencies on other header files (both private and standard) so their
inclusion in .c file require to add these deps in certain order to
that .c file to make it compilable.

Fix both issues by removal the mentioned circular dependency, by filling
i40e headers with their dependencies so they can be placed anywhere in
a source code. Additionally remove bunch of includes from i40e.h super
header file that are not necessary and include i40e.h only in .c files
that really require it.

[1] 649c87c6ff52 ("ice: remove circular header dependencies on ice.h")

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 6dbdd4de0362 ("e1000e: Workaround for sporadic MDI error on Meteor Lake systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h        | 43 ++++---------------
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  4 +-
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  2 +
 drivers/net/ethernet/intel/i40e/i40e_client.c |  1 -
 drivers/net/ethernet/intel/i40e/i40e_common.c | 11 +++--
 drivers/net/ethernet/intel/i40e/i40e_dcb.c    |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_ddp.c    |  2 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  3 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.h   |  5 ++-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  3 +-
 drivers/net/ethernet/intel/i40e/i40e_hmc.c    |  3 +-
 drivers/net/ethernet/intel/i40e/i40e_hmc.h    |  4 ++
 .../net/ethernet/intel/i40e/i40e_lan_hmc.c    |  8 ++--
 .../net/ethernet/intel/i40e/i40e_lan_hmc.h    |  2 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 15 ++++---
 drivers/net/ethernet/intel/i40e/i40e_nvm.c    |  2 +
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  5 +--
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    |  3 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  7 ++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  1 +
 .../ethernet/intel/i40e/i40e_txrx_common.h    |  2 +
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  7 +--
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |  2 +
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  4 --
 drivers/net/ethernet/intel/i40e/i40e_xsk.h    |  4 ++
 27 files changed, 72 insertions(+), 81 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 6f08c8fe653bd..3e6839ac1f0f1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -4,47 +4,20 @@
 #ifndef _I40E_H_
 #define _I40E_H_
 
-#include <net/tcp.h>
-#include <net/udp.h>
-#include <linux/types.h>
-#include <linux/errno.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/netdevice.h>
-#include <linux/ioport.h>
-#include <linux/iommu.h>
-#include <linux/slab.h>
-#include <linux/list.h>
-#include <linux/hashtable.h>
-#include <linux/string.h>
-#include <linux/in.h>
-#include <linux/ip.h>
-#include <linux/sctp.h>
-#include <linux/pkt_sched.h>
-#include <linux/ipv6.h>
-#include <net/checksum.h>
-#include <net/ip6_checksum.h>
 #include <linux/ethtool.h>
-#include <linux/if_vlan.h>
-#include <linux/if_macvlan.h>
-#include <linux/if_bridge.h>
-#include <linux/clocksource.h>
-#include <linux/net_tstamp.h>
+#include <linux/pci.h>
 #include <linux/ptp_clock_kernel.h>
+#include <linux/types.h>
+#include <linux/avf/virtchnl.h>
+#include <linux/net/intel/i40e_client.h>
 #include <net/pkt_cls.h>
-#include <net/pkt_sched.h>
-#include <net/tc_act/tc_gact.h>
-#include <net/tc_act/tc_mirred.h>
 #include <net/udp_tunnel.h>
-#include <net/xdp_sock.h>
-#include <linux/bitfield.h>
-#include "i40e_type.h"
+#include "i40e_dcb.h"
+#include "i40e_debug.h"
+#include "i40e_io.h"
 #include "i40e_prototype.h"
-#include <linux/net/intel/i40e_client.h>
-#include <linux/avf/virtchnl.h>
-#include "i40e_virtchnl_pf.h"
+#include "i40e_register.h"
 #include "i40e_txrx.h"
-#include "i40e_dcb.h"
 
 /* Useful i40e defaults */
 #define I40E_MAX_VEB			16
diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index e72cfe587c89e..9ce6e633cc2f0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
-#include "i40e_type.h"
+#include <linux/delay.h>
+#include "i40e_alloc.h"
 #include "i40e_register.h"
-#include "i40e_adminq.h"
 #include "i40e_prototype.h"
 
 static void i40e_resume_aq(struct i40e_hw *hw);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index 3357d65a906bf..18a1c3b6d72c5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -4,6 +4,8 @@
 #ifndef _I40E_ADMINQ_CMD_H_
 #define _I40E_ADMINQ_CMD_H_
 
+#include <linux/bits.h>
+
 /* This header file defines the i40e Admin Queue commands and is shared between
  * i40e Firmware and Software.
  *
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index 639c5a1ca853b..306758428aefd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -6,7 +6,6 @@
 #include <linux/net/intel/i40e_client.h>
 
 #include "i40e.h"
-#include "i40e_prototype.h"
 
 static LIST_HEAD(i40e_devices);
 static DEFINE_MUTEX(i40e_device_mutex);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 1b493854f5229..e0685219dbde9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1,11 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2021 Intel Corporation. */
 
-#include "i40e.h"
-#include "i40e_type.h"
-#include "i40e_adminq.h"
-#include "i40e_prototype.h"
 #include <linux/avf/virtchnl.h>
+#include <linux/delay.h>
+#include <linux/etherdevice.h>
+#include <linux/pci.h>
+#include "i40e_adminq_cmd.h"
+#include "i40e_devids.h"
+#include "i40e_prototype.h"
+#include "i40e_register.h"
 
 /**
  * i40e_set_mac_type - Sets MAC type
diff --git a/drivers/net/ethernet/intel/i40e/i40e_dcb.c b/drivers/net/ethernet/intel/i40e/i40e_dcb.c
index f81e744c0fb36..68602fc375f62 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_dcb.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_dcb.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2021 Intel Corporation. */
 
-#include "i40e_adminq.h"
-#include "i40e_prototype.h"
+#include "i40e_alloc.h"
 #include "i40e_dcb.h"
+#include "i40e_prototype.h"
 
 /**
  * i40e_get_dcbx_status
diff --git a/drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c b/drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c
index 195421d863ab1..077a95dad32cf 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c
@@ -2,8 +2,8 @@
 /* Copyright(c) 2013 - 2021 Intel Corporation. */
 
 #ifdef CONFIG_I40E_DCB
-#include "i40e.h"
 #include <net/dcbnl.h>
+#include "i40e.h"
 
 #define I40E_DCBNL_STATUS_SUCCESS	0
 #define I40E_DCBNL_STATUS_ERROR		1
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ddp.c b/drivers/net/ethernet/intel/i40e/i40e_ddp.c
index 0e72abd178ae3..21b3518c40968 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ddp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ddp.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include <linux/firmware.h>
 #include "i40e.h"
 
-#include <linux/firmware.h>
 
 /**
  * i40e_ddp_profiles_eq - checks if DDP profiles are the equivalent
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 1a497cb077100..999c9708def53 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -5,8 +5,9 @@
 
 #include <linux/fs.h>
 #include <linux/debugfs.h>
-
+#include <linux/if_bridge.h>
 #include "i40e.h"
+#include "i40e_virtchnl_pf.h"
 
 static struct dentry *i40e_dbg_root;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_diag.h b/drivers/net/ethernet/intel/i40e/i40e_diag.h
index c3ce5f35211f0..ece3a6b9a5c61 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_diag.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_diag.h
@@ -4,7 +4,10 @@
 #ifndef _I40E_DIAG_H_
 #define _I40E_DIAG_H_
 
-#include "i40e_type.h"
+#include "i40e_adminq_cmd.h"
+
+/* forward-declare the HW struct for the compiler */
+struct i40e_hw;
 
 enum i40e_lb_mode {
 	I40E_LB_MODE_NONE       = 0x0,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index bd1321bf7e268..4e90570ba7803 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -3,9 +3,10 @@
 
 /* ethtool support for i40e */
 
-#include "i40e.h"
+#include "i40e_devids.h"
 #include "i40e_diag.h"
 #include "i40e_txrx_common.h"
+#include "i40e_virtchnl_pf.h"
 
 /* ethtool statistics helpers */
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_hmc.c b/drivers/net/ethernet/intel/i40e/i40e_hmc.c
index b383aea652f3e..1742624ca62ed 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_hmc.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_hmc.c
@@ -1,9 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
-#include "i40e.h"
-#include "i40e_register.h"
 #include "i40e_alloc.h"
+#include "i40e_debug.h"
 #include "i40e_hmc.h"
 #include "i40e_type.h"
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_hmc.h b/drivers/net/ethernet/intel/i40e/i40e_hmc.h
index 9960da07a5732..480e3a883cc7a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_hmc.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_hmc.h
@@ -4,6 +4,10 @@
 #ifndef _I40E_HMC_H_
 #define _I40E_HMC_H_
 
+#include "i40e_alloc.h"
+#include "i40e_io.h"
+#include "i40e_register.h"
+
 #define I40E_HMC_MAX_BP_COUNT 512
 
 /* forward-declare the HW struct for the compiler */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
index 830f1de254ef4..beaaf5c309d51 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
-#include "i40e.h"
-#include "i40e_register.h"
-#include "i40e_type.h"
-#include "i40e_hmc.h"
+#include "i40e_alloc.h"
+#include "i40e_debug.h"
 #include "i40e_lan_hmc.h"
-#include "i40e_prototype.h"
+#include "i40e_type.h"
 
 /* lan specific interface functions */
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.h b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.h
index 9f960404c2b37..305a276953b01 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.h
@@ -4,6 +4,8 @@
 #ifndef _I40E_LAN_HMC_H_
 #define _I40E_LAN_HMC_H_
 
+#include "i40e_hmc.h"
+
 /* forward-declare the HW struct for the compiler */
 struct i40e_hw;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 46b7a428808a8..a21fc92aa2725 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1,19 +1,22 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2021 Intel Corporation. */
 
-#include <linux/etherdevice.h>
-#include <linux/of_net.h>
-#include <linux/pci.h>
-#include <linux/bpf.h>
 #include <generated/utsrelease.h>
 #include <linux/crash_dump.h>
+#include <linux/if_bridge.h>
+#include <linux/if_macvlan.h>
+#include <linux/module.h>
+#include <net/pkt_cls.h>
+#include <net/xdp_sock_drv.h>
 
 /* Local includes */
 #include "i40e.h"
+#include "i40e_devids.h"
 #include "i40e_diag.h"
+#include "i40e_lan_hmc.h"
+#include "i40e_virtchnl_pf.h"
 #include "i40e_xsk.h"
-#include <net/udp_tunnel.h>
-#include <net/xdp_sock_drv.h>
+
 /* All i40e tracepoints are defined by the include below, which
  * must be included exactly once across the whole kernel with
  * CREATE_TRACE_POINTS defined
diff --git a/drivers/net/ethernet/intel/i40e/i40e_nvm.c b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
index 07a46adeab38e..77cdbfc19d477 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_nvm.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_nvm.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include <linux/delay.h>
+#include "i40e_alloc.h"
 #include "i40e_prototype.h"
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index 9c9234c0706f0..2001fefa0c52d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -4,10 +4,9 @@
 #ifndef _I40E_PROTOTYPE_H_
 #define _I40E_PROTOTYPE_H_
 
-#include "i40e_type.h"
-#include "i40e_alloc.h"
-#include "i40e_debug.h"
 #include <linux/avf/virtchnl.h>
+#include "i40e_debug.h"
+#include "i40e_type.h"
 
 /* Prototypes for shared code functions that are not in
  * the standard function pointer structures.  These are
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index cac9584debb1d..65c714d0bfffd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -1,9 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
-#include "i40e.h"
 #include <linux/ptp_classify.h>
 #include <linux/posix-clock.h>
+#include "i40e.h"
+#include "i40e_devids.h"
 
 /* The XL710 timesync is very much like Intel's 82599 design when it comes to
  * the fundamental clock design. However, the clock operations are much simpler
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index f703646622d9a..c962987d8b51b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1,14 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
-#include <linux/prefetch.h>
 #include <linux/bpf_trace.h>
+#include <linux/prefetch.h>
+#include <linux/sctp.h>
 #include <net/mpls.h>
 #include <net/xdp.h>
-#include "i40e.h"
-#include "i40e_trace.h"
-#include "i40e_prototype.h"
 #include "i40e_txrx_common.h"
+#include "i40e_trace.h"
 #include "i40e_xsk.h"
 
 #define I40E_TXD_CMD (I40E_TX_DESC_CMD_EOP | I40E_TX_DESC_CMD_RS)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 81f6a991bfb73..2b1d50873a4d1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -5,6 +5,7 @@
 #define _I40E_TXRX_H_
 
 #include <net/xdp.h>
+#include "i40e_type.h"
 
 /* Interrupt Throttling and Rate Limiting Goodies */
 #define I40E_DEFAULT_IRQ_WORK      256
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h b/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
index 8c5118c8baafb..e26807fd21232 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
@@ -4,6 +4,8 @@
 #ifndef I40E_TXRX_COMMON_
 #define I40E_TXRX_COMMON_
 
+#include "i40e.h"
+
 int i40e_xmit_xdp_tx_ring(struct xdp_buff *xdp, struct i40e_ring *xdp_ring);
 void i40e_clean_programming_status(struct i40e_ring *rx_ring, u64 qword0_raw,
 				   u64 qword1);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 44cea0f4f908d..4092f82bcfb12 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -4,14 +4,9 @@
 #ifndef _I40E_TYPE_H_
 #define _I40E_TYPE_H_
 
-#include <linux/delay.h>
-#include <linux/if_ether.h>
-#include "i40e_io.h"
-#include "i40e_register.h"
+#include <uapi/linux/if_ether.h>
 #include "i40e_adminq.h"
 #include "i40e_hmc.h"
-#include "i40e_lan_hmc.h"
-#include "i40e_devids.h"
 
 /* I40E_MASK is a macro used on 32 bit registers */
 #define I40E_MASK(mask, shift) ((u32)(mask) << (shift))
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 6b90453205b23..7d47a05274548 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2,6 +2,8 @@
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
 #include "i40e.h"
+#include "i40e_lan_hmc.h"
+#include "i40e_virtchnl_pf.h"
 
 /*********************notification routines***********************/
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index cf190762421cc..66f95e2f3146a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -4,7 +4,9 @@
 #ifndef _I40E_VIRTCHNL_PF_H_
 #define _I40E_VIRTCHNL_PF_H_
 
-#include "i40e.h"
+#include <linux/avf/virtchnl.h>
+#include <linux/netdevice.h>
+#include "i40e_type.h"
 
 #define I40E_MAX_VLANID 4095
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 1f8ae6f5d9807..65f38a57b3dfe 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -2,11 +2,7 @@
 /* Copyright(c) 2018 Intel Corporation. */
 
 #include <linux/bpf_trace.h>
-#include <linux/stringify.h>
 #include <net/xdp_sock_drv.h>
-#include <net/xdp.h>
-
-#include "i40e.h"
 #include "i40e_txrx_common.h"
 #include "i40e_xsk.h"
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
index 821df248f8bee..ef156fad52f26 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
@@ -4,6 +4,8 @@
 #ifndef _I40E_XSK_H_
 #define _I40E_XSK_H_
 
+#include <linux/types.h>
+
 /* This value should match the pragma in the loop_unrolled_for
  * macro. Why 4? It is strictly empirical. It seems to be a good
  * compromise between the advantage of having simultaneous outstanding
@@ -20,7 +22,9 @@
 #define loop_unrolled_for for
 #endif
 
+struct i40e_ring;
 struct i40e_vsi;
+struct net_device;
 struct xsk_buff_pool;
 
 int i40e_queue_pair_disable(struct i40e_vsi *vsi, int queue_pair);
-- 
2.43.0



