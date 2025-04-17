Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C558819ABC6;
	Thu, 17 Apr 2025 18:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915714; cv=none; b=FZ8mKfAaWvlf2p/v3nf0aB2rRZwmfuWEdhu9u43qPT0WRB2CpwA1NNJCJkCD56+2aKVQE0eEJz7PJ4jf3t5o1/Nb7OXCWIH0tdKhuZxU+6VWdgTJ+mt0DA8t0rMhyTgFvdX+6zhIoqJydATWCmc/1l2QbLnHRO/2sXH7kR7ICNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915714; c=relaxed/simple;
	bh=2EbRoSD8buXCwlbVHGK32WjNfEeP73jXwLEjScenox0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7f3ICVA1euc4dmDuJRWk5l4hVd2UNWEX0jBqtv1AeoFD2uhP51G5tk8+I2ySBZA7jqA48YgDXUY+QpB2xeldb+iMUL6TyfzbO9K8Jtc48pcWv/wDmHnG8wwk1jzNze59NS2VlJnHlQaxXuoJf6LGQZtxzPMgvc4Z9xdEM2UDys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAEch4bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAEch4bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E733AC4CEE4;
	Thu, 17 Apr 2025 18:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915714;
	bh=2EbRoSD8buXCwlbVHGK32WjNfEeP73jXwLEjScenox0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAEch4bjl5WVNXxb+Kcf790GsJBobQ3G4Cuaa1rjEac0ay5yPW1BPNpNv9v/1GbC0
	 MGCwKUtQmijMSq7U4K5Gfp/9gFrZIZLML1GPGbvTd7z6x1EJwUgQDx9q3WMIGYtGI1
	 edoeJOlq/65gpmOEBk9nbEh2luEZfIjpRJWURvco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 189/393] media: mediatek: vcodec: Fix a resource leak related to the scp device in FW initialization
Date: Thu, 17 Apr 2025 19:49:58 +0200
Message-ID: <20250417175115.189782623@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


