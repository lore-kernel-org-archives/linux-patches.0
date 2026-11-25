Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622818;
	b=bwLOdJ+zBLuWBOQGseJRpOa4ZgHnelW4U9IPjvw3BFMvx164IS9PfpeOgpTbVjIG9WOB
	 X8YY74F4hKKT1Vz4JmgH7gmtK54bklP9C8cMur3x9n+kNFeNOY7GclI45w6N3ru8tmxmI
	 LM7kwLKsK1Mb4B2Kc2DsEX6xe+b065dDzFFRv6jpP42ua+nhkLVsUs2B1XeZfnHbpJN+I
	 6zrdPnGv4gF2yUF+ccXKxdYkyatEsp6Nib7FnCt/0APhR3Ncy/O5TlWJWXTMmRt/9aXpK
	 GDWwuMOfW47E7R5tgIgoCsSDRFJImxjLM7Y378Y4lES+MLmX6h5GWKNcuZN2lBR0eUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lMoxiFErbb9aEaM8cwXgUnCTAvBbTx3VTpOM169/t4A=;
	b=A5eXlprTUV/MwA1uj5yu/2eL5OMnvtVe28hQYGR5i/v2yS393PJ1o11UhiARPCPmSaVY
	 xqlTUJ7LYMJevtL13RWV4v1QRlnXdMV7+C9e218LyWYb588Wwgz0Ad1fpSzdX4KwF9FF8
	 OJqcJl93grC5U48DN4sWQ7h/5P5VByCCCRTqnSHmzSkm8WuQ25YOsr7UDyIfXuZsoezm+
	 zA4WbFVcwwkzKjbxsyPxhiglD8dMzvE2J+cHjsWJZSg/mQLwd6sJG4PNZx0el/Ihni7Gf
	 f55JCco187ZBchxrqRENrtD7sBKW9Q54ykXdlXEptbcVwPNEb0g9P+xmLoiPJ8qffmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wgCbffcf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D38606A32C;
	Wed, 25 Nov 2026 16:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wgCbffcf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617381F000CF;
	Wed, 25 Nov 2026 16:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622817;
	bh=lMoxiFErbb9aEaM8cwXgUnCTAvBbTx3VTpOM169/t4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgCbffcfQgNAxgYLPxmv0WdvpUIPkkLv7wppJ1TySlmyar/HeM1g5F90zIUqtKWZv
	 vH3dDroqIv01sVb5Pn7i21F0Rk7LpO4DiVGmqJ//viVgpN7k/G3R3BSXKqFSFuv78R
	 kJZXdvYaAP/NSzrRfxuxnKVZVNo4wg+8rEpVnua0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciek Machnikowski <maciej.machnikowski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 642/990] ice: use reference counting and SRCU for PTP port access
Date: Wed, 25 Nov 2026 15:33:29 +0100
Message-ID: <20261125143837.129869288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit d5d859a6efff473d799d35999a35aa764dcc185b ]

The ice adapter structure maintains a list of ports associated with the
adapter. This is used for supporting PTP, where the clock owner must handle
many operations that require access to the PTP port structures of the
associated PFs.

This is implemented using a linked list and a mutex. This sort of works,
but a few places within the code do not acquire the mutex when iterating
the list. This includes ice_ptp_flush_all_tx_tracker(),
ice_ptp_restart_all_phy(), and ice_ptp_prepare_rebuild_sec().

Fixing this is tricky, especially since it is not clear if we can simply
acquire the lock around the complete iterations.

The pattern of use for the port list is read-mostly with modifications only
happening during PF initialization when elements are inserted. This
typically only happens during early boot, though a PF could in principle be
removed or loaded at arbitrary times via bind and unbind operations.

The use of a mutex does mean the driver can sleep while holding it, but it
still creates complicates with lock ordering and prevents iterating the
list in any code path that *can't* sleep.

Instead, use SRCU primitives for the port linked list, along with a
reference count on the port. The kref reference counter ensures that a PF
will have a valid lifetime and not be removed until the reference is
released. Note that this change focuses solely on the port list and does
not make an effort to resolve access to ctrl_pf, which is currently being
investigated by another developer.

Use of sleepable RCU is required because we often iterate the PTP port list
and perform operations that might sleep. Attempts at implementing regular
RCU have thus far not proven to be acceptable.

The remove path first removes the port from the list, and we use
kref_get_unless_zero to ensure that such ports are skipped when iterating
the list. This ensures that once a port starts removing we will drop
references and no longer be able to acquire new ones. This avoids loop
iterations chaining together to indefinitely block removal.

