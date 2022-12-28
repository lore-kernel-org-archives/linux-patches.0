Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFCF1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDAEC433F1;
	Wed, 28 Dec 2022 16:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244000;
	bh=I21Uviczf09RqOMqnp8NxnQrbMRK7oSdOiegTRbWpr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fqvyXvvXYupl/Tsnq4DdgoyAcQyb8kuutpneLr5vHveieF70WY6OIXNFrpBvZKSh
	 c7C519nNprp2jmQ0Oqsr/YexAGyhCc4ulYVDvWViiJWHyqn3BGFSuMNyMhqPYn6wW2
	 bYHFSkkJIKf6X4wDrgrsWKPOFn0Np+zl/2zhP6Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhan <zhanjie9@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0629/1073] scsi: libsas: Add smp_ata_check_ready_type()
Date: Wed, 28 Dec 2022 15:36:57 +0100
Message-Id: <20221228144345.126197151@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jie Zhan <zhanjie9@hisilicon.com>

[ Upstream commit 9181ce3cb5d96f0ee28246a857ca651830fa3746 ]

Create function smp_ata_check_ready_type() for LLDDs to wait for SATA
devices to come up after a link reset.

Signed-off-by: Jie Zhan <zhanjie9@hisilicon.com>
Link: https://lore.kernel.org/r/20221118083714.4034612-4-zhanjie9@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 3c2673a09cf1 ("scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_ata.c      | 25 +++++++++++++++++++++++++
 drivers/scsi/libsas/sas_expander.c |  4 ++--
 drivers/scsi/libsas/sas_internal.h |  2 ++
 include/scsi/sas_ata.h             |  6 ++++++
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index d35c9296f738..2fd55ef9ffca 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -287,6 +287,31 @@ static int sas_ata_clear_pending(struct domain_device *dev, struct ex_phy *phy)
 		return 1;
 }
 
+int smp_ata_check_ready_type(struct ata_link *link)
+{
+	struct domain_device *dev = link->ap->private_data;
+	struct sas_phy *phy = sas_get_local_phy(dev);
+	struct domain_device *ex_dev = dev->parent;
+	enum sas_device_type type = SAS_PHY_UNUSED;
+	u8 sas_addr[SAS_ADDR_SIZE];
+	int res;
+
+	res = sas_get_phy_attached_dev(ex_dev, phy->number, sas_addr, &type);
+	sas_put_local_phy(phy);
+	if (res)
+		return res;
+
+	switch (type) {
+	case SAS_SATA_PENDING:
+		return 0;
+	case SAS_END_DEVICE:
+		return 1;
+	default:
+		return -ENODEV;
+	}
+}
+EXPORT_SYMBOL_GPL(smp_ata_check_ready_type);
+
 static int smp_ata_check_ready(struct ata_link *link)
 {
 	int res;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 5ce251830104..63a23251fb1d 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1693,8 +1693,8 @@ static int sas_get_phy_change_count(struct domain_device *dev,
 	return res;
 }
 
-static int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
-				    u8 *sas_addr, enum sas_device_type *type)
+int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
+			     u8 *sas_addr, enum sas_device_type *type)
 {
 	int res;
 	struct smp_disc_resp *disc_resp;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 8d0ad3abc7b5..a94bd0790b05 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -84,6 +84,8 @@ struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
 int sas_ex_phy_discover(struct domain_device *dev, int single);
 int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
 			    struct smp_rps_resp *rps_resp);
+int sas_get_phy_attached_dev(struct domain_device *dev, int phy_id,
+			     u8 *sas_addr, enum sas_device_type *type);
 int sas_try_ata_reset(struct asd_sas_phy *phy);
 void sas_hae_reset(struct work_struct *work);
 
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index a1df4f9d57a3..ec646217e7f6 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -35,6 +35,7 @@ void sas_ata_end_eh(struct ata_port *ap);
 int sas_execute_ata_cmd(struct domain_device *device, u8 *fis,
 			int force_phy_id);
 int sas_ata_wait_after_reset(struct domain_device *dev, unsigned long deadline);
+int smp_ata_check_ready_type(struct ata_link *link);
 #else
 
 
@@ -98,6 +99,11 @@ static inline int sas_ata_wait_after_reset(struct domain_device *dev,
 {
 	return -ETIMEDOUT;
 }
+
+static inline int smp_ata_check_ready_type(struct ata_link *link)
+{
+	return 0;
+}
 #endif
 
 #endif /* _SAS_ATA_H_ */
-- 
2.35.1



