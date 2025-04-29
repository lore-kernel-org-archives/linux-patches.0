Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E8721ABDB;
	Tue, 29 Apr 2025 17:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947597; cv=none; b=BjYZuDXNaNaPYbtGsadZPZZRrpxYrSsBkEVjItd6niFZFnxxzw2m531mN/cuhMr/LThHvnFqL6wvK5uJd+EhFUAn/2oRCy9ZoIVYHlTqctDnyCaI1ueKrkNWXODESNAgwuq/067K8oWxMdCJ7cVGg8vqyX26Vjo2fdS5eVQJ1+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947597; c=relaxed/simple;
	bh=BI8yXTBQjfsvl5l13gfn1KHosr04KCohhRvF4IlavVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeppqTwMnjMhOHoKWUuzzdOoP6FC6DagY7NxqN9czlc6pbF6m7o7Iu7xJYL99kSQUZdpwOSy+KUhokCOPQaLnOseiSQrNr/Mi6zOJJTJp1vaxWbWqiDNB9OdPYyDlHuUhwcV+EApBQvBN+pEFvuykK0LgaEXljicGDFjbX0DueI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0CItugk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0CItugk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5012C4CEE3;
	Tue, 29 Apr 2025 17:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947597;
	bh=BI8yXTBQjfsvl5l13gfn1KHosr04KCohhRvF4IlavVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0CItugk22JVbmaWhkmJh4tbREXUwX84lvVTCx1gIpxSGE5MpCXDtbUgCf0A8tio3
	 PQMKX9BblNF45pLmi5hl9YKMbLfogHw7n5got4lDpNQUAJtOAR2ari7ZPPtiZKxcER
	 Zd2FapICwimgrC2PKDAm0oTyCf7lIdkefrucZW/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/280] ksmbd: browse interfaces list on FSCTL_QUERY_INTERFACE_INFO IOCTL
Date: Tue, 29 Apr 2025 18:39:39 +0200
Message-ID: <20250429161116.681624679@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit b2d99376c5d61eb60ffdb6c503e4b6c8f9712ddd ]

