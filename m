Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7922346551;
	Wed, 20 Dec 2023 16:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0DxOLbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0196C433C7;
	Wed, 20 Dec 2023 16:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088670;
	bh=ZrUfw4z0hNKdkWe0c7qKf72vC+XwGrwgaBRM71rCtcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0DxOLbZIBkN05TqqkA5UbgcBp3InnU0fBM49vMgAwWOf2AW2byM7GPR9sy85UT7e
	 himnp+owW0XFGoWDm4SsVj+spPh/IKnAnmQtREfTUX1FeX6+jskXCwC+LysJ0caOOJ
	 ecDHbre5+NTb4t3bklk7fsjzmDlZOplIAwyNSLmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 016/159] ksmbd: register ksmbd ib client with ib_register_client()
Date: Wed, 20 Dec 2023 17:08:01 +0100
Message-ID: <20231220160932.035187019@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 31928a001bed0d9642711d2eba520fc46d41c376 ]

Register ksmbd ib client with ib_register_client() to find the rdma capable
network adapter. If ops.get_netdev(Chelsio NICs) is NULL, ksmbd will find
it using ib_device_get_by_netdev in old way.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |  107 +++++++++++++++++++++++++++++++++++++++++-----
 fs/ksmbd/transport_rdma.h |    2 
 2 files changed, 98 insertions(+), 11 deletions(-)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -79,6 +79,14 @@ static int smb_direct_max_read_write_siz
 
 static int smb_direct_max_outstanding_rw_ops = 8;
 
+static LIST_HEAD(smb_direct_device_list);
+static DEFINE_RWLOCK(smb_direct_device_lock);
+
+struct smb_direct_device {
+	struct ib_device	*ib_dev;
+	struct list_head	list;
+};
+
 static struct smb_direct_listener {
 	struct rdma_cm_id	*cm_id;
 } smb_direct_listener;
@@ -2013,12 +2021,61 @@ err:
 	return ret;
 }
 
+static int smb_direct_ib_client_add(struct ib_device *ib_dev)
+{
+	struct smb_direct_device *smb_dev;
+
+	if (!ib_dev->ops.get_netdev ||
+	    !rdma_frwr_is_supported(&ib_dev->attrs))
+		return 0;
+
+	smb_dev = kzalloc(sizeof(*smb_dev), GFP_KERNEL);
+	if (!smb_dev)
+		return -ENOMEM;
+	smb_dev->ib_dev = ib_dev;
+
+	write_lock(&smb_direct_device_lock);
+	list_add(&smb_dev->list, &smb_direct_device_list);
+	write_unlock(&smb_direct_device_lock);
+
+	ksmbd_debug(RDMA, "ib device added: name %s\n", ib_dev->name);
+	return 0;
+}
+
+static void smb_direct_ib_client_remove(struct ib_device *ib_dev,
+					void *client_data)
+{
+	struct smb_direct_device *smb_dev, *tmp;
+
+	write_lock(&smb_direct_device_lock);
+	list_for_each_entry_safe(smb_dev, tmp, &smb_direct_device_list, list) {
+		if (smb_dev->ib_dev == ib_dev) {
+			list_del(&smb_dev->list);
+			kfree(smb_dev);
+			break;
+		}
+	}
+	write_unlock(&smb_direct_device_lock);
+}
+
+static struct ib_client smb_direct_ib_client = {
+	.name	= "ksmbd_smb_direct_ib",
+	.add	= smb_direct_ib_client_add,
+	.remove	= smb_direct_ib_client_remove,
+};
+
 int ksmbd_rdma_init(void)
 {
 	int ret;
 
 	smb_direct_listener.cm_id = NULL;
 
+	ret = ib_register_client(&smb_direct_ib_client);
+	if (ret) {
+		pr_err("failed to ib_register_client\n");
+		return ret;
+	}
+
 	/* When a client is running out of send credits, the credits are
 	 * granted by the server's sending a packet using this queue.
 	 * This avoids the situation that a clients cannot send packets
@@ -2042,30 +2099,60 @@ int ksmbd_rdma_init(void)
 	return 0;
 }
 
-int ksmbd_rdma_destroy(void)
+void ksmbd_rdma_destroy(void)
 {
-	if (smb_direct_listener.cm_id)
-		rdma_destroy_id(smb_direct_listener.cm_id);
+	if (!smb_direct_listener.cm_id)
+		return;
+
+	ib_unregister_client(&smb_direct_ib_client);
+	rdma_destroy_id(smb_direct_listener.cm_id);
+
 	smb_direct_listener.cm_id = NULL;
 
 	if (smb_direct_wq) {
 		destroy_workqueue(smb_direct_wq);
 		smb_direct_wq = NULL;
 	}
-	return 0;
 }
 
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 {
-	struct ib_device *ibdev;
+	struct smb_direct_device *smb_dev;
+	int i;
 	bool rdma_capable = false;
 
-	ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
-	if (ibdev) {
-		if (rdma_frwr_is_supported(&ibdev->attrs))
-			rdma_capable = true;
-		ib_device_put(ibdev);
+	read_lock(&smb_direct_device_lock);
+	list_for_each_entry(smb_dev, &smb_direct_device_list, list) {
+		for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
+			struct net_device *ndev;
+
+			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
+							       i + 1);
+			if (!ndev)
+				continue;
+
+			if (ndev == netdev) {
+				dev_put(ndev);
+				rdma_capable = true;
+				goto out;
+			}
+			dev_put(ndev);
+		}
 	}
+out:
+	read_unlock(&smb_direct_device_lock);
+
+	if (rdma_capable == false) {
+		struct ib_device *ibdev;
+
+		ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
+		if (ibdev) {
+			if (rdma_frwr_is_supported(&ibdev->attrs))
+				rdma_capable = true;
+			ib_device_put(ibdev);
+		}
+	}
+
 	return rdma_capable;
 }
 
--- a/fs/ksmbd/transport_rdma.h
+++ b/fs/ksmbd/transport_rdma.h
@@ -56,7 +56,7 @@ struct smb_direct_data_transfer {
 
 #ifdef CONFIG_SMB_SERVER_SMBDIRECT
 int ksmbd_rdma_init(void);
-int ksmbd_rdma_destroy(void);
+void ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
 void init_smbd_max_io_size(unsigned int sz);
 #else


