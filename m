Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6581A76C1;
	Tue, 30 Jul 2024 17:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359746; cv=none; b=sgLYT2fP/eGcWLvPLmKxZURUazB2lXtroyNEMV2TttxvtLyHH91BDJZF5RIuD2KUWTYTPaNBpMFMnOeDuPscL4UAvxxrDB+b3D3aft9NUnFnh/Tf/bpOTnM6osdY3VrG0lVXeR1Q58aWfbYrz8l5eSdydlumPiWj3ykG1ApAD9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359746; c=relaxed/simple;
	bh=Kzt2gxQ1HtMJKBRDS8pH1ajUMKFxXG2ZJb5R0hqVFEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O5pqWKEqdVSUX6EzH/DaxPJpT1rxiz2UJQkA8o12i1aCy5BTGki4cNn69PQXhj5xt1BhH3InKYFPr/SaAhkBtFQn1ewZs9KFeL8Ytou/rji2iNmuzoiIhpVP+Q3Wn8tDtVY0b7mqs5I4LszRLsHjpcqEp+oxvtK7Eg1///CqmBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsMOSpQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsMOSpQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15043C4AF0C;
	Tue, 30 Jul 2024 17:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359746;
	bh=Kzt2gxQ1HtMJKBRDS8pH1ajUMKFxXG2ZJb5R0hqVFEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RsMOSpQBE+rUGymtVaDX2Fz7soCGzkynnqlgRwBvg7IoMoTDsTf5IOStShG7vAuBl
	 fIRS15tGSDDBowdOdAx9uP33PmHLthit8Rik6GXXytCiw7wZnHm7m+PZJUcj3QJtAG
	 AE1RLKjuPMgVfnhHYWTVVe4fwwa46dBqtb8TLNd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 527/809] remoteproc: mediatek: Dont attempt to remap l1tcm memory if missing
Date: Tue, 30 Jul 2024 17:46:43 +0200
Message-ID: <20240730151745.554418814@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 67ca3f98070ffdf308b91e08a477fcb1e9684ae8 ]

The current code doesn't check whether platform_get_resource_byname()
succeeded to get the l1tcm memory, which is optional, before attempting
to map it. This results in the following error message when it is
missing:

  mtk-scp 10500000.scp: error -EINVAL: invalid resource (null)

Add a check so that the remapping is only attempted if the memory region
exists. This also allows to simplify the logic handling failure to
remap, since a failure then is always a failure.

Fixes: ca23ecfdbd44 ("remoteproc/mediatek: support L1TCM")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240627-scp-invalid-resource-l1tcm-v1-1-7d221e6c495a@collabora.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/mtk_scp.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/remoteproc/mtk_scp.c b/drivers/remoteproc/mtk_scp.c
index b8498772dba17..3958f7b02d701 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -1344,14 +1344,12 @@ static int scp_probe(struct platform_device *pdev)
 
 	/* l1tcm is an optional memory region */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "l1tcm");
-	scp_cluster->l1tcm_base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(scp_cluster->l1tcm_base)) {
-		ret = PTR_ERR(scp_cluster->l1tcm_base);
-		if (ret != -EINVAL)
-			return dev_err_probe(dev, ret, "Failed to map l1tcm memory\n");
+	if (res) {
+		scp_cluster->l1tcm_base = devm_ioremap_resource(dev, res);
+		if (IS_ERR(scp_cluster->l1tcm_base))
+			return dev_err_probe(dev, PTR_ERR(scp_cluster->l1tcm_base),
+					     "Failed to map l1tcm memory\n");
 
-		scp_cluster->l1tcm_base = NULL;
-	} else {
 		scp_cluster->l1tcm_size = resource_size(res);
 		scp_cluster->l1tcm_phys = res->start;
 	}
-- 
2.43.0



