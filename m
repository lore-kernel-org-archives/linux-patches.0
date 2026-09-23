Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D67647A0C4;
	Wed, 23 Sep 2026 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175337; cv=none; b=O8Gr2klw+mOx6x0AOdEQ4NgMQ2GBnRNl7XzMKK7e6I4WwhbyBro/AYkzYj2RcnGlSarqWJVTNCJoRlman32mEbWbQNHf6HfgtpCmw0t6hO72q9IamojDqXYKZvrz63KNymRJ8Tf50QB4jRfvahCr4Dh2i0ZUNOOzla0WGpwoIKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175337; c=relaxed/simple;
	bh=0tDQwprzjaeU0c4YE4sc3wJtECAXi/HJBUsl6XRtzW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onW2dCqZaL3RtjSRA06GgeZ4eQshZUd3hTy1WHe6NkoWakdPaGqYcOIUeN6hS+a6n0hbwX0efctHJg40llUfnaSJVlc3TjSk8mxoiasU65XRtjRLwZZ1xIF4/49w2HIwj3ZOCnHOOvXHYIHOSJMc8u2iWmriQwd+kSn7ERk4IVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJIvo+Za; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJIvo+Za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44C31F000FF;
	Wed, 23 Sep 2026 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175336;
	bh=uqHCYQvnPRH/nSN2krUfzHmbqUOimSVePkPvdbBUdd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJIvo+ZazOnMha1NFfxGSUzZ78teoMaj+ZboFTDyq/BjvRKbu+GjHafPtO3jINRFg
	 6bZJBjtYLr5r47oqjNbL7UP4uvjE9ZOVa6tPwrydGqJ1xQencmopi8WQjwpT2/LYpW
	 Lsq4ut5r8Fhlsz+HB1QjuA6gSfqwcAqQvPHX+kcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 396/398] Bluetooth: hci_qca: fix NULL pointer dereference in qca_setup() for non-serdev device
Date: Wed, 23 Sep 2026 16:07:50 +0200
Message-ID: <20260923140653.733944875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

commit 3ec629fee178d429f01ae843e4ea888de93012bf upstream.

hu->serdev is NULL for hci_uart attached via non-serdev paths, but
qca_setup() unconditionally calls serdev_device_get_drvdata(hu->serdev)
and dereferences the result, causing a NULL pointer dereference.

Fix by guarding the dereference with a NULL check, consistent with the
rest of qca_setup().

Fixes: 22d893eec0d5 ("Bluetooth: hci_qca: Refactor HFP hardware offload capability handling")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1917,9 +1917,12 @@ static int qca_setup(struct hci_uart *hu
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
@@ -1981,7 +1984,7 @@ retry:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
 	case QCA_WCN7850:
-		if (qcadev->bdaddr_property_broken)
+		if (qcadev && qcadev->bdaddr_property_broken)
 			hci_set_quirk(hdev, HCI_QUIRK_BDADDR_PROPERTY_BROKEN);
 
 		hci_set_aosp_capable(hdev);
@@ -2074,7 +2077,7 @@ out:
 	else
 		hu->hdev->set_bdaddr = qca_set_bdaddr;
 
-	if (qcadev->support_hfp_hw_offload)
+	if (qcadev && qcadev->support_hfp_hw_offload)
 		qca_configure_hfp_offload(hdev);
 
 	qca->fw_version = le16_to_cpu(ver.patch_ver);


