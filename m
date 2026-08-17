Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8933643B3F4;
	Mon, 17 Aug 2026 13:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974083; cv=none; b=lVfJt5jEI+DU+27bRpKB85xLoY6atBdxq4LfejsRJsSStKaNpPbKipUPrgpeoHWmKyraBIe9mP28Lzb6UK91HAPbgPwFJeC1Jh5859xNZdhchSc/g4aTtnaVqwqzq4ZNBxEyHJkQbs7j+Hvnri695cFdsY1D9tdJ7Za50XQlRmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974083; c=relaxed/simple;
	bh=6JJkYn0zlZffvL7rsJ6LjVVL8ISVdy1orn8TzmLdgbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHkGlMXXHLSGWvntkrPm0n9jjVW7Qo9yt7XP/jBLqpvmQTyHTuy/WeHRjPdv5zw2K8QY+zfI57I+CPNm9LTRtZPwP9fSKMxqIdulocgpYaJa3sqnHR6HlBLMB3LIpmzZeZeVTCjCvhtpwiEe8DzGZ1UZxV9aHu50UWde99a23x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnrgywMD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnrgywMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BE21F00AC4;
	Mon, 17 Aug 2026 13:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974074;
	bh=EI8xcRYRJBra0OmG8uVhdfZ+R+OqgJFbz9SvcQcOiME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZnrgywMDEdj+I+MmMKP+aTc3+F5aPMnzlh9K+MQS/VvqHSunPtj7c4R+FQGM7Gq/0
	 KapA+Cc8Gtr0qtd7h7P3INcuWz4hxkLaWi0mrCpy0e54O5uKy/gP6VRtxi1kbqreAQ
	 w0Ov4YyqtdKEIZNRxzWqCotrYVhjzCiZqD8lhk5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Bhargava Marreddy <bhargava.marreddy@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 078/271] bnge: Fix NULL pointer dereference in aux device release
Date: Mon, 17 Aug 2026 15:30:03 +0200
Message-ID: <20260817132539.948629552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 1cb4298810e27e037d3ca07286ecbb97e89ba58d ]

If allocation of auxr_dev fails during auxiliary device setup, the error
path calls auxiliary_device_uninit(), which eventually invokes
bnge_aux_dev_release().

The release callback unconditionally dereferences aux_priv->auxr_dev->pdev
to retrieve the parent bnge_dev. Since auxr_dev has not yet been allocated
on this failure path, the dereference results in a NULL pointer exception

Retrieve the parent bnge_dev from the auxiliary device's parent instead of
auxr_dev, and free auxr_dev only when it was successfully allocated. This
allows the release callback to correctly clean up partially initialized
auxiliary devices.

Fixes: 8ac050ec3b1c ("bng_en: Add RoCE aux device support")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Bhargava Marreddy <bhargava.marreddy@broadcom.com>
Link: https://patch.msgid.link/20260731192301.1427645-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_auxr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c b/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c
index 67e93e17d4d9f..0955b488b6fea 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c
@@ -141,12 +141,15 @@ static void bnge_aux_dev_release(struct device *dev)
 {
 	struct bnge_auxr_priv *aux_priv =
 			container_of(dev, struct bnge_auxr_priv, aux_dev.dev);
-	struct bnge_dev *bd = pci_get_drvdata(aux_priv->auxr_dev->pdev);
+	struct bnge_auxr_dev *auxr_dev = aux_priv->auxr_dev;
+	struct bnge_dev *bd = pci_get_drvdata(to_pci_dev(dev->parent));
 
 	ida_free(&bnge_aux_dev_ids, aux_priv->id);
-	kfree(aux_priv->auxr_dev->auxr_info);
+	if (auxr_dev) {
+		kfree(auxr_dev->auxr_info);
+		kfree(auxr_dev);
+	}
 	bd->auxr_dev = NULL;
-	kfree(aux_priv->auxr_dev);
 	kfree(aux_priv);
 	bd->aux_priv = NULL;
 }
-- 
2.53.0