ksmbd.mount will give each interfaces list and bind_interfaces_only flags
to ksmbd server. Previously, the interfaces list was sent only
when bind_interfaces_only was enabled.
ksmbd server browse only interfaces list given from ksmbd.conf on
FSCTL_QUERY_INTERFACE_INFO IOCTL.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 21a4e47578d4 ("ksmbd: fix use-after-free in __smb2_lease_break_noti()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/ksmbd_netlink.h |  3 +-
 fs/smb/server/server.h        |  1 +
 fs/smb/server/smb2pdu.c       |  4 ++
 fs/smb/server/transport_ipc.c |  1 +
 fs/smb/server/transport_tcp.c | 73 +++++++++++++++--------------------
 fs/smb/server/transport_tcp.h |  1 +
 6 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index 3d01d9d152934..3f07a612c05b4 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -111,7 +111,8 @@ struct ksmbd_startup_request {
 	__u32	smb2_max_credits;	/* MAX credits */
 	__u32	smbd_max_io_size;	/* smbd read write size */
 	__u32	max_connections;	/* Number of maximum simultaneous connections */
-	__u32	reserved[126];		/* Reserved room */
+	__s8	bind_interfaces_only;
+	__s8	reserved[503];		/* Reserved room */
 	__u32	ifc_list_sz;		/* interfaces list size */
 	__s8	____payload[];
 };
diff --git a/fs/smb/server/server.h b/fs/smb/server/server.h
index 94187628ff089..995555febe7d1 100644
--- a/fs/smb/server/server.h
+++ b/fs/smb/server/server.h
@@ -46,6 +46,7 @@ struct ksmbd_server_config {
 
 	char			*conf[SERVER_CONF_WORK_GROUP + 1];
 	struct task_struct	*dh_task;
+	bool			bind_interfaces_only;
 };
 
 extern struct ksmbd_server_config server_conf;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index dfae37951312f..6b9286c963439 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -38,6 +38,7 @@
 #include "mgmt/user_session.h"
 #include "mgmt/ksmbd_ida.h"
 #include "ndr.h"
+#include "transport_tcp.h"
 
 static void __wbuf(struct ksmbd_work *work, void **req, void **rsp)
 {
@@ -7771,6 +7772,9 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		if (netdev->type == ARPHRD_LOOPBACK)
 			continue;
 
+		if (!ksmbd_find_netdev_name_iface_list(netdev->name))
+			continue;
+
 		flags = dev_get_flags(netdev);
 		if (!(flags & IFF_RUNNING))
 			continue;
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 2e17164efc91a..2da2a5f6b983a 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -338,6 +338,7 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 	ret = ksmbd_set_netbios_name(req->netbios_name);
 	ret |= ksmbd_set_server_string(req->server_string);
 	ret |= ksmbd_set_work_group(req->work_group);
+	server_conf.bind_interfaces_only = req->bind_interfaces_only;
 	ret |= ksmbd_tcp_set_interfaces(KSMBD_STARTUP_CONFIG_INTERFACES(req),
 					req->ifc_list_sz);
 out:
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 0d9007285e30b..7f38a3c3f5bd6 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -504,32 +504,37 @@ static int create_socket(struct interface *iface)
 	return ret;
 }
 
+struct interface *ksmbd_find_netdev_name_iface_list(char *netdev_name)
+{
+	struct interface *iface;
+
+	list_for_each_entry(iface, &iface_list, entry)
+		if (!strcmp(iface->name, netdev_name))
+			return iface;
+	return NULL;
+}
+
 static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 			      void *ptr)
 {
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
 	struct interface *iface;
-	int ret, found = 0;
+	int ret;
 
 	switch (event) {
 	case NETDEV_UP:
 		if (netif_is_bridge_port(netdev))
 			return NOTIFY_OK;
 
-		list_for_each_entry(iface, &iface_list, entry) {
-			if (!strcmp(iface->name, netdev->name)) {
-				found = 1;
-				if (iface->state != IFACE_STATE_DOWN)
-					break;
-				ksmbd_debug(CONN, "netdev-up event: netdev(%s) is going up\n",
-					    iface->name);
-				ret = create_socket(iface);
-				if (ret)
-					return NOTIFY_OK;
-				break;
-			}
+		iface = ksmbd_find_netdev_name_iface_list(netdev->name);
+		if (iface && iface->state == IFACE_STATE_DOWN) {
+			ksmbd_debug(CONN, "netdev-up event: netdev(%s) is going up\n",
+					iface->name);
+			ret = create_socket(iface);
+			if (ret)
+				return NOTIFY_OK;
 		}
-		if (!found && bind_additional_ifaces) {
+		if (!iface && bind_additional_ifaces) {
 			iface = alloc_iface(kstrdup(netdev->name, KSMBD_DEFAULT_GFP));
 			if (!iface)
 				return NOTIFY_OK;
@@ -541,21 +546,19 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 		}
 		break;
 	case NETDEV_DOWN:
-		list_for_each_entry(iface, &iface_list, entry) {
-			if (!strcmp(iface->name, netdev->name) &&
-			    iface->state == IFACE_STATE_CONFIGURED) {
-				ksmbd_debug(CONN, "netdev-down event: netdev(%s) is going down\n",
-						iface->name);
-				tcp_stop_kthread(iface->ksmbd_kthread);
-				iface->ksmbd_kthread = NULL;
-				mutex_lock(&iface->sock_release_lock);
-				tcp_destroy_socket(iface->ksmbd_socket);
-				iface->ksmbd_socket = NULL;
-				mutex_unlock(&iface->sock_release_lock);
-
-				iface->state = IFACE_STATE_DOWN;
-				break;
-			}
+		iface = ksmbd_find_netdev_name_iface_list(netdev->name);
+		if (iface && iface->state == IFACE_STATE_CONFIGURED) {
+			ksmbd_debug(CONN, "netdev-down event: netdev(%s) is going down\n",
+					iface->name);
+			tcp_stop_kthread(iface->ksmbd_kthread);
+			iface->ksmbd_kthread = NULL;
+			mutex_lock(&iface->sock_release_lock);
+			tcp_destroy_socket(iface->ksmbd_socket);
+			iface->ksmbd_socket = NULL;
+			mutex_unlock(&iface->sock_release_lock);
+
+			iface->state = IFACE_STATE_DOWN;
+			break;
 		}
 		break;
 	}
@@ -624,18 +627,6 @@ int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz)
 	int sz = 0;
 
 	if (!ifc_list_sz) {
-		struct net_device *netdev;
-
-		rtnl_lock();
-		for_each_netdev(&init_net, netdev) {
-			if (netif_is_bridge_port(netdev))
-				continue;
-			if (!alloc_iface(kstrdup(netdev->name, KSMBD_DEFAULT_GFP))) {
-				rtnl_unlock();
-				return -ENOMEM;
-			}
-		}
-		rtnl_unlock();
 		bind_additional_ifaces = 1;
 		return 0;
 	}
diff --git a/fs/smb/server/transport_tcp.h b/fs/smb/server/transport_tcp.h
index e338bebe322f1..8c9aa624cfe3c 100644
--- a/fs/smb/server/transport_tcp.h
+++ b/fs/smb/server/transport_tcp.h
@@ -7,6 +7,7 @@
 #define __KSMBD_TRANSPORT_TCP_H__
 
 int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz);
+struct interface *ksmbd_find_netdev_name_iface_list(char *netdev_name);
 int ksmbd_tcp_init(void);
 void ksmbd_tcp_destroy(void);
 
-- 
2.39.5



