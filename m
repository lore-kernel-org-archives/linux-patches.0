Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB0046A611;
	Tue, 21 Jul 2026 16:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649709; cv=none; b=d15vcoHaTzw+Z/KzRsli+6gC/jVHhvSc0itm384qYX6VzLxKT9lR3R4dGwn8u1AP/M/D8qkBOYfol9b+3FP39iU40weamuSnmZvQzbG4JiIUXs9cAY521Cix1ctyZZZpei/2BtwmWf4B8PT5rg4NgO7Q7QpD2QlXdVLAebcFH3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649709; c=relaxed/simple;
	bh=yud2988m4cI87kFBYxTHWvr0fCDByG7VPw6kluaCm98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnsllRzmi+1FdVXwK5igfglVEtun3qCR7KYv2qp3BpLlNKJ/AdFNheTmRt+ZtHurVjOG/bycVguSYrD0Ay15iZzZFZhv2AQZu9y33tM+yeQ29C49h2AlarGLjTBGSERMkVYo19lOypcZ25UeRmNCP2srHQMDECKzILAyMUWhGCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXf7Nq6B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXf7Nq6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913FE1F00A3A;
	Tue, 21 Jul 2026 16:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649708;
	bh=V2uRvpEy6+HfyWEjQkEhwSFVo/cY7fUoGq80RVyLqQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXf7Nq6BIqeCfiZ+eVFUTy8riIG0Nxmb3FEWRnHr6UghKzQ3/5gmoLTsLLrhDntIx
	 KWqIziXYaSJdgxhfYzIxx2+0eqD8ulSzvNdomaqRdEukchq5LaJ/OsjBJ6SSmbUanJ
	 AGrat0mQfMOuLqsEJWJbeMv7/obIb2gZ7697HUAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0677/2077] Bluetooth: hci_qca: fix NULL pointer dereference in qca_setup() for non-serdev device
Date: Tue, 21 Jul 2026 17:05:50 +0200
Message-ID: <20260721152608.765246104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 3ec629fee178d429f01ae843e4ea888de93012bf ]

hu->serdev is NULL for hci_uart attached via non-serdev paths, but
qca_setup() unconditionally calls serdev_device_get_drvdata(hu->serdev)
and dereferences the result, causing a NULL pointer dereference.

Fix by guarding the dereference with a NULL check, consistent with the
rest of qca_setup().

Fixes: 22d893eec0d5 ("Bluetooth: hci_qca: Refactor HFP hardware offload capability handling")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 34500137df2c10..cc7b34a61fa783 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1916,9 +1916,12 @@ static int qca_setup(struct hci_uart *hu)
 	const char *rampatch_name = qca_get_rampatch_name(hu);
 	int ret;
 	struct qca_btsoc_version ver;
-	struct qca_serdev *qcadev = serdev_device_get_drvdata(hu->serdev);
+	struct qca_serdev *qcadev = NULL;
 	const char *soc_name;
 
+	if (hu->serdev)
+		qcadev = serdev_device_get_drvdata(hu->serdev);
+
 	ret = qca_check_speeds(hu);
 	if (ret)
 		return ret;
@@ -1980,7 +1983,7 @@ static int qca_setup(struct hci_uart *hu)
 	case QCA_WCN6750:
 	case QCA_WCN6855:
 	case QCA_WCN7850:
-		if (qcadev->bdaddr_property_broken)
+		if (qcadev && qcadev->bdaddr_property_broken)
 			hci_set_quirk(hdev, HCI_QUIRK_BDADDR_PROPERTY_BROKEN);
 
 		hci_set_aosp_capable(hdev);
@@ -2073,7 +2076,7 @@ static int qca_setup(struct hci_uart *hu)
 	else
 		hu->hdev->set_bdaddr = qca_set_bdaddr;
 
-	if (qcadev->support_hfp_hw_offload)
+	if (qcadev && qcadev->support_hfp_hw_offload)
 		qca_configure_hfp_offload(hdev);
 
 	qca->fw_version = le16_to_cpu(ver.patch_ver);
-- 
2.53.0



