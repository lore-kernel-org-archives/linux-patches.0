Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498B0146A9D;
	Tue, 25 Jun 2024 09:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308933; cv=none; b=VOzh0YqAcJm2rqiJiZYpbpxXLu4IcSkagtzmrroSsARi6pCRuhHIT8SgkAxQb4i0N4SY57oMUdn1mdsGCKQZlSotSZZmQGcwh0qxHT8+m/ddozrNKfn8UGIao9DVFbpL1CAQHtm9er67TScPc3754kMPAGmRSloHPIFK4HOccqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308933; c=relaxed/simple;
	bh=isENPCBTtR8Ii98RKbt8kmadv45+e9fnlywF2eQoBug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAnDXKWUXIW+dsRj2GV4MV6ojSOCuNRZ+5HAOf76L8VdX2t6C3Hodz1tqdl3VIV5Uh0VjrhoxEqWKgGiH3PujJmXV2b0C7FV8OMUCV9NLGS4YQT+c1nggjULz+9slYVVPCTU6iW+IPBZ4sHD2ZJKWj6GJkH4xllh9eZmU3RA7Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Melz3/Wv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Melz3/Wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EA1C32781;
	Tue, 25 Jun 2024 09:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308933;
	bh=isENPCBTtR8Ii98RKbt8kmadv45+e9fnlywF2eQoBug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Melz3/Wv11/KWctDfBWIiCqy0BBS/I7KtJOrYBpNzHy2ML2xxl5v8KUGUw4u266Y6
	 +AH8OsKw1vq/2f1kz9iJv8OSj5DxjXQTGlJQqvpo0Ru9e6qjoYfAe0uHi4zuGsTQd+
	 WYszTXPgzkR1SvCB22V4wVFO9fnb4j2zfXtOCLA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/192] media: mtk-vcodec: potential null pointer deference in SCP
Date: Tue, 25 Jun 2024 11:31:50 +0200
Message-ID: <20240625085538.626852533@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Fullway Wang <fullwaywang@outlook.com>

[ Upstream commit 53dbe08504442dc7ba4865c09b3bbf5fe849681b ]

The return value of devm_kzalloc() needs to be checked to avoid
NULL pointer deference. This is similar to CVE-2022-3113.

Link: https://lore.kernel.org/linux-media/PH7PR20MB5925094DAE3FD750C7E39E01BF712@PH7PR20MB5925.namprd20.prod.outlook.com
Signed-off-by: Fullway Wang <fullwaywang@outlook.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c   | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c b/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
index 9e744d07a1e8e..774487fb72a31 100644
--- a/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
+++ b/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
@@ -79,6 +79,8 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_scp_init(void *priv, enum mtk_vcodec_fw_use
 	}
 
 	fw = devm_kzalloc(&plat_dev->dev, sizeof(*fw), GFP_KERNEL);
+	if (!fw)
+		return ERR_PTR(-ENOMEM);
 	fw->type = SCP;
 	fw->ops = &mtk_vcodec_rproc_msg;
 	fw->scp = scp;
-- 
2.43.0



