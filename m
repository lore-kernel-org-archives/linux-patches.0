Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F6346E00C;
	Tue, 21 Jul 2026 19:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662110; cv=none; b=m4+yts8hDw9VDs8yrGDH5/p/ZbgTditERtKKb37Gr5jqApTwHpxGMviw0wAl98Jf5OuijZZqF4qK88PJSVMR1FfWA011wrQufkNzg2+8YEr++1rcaKZ7ZjqELv/OTDww/qN/5CnOBpFdBSNzMOhZCYm7MeOrOsmGVIMWM+K+f94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662110; c=relaxed/simple;
	bh=vMTdwi1Y5QeZo+u6/fl+3CkYDNOXYdB6QdnzXQMirZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSY8Y+ZznCHMYmTVgdSvofLcaQa6r7EBngEdK04cE5V4V9dlhRKuj/pu9iIaJQO3wPsJngPdjood5ohLognt6XkoJGqDDyim8RFCAFlJFvr+XL1dEfQclpHL+lIC4HBN7keuE4NxPK1SFe4w2IG3uhToT3eWTI79TNuXUk87TQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bnnc1Cet; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bnnc1Cet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BFB1F000E9;
	Tue, 21 Jul 2026 19:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662108;
	bh=rCyKityF2XAF2nJ4mJRXa7GaBfn0Xxtw8qDYjzyraq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bnnc1CetBDIs+bnGvR50CnFaUWRgyQFFtvYxkTqvobn4Dw9kbopVRcx9J6+gvHkpv
	 1s1BnKiJQZX3MFjXxjpXYIybgvhVPGWmV3U7OSJ7y/jTahlxepAk0Ff6Gn12M8drOP
	 OSVq3MPFfZc8rdMeKmmBcAwWj6+YvISNRB5QAuOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0318/1276] Bluetooth: hci_qca: fix NULL pointer dereference in qca_dmp_hdr() for non-serdev device
Date: Tue, 21 Jul 2026 17:12:41 +0200
Message-ID: <20260721152453.215228636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 6b8cbcf08de0db62254d1981f83db0f94681ccd9 ]

hu->serdev is NULL for hci_uart attached via non-serdev paths, but
qca_dmp_hdr() unconditionally dereferences hu->serdev->dev.driver->name,
causing a NULL pointer dereference.

Fix by guarding the dereference with a NULL check and falling back to
"hci_ldisc_qca" for the non-serdev case.

Fixes: 06d3fdfcdf5c ("Bluetooth: hci_qca: Add qcom devcoredump support")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 7897307a7fe294..de9fd0e77d398a 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1010,7 +1010,7 @@ static void qca_dmp_hdr(struct hci_dev *hdev, struct sk_buff *skb)
 	skb_put_data(skb, buf, strlen(buf));
 
 	snprintf(buf, sizeof(buf), "Driver: %s\n",
-		hu->serdev->dev.driver->name);
+		 hu->serdev ? hu->serdev->dev.driver->name : "hci_ldisc_qca");
 	skb_put_data(skb, buf, strlen(buf));
 }
 
-- 
2.53.0