The ice_ptp_release_port_srcu() function is used as the release function
for the kref_put() call. This uses wake_up_var() to wake the removing
thread. The waiting thread will block until the final reference has been
removed, then it will use synchronize_srcu() to ensure any outstanding SRCU
critical sections have had the necessary grace period.

This flow ensures that accesses to ports via the adapter port list will
remain valid until both the SRCU critical sections have ended and all the
references to the ports have been dropped. Strictly speaking, SRCU alone
might be sufficient for existing code paths, but the reference count allows
the option for passing a pointer to the port on to other functions if
necessary in the future.

Fixes: e800654e85b5 ("ice: Use ice_adapter for PTP shared data instead of auxdev")
Reviewed-by: Maciek Machnikowski <maciej.machnikowski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20261027-reduction-v1-1-81237c67a361@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Dropped the cpi_phy_lock init/destroy context, used kzalloc(sizeof(*adapter), GFP_KERNEL) instead of kzalloc_obj(), and omitted the mutex.h include context line. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_adapter.c |  17 ++-
 drivers/net/ethernet/intel/ice/ice_adapter.h |  17 ++-
 drivers/net/ethernet/intel/ice/ice_ptp.c     | 125 ++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_ptp.h     |   4 +
 4 files changed, 121 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adapter.c b/drivers/net/ethernet/intel/ice/ice_adapter.c
index 0a8a48cd4bce6..8d0a4f6653cf0 100644
--- a/drivers/net/ethernet/intel/ice/ice_adapter.c
+++ b/drivers/net/ethernet/intel/ice/ice_adapter.c
@@ -6,6 +6,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/srcu.h>
 #include <linux/xarray.h>
 #include "ice_adapter.h"
 #include "ice.h"
@@ -54,26 +55,34 @@ static unsigned long ice_adapter_xa_index(struct pci_dev *pdev)
 static struct ice_adapter *ice_adapter_new(struct pci_dev *pdev)
 {
 	struct ice_adapter *adapter;
+	int err;
 
 	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
 	if (!adapter)
 		return NULL;
 
+	err = init_srcu_struct(&adapter->ports.srcu);
+	if (err) {
+		kfree(adapter);
+		return NULL;
+	}
+
 	adapter->index = ice_adapter_index(pdev);
 	spin_lock_init(&adapter->ptp_gltsyn_time_lock);
 	spin_lock_init(&adapter->txq_ctx_lock);
 	refcount_set(&adapter->refcount, 1);
 
-	mutex_init(&adapter->ports.lock);
-	INIT_LIST_HEAD(&adapter->ports.ports);
+	spin_lock_init(&adapter->ports.lock);
+	INIT_LIST_HEAD(&adapter->ports.list);
 
 	return adapter;
 }
 
 static void ice_adapter_free(struct ice_adapter *adapter)
 {
-	WARN_ON(!list_empty(&adapter->ports.ports));
-	mutex_destroy(&adapter->ports.lock);
+	WARN_ON(!list_empty(&adapter->ports.list));
+
+	cleanup_srcu_struct(&adapter->ports.srcu);
 
 	kfree(adapter);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_adapter.h b/drivers/net/ethernet/intel/ice/ice_adapter.h
index e95266c7f20bd..636ee05f110af 100644
--- a/drivers/net/ethernet/intel/ice/ice_adapter.h
+++ b/drivers/net/ethernet/intel/ice/ice_adapter.h
@@ -5,6 +5,7 @@
 #define _ICE_ADAPTER_H_
 
 #include <linux/types.h>
+#include <linux/srcu.h>
 #include <linux/spinlock_types.h>
 #include <linux/refcount_types.h>
 
@@ -14,15 +15,19 @@ struct ice_pf;
 /**
  * struct ice_port_list - data used to store the list of adapter ports
  *
- * This structure contains data used to maintain a list of adapter ports
+ * This structure contains data used to maintain a list of adapter ports.
+ * Writers modifying the list *must* acquire the lock, and use SRCU safe list
+ * operations. Readers should use srcu_read_lock() on the provided domain.
  *
- * @ports: list of ports
- * @lock: protect access to the ports list
+ * @list: list of ports
+ * @lock: protect write access to the list
+ * @srcu: Sleepable RCU domain for this adapter
  */
 struct ice_port_list {
-	struct list_head ports;
-	/* To synchronize the ports list operations */
-	struct mutex lock;
+	struct list_head list;
+	/* To synchronize write operations on the port list */
+	spinlock_t lock;
+	struct srcu_struct srcu;
 };
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index d33cd5f5f21c3..09e9550096a09 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1,6 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (C) 2021, Intel Corporation. */
 
+#include <linux/rculist.h>
+#include <linux/srcu.h>
+#include <linux/wait_bit.h>
 #include "ice.h"
 #include "ice_lib.h"
 #include "ice_trace.h"
@@ -674,20 +677,37 @@ static void ice_ptp_process_tx_tstamp(struct ice_ptp_tx *tx)
 	}
 }
 
