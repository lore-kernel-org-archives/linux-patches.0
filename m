Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82630258CF9;
	Thu, 17 Apr 2025 18:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914384; cv=none; b=fP2zfQaFAfQK+CeMljLfpnqKRwGUxKpOz39KorPEcKoe4Xt4Y7I/1Jkgt7PhSZuR4FXA8h+qB42D/3ZY8xkr2IMHAsddcdqsTgkrUPs6oNs5fNz8Vp+9r4cSY786iZP6FVg8Fx+4lyfSV7Rw9HIsHXUkN/kxdxKeCH5K23YZ28o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914384; c=relaxed/simple;
	bh=/QQ8FHSTOkZezIjoko7AoKIRyNWqJ18DukrqVxwwq2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sl2LYvmAg77Gs3wS1EFhr6gNqhWjHeD4vpbbV2qvugPkfiY/7/cBjmsQoh6STfcfD0kpVv/k14a0XlLBH4ZsNgrJ5P+Wy/Q48z5C7orGqpk24+AFDlkfn3KZwu3L17cp25mgyeOVp5E8zrrVYS0OXGFKszKpR6qP/d0oZdRv3OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbX7FaRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbX7FaRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F065C4CEE7;
	Thu, 17 Apr 2025 18:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914384;
	bh=/QQ8FHSTOkZezIjoko7AoKIRyNWqJ18DukrqVxwwq2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbX7FaRG+0H3hRuLw7BEs4stGsA/zeL5qH+UTdtCAUXljfki00ixYNvraFFl47xgI
	 Fs4uVHeT5PDKyQBFQTzJa5ErJOghxRykmEUx9SZO8yoqmMbX8cAVEoWcvAzweBftsU
	 8CsunwYpssaJzlZ+5/EdeQ6abTLLIzI6rogZJ9bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 197/414] media: mediatek: vcodec: Fix a resource leak related to the scp device in FW initialization
Date: Thu, 17 Apr 2025 19:49:15 +0200
Message-ID: <20250417175119.370342033@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


