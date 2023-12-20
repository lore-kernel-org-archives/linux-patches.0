Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F250847A6C;
	Wed, 20 Dec 2023 16:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSQs4mud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75171C433C8;
	Wed, 20 Dec 2023 16:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088672;
	bh=hgw1+aZr44aT7ATLotmM49c00iA2+cu/XkrawjnHCf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSQs4mudDgViO2bSh+K5yIIxHUAwL9h43/QpMpj5xDiWWb2IIIPpJETJ+weKDCr2V
	 z/Bk7/Od8gHoH8Zt8fqNMuVexIzHj1qzNn4eY8ParywOf9ZtGgRsk5eUyS1Z7UsQBo
	 ggylUawM3EF1uCpFfxrHQip37OoZDLRl9lz6rPF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 017/159] ksmbd: set 445 port to smbdirect port by default
Date: Wed, 20 Dec 2023 17:08:02 +0100
Message-ID: <20231220160932.075691379@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit cb097b3dd5ece9596a0a0b7e33893c02a9bde8c6 ]

When SMB Direct is used with iWARP, Windows use 5445 port for smb direct
port, 445 port for SMB. This patch check ib_device using ib_client to
know if NICs type is iWARP or Infiniband.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |   15 ++++++++++++---
 fs/ksmbd/transport_rdma.h |    2 --
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -34,7 +34,8 @@
 #include "smbstatus.h"
 #include "transport_rdma.h"
 
-#define SMB_DIRECT_PORT	5445
+#define SMB_DIRECT_PORT_IWARP		5445
+#define SMB_DIRECT_PORT_INFINIBAND	445
 
 #define SMB_DIRECT_VERSION_LE		cpu_to_le16(0x0100)
 
@@ -60,6 +61,10 @@
  * as defined in [MS-SMBD] 3.1.1.1
  * Those may change after a SMB_DIRECT negotiation
  */
+
+/* Set 445 port to SMB Direct port by default */
+static int smb_direct_port = SMB_DIRECT_PORT_INFINIBAND;
+
 /* The local peer's maximum number of credits to grant to the peer */
 static int smb_direct_receive_credit_max = 255;
 
@@ -1948,7 +1953,7 @@ static int smb_direct_handle_connect_req
 
 	KSMBD_TRANS(t)->handler = kthread_run(ksmbd_conn_handler_loop,
 					      KSMBD_TRANS(t)->conn, "ksmbd:r%u",
-					      SMB_DIRECT_PORT);
+					      smb_direct_port);
 	if (IS_ERR(KSMBD_TRANS(t)->handler)) {
 		int ret = PTR_ERR(KSMBD_TRANS(t)->handler);
 
@@ -2025,6 +2030,10 @@ static int smb_direct_ib_client_add(stru
 {
 	struct smb_direct_device *smb_dev;
 
+	/* Set 5445 port if device type is iWARP(No IB) */
+	if (ib_dev->node_type != RDMA_NODE_IB_CA)
+		smb_direct_port = SMB_DIRECT_PORT_IWARP;
+
 	if (!ib_dev->ops.get_netdev ||
 	    !rdma_frwr_is_supported(&ib_dev->attrs))
 		return 0;
@@ -2086,7 +2095,7 @@ int ksmbd_rdma_init(void)
 	if (!smb_direct_wq)
 		return -ENOMEM;
 
-	ret = smb_direct_listen(SMB_DIRECT_PORT);
+	ret = smb_direct_listen(smb_direct_port);
 	if (ret) {
 		destroy_workqueue(smb_direct_wq);
 		smb_direct_wq = NULL;
--- a/fs/ksmbd/transport_rdma.h
+++ b/fs/ksmbd/transport_rdma.h
@@ -7,8 +7,6 @@
 #ifndef __KSMBD_TRANSPORT_RDMA_H__
 #define __KSMBD_TRANSPORT_RDMA_H__
 
-#define SMB_DIRECT_PORT	5445
-
 #define SMBD_DEFAULT_IOSIZE (8 * 1024 * 1024)
 #define SMBD_MIN_IOSIZE (512 * 1024)
 #define SMBD_MAX_IOSIZE (16 * 1024 * 1024)


