Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF481FBF5D;
	Wed,  6 Nov 2024 12:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896733; cv=none; b=GLKNdEheZj4pJIgQrIfoc1K/4c6ZIun+FXELs7XwZw4yGmJ3WeTLJyu7hXVnQcGhieU0mx6gaT91QKu3TAumwQhg3zwLsH/e+PO4t1DWUkxsVsQBEFAddZ0JnCZlOlz3kxo0UIvBBaqR6wNJalgX3fCkgs+oMeTULUdNglpxD/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896733; c=relaxed/simple;
	bh=Q8hnD5djZn1TcT2mrM5ScS2pxuCE/JFWru5Bw2cNE+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAFRe2lOzqN3Hk8to93XE8689Lywa8W5nefWpBCUotngnNjYDSADmqZvcNEMi1A1RnUCabTdvkyWkSb539dIGP+zKBJYwd6mR6rN1YRqw0ZbMkPBK5aeFJOfMtYwBY61v87SAJSbIvpiRhxGBT9UlS+Vfxd2gncpFc3L1cDENB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJtJTXG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJtJTXG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE09C4CECD;
	Wed,  6 Nov 2024 12:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896733;
	bh=Q8hnD5djZn1TcT2mrM5ScS2pxuCE/JFWru5Bw2cNE+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJtJTXG2CI4Yi037nzOcZJegRZNEjyeWer/Rjtg73Luzl+shK7R3pJBY2CorCCZ4W
	 EGq22I1XgmKZ8qe0szafOcjy2h6U3+3XBCsEfofb3hRchXw0g/fzqJDpaoTSc4CHnG
	 TXqwFPImxRcMZk9gflrAtV5JYpG6P6zxEbmB8X84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 054/110] ASoC: qcom: Fix NULL Dereference in asoc_qcom_lpass_cpu_platform_probe()
Date: Wed,  6 Nov 2024 13:04:20 +0100
Message-ID: <20241106120304.695430439@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zichen Xie <zichenxie0106@gmail.com>

commit 49da1463c9e3d2082276c3e0e2a8b65a88711cd2 upstream.

A devm_kzalloc() in asoc_qcom_lpass_cpu_platform_probe() could
possibly return NULL pointer. NULL Pointer Dereference may be
triggerred without addtional check.
Add a NULL check for the returned pointer.

Fixes: b5022a36d28f ("ASoC: qcom: lpass: Use regmap_field for i2sctl and dmactl registers")
Cc: stable@vger.kernel.org
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Link: https://patch.msgid.link/20241006205737.8829-1-zichenxie0106@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/lpass-cpu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -946,6 +946,8 @@ int asoc_qcom_lpass_cpu_platform_probe(s
 	/* Allocation for i2sctl regmap fields */
 	drvdata->i2sctl = devm_kzalloc(&pdev->dev, sizeof(struct lpaif_i2sctl),
 					GFP_KERNEL);
+	if (!drvdata->i2sctl)
+		return -ENOMEM;
 
 	/* Initialize bitfields for dai I2SCTL register */
 	ret = lpass_cpu_init_i2sctl_bitfields(dev, drvdata->i2sctl,


