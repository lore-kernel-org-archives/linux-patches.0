Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9407F8F5C;
	Mon,  1 Apr 2024 16:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987837; cv=none; b=mM7C3EXz7YLU3HJTtL902qdnGvrQBQUg3zgdXGQc3tArs6DLceO3tCY7FTT58hk/kC9nJngchIsVPsDDXpO9ab57ubBc3pvOGDxxlbqs6G2P8br5KKcsY1gaRcvXxJKsNQzaV9huGilg0HDxIr1gcP3rnldZnENXcxjjkjdPSqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987837; c=relaxed/simple;
	bh=toXop0LEx21jteSFdSQq7UrSbLGFW+9co8H37I6KxAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pdv3JFAmIIVnmh5dRaHx6sUm/sxrTeZFNWN3zv1llWd9Hm5/+CxQDj2S+PlN2oKP++A4vfKMgWGFZdPyPEgnumtN5kVo4Bxgq1PrFhBFoLHaZmVj6X53WUvvXEcs6kLc8nyPlLXKxcL428GnueC/fdd5XZvcWnuZRMf2cikCRBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ios53dtz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ios53dtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15518C433C7;
	Mon,  1 Apr 2024 16:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987837;
	bh=toXop0LEx21jteSFdSQq7UrSbLGFW+9co8H37I6KxAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ios53dtzJI/wXMcfxTUTbyHME3MaVK2rcTb6l/xA5RiexjRgPZBYTDW6u5v5xA6XM
	 3zH6msIUIwkpZk3IFATObNXBobynly7M6y1g6g4dfl8A7Pis015Mwwv+3IYctqNPYq
	 LNcop46cnFvG0pWFAyanj8CVbaAiCOU3qNRvQVPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.8 395/399] scsi: libsas: Add a helper sas_get_sas_addr_and_dev_type()
Date: Mon,  1 Apr 2024 17:46:01 +0200
Message-ID: <20240401152600.963792727@linuxfoundation.org>
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


