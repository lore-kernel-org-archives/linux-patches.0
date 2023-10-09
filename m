Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0EE1A5A3
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgphnHXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8A8C433C9;
	Mon,  9 Oct 2023 13:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859251;
	bh=ZevweBLRoMFFI3Fo8w6WSL1xQyPYGt3A1/fDffetmdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgphnHXeqdplOSkDZi1Fgka9GFHq0eyR6t8ax26k2k6qe5nzw1MQGseMKdpGMZmDC
	 /LTrvzLfz1+Zi6fi6KfiY/DKc9SaIwOiDmwSUJYX8iqF/A5JkKglk2nLAt94OP2lfP
	 knPbgG3az6QLpxBmIptP8oUcv1l95RQDcLCV4jVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoke Wang <xkernel.wang@foxmail.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/55] i2c: mux: demux-pinctrl: check the return value of devm_kstrdup()
Date: Mon,  9 Oct 2023 15:06:06 +0200
Message-ID: <20231009130107.988339560@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>
References: <20231009130107.717692466@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit 7c0195fa9a9e263df204963f88a22b21688ffb66 ]

devm_kstrdup() returns pointer to allocated string on success,
NULL on failure. So it is better to check the return value of it.

Fixes: e35478eac030 ("i2c: mux: demux-pinctrl: run properly with multiple instances")
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-demux-pinctrl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/muxes/i2c-demux-pinctrl.c b/drivers/i2c/muxes/i2c-demux-pinctrl.c
index c638b2fc7fa28..647b5ff69a9cc 100644
--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -243,6 +243,10 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 
 		props[i].name = devm_kstrdup(&pdev->dev, "status", GFP_KERNEL);
 		props[i].value = devm_kstrdup(&pdev->dev, "ok", GFP_KERNEL);
+		if (!props[i].name || !props[i].value) {
+			err = -ENOMEM;
+			goto err_rollback;
+		}
 		props[i].length = 3;
 
 		of_changeset_init(&priv->chan[i].chgset);
-- 
2.40.1



