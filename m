Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D1D1DC9B3;
	Wed,  5 Feb 2025 15:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767683; cv=none; b=Z63aMFkkoUqCgsOFBoQRyUBVjDcUyTG2zJEanINy3cplb4sJaM1F65GLLr87sW7nIIy+ODHMieLkjksRe52ebwORE3tAqDX5+JtsQxzknttB+d5pyMgLEmVeVfYXxrLjog7LN2e6kZzk21ByL9Hyp+3E4hn8rjc32ZlsooblFro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767683; c=relaxed/simple;
	bh=EBQ1z2JXzgja3MEMpQwHRbxpPHiPf+W+B8al+i7Vsts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdhG4JCMr9+ycEecwoD5BiIXly9ff+wH7l20vOWyvY0Ch8x9ujr48c/yvZM5YFGPgw2NONA+WraQrZB4orIwzRcBQ7oFQQKFyIBgcUrPHoaa6z+LvLMm/1DUwjbLFxcfjzsomTUiYBM/wJHt2KdvNofjpgqOdEyzhidibyVH6N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiDf8J6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiDf8J6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF49FC4CED1;
	Wed,  5 Feb 2025 15:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767683;
	bh=EBQ1z2JXzgja3MEMpQwHRbxpPHiPf+W+B8al+i7Vsts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiDf8J6i5WyPMenWpIrHN02DNNM6Rd5rB1/nh8F3O1z0YEfeAukR+4V9q/1DC6Kd3
	 mHfOZ3EbK3X9bJOSA7w8hUzs7IGnotvcT9Z/0wGemSgh4qbHT4qAkxgiNOqfPgFyIL
	 F1xA+zVc9GueHIE0bNlEdTMcaaPsONIyvDDGDb/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 438/623] mailbox: mpfs: fix copy and paste bug in probe
Date: Wed,  5 Feb 2025 14:43:00 +0100
Message-ID: <20250205134512.973834704@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit f055feb49c1c4333abb80ce1e9d93841cf74ea84 ]

This code accidentally checks ->ctrl_base instead of ->mbox_base so the
error handling can never be triggered.

Fixes: a4123ffab9ec ("mailbox: mpfs: support new, syscon based, devicetree configuration")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-mpfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-mpfs.c b/drivers/mailbox/mailbox-mpfs.c
index 4df546e3b7eae..d5d9effece979 100644
--- a/drivers/mailbox/mailbox-mpfs.c
+++ b/drivers/mailbox/mailbox-mpfs.c
@@ -251,7 +251,7 @@ static inline int mpfs_mbox_syscon_probe(struct mpfs_mbox *mbox, struct platform
 		return PTR_ERR(mbox->sysreg_scb);
 
 	mbox->mbox_base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(mbox->ctrl_base))
+	if (IS_ERR(mbox->mbox_base))
 		return PTR_ERR(mbox->mbox_base);
 
 	return 0;
-- 
2.39.5



