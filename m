Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8222C3749;
	Mon, 27 Oct 2025 19:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592555; cv=none; b=ZDje1IxVvX2/BM5oAokbJLqt2ogtA605ztlFy57sKCJuEhH6+cR1vbeVgcwisWPj7y7RWPo+mtV3GeT87oRjGAaSuMbpCgkCOQigb1B6uaSZFEVOVCyF9eq97m65HtpJpwhGH24wSn9waNjmfjOFMOT3LQJKKMZmhMx0v9l/jNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592555; c=relaxed/simple;
	bh=SxdhGIxH+mLv2URbe75K7IYAr3eVVhlOhjf+2siayAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyIJKB9U+JGWPZif+UWZ7it9cveZMlQyGuk/f3LJE6FLZnrLO4v6QxMJ/WH0oXFCEtKMfgu1pkogC/inV9u5NmL9wsWoZ0qvc05YYg1GSUdiagPzOruBJm0O6mrBC6scHbiy5SLB+xr4J09knllPa7CtO8micayx50cYMuiwGDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNrScJYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNrScJYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D692FC4CEF1;
	Mon, 27 Oct 2025 19:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592555;
	bh=SxdhGIxH+mLv2URbe75K7IYAr3eVVhlOhjf+2siayAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNrScJYbvDDe/sr7ao4fGqWiJ61KM0NQPYKMR95HaULqkHsrev+3lXsxYf2R4jpqC
	 G/XzBl+0HEw79TSJaNTMP7pHramoOdjBqkRWiwrCoE+YfyDK5ZjpJwE1tTd/kMJYu4
	 0iR5G+bOGrvXOI17i8N0NXCP31f8KIFDcNaGvDvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 152/157] ksmbd: browse interfaces list on FSCTL_QUERY_INTERFACE_INFO IOCTL
Date: Mon, 27 Oct 2025 19:36:53 +0100
Message-ID: <20251027183505.373176519@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/ksmbd_netlink.h |    3 +
 fs/smb/server/server.h        |    1 
 fs/smb/server/smb2pdu.c       |    4 ++
 fs/smb/server/transport_ipc.c |    1 
 fs/smb/server/transport_tcp.c |   67 +++++++++++++++++++-----------------------
 fs/smb/server/transport_tcp.h |    1 
 6 files changed, 40 insertions(+), 37 deletions(-)

--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -107,8 +107,9 @@ struct ksmbd_startup_request {
 	__u32	smb2_max_credits;	/* MAX credits */
 	__u32	smbd_max_io_size;	/* smbd read write size */
 	__u32	max_connections;	/* Number of maximum simultaneous connections */
+	__s8	bind_interfaces_only;
 	__u32	max_ip_connections;	/* Number of maximum connection per ip address */
-	__u32	reserved[125];		/* Reserved room */
+	__s8	reserved[499];		/* Reserved room */
 	__u32	ifc_list_sz;		/* interfaces list size */
 	__s8	____payload[];
 } __packed;
--- a/fs/smb/server/server.h
+++ b/fs/smb/server/server.h
@@ -45,6 +45,7 @@ struct ksmbd_server_config {
 	unsigned int		max_ip_connections;
 
 	char			*conf[SERVER_CONF_WORK_GROUP + 1];
+	bool			bind_interfaces_only;
 };
 
 extern struct ksmbd_server_config server_conf;
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -37,6 +37,7 @@
 #include "mgmt/user_session.h"
 #include "mgmt/ksmbd_ida.h"
 #include "ndr.h"
+#include "transport_tcp.h"
 
 static void __wbuf(struct ksmbd_work *work, void **req, void **rsp)
 {
@@ -7423,6 +7424,9 @@ static int fsctl_query_iface_info_ioctl(
 		if (netdev->type == ARPHRD_LOOPBACK)
 			continue;
 
+		if (!ksmbd_find_netdev_name_iface_list(netdev->name))
+			continue;
+
 		flags = dev_get_flags(netdev);
 		if (!(flags & IFF_RUNNING))
 			continue;
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -324,6 +324,7 @@ static int ipc_server_config_on_startup(
 	ret = ksmbd_set_netbios_name(req->netbios_name);
 	ret |= ksmbd_set_server_string(req->server_string);
 	ret |= ksmbd_set_work_group(req->work_group);
+	server_conf.bind_interfaces_only = req->bind_interfaces_only;
 	ret |= ksmbd_tcp_set_interfaces(KSMBD_STARTUP_CONFIG_INTERFACES(req),
 					req->ifc_list_sz);
 out:
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -544,30 +544,37 @@ out_clear:
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
 			iface = alloc_iface(kstrdup(netdev->name, GFP_KERNEL));
 			if (!iface)
 				return NOTIFY_OK;
@@ -577,19 +584,19 @@ static int ksmbd_netdev_event(struct not
 		}
 		break;
 	case NETDEV_DOWN:
-		list_for_each_entry(iface, &iface_list, entry) {
-			if (!strcmp(iface->name, netdev->name) &&
-			    iface->state == IFACE_STATE_CONFIGURED) {
-				tcp_stop_kthread(iface->ksmbd_kthread);
-				iface->ksmbd_kthread = NULL;
-				mutex_lock(&iface->sock_release_lock);
-				tcp_destroy_socket(iface->ksmbd_socket);
-				iface->ksmbd_socket = NULL;
-				mutex_unlock(&iface->sock_release_lock);
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
 
-				iface->state = IFACE_STATE_DOWN;
-				break;
-			}
+			iface->state = IFACE_STATE_DOWN;
+			break;
 		}
 		break;
 	}
@@ -658,18 +665,6 @@ int ksmbd_tcp_set_interfaces(char *ifc_l
 	int sz = 0;
 
 	if (!ifc_list_sz) {
-		struct net_device *netdev;
-
-		rtnl_lock();
-		for_each_netdev(&init_net, netdev) {
-			if (netif_is_bridge_port(netdev))
-				continue;
-			if (!alloc_iface(kstrdup(netdev->name, GFP_KERNEL))) {
-				rtnl_unlock();
-				return -ENOMEM;
-			}
-		}
-		rtnl_unlock();
 		bind_additional_ifaces = 1;
 		return 0;
 	}
--- a/fs/smb/server/transport_tcp.h
+++ b/fs/smb/server/transport_tcp.h
@@ -7,6 +7,7 @@
 #define __KSMBD_TRANSPORT_TCP_H__
 
 int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz);
+struct interface *ksmbd_find_netdev_name_iface_list(char *netdev_name);
 int ksmbd_tcp_init(void);
 void ksmbd_tcp_destroy(void);
 


