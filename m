Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31AE345EA7;
	Sat, 12 Sep 2026 15:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228206; cv=none; b=j+8U04pE8SdzyXuDMSG2ep/hGgIWIVmpAFsGVpzqj5B0w+oEJ2z8l2Ok56WSRtZfUtbDLU0HIqroHu0FUwJlWtoMHEJQ6gKAcXKhbRRwVy1/NLdF5Yj2JTdZxMKtZK6cZ0Q5vH9rMcPQwJR/vMRyorLwqWvn2zv3acF7tzAFbOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228206; c=relaxed/simple;
	bh=zf81fLzlMUYOQ/l6uyHw3VhZzdVZ9qwIr9Oj1fJYc68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/2C4EEDGpV6ae3a2e1FjSZ0Pg1DxWA/DP6ISGJwoqhreOyahEJpVCptwqiGQqQopWtsQ8QCJHkSsX7Sbd7azS1qHKcpuKPUPJiButR9yOwBMgknMeflh8duEl+TizA4u9sGtwSiADkzVM22GYVpMgLVPvo1Of2103TNy8e4fGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/G84L8r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/G84L8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A961F000FF;
	Sat, 12 Sep 2026 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228205;
	bh=ND18/QIxZyQMBWS0d5m3eG6SaEoWiv+05QRcx6vZOE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/G84L8rD/TGE3m3LgRFmN/P3uz9UPwMTTBCYTpkiiIG6Wr3FAZ6SpE9iG20+lijx
	 D9ZtRZq1zs8T/6OVo+h/MSZ+N57Qv4JoNTdeiDkKlt0z91HfYivslp23aSPCtkm6pX
	 gBqBBRigoMxpNp2H0l67TRozFQEHqOnjy78s44V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0339/1191] ASoC: fsl: mpc5200-i2s: Free DMA resources on probe failure
Date: Sat, 12 Sep 2026 08:51:07 +0200
Message-ID: <20260912065555.841828114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


