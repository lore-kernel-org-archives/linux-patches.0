Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18D81BD002;
	Tue,  2 Jul 2024 17:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940243; cv=none; b=srQTolbqZfsireQsjqFwAQbYkvB7KvKEbYBAXP6t1LPCvl5NJSwU75VIUlUfT7UvnSdOWnStP8SH85ZVAaQuLC1mSy/ImJCErSwOCHLYCWhYd+Wt3lFf2aCJOKhQiI5PLDjWCCWAAEsPsVvfvNh2EMz7SzSiQUmktt9l1jl4D0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940243; c=relaxed/simple;
	bh=/iQbMqtV2TvB7VupZf25/jpF/0fb4hHgqJ+yshi1sxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqHUhDl8WuUgWAWBX2DnLP4s7WtTSz4N9kELljLwYLhTVw8fWFU7EilbOzkWEKdQ7sJvj8NbGspVWugYktxn3YAYhaYIUylxx/Iu5Fdzg5c+toy/l5YTBRdrboP2E8M1ZCKidBbvnRitBwKb0HN+SOqlHHL+8WMtiNv9vbtX/ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ir2/b5hF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ir2/b5hF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE29EC116B1;
	Tue,  2 Jul 2024 17:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940243;
	bh=/iQbMqtV2TvB7VupZf25/jpF/0fb4hHgqJ+yshi1sxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ir2/b5hF3Hm0vsK7mfNwr4kOttGBChWzn+G9bNpAI1ydUoUjIhlVJ2hZXdELexjdY
	 HtOoGoyxDbpsD9BHcd3FdTVe6pZnx3guU3jpswGZcmc065McQmbFD251i+q+jygOqp
	 KvZmGng0KAplW0msjYuzoqaI8XhuvKB7Djxflrps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 096/222] nvmet: make tsas attribute idempotent for RDMA
Date: Tue,  2 Jul 2024 19:02:14 +0200
Message-ID: <20240702170247.640603234@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 0f1f5803920d2a6b88bee950914fd37421e17170 ]

The RDMA transport defines values for TSAS, but it cannot be changed as
we only support the 'connected' mode.
So to avoid errors during reconfiguration we should allow to write the
current value.

Fixes: 3f123494db72 ("nvmet: make TCP sectype settable via configfs")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 39 ++++++++++++++++++++++++++--------
 include/linux/nvme.h           |  2 ++
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index c9640e6d10cab..d80c3b93d6ce9 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -413,25 +413,46 @@ static ssize_t nvmet_addr_tsas_show(struct config_item *item,
 	return sprintf(page, "\n");
 }
 
+static u8 nvmet_addr_tsas_rdma_store(const char *page)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nvmet_addr_tsas_rdma); i++) {
+		if (sysfs_streq(page, nvmet_addr_tsas_rdma[i].name))
+			return nvmet_addr_tsas_rdma[i].type;
+	}
+	return NVMF_RDMA_QPTYPE_INVALID;
+}
+
+static u8 nvmet_addr_tsas_tcp_store(const char *page)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nvmet_addr_tsas_tcp); i++) {
+		if (sysfs_streq(page, nvmet_addr_tsas_tcp[i].name))
+			return nvmet_addr_tsas_tcp[i].type;
+	}
+	return NVMF_TCP_SECTYPE_INVALID;
+}
+
 static ssize_t nvmet_addr_tsas_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct nvmet_port *port = to_nvmet_port(item);
 	u8 treq = nvmet_port_disc_addr_treq_mask(port);
-	u8 sectype;
-	int i;
+	u8 sectype, qptype;
 
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (port->disc_addr.trtype != NVMF_TRTYPE_TCP)
-		return -EINVAL;
-
-	for (i = 0; i < ARRAY_SIZE(nvmet_addr_tsas_tcp); i++) {
-		if (sysfs_streq(page, nvmet_addr_tsas_tcp[i].name)) {
-			sectype = nvmet_addr_tsas_tcp[i].type;
+	if (port->disc_addr.trtype == NVMF_TRTYPE_RDMA) {
+		qptype = nvmet_addr_tsas_rdma_store(page);
+		if (qptype == port->disc_addr.tsas.rdma.qptype)
+			return count;
+	} else if (port->disc_addr.trtype == NVMF_TRTYPE_TCP) {
+		sectype = nvmet_addr_tsas_tcp_store(page);
+		if (sectype != NVMF_TCP_SECTYPE_INVALID)
 			goto found;
-		}
 	}
 
 	pr_err("Invalid value '%s' for tsas\n", page);
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 69ac2abf8acfe..c693ac344ec05 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -85,6 +85,7 @@ enum {
 enum {
 	NVMF_RDMA_QPTYPE_CONNECTED	= 1, /* Reliable Connected */
 	NVMF_RDMA_QPTYPE_DATAGRAM	= 2, /* Reliable Datagram */
+	NVMF_RDMA_QPTYPE_INVALID	= 0xff,
 };
 
 /* RDMA Provider Type codes for Discovery Log Page entry TSAS
@@ -110,6 +111,7 @@ enum {
 	NVMF_TCP_SECTYPE_NONE = 0, /* No Security */
 	NVMF_TCP_SECTYPE_TLS12 = 1, /* TLSv1.2, NVMe-oF 1.1 and NVMe-TCP 3.6.1.1 */
 	NVMF_TCP_SECTYPE_TLS13 = 2, /* TLSv1.3, NVMe-oF 1.1 and NVMe-TCP 3.6.1.1 */
+	NVMF_TCP_SECTYPE_INVALID = 0xff,
 };
 
 #define NVME_AQ_DEPTH		32
-- 
2.43.0



