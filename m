Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB212135C1;
	Thu, 12 Dec 2024 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017531; cv=none; b=P1Yc2zG0zvLE29QVHSCxXbI5tlYnOBBRKOeookC7SaWLV3+6XQ1ph6uuG7OpOhngOWk0vgt51TUdrWBCdGQcU2zcergjo/YKyP4hnOTrkOWxsoSxDjH0e9mE0bXxruRDfQsmsiVqL2QYKkx1lsqTDWm7tHfkO5R2o8UNLKyWuCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017531; c=relaxed/simple;
	bh=ElEtl9VBboOKTbqMwuf7AvF/AITELJUzmAxvwViySqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fge8xdihBw+Oq+r47wsL1klYXc1tVcfcAcSdusia9hH2Koktw0iq9Q/94DYrWQeGUcUYNer+kdBZ8EKvZ6/nOLTYXoetHG0NGSMPWGLzCn0c1C0msMnF4Higiv6fdDARxiE4VQ0F7llbYjwOcAeaNONgQtL/DTYINks8rO7YOgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8+YpQ/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8+YpQ/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D463FC4CECE;
	Thu, 12 Dec 2024 15:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017531;
	bh=ElEtl9VBboOKTbqMwuf7AvF/AITELJUzmAxvwViySqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8+YpQ/z4dp6xQDQ2SOaEb7/KE1TN+d+yHTd8bF3QT7oFgMEAaCM/1YCAYwzhpR0E
	 Wk3nWaHBRmWjb3X37bP/siaBLKUhABwVdWctUY75DhPq76xpReWx3Y5g3TW+riPaRx
	 wVNvSBcxS9VxlNGbKM6p2IOf41kt2LFmm8h89whE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Jan Karcher <jaka@linux.ibm.com>
Subject: [PATCH 6.6 040/356] net/smc: add operations to merge sndbuf with peer DMB
Date: Thu, 12 Dec 2024 15:55:59 +0100
Message-ID: <20241212144246.212617801@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 4398888268582cb51b69c6ee94f551bb8d37d12f ]

In some scenarios using Emulated-ISM device, sndbuf can share the same
physical memory region with peer DMB to avoid data copy from one side
to the other. In such case the sndbuf is only a descriptor that
describes the shared memory and does not actually occupy memory, it's
more like a ghost buffer.

      +----------+                     +----------+
      | socket A |                     | socket B |
      +----------+                     +----------+
            |                               |
       +--------+                       +--------+
       | sndbuf |                       |  DMB   |
       |  desc  |                       |  desc  |
       +--------+                       +--------+
            |                               |
            |                          +----v-----+
            +-------------------------->  memory  |
                                       +----------+

So here introduces three new SMC-D device operations to check if this
feature is supported by device, and to {attach|detach} ghost sndbuf to
peer DMB. For now only loopback-ism supports this.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-and-tested-by: Jan Karcher <jaka@linux.ibm.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 0541db8ee32c ("net/smc: initialize close_work early to avoid warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/smc.h |  3 +++
 net/smc/smc_ism.c | 40 ++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_ism.h |  4 ++++
 3 files changed, 47 insertions(+)

diff --git a/include/net/smc.h b/include/net/smc.h
index 9dfe57f3e4f0b..6fef76087b9ed 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -79,6 +79,9 @@ struct smcd_ops {
 	int (*reset_vlan_required)(struct smcd_dev *dev);
 	int (*signal_event)(struct smcd_dev *dev, struct smcd_gid *rgid,
 			    u32 trigger_irq, u32 event_code, u64 info);
+	int (*support_dmb_nocopy)(struct smcd_dev *dev);
+	int (*attach_dmb)(struct smcd_dev *dev, struct smcd_dmb *dmb);
+	int (*detach_dmb)(struct smcd_dev *dev, u64 token);
 };
 
 struct smcd_dev {
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 3623df320de55..61ffc72014013 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -228,6 +228,46 @@ int smc_ism_register_dmb(struct smc_link_group *lgr, int dmb_len,
 #endif
 }
 
+bool smc_ism_support_dmb_nocopy(struct smcd_dev *smcd)
+{
+	/* for now only loopback-ism supports
+	 * merging sndbuf with peer DMB to avoid
+	 * data copies between them.
+	 */
+	return (smcd->ops->support_dmb_nocopy &&
+		smcd->ops->support_dmb_nocopy(smcd));
+}
+
+int smc_ism_attach_dmb(struct smcd_dev *dev, u64 token,
+		       struct smc_buf_desc *dmb_desc)
+{
+	struct smcd_dmb dmb;
+	int rc = 0;
+
+	if (!dev->ops->attach_dmb)
+		return -EINVAL;
+
+	memset(&dmb, 0, sizeof(dmb));
+	dmb.dmb_tok = token;
+	rc = dev->ops->attach_dmb(dev, &dmb);
+	if (!rc) {
+		dmb_desc->sba_idx = dmb.sba_idx;
+		dmb_desc->token = dmb.dmb_tok;
+		dmb_desc->cpu_addr = dmb.cpu_addr;
+		dmb_desc->dma_addr = dmb.dma_addr;
+		dmb_desc->len = dmb.dmb_len;
+	}
+	return rc;
+}
+
+int smc_ism_detach_dmb(struct smcd_dev *dev, u64 token)
+{
+	if (!dev->ops->detach_dmb)
+		return -EINVAL;
+
+	return dev->ops->detach_dmb(dev, token);
+}
+
 static int smc_nl_handle_smcd_dev(struct smcd_dev *smcd,
 				  struct sk_buff *skb,
 				  struct netlink_callback *cb)
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index 0e5e563099ec3..8312c3586d2b3 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -41,6 +41,10 @@ int smc_ism_put_vlan(struct smcd_dev *dev, unsigned short vlan_id);
 int smc_ism_register_dmb(struct smc_link_group *lgr, int buf_size,
 			 struct smc_buf_desc *dmb_desc);
 int smc_ism_unregister_dmb(struct smcd_dev *dev, struct smc_buf_desc *dmb_desc);
+bool smc_ism_support_dmb_nocopy(struct smcd_dev *smcd);
+int smc_ism_attach_dmb(struct smcd_dev *dev, u64 token,
+		       struct smc_buf_desc *dmb_desc);
+int smc_ism_detach_dmb(struct smcd_dev *dev, u64 token);
 int smc_ism_signal_shutdown(struct smc_link_group *lgr);
 void smc_ism_get_system_eid(u8 **eid);
 u16 smc_ism_get_chid(struct smcd_dev *dev);
-- 
2.43.0



