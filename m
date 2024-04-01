Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936353F8F4;
	Mon,  1 Apr 2024 16:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987800; cv=none; b=sV1BxFbFvrkD1cukLjm5qLvT/iF4wi96N1TPK8dhHh8/4fKa+9ejSXHKuSmp1ubC9qkJnYcN2MMM/pAIovFxt9q2SnMWuYJtYuLdcFV2iIWIB8VhLyathAYaNmtS8o0JLOfEVNYr2tVIKLQs4TYga4xvbvShPGA1Y5TJ+lszjwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987800; c=relaxed/simple;
	bh=OztKi9wCvkndfbtySX73EaSHzaX8A/jXYjYuBCursAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcKO3+XxBJExBbLsKlyCOhPsbWwRbkRT8t9xXgsuwOZMvz+wtqF2KbyitefRBoVPK4GKio+jon8zf+ZBOETpXOeOzs10HWVy1W2l8iIhj0vdz8Nv2nDttpIKQaJBi5efxR7TQHxyOCkHjpaJIcbipLRV85WLW1ZBds2n3ep6N3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wZICVux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wZICVux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99437C433C7;
	Mon,  1 Apr 2024 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987800;
	bh=OztKi9wCvkndfbtySX73EaSHzaX8A/jXYjYuBCursAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wZICVuxgl6/0FekhSxbiqPXAmr0XFM3i2SozjJ7KEzExlBpTcsckzJKWo7f8bqpS
	 L94i0wksAv9sjRolLyM1lafExAYjRwvxJffdhOFth+bm35eOYHs8076xnMwJ6L6kNW
	 pu22i0/obPxpYVC49zpg87zDdGa9cgf7mn85DVrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.8 396/399] scsi: libsas: Fix disk not being scanned in after being removed
Date: Mon,  1 Apr 2024 17:46:02 +0200
Message-ID: <20240401152600.998640232@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

commit 8e68a458bcf5b5cb9c3624598bae28f08251601f upstream.

As of commit d8649fc1c5e4 ("scsi: libsas: Do discovery on empty PHY to
update PHY info"), do discovery will send a new SMP_DISCOVER and update
phy->phy_change_count. We found that if the disk is reconnected and phy
change_count changes at this time, the disk scanning process will not be
triggered.

Therefore, call sas_set_ex_phy() to update the PHY info with the results of
the last query. And because the previous phy info will be used when calling
sas_unregister_devs_sas_addr(), sas_unregister_devs_sas_addr() should be
called before sas_set_ex_phy().

Fixes: d8649fc1c5e4 ("scsi: libsas: Do discovery on empty PHY to update PHY info")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://lore.kernel.org/r/20240307141413.48049-3-yangxingui@huawei.com
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libsas/sas_expander.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1945,6 +1945,7 @@ static int sas_rediscover_dev(struct dom
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
 	enum sas_device_type type = SAS_PHY_UNUSED;
+	struct smp_disc_resp *disc_resp;
 	u8 sas_addr[SAS_ADDR_SIZE];
 	char msg[80] = "";
 	int res;
@@ -1956,33 +1957,41 @@ static int sas_rediscover_dev(struct dom
 		 SAS_ADDR(dev->sas_addr), phy_id, msg);
 
 	memset(sas_addr, 0, SAS_ADDR_SIZE);
-	res = sas_get_phy_attached_dev(dev, phy_id, sas_addr, &type);
+	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
+	if (!disc_resp)
+		return -ENOMEM;
+
+	res = sas_get_phy_discover(dev, phy_id, disc_resp);
 	switch (res) {
 	case SMP_RESP_NO_PHY:
 		phy->phy_state = PHY_NOT_PRESENT;
 		sas_unregister_devs_sas_addr(dev, phy_id, last);
-		return res;
+		goto out_free_resp;
 	case SMP_RESP_PHY_VACANT:
 		phy->phy_state = PHY_VACANT;
 		sas_unregister_devs_sas_addr(dev, phy_id, last);
-		return res;
+		goto out_free_resp;
 	case SMP_RESP_FUNC_ACC:
 		break;
 	case -ECOMM:
 		break;
 	default:
-		return res;
+		goto out_free_resp;
 	}
 
+	if (res == 0)
+		sas_get_sas_addr_and_dev_type(disc_resp, sas_addr, &type);
+
 	if ((SAS_ADDR(sas_addr) == 0) || (res == -ECOMM)) {
 		phy->phy_state = PHY_EMPTY;
 		sas_unregister_devs_sas_addr(dev, phy_id, last);
 		/*
-		 * Even though the PHY is empty, for convenience we discover
-		 * the PHY to update the PHY info, like negotiated linkrate.
+		 * Even though the PHY is empty, for convenience we update
+		 * the PHY info, like negotiated linkrate.
 		 */
-		sas_ex_phy_discover(dev, phy_id);
-		return res;
+		if (res == 0)
+			sas_set_ex_phy(dev, phy_id, disc_resp);
+		goto out_free_resp;
 	} else if (SAS_ADDR(sas_addr) == SAS_ADDR(phy->attached_sas_addr) &&
 		   dev_type_flutter(type, phy->attached_dev_type)) {
 		struct domain_device *ata_dev = sas_ex_to_ata(dev, phy_id);
@@ -1994,7 +2003,7 @@ static int sas_rediscover_dev(struct dom
 			action = ", needs recovery";
 		pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
 			 SAS_ADDR(dev->sas_addr), phy_id, action);
-		return res;
+		goto out_free_resp;
 	}
 
 	/* we always have to delete the old device when we went here */
@@ -2003,7 +2012,10 @@ static int sas_rediscover_dev(struct dom
 		SAS_ADDR(phy->attached_sas_addr));
 	sas_unregister_devs_sas_addr(dev, phy_id, last);
 
-	return sas_discover_new(dev, phy_id);
+	res = sas_discover_new(dev, phy_id);
+out_free_resp:
+	kfree(disc_resp);
+	return res;
 }
 
 /**


