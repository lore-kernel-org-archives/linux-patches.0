Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F39BA3F;
	Mon,  1 Apr 2024 16:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990564; cv=none; b=EKTJaVkTS2prqb5Zy7JO04KQXWvnSaloPCMn9IPRBlAVJSwB6KiQ3W4RdiKb2M6sBATf785rPeCtyheQTfIqwnNBOx5dEU6FPx4ShqtWlJvVKh7GnAoQTl/5jwYsE9XKKt2Swa5F4egi+I9mrP/WNMRPJL7bo7uAY8UfesGEei8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990564; c=relaxed/simple;
	bh=VOTV5T1DWEw3wEdyqyMAJvg6w56GxKGu+vA6JTpdlvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsEG6xAgEJw+Bwgw8c53MzMKC//iJka1Sre3NbKSi3xXQUm448xuCp6BLod51rl5t+pen1aNeXWtkdg03jx8xo4tk29hnp6KaaIEMNEdfBXJT84/q/Up8u/fRU0deH2b2d22HbY21xjslKUQVgdziNfKw/cTNVLcd0YYJ6l0T4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgvNrt73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgvNrt73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0EFC433C7;
	Mon,  1 Apr 2024 16:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990563;
	bh=VOTV5T1DWEw3wEdyqyMAJvg6w56GxKGu+vA6JTpdlvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgvNrt733itITdOXW7I945vWSrDsmq3tkGj4P2KyLkYtLYd1RedjEjVqXqyYEu2Y6
	 C2D7fx+s1FiujSg16I6r0gGhHZDEhXCgD1GI56oQRbO6hQiIV48OuP9cUkQPAfNKCF
	 lRIv+AhOaBSSglzJ0DCo8NIRxTAQibcSXGK/hPv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 393/396] scsi: libsas: Add a helper sas_get_sas_addr_and_dev_type()
Date: Mon,  1 Apr 2024 17:47:22 +0200
Message-ID: <20240401152559.626682798@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Xingui Yang <yangxingui@huawei.com>

commit a57345279fd311ba679b8083feb0eec5272c7729 upstream.

Add a helper to get attached_sas_addr and device type from disc_resp.

Suggested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://lore.kernel.org/r/20240307141413.48049-2-yangxingui@huawei.com
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libsas/sas_expander.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1621,6 +1621,16 @@ out_err:
 
 /* ---------- Domain revalidation ---------- */
 
+static void sas_get_sas_addr_and_dev_type(struct smp_disc_resp *disc_resp,
+					  u8 *sas_addr,
+					  enum sas_device_type *type)
+{
+	memcpy(sas_addr, disc_resp->disc.attached_sas_addr, SAS_ADDR_SIZE);
+	*type = to_dev_type(&disc_resp->disc);
+	if (*type == SAS_PHY_UNUSED)
+		memset(sas_addr, 0, SAS_ADDR_SIZE);
+}
+
 static int sas_get_phy_discover(struct domain_device *dev,
 				int phy_id, struct smp_disc_resp *disc_resp)
 {
@@ -1674,13 +1684,8 @@ int sas_get_phy_attached_dev(struct doma
 		return -ENOMEM;
 
 	res = sas_get_phy_discover(dev, phy_id, disc_resp);
-	if (res == 0) {
-		memcpy(sas_addr, disc_resp->disc.attached_sas_addr,
-		       SAS_ADDR_SIZE);
-		*type = to_dev_type(&disc_resp->disc);
-		if (*type == 0)
-			memset(sas_addr, 0, SAS_ADDR_SIZE);
-	}
+	if (res == 0)
+		sas_get_sas_addr_and_dev_type(disc_resp, sas_addr, type);
 	kfree(disc_resp);
 	return res;
 }


