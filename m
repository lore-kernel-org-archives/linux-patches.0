Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8F233C511;
	Fri,  9 Jan 2026 11:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959513; cv=none; b=Nw7ikxTCz1khBZe/FBtkIUtqKBFa8+aEY320auKfeM2zCOANkV5FysY8xqH9VVQlMVrLrOtnd0pDkzoRyelWp11ZPNOC+gwC0UXB5ZxgX5+np2Hp9xjfzzO0gjF/9YOFL89A6mUBLmicVbaPo/KQs19nDVJn1iIHaVBtfVNzFto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959513; c=relaxed/simple;
	bh=+e29otBe0yEWImE7S6vbzG8yAHMDth1u0SyVF/FZi9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmpcnA2ZlEVVHt2na5j5m7CokMgh7PEMbIPQ7+F7sYv5Og2dR7BBPAB89Ssrr70klVOHkPqf4dJesXkgKqL2cG6Ym8F9XlDAtKSCpkTWyzFh3KYQjIdp9Qm74tBeYgzw5kU2gFetyY2/hrnqT5JcxqhybJUVpCJijw03tFLaY4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpkaskuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpkaskuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8CDC4CEF1;
	Fri,  9 Jan 2026 11:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959513;
	bh=+e29otBe0yEWImE7S6vbzG8yAHMDth1u0SyVF/FZi9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lpkaskuGAgZ1FqTSHlbo+qc8kmTZ9/7yB1HiBdihuYY+BGeQgLbxC3phHZZucl3LC
	 BOLaXqeuqD/z4a8YOTyp5pZPey2DAXMQzmu0XOMF7mWhSZolPDXMTnHJtkiqy5J6Fs
	 pIvAcu9XspJQ0Qc6rA82sznDgOrPBLPd8GOCB1fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/737] uio: uio_fsl_elbc_gpcm:: Add null pointer check to uio_fsl_elbc_gpcm_probe
Date: Fri,  9 Jan 2026 12:33:38 +0100
Message-ID: <20260109112136.967360189@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 82dda799f327d..a433bc84313fa 100644
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



