Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EEE582BBA;
	Wed,  9 Sep 2026 14:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963686; cv=none; b=tMAEkSemVf7m5fsHiTrCdZAp1YyT7TfkSnHXgMq/2rEm0wvSKCChFnfbkxJtB8JjcueILudLdb7+2bwDIIJqwhxf7T14qRQUr7rvPTmV0xjj/pa/RjEM9BBTLldr/ScCiiEzcXhrje7FOtUMMvkfysgaQG70tGHtO8gh/7AGMCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963686; c=relaxed/simple;
	bh=uWVPDOsE+t9sRBx+Deg0IF/s9nNaUroT7X00xDQEoyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jS89weYEqJzUSN9m5U5OcdNPJJgqlwxwz+jR93CGKQL6q1pfk2KbPFiCleuR3JvK1h/vUp7sUOP6pK2C9+flR5uuMn0xDo/Omdo/4rNUK9N1Q5r2JItxVn4kB+R2O5SJs5TePNW7HYzIo8iRlZH1tawEhwe9Flok9JGwnE/uZVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQLUsYSV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQLUsYSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759E41F00A3A;
	Wed,  9 Sep 2026 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963685;
	bh=GGmWT+1x1JK7OzBSiQDoru+LTQvxOqTnEH5rPRwXiq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQLUsYSVktYp4iawO42fg8N+6O8j8uRwMDahyuPRz/cZtwLKLWh6fiDOU8ls02w95
	 BAQxtl60GFqM1EcBgbswFADgh62PL0eV3d+XzFns9TMUbeXET99aP8+TTEXva99aD1
	 L9KJ64n5jZfst0GTMybt/nddqRu3ZnCglrEo8lBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 162/583] ASoC: fsl: mpc5200-i2s: Free DMA resources on probe failure
Date: Wed,  9 Sep 2026 15:37:27 +0200
Message-ID: <20260909134243.824415096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 3a89ddcf0c3d9a068631e8c24d5c9e81d1e6512a upstream.

mpc5200_audio_dma_create() creates the DMA resources before registering
the component. If snd_soc_register_component() fails, the function
returns directly and leaves the DMA resources allocated.

Call mpc5200_audio_dma_destroy() before returning from this error path.

Fixes: f515b67381de ("ASoC: fsl: mpc5200 combine psc_dma platform data")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20260622094822.926166-1-haoxiang_li2024@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/mpc5200_psc_i2s.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/fsl/mpc5200_psc_i2s.c
+++ b/sound/soc/fsl/mpc5200_psc_i2s.c
@@ -170,6 +170,7 @@ static int psc_i2s_of_probe(struct platf
 					psc_i2s_dai, ARRAY_SIZE(psc_i2s_dai));
 	if (rc != 0) {
 		pr_err("Failed to register DAI\n");
+		mpc5200_audio_dma_destroy(op);
 		return rc;
 	}
 


