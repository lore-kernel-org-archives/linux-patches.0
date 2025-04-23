Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F7127FD7F;
	Wed, 23 Apr 2025 15:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420877; cv=none; b=AAT4rB37dg+x9IEzWvfFGpIV7LFwDIKAa+f0boQku/leK+MCD1o2p0/29IBUFmmTXkSPDtGQputTOmep2zSiKlsFFfpm+srip5ZoR6gg9ihe6fAnDUNEvZkLnlF23ia4C6oc7/Qz1qzH7hOCFX+eKAeHCAfbt+CeWCjKSZFu+08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420877; c=relaxed/simple;
	bh=jYXsovgSZGaPxTYpj6Ihl48cc1nSYKxZWB9KVbpKSUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEgSmuYPh/SiMZZiB3BJhzEuljRp1PhdOCbmuIoeg77WME/ROha0IeMykhrIBvLuuT6UTUSTzLuHDeCIaSbt5pb1ugxO+Bz369QLruKObN+i7qd7ma698PFmPeZ0/SEz6Hhe3xGVBpbK+R6zRnezKl82jZ1nfhAzdUz+ENaz4FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQSB1Lqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQSB1Lqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6785BC4CEE2;
	Wed, 23 Apr 2025 15:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420876;
	bh=jYXsovgSZGaPxTYpj6Ihl48cc1nSYKxZWB9KVbpKSUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQSB1LqdClr2m+3EvlxDyLtXe9ks9D1dFGq2iRfAZOAG/EzDnQ76S5YAp9l1WMQRD
	 wzLiEA6pDR7jSdmwal8hmEfw8vKskcboEwM+b6BcR8Vp6FbthwQY4JkEgt2DMfZ4By
	 gYH/gVv9RkGT9dNx0zC0nrfYLtT/7AgK28mkgYTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 120/393] media: mediatek: vcodec: Fix a resource leak related to the scp device in FW initialization
Date: Wed, 23 Apr 2025 16:40:16 +0200
Message-ID: <20250423142648.314822337@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit 4936cd5817af35d23e4d283f48fa59a18ef481e4 upstream.

On Mediatek devices with a system companion processor (SCP) the mtk_scp
structure has to be removed explicitly to avoid a resource leak.
Free the structure in case the allocation of the firmware structure fails
during the firmware initialization.

Fixes: 53dbe0850444 ("media: mtk-vcodec: potential null pointer deference in SCP")
Cc: stable@vger.kernel.org
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
+++ b/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
@@ -79,8 +79,11 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_scp_
 	}
 
 	fw = devm_kzalloc(&plat_dev->dev, sizeof(*fw), GFP_KERNEL);
-	if (!fw)
+	if (!fw) {
+		scp_put(scp);
 		return ERR_PTR(-ENOMEM);
+	}
+
 	fw->type = SCP;
 	fw->ops = &mtk_vcodec_rproc_msg;
 	fw->scp = scp;


