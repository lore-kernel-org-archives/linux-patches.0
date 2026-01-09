Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A9515ADB4;
	Fri,  9 Jan 2026 12:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961328; cv=none; b=pp5YeNXgEvN1IOD6q37Mni/CQVhu6BypQ3FJCiMjzYKSZeFbsBlkDG/g+PB0ySAZuWsHnAPXX96EMxy788Sct1MXAcC7IRRv9NaGt29KG8aZ7hs7ZBq9u85Stsr4gQza5e0Ik8VHWjRN3x3L449N0MceCrIZYA0o98pNL88ZY28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961328; c=relaxed/simple;
	bh=eEnHAQ+ufIMDIm+e9JsdmWs/XdNUcogYo1WVXYvFsyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzff0V0SddhZup4xN1cLkNSMbTLMCGERynfTK859ODsJRVHJCMQtVhQg3PESBMGKFdXun6MqsMLpYwB5pSYK35oYbfHABMNP3cgj28dhL5JklzEVLaTgoMf9fKCoWCgLRC+WAPfcKscpQDYee2TEdYkh60YoyOGdSZQk3cC575k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4OuqVvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4OuqVvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D392C4CEF1;
	Fri,  9 Jan 2026 12:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961328;
	bh=eEnHAQ+ufIMDIm+e9JsdmWs/XdNUcogYo1WVXYvFsyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4OuqVvYJO5m/AFthDEnCDZNgiQCXcrJx30LzzeTXm2ZHDW/bf9GB4I/FQc/gQogy
	 0OeJjDOpB3j5lL7WwUFyhHqkRot2aDlfBpBH5GuZZ1k1Gibx6LzI1UD3qBJVIVByNC
	 Kw7qJWlBe85Vl7ZAxiDLKkB49U2JMOr72T/5nuto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 6.6 715/737] RDMA/rxe: Fix the failure of ibv_query_device() and ibv_query_device_ex() tests
Date: Fri,  9 Jan 2026 12:44:14 +0100
Message-ID: <20260109112200.979393823@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit 8ce2eb9dfac8743d1c423b86339336a5b6a6069e ]

In rdma-core, the following failures appear.

"
$ ./build/bin/run_tests.py -k device
ssssssss....FF........s
======================================================================
FAIL: test_query_device (tests.test_device.DeviceTest.test_query_device)
Test ibv_query_device()
----------------------------------------------------------------------
Traceback (most recent call last):
   File "/home/ubuntu/rdma-core/tests/test_device.py", line 63, in
   test_query_device
     self.verify_device_attr(attr, dev)
   File "/home/ubuntu/rdma-core/tests/test_device.py", line 200, in
   verify_device_attr
     assert attr.sys_image_guid != 0
            ^^^^^^^^^^^^^^^^^^^^^^^^
AssertionError

======================================================================
FAIL: test_query_device_ex (tests.test_device.DeviceTest.test_query_device_ex)
Test ibv_query_device_ex()
----------------------------------------------------------------------
Traceback (most recent call last):
   File "/home/ubuntu/rdma-core/tests/test_device.py", line 222, in
   test_query_device_ex
     self.verify_device_attr(attr_ex.orig_attr, dev)
   File "/home/ubuntu/rdma-core/tests/test_device.py", line 200, in
   verify_device_attr
     assert attr.sys_image_guid != 0
            ^^^^^^^^^^^^^^^^^^^^^^^^
AssertionError
"

The root cause is: before a net device is set with rxe, this net device
is used to generate a sys_image_guid.

Fixes: 2ac5415022d1 ("RDMA/rxe: Remove the direct link to net_device")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20250302215444.3742072-1-yanjun.zhu@linux.dev
Reviewed-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Tested-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Shivani: Modified to apply on 6.6.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rxe/rxe.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -38,10 +38,8 @@ void rxe_dealloc(struct ib_device *ib_de
 }
 
 /* initialize rxe device parameters */
-static void rxe_init_device_param(struct rxe_dev *rxe)
+static void rxe_init_device_param(struct rxe_dev *rxe, struct net_device *ndev)
 {
-	struct net_device *ndev;
-
 	rxe->max_inline_data			= RXE_MAX_INLINE_DATA;
 
 	rxe->attr.vendor_id			= RXE_VENDOR_ID;
@@ -74,15 +72,9 @@ static void rxe_init_device_param(struct
 	rxe->attr.max_pkeys			= RXE_MAX_PKEYS;
 	rxe->attr.local_ca_ack_delay		= RXE_LOCAL_CA_ACK_DELAY;
 
-	ndev = rxe_ib_device_get_netdev(&rxe->ib_dev);
-	if (!ndev)
-		return;
-
 	addrconf_addr_eui48((unsigned char *)&rxe->attr.sys_image_guid,
 			ndev->dev_addr);
 
-	dev_put(ndev);
-
 	rxe->max_ucontext			= RXE_MAX_UCONTEXT;
 }
 
@@ -115,18 +107,13 @@ static void rxe_init_port_param(struct r
 /* initialize port state, note IB convention that HCA ports are always
  * numbered from 1
  */
-static void rxe_init_ports(struct rxe_dev *rxe)
+static void rxe_init_ports(struct rxe_dev *rxe, struct net_device *ndev)
 {
 	struct rxe_port *port = &rxe->port;
-	struct net_device *ndev;
 
 	rxe_init_port_param(port);
-	ndev = rxe_ib_device_get_netdev(&rxe->ib_dev);
-	if (!ndev)
-		return;
 	addrconf_addr_eui48((unsigned char *)&port->port_guid,
 			    ndev->dev_addr);
-	dev_put(ndev);
 	spin_lock_init(&port->port_lock);
 }
 
@@ -144,12 +131,12 @@ static void rxe_init_pools(struct rxe_de
 }
 
 /* initialize rxe device state */
-static void rxe_init(struct rxe_dev *rxe)
+static void rxe_init(struct rxe_dev *rxe, struct net_device *ndev)
 {
 	/* init default device parameters */
-	rxe_init_device_param(rxe);
+	rxe_init_device_param(rxe, ndev);
 
-	rxe_init_ports(rxe);
+	rxe_init_ports(rxe, ndev);
 	rxe_init_pools(rxe);
 
 	/* init pending mmap list */
@@ -186,7 +173,7 @@ void rxe_set_mtu(struct rxe_dev *rxe, un
 int rxe_add(struct rxe_dev *rxe, unsigned int mtu, const char *ibdev_name,
 			struct net_device *ndev)
 {
-	rxe_init(rxe);
+	rxe_init(rxe, ndev);
 	rxe_set_mtu(rxe, mtu);
 
 	return rxe_register_device(rxe, ibdev_name, ndev);