+static void ice_ptp_release_port_srcu(struct kref *ref)
+{
+	/* wake_up_var() requires full ordering but kref_put only provides
+	 * release ordering.
+	 */
+	smp_mb__after_atomic();
+	wake_up_var(ref);
+}
+
 static void ice_ptp_tx_tstamp_owner(struct ice_pf *pf)
 {
+	struct ice_port_list *ports = &pf->adapter->ports;
 	struct ice_ptp_port *port;
+	int srcu_idx;
 
-	mutex_lock(&pf->adapter->ports.lock);
-	list_for_each_entry(port, &pf->adapter->ports.ports, list_node) {
+	srcu_idx = srcu_read_lock(&ports->srcu);
+	list_for_each_entry_srcu(port, &ports->list, list_node,
+				 srcu_read_lock_held(&ports->srcu)) {
 		struct ice_ptp_tx *tx = &port->tx;
 
-		if (!tx || !tx->init)
+		if (!tx->init)
+			continue;
+
+		if (!kref_get_unless_zero(&port->ref))
 			continue;
 
 		ice_ptp_process_tx_tstamp(tx);
+
+		kref_put(&port->ref, ice_ptp_release_port_srcu);
 	}
-	mutex_unlock(&pf->adapter->ports.lock);
+	srcu_read_unlock(&ports->srcu, srcu_idx);
 }
 
 /**
@@ -807,10 +827,19 @@ ice_ptp_mark_tx_tracker_stale(struct ice_ptp_tx *tx)
 static void
 ice_ptp_flush_all_tx_tracker(struct ice_pf *pf)
 {
+	struct ice_port_list *ports = &pf->adapter->ports;
 	struct ice_ptp_port *port;
+	int srcu_idx;
 
-	list_for_each_entry(port, &pf->adapter->ports.ports, list_node)
+	srcu_idx = srcu_read_lock(&ports->srcu);
+	list_for_each_entry_srcu(port, &ports->list, list_node,
+				 srcu_read_lock_held(&ports->srcu)) {
+		if (!kref_get_unless_zero(&port->ref))
+			continue;
 		ice_ptp_flush_tx_tracker(ptp_port_to_pf(port), &port->tx);
+		kref_put(&port->ref, ice_ptp_release_port_srcu);
+	}
+	srcu_read_unlock(&ports->srcu, srcu_idx);
 }
 
 /**
@@ -1403,16 +1432,22 @@ static void ice_ptp_reset_phy_timestamping(struct ice_pf *pf)
  */
 static void ice_ptp_restart_all_phy(struct ice_pf *pf)
 {
-	struct list_head *entry;
+	struct ice_port_list *ports = &pf->adapter->ports;
+	struct ice_ptp_port *port;
+	int srcu_idx;
 
-	list_for_each(entry, &pf->adapter->ports.ports) {
-		struct ice_ptp_port *port = list_entry(entry,
-						       struct ice_ptp_port,
-						       list_node);
+	srcu_idx = srcu_read_lock(&ports->srcu);
+	list_for_each_entry_srcu(port, &ports->list, list_node,
+				 srcu_read_lock_held(&ports->srcu)) {
+		if (!kref_get_unless_zero(&port->ref))
+			continue;
 
 		if (port->link_up)
 			ice_ptp_port_phy_restart(port);
+
+		kref_put(&port->ref, ice_ptp_release_port_srcu);
 	}
+	srcu_read_unlock(&ports->srcu, srcu_idx);
 }
 
 /**
@@ -2672,19 +2707,28 @@ static bool ice_port_has_timestamps(struct ice_ptp_tx *tx)
 
 static bool ice_any_port_has_timestamps(struct ice_pf *pf)
 {
+	struct ice_port_list *ports = &pf->adapter->ports;
+	bool have_tstamps = false;
 	struct ice_ptp_port *port;
+	int srcu_idx;
 
-	scoped_guard(mutex, &pf->adapter->ports.lock) {
-		list_for_each_entry(port, &pf->adapter->ports.ports,
-				    list_node) {
-			struct ice_ptp_tx *tx = &port->tx;
+	srcu_idx = srcu_read_lock(&ports->srcu);
+	list_for_each_entry_srcu(port, &ports->list, list_node,
+				 srcu_read_lock_held(&ports->srcu)) {
+		if (!kref_get_unless_zero(&port->ref))
+			continue;
 
-			if (ice_port_has_timestamps(tx))
-				return true;
-		}
+		if (ice_port_has_timestamps(&port->tx))
+			have_tstamps = true;
+
+		kref_put(&port->ref, ice_ptp_release_port_srcu);
+
+		if (have_tstamps)
+			break;
 	}
+	srcu_read_unlock(&ports->srcu, srcu_idx);
 
-	return false;
+	return have_tstamps;
 }
 
 bool ice_ptp_tx_tstamps_pending(struct ice_pf *pf)
@@ -2868,14 +2912,18 @@ void ice_ptp_queue_work(struct ice_pf *pf)
 static void ice_ptp_prepare_rebuild_sec(struct ice_pf *pf, bool rebuild,
 					enum ice_reset_req reset_type)
 {
-	struct list_head *entry;
+	struct ice_port_list *ports = &pf->adapter->ports;
+	struct ice_ptp_port *port;
+	int srcu_idx;
 
-	list_for_each(entry, &pf->adapter->ports.ports) {
-		struct ice_ptp_port *port = list_entry(entry,
-						       struct ice_ptp_port,
-						       list_node);
+	srcu_idx = srcu_read_lock(&ports->srcu);
+	list_for_each_entry_srcu(port, &ports->list, list_node,
+				 srcu_read_lock_held(&ports->srcu)) {
 		struct ice_pf *peer_pf = ptp_port_to_pf(port);
 
+		if (!kref_get_unless_zero(&port->ref))
+			continue;
+
 		if (!ice_is_primary(&peer_pf->hw)) {
 			if (rebuild) {
 				/* TODO: When implementing rebuild=true:
@@ -2887,7 +2935,10 @@ static void ice_ptp_prepare_rebuild_sec(struct ice_pf *pf, bool rebuild,
 				ice_ptp_prepare_for_reset(peer_pf, reset_type);
 			}
 		}
+
+		kref_put(&port->ref, ice_ptp_release_port_srcu);
 	}
+	srcu_read_unlock(&ports->srcu, srcu_idx);
 }
 
 /**
@@ -3069,24 +3120,34 @@ static int ice_ptp_setup_pf(struct ice_pf *pf)
 		return -ENODEV;
 
 	INIT_LIST_HEAD(&ptp->port.list_node);
-	mutex_lock(&pf->adapter->ports.lock);
+	kref_init(&ptp->port.ref);
 
-	list_add(&ptp->port.list_node,
-		 &pf->adapter->ports.ports);
-	mutex_unlock(&pf->adapter->ports.lock);
+	spin_lock(&pf->adapter->ports.lock);
+	list_add_rcu(&ptp->port.list_node, &pf->adapter->ports.list);
+	spin_unlock(&pf->adapter->ports.lock);
 
 	return 0;
 }
 
 static void ice_ptp_cleanup_pf(struct ice_pf *pf)
 {
+	struct ice_port_list *ports = &pf->adapter->ports;
 	struct ice_ptp *ptp = &pf->ptp;
+	struct kref *ref;
 
-	if (pf->hw.mac_type != ICE_MAC_UNKNOWN) {
-		mutex_lock(&pf->adapter->ports.lock);
-		list_del(&ptp->port.list_node);
-		mutex_unlock(&pf->adapter->ports.lock);
-	}
+	if (pf->hw.mac_type == ICE_MAC_UNKNOWN)
+		return;
+
+	spin_lock(&ports->lock);
+	list_del_rcu(&ptp->port.list_node);
+	spin_unlock(&ports->lock);
+
+	ref = &ptp->port.ref;
+	kref_put(ref, ice_ptp_release_port_srcu);
+
+	wait_var_event(ref, !kref_read(ref));
+
+	synchronize_srcu(&ports->srcu);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 0a5a1db66d614..1a1ea1891245b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -5,6 +5,8 @@
 #define _ICE_PTP_H_
 
 #include <linux/ptp_clock_kernel.h>
+#include <linux/rculist.h>
+#include <linux/kref.h>
 #include <linux/kthread.h>
 
 #include "ice_ptp_hw.h"
@@ -138,6 +140,7 @@ struct ice_ptp_tx {
  * and determine when the port's PHY offset is valid.
  *
  * @list_node: list member structure
+ * @ref: reference counter for use with adapter ports list
  * @tx: Tx timestamp tracking for this port
  * @ov_work: delayed work task for tracking when PHY offset is valid
  * @ps_lock: mutex used to protect the overall PTP PHY start procedure
@@ -147,6 +150,7 @@ struct ice_ptp_tx {
  */
 struct ice_ptp_port {
 	struct list_head list_node;
+	struct kref ref;
 	struct ice_ptp_tx tx;
 	struct kthread_delayed_work ov_work;
 	struct mutex ps_lock; /* protects overall PTP PHY start procedure */
-- 
2.53.0



