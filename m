Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6730F2EBB8D;
	Tue, 21 Jul 2026 20:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666091; cv=none; b=oLq6GfM+8rsr1cY2+BXwyscLnPLPelcHXGoKjXmDIfnCjN5JA8C/B2MavROAXDMiMxhwl77nayK5qMeMYWMv2YTPldcSyJnWPxLjv8W6eAs93tgty7gC1HY4E70U5H82wCf6fGyk6/TLCUucLPWQzVAeEFszveI5b1VVET/+EII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666091; c=relaxed/simple;
	bh=NasBng3aWBUNnCz28MjcGOIiI4R9RSda6DEr9ZGj3pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eywyGM0rZGViJertwTLwVapprv1k5upImTD10OaIbQ9PHwGG5b4RxPCsvaq2QYp0UgUlHS8113MSPs/6XOBgl4eCVRVSbXtK6Bv/2wU/VEqNpqZra1SPLGJluuPdQIN4Qb9V3U0tznAwy0NnzY8GK1xKpLJP8y+nDdDfq0wdvdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5mEgJRG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5mEgJRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB101F000E9;
	Tue, 21 Jul 2026 20:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666090;
	bh=7Yb6IuW45SYQJuwKKCeO9K+XuHgSiFr0sGWWvD+KD9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5mEgJRGmUMcd2J6JvYFP3CtRT7/qLYW26dUNnbSVsOCfs3JIS3QFfuA2J+AlEnj9
	 kwTGPaBK3sMHP/hJ8vPY+y6YcJvmvDsF5hN98LeG+FvWg1x2Chb4wNZMOOZOwARH9t
	 BGGbL04lOHe7aDOcTLL3+MtDx5anhs2qjYoMJr40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0549/1266] Bluetooth: hci_qca: fix NULL pointer dereference in qca_dmp_hdr() for non-serdev device
Date: Tue, 21 Jul 2026 17:16:26 +0200
Message-ID: <20260721152454.152620459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ac737ee143614c..2986b18655a150 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1008,7 +1008,7 @@ static void qca_dmp_hdr(struct hci_dev *hdev, struct sk_buff *skb)
 	skb_put_data(skb, buf, strlen(buf));
 
 	snprintf(buf, sizeof(buf), "Driver: %s\n",
-		hu->serdev->dev.driver->name);
+		 hu->serdev ? hu->serdev->dev.driver->name : "hci_ldisc_qca");
 	skb_put_data(skb, buf, strlen(buf));
 }
 
-- 
2.53.0



