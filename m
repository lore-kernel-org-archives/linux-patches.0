Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6612B21105;
	Mon,  1 Apr 2024 17:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991450; cv=none; b=jBAKiGQ9A6MglcxXIC0kDYrV/ncoOy9aJhSZNEIrEtCoC2BHYuILzEZQJwO3mYvmQGSLXU4GVWLMZuYXJuHzxhadWqeb1eeGCqXubWvWBaH92ha729zpYt/bpgMVHMeGx0euswFFM6C3MPxfVL8xTY0esY1tziQZMWLeqPaiGuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991450; c=relaxed/simple;
	bh=XcFvEPNmm4Kuid4lLqaA+oL7JIoYJoPqk7FE21nd4gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aO1+9fnyo2ZexD9uWMu1PcBbZXCv0X0FxIauJlmUejT2MSS17/kYdmE0gWOfWaTTLO8oO3zVlGQQHQVP+4t2pGYO44o0a25DMaAExr7MSAR9AaDXTtXkUuaiDgBzzSi9GiokhyUXHEq7Nz9Zw62JUEQr02hwcrPHunhghJmASXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnBhVdfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnBhVdfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6262C433C7;
	Mon,  1 Apr 2024 17:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991450;
	bh=XcFvEPNmm4Kuid4lLqaA+oL7JIoYJoPqk7FE21nd4gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnBhVdfAn9sC709GSyBaQPYshdtRcJZILYMVIMdYqfDlQ8yHk8zTDw12XyzoX9MPy
	 JWxze1zt+/EQJZy2AduNSeMmKiJtlAwB/AFOYdmC9Z3UIVwzuuuu+dyruT3d2QqCDo
	 ZfSxsbeLp2/D3dlNfhAlnVcmCfChFZpJfvZJXSfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 268/272] scsi: libsas: Add a helper sas_get_sas_addr_and_dev_type()
Date: Mon,  1 Apr 2024 17:47:38 +0200
Message-ID: <20240401152539.439087579@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1651,6 +1651,16 @@ out_err:
 
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
@@ -1704,13 +1714,8 @@ int sas_get_phy_attached_dev(struct doma
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


