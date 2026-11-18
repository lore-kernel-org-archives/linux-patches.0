Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027842;
	b=lI/5u9weRbUkOQbYdFULTokd9nPYuKy+/QH2k+oqk9b0T7FtYlIbtJnA97epzs9YRDbq
	 D8GXENN1pZwtAL2z0ZgEBLDHEkcHVu/WIKq65RteYhO+aISgWPLQ87cvlglT+Me8qQdMc
	 eopqWS/KqyWq+dy831sRvOPG71mBwubVtuFmD5Wh43uV0Be9VWGbp5QNu76WugCdOf+OU
	 l2bc8vqv0dSpu2Y47WgWXnblOz2BIGYR5BTPjCaoYjVy7RDHb4jGzn8PsE5CW1igAMjy0
	 HAoElS/R55VPlgZk9MnOwPqwOwfI4Xon0yUcn1lWrkOk9ic4XWYcl+7SWmyvrfqxlwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LgA8Jui4K+phQuajhIsQypguHz9rBxrAGmgja9c+JG8=;
	b=cKun3qnssdxyU5SmPpk4DjpadSSTaRn5f12XlaZiWrPYvZ5mhRN025D/mAIFs2XCq2JD
	 WPfzjP+OGZiUTFC3tnoWH0EnewCYpjzXK4ThH6Jgr7kuDIJkmjuUTRi/v+uDohyhD0l9Z
	 OzXa0zb03DMwm4Bwffq8RUvC+XZGbZIUAt01h1Fb17152OTGBaAW4SB8ykBEwSd20N7ph
	 l4x2KuNmaeJhe5v4IwG/AtSAChMXkWvS3DexObJatdUvy96GzD9ROkOyDkWiMiLEksJCy
	 gkuJTjagIZuVgIYoaTx62ogUtwXyxJjIeZtBG9wApqnq/83iuCSoQdpbCACFvpp9liw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bli+4m2q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4583606A325;
	Wed, 18 Nov 2026 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bli+4m2q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036511F000C4;
	Wed, 18 Nov 2026 18:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027842;
	bh=LgA8Jui4K+phQuajhIsQypguHz9rBxrAGmgja9c+JG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bli+4m2qOpxu5D1DukUdXmKJGWRyCBQglLE/yjwmDqKJjScotMwOeALiuNCLG96Nb
	 YIL8YugTF6I3AK12gmKDAIZK7EONLzyoRGDGhgg3xyJuus3EZTUcpLZx0S9MmXzUnd
	 It3QoTE1Ho9qK8zB070CWCWRzhu0Kjvmuh6/4b2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1933/2151] scsi: elx: libefc: Fix resource leak in efcport_init() error path
Date: Wed, 18 Nov 2026 16:01:08 +0100
Message-ID: <20261118150232.192388313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit b4bd078b78c248d4263a1da7033cbe7a74ce0e12 ]

efcport_init() creates efc->node_pool and efc->node_dma_pool before
allocating efc->els_io_pool. When the latter allocation fails it returns
-ENOMEM without releasing the node dma pool or the node pool, leaking
both. The caller efct_efclib_config() only logs the error and
efct_device_attach() failure path never calls efcport_destroy(), so the
resources are never freed.

Destroy node_dma_pool and node_pool before returning from the
els_io_pool allocation failure path.

Fixes: d7b71fd2195e ("scsi: elx: libefc: Emulex FC discovery library APIs and definitions")
Assisted-by: DeepSeek-V4.1-Flash
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Link: https://patch.msgid.link/20261008185403.2791781-1-vulab@iscas.ac.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/libefc/efclib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/elx/libefc/efclib.c b/drivers/scsi/elx/libefc/efclib.c
index dd3e3d0a47614..ceec0e2a0266a 100644
--- a/drivers/scsi/elx/libefc/efclib.c
+++ b/drivers/scsi/elx/libefc/efclib.c
@@ -50,6 +50,8 @@ int efcport_init(struct efc *efc)
 						sizeof(struct efc_els_io_req));
 	if (!efc->els_io_pool) {
 		efc_log_err(efc, "Can't allocate els io pool\n");
+		dma_pool_destroy(efc->node_dma_pool);
+		mempool_destroy(efc->node_pool);
 		return -ENOMEM;
 	}
 
-- 
2.53.0



