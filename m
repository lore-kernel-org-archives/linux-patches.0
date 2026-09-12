Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B5F309EE2;
	Sat, 12 Sep 2026 19:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242003; cv=none; b=aZuPXtwbQHRhKQqgX/clbnGEIxUWBOH4NCcD2Sl2BIxdnqLCEuD8YHTfs3Hj0FxMyWIJD0BrtrWbszn6rAJlVYMe0KTa5GtMAYUmklPIKT5lZwSyawQZLCQnnQZQrYY2uDdHmfYQPK0oclPe1FG0tdo8Nt4UOp1QSQXbyJNjVl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242003; c=relaxed/simple;
	bh=RtC9o4dZGOfniHGFbvWH7XWbxdSbGf+CxTI6k7Q202w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfY7Fz3ZYxAQ0LZsVo5RVHN4YhUU6TWj7ewoW1RrELVKjXugnk3/cXFaAQN+1f4dOzw6bRLzE+ViwN9g+OVmQRpWb3xSEJ4Qdy0qqFWV65x2SIsl9xO3gT9wrWyGj2q3AFhCv4VbaHosTLY8gTS+KpwUPLys9RVVw5+6emwh8WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MN3NA+uj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MN3NA+uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43981F000FF;
	Sat, 12 Sep 2026 19:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242002;
	bh=EqXY5rcsUwvXeiX9cWOhq7APONXfIP3C49dFaC/cMhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MN3NA+ujRQUbqIpVrk1nqbm8i2exLB96eRgUBssBkz0nairNcn3H+TQbGhB6+mC1H
	 N/SkGcWIpAp73N9FvPvK7y/VqdXIIBsyUZKKqL52PMMoFj9n6cAMabNuwUvSGvtM1y
	 F25w0v+pBlrdfl5KLdyMm3WGRWGE0SeSVOyAJVtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 253/798] ASoC: fsl: mpc5200-i2s: Free DMA resources on probe failure
Date: Sat, 12 Sep 2026 08:58:01 +0200
Message-ID: <20260912065522.957535764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


