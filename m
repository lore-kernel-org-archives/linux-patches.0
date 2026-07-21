Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30DF46C4B9;
	Tue, 21 Jul 2026 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649711; cv=none; b=nMr4FGVIfOTQDCT4YjGJDofbGLIoZGVuF/T0ykJ0sIvFTizNAHNmZwyJgADdt9anOaMspYO/kSkvADbF3Cnhx4Wr3h9pMrj+x0IOloNmQtvDEfex7XMwsY8tR9fpf8ToW3m0XLuQ79GPbq5NNjegAaA0iCoE+Vw7zn2DBjzz/18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649711; c=relaxed/simple;
	bh=OiP4MdAhuPwAcx/l4q2i+P0ElyAaVsqvlBElhcXA3PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2qQ6BHOabSjM1wUo86yrFJ8RsUPc3bjyHU3rj+yvhz3OnsiTNWIfNGkzD8GCG6NaGwsS1YzAgoz9s16SPFym3TuQvQBkFFUPIGkMcYANuPoG5zZG42ET97XAzRQ/NvLv6Ro1vqcaQ4DsnokyULf4kp8o9oz7HWVnI/X2FN7ea8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyd5Bbd9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyd5Bbd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358B51F000E9;
	Tue, 21 Jul 2026 16:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649710;
	bh=ac+TZKU88ZbJxtct1CaZg1qseng7J4uzMznuXknd0/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tyd5Bbd96xDl67O9TdOCZxji2kAmWZfvIlgpZmTfD5EVD9OViPHSo8VGBrzuBFB+U
	 ZNwouKmLMdX7y1dnMtUiy5C9ap8SUx1qdrwXHRDjfXS71l4VMMB7We8w+oMLNQ8kuW
	 vDMVBuEOfzyKXfkQGZ5axyo8h9lOkMKaF4wWUdcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0678/2077] Bluetooth: hci_qca: fix NULL pointer dereference in qca_dmp_hdr() for non-serdev device
Date: Tue, 21 Jul 2026 17:05:51 +0200
Message-ID: <20260721152608.788607135@linuxfoundation.org>
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
index cc7b34a61fa783..2444471956197b 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1028,7 +1028,7 @@ static void qca_dmp_hdr(struct hci_dev *hdev, struct sk_buff *skb)
 	skb_put_data(skb, buf, strlen(buf));
 
 	snprintf(buf, sizeof(buf), "Driver: %s\n",
-		hu->serdev->dev.driver->name);
+		 hu->serdev ? hu->serdev->dev.driver->name : "hci_ldisc_qca");
 	skb_put_data(skb, buf, strlen(buf));
 }
 
-- 
2.53.0



