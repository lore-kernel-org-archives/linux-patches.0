Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042DB33B961;
	Tue, 16 Dec 2025 11:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883985; cv=none; b=EySbCUuq1f07/v8yeMCka0hLlfNiLBGedbwUFbDtnKI/ES19kppQx5mHY0WtD5sO36CXO03I+1wV4v7jc9ElZAT/aY2RrNsVBhADguVNDrS4QsDHV6JXh3rKOWOwIaB2Zu0rNnWZT3QzH6CyvaABSdlSS61qqb90ZAhDuirUJMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883985; c=relaxed/simple;
	bh=8oCc4W9wzhxBGG1VB9jfF2ZKxyR1FLs0MRtDAl0HybA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn3DjwG/0o/OCKtRnZiRjOa58oGaY/YIV0pGqF86w6lVhSGnu/CRpzz2+YpU28yVmpg7YMwhRhR/kjOoGbkTcpI9WTyd2pFH3cySw7Dg3FQ24M3B+1sSzZ+RBKUw7jkN0oFoDwIhv6XMj/8X/Q3y9SETB/42JjfSfK0dW88vt4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdKrA/k8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdKrA/k8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECCFC4CEF1;
	Tue, 16 Dec 2025 11:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883984;
	bh=8oCc4W9wzhxBGG1VB9jfF2ZKxyR1FLs0MRtDAl0HybA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdKrA/k85hN2k7MG4Fs/EUzatwEQzfCV0IjKIORMMATuQ4lBX1v2hQFeZaURlmH39
	 jqZZpiq9FFgbo9NGhOXt4Biy0BbxUeBjJruzOXZIjkjITtQIBFexcAVb0EmG04XYHS
	 iBGZfxF511/PsVEPlqN+5fX5R8v63fgzZWCba344=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/354] uio: uio_fsl_elbc_gpcm:: Add null pointer check to uio_fsl_elbc_gpcm_probe
Date: Tue, 16 Dec 2025 12:10:24 +0100
Message-ID: <20251216111322.984537166@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 496caff66e7ea..dcf08042e894b 100644
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



