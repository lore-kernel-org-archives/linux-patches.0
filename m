Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8BC326939;
	Sat, 12 Sep 2026 13:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221579; cv=none; b=Q8/06dyUwIgUVENe3PKAbs7PniAGYGIH/m0jjzBfp2MOWmAUtWR7T6UJVdGGMaTxunuByqdOMIFlmSNwnRk/xRWWxC5otmHaIEuTkwuCrBKN0YjDr6SdulJ+8s7jJeDqhBo8e+VNnYhS39G8iPqL6PCYP7yQJWXQ2U8jcnED/wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221579; c=relaxed/simple;
	bh=Y3q1Ov/jn/cL+w1HWCcXYD7G2wbsgdIlCgtq0HyztC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFPyAVSrPmep6zYWrY1YtPkSuFOE3LAC3/LB1Y+TH6YdTqdMuq+36DpV7bgJB+/IFEFY6JC5wrZSm2k0VhIyxhHxKllbYymSUGO4biDuwGH83dufZyaDjXcHsHRXTKjapk5t1BtcglEJMLr5MXV6i8RzUhTTDbwUFB+5QilBx3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5O2n+Mo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5O2n+Mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5071F000FF;
	Sat, 12 Sep 2026 13:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221573;
	bh=y+UcfH/bc0G9CvRjlZWJaAx+4eIIAQiTtiJF0gfGPJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5O2n+Mo4UmZRQ5fbZRzSEyAAqxIeO5qBA3jwz+XxzhS7VXTl5BiCC6HRGiPKSrXD
	 jz4cPjG6gMFvGvWn2sIG6/k9NeOOD4y2GHDQ+6tDNgINnZhB3KT/3aTjIX9oglXZsR
	 7TB1wvZ/S2DZc0/8+SytvFheTpD1fpjO9KwKOuKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0410/1424] ASoC: fsl: mpc5200-i2s: Free DMA resources on probe failure
Date: Sat, 12 Sep 2026 08:47:22 +0200
Message-ID: <20260912065616.464942214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -171,6 +171,7 @@ static int psc_i2s_of_probe(struct platf
 					psc_i2s_dai, ARRAY_SIZE(psc_i2s_dai));
 	if (rc != 0) {
 		pr_err("Failed to register DAI\n");
+		mpc5200_audio_dma_destroy(op);
 		return rc;
 	}
 


