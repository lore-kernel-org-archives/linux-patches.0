Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395F03624A1;
	Tue, 16 Dec 2025 12:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886932; cv=none; b=XDD59KgbI7TUDfSjvygA5H/qs/4SFA+wKEqOLxYXdEgUKCuaQ4oTxJln0Q6bMd69FesqGPQec5ALMUis1bRyq3gqEl6+ZQLwPyM9SNNGg1X6UfioR95sVmp1LpcWP762U6DTABNHjnrcGj8SlZHk4bE2bC2O5P3ifsppUebY7Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886932; c=relaxed/simple;
	bh=sPoiQuDLKUdP7CaCxxKrIRbfGRqlJgLIWSNLlWpcd/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTswJyYF8sQSDhuYrx9l7hGbPo3y5+nRlv3ld+xuJFZhlJGq7t7Hj4lD0VBEIQNn4KzokuDqmWfJIqhVqurwZboPCbrvQ0ZHys6r5Nm5DsihOTVwfRPL458S2Q9ufWeY1zPBJsri54/+QWSoKitMAMjv7TQG+QplsqFRntjxA88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYsg+i4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYsg+i4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5154C4CEF1;
	Tue, 16 Dec 2025 12:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886932;
	bh=sPoiQuDLKUdP7CaCxxKrIRbfGRqlJgLIWSNLlWpcd/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYsg+i4H2guBL6SzYibcTz/DyWO1fV6egi4ZbW6tlK4EJBvnDlOYNH1ABOtrda2Oi
	 yXjwKGgiT7Fl4yDvn58UF8RNsclaC+IaPRTDlidx9K6RKXKCLjGPQ8iOj65ePsp37M
	 F39P5dM5DKY/1aZ+x7LRF2JWmaRGyr8xPsyfQlGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/614] uio: uio_fsl_elbc_gpcm:: Add null pointer check to uio_fsl_elbc_gpcm_probe
Date: Tue, 16 Dec 2025 12:07:24 +0100
Message-ID: <20251216111404.106758072@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit d48fb15e6ad142e0577428a8c5028136e10c7b3d ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: d57801c45f53e ("uio: uio_fsl_elbc_gpcm: use device-managed allocators")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Link: https://patch.msgid.link/20251015064020.56589-1-liqiang01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_fsl_elbc_gpcm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/uio/uio_fsl_elbc_gpcm.c b/drivers/uio/uio_fsl_elbc_gpcm.c
index 81454c3e2484c..338dd2aaabc87 100644
--- a/drivers/uio/uio_fsl_elbc_gpcm.c
+++ b/drivers/uio/uio_fsl_elbc_gpcm.c
@@ -384,6 +384,11 @@ static int uio_fsl_elbc_gpcm_probe(struct platform_device *pdev)
 
 	/* set all UIO data */
 	info->mem[0].name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%pOFn", node);
+	if (!info->mem[0].name) {
+		ret = -ENODEV;
+		goto out_err3;
+	}
+
 	info->mem[0].addr = res.start;
 	info->mem[0].size = resource_size(&res);
 	info->mem[0].memtype = UIO_MEM_PHYS;
@@ -423,6 +428,8 @@ static int uio_fsl_elbc_gpcm_probe(struct platform_device *pdev)
 out_err2:
 	if (priv->shutdown)
 		priv->shutdown(info, true);
+
+out_err3:
 	iounmap(info->mem[0].internal_addr);
 	return ret;
 }
-- 
2.51.0



