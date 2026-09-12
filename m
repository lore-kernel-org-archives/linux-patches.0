Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A154274B46;
	Sat, 12 Sep 2026 18:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237591; cv=none; b=DYaLt1qbyqGUSxlrIerN08sMxymzr81RFbkWLwVQenQEN8wmvs8UQWjXUvF/FmSAHQHUtjmMYTKhwPorg7HSHMMfpPVAyIpisx7Fgsx0JAiBlKYTkoFLRyrogjDLR8uVV5iTfCAFasRcoRqclMCS7fOfPQmlSI3brxTzXayZqLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237591; c=relaxed/simple;
	bh=LyITAxRKeJFlADKuNLassTVqVVcPH7Q6OFPVfKKDQ4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZU9W7e39pS9uJ48kJlSUK1MePtM+3gNIl91srawWSmv32Q+Hozsu00DlruhMYj08YXnw6+2QSYPE53si6VzoqTvVZQYJpRCHFGkEavnTBziW2JYtrjAlRwP4uiMePZfuLFoxxJvZO5KcDvq8K6pI8f1LhWsTrDC3UztNQIsccek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uO+strpp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uO+strpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07921F000FF;
	Sat, 12 Sep 2026 18:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237590;
	bh=TCfAsoY+rTmRzwVbqpDGuDL11Mg4BbJAk4b4dSNLk6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uO+strppnqyS5cWQsA+Kom5F9Jf83YYlki0xQHG9DPi3ujX58s5YK+C+QUkDsXMQW
	 5+a6HiDnZ3TzRL5eAno9Xlh9WeLq0+DqekX7hDBDGp0b1cmz5f7HtUFGb/LfWoffOu
	 3ivxI9LMlkhVdChJomx4rK1KOWPkTfMnSJtHzLfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 288/935] ASoC: fsl: mpc5200-i2s: Free DMA resources on probe failure
Date: Sat, 12 Sep 2026 08:55:18 +0200
Message-ID: <20260912065533.419991540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


