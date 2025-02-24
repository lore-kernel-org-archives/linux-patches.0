Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856D318A6BA;
	Mon, 24 Feb 2025 14:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407906; cv=none; b=SxkHtvhxNCp5uIw2+Jb7Xf94rXSIocCOyC9YT5SsJzKUybR73e7p58ooY6ryKL/bEKWBZcF/1IcFG35PJ1LJN3UwwAw8x4uLRaVU9OAVx/riHfakWvUJPFKVZGmLMidME87y0vqSw/A5+EyNlFkJV2mfFAl8Wcsrte640avTi60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407906; c=relaxed/simple;
	bh=EaDiff5p/s+N1xi3h9UaA6cBs7nGnsn7BQMnVuj7yjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQfyREPJkfJLGvuUj7l1VS1owJQ63fn2jhYzmnFDZrCYPsDkl/69/j/RUrzW82CF15Wk3ByuDW2Sr4oU+ftHr2x1hVi0KelDs2j26Fm5T04QWXX2y+DvaGLD5ZUrMuWoDCEJ4+HxEcnMLuAscascUcONDC2dJX4MBeJ2zuyGuQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2ul/G/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2ul/G/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2186C4CEE6;
	Mon, 24 Feb 2025 14:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407906;
	bh=EaDiff5p/s+N1xi3h9UaA6cBs7nGnsn7BQMnVuj7yjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2ul/G/I1AsHJrANKRk3wX5f9lwhl4qCIJXNWJcf2AhsZGDP/ASNHGZTb3scSi5As
	 bpBQBnI/bSCJjnWBtZTr1sErJAuOObumrao2CTBxT07G25vBGK1lqvbe/WtpWa2jp9
	 j2wJCg2+Mek9Z8V8DCKkn8AsXFoycDzr8DNmbR6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/140] ASoC: renesas: rz-ssi: Add a check for negative sample_space
Date: Mon, 24 Feb 2025 15:34:03 +0100
Message-ID: <20250224142604.740499178@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 82a0a3e6f8c02b3236b55e784a083fa4ee07c321 ]

My static checker rule complains about this code.  The concern is that
if "sample_space" is negative then the "sample_space >= runtime->channels"
condition will not work as intended because it will be type promoted to a
high unsigned int value.

strm->fifo_sample_size is SSI_FIFO_DEPTH (32).  The SSIFSR_TDC_MASK is
0x3f.  Without any further context it does seem like a reasonable warning
and it can't hurt to add a check for negatives.

Cc: stable@vger.kernel.org
Fixes: 03e786bd4341 ("ASoC: sh: Add RZ/G2L SSIF-2 driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/e07c3dc5-d885-4b04-a742-71f42243f4fd@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rz-ssi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sh/rz-ssi.c b/sound/soc/sh/rz-ssi.c
index 353863f49b313..54f096bdc7ee2 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -484,6 +484,8 @@ static int rz_ssi_pio_send(struct rz_ssi_priv *ssi, struct rz_ssi_stream *strm)
 	sample_space = strm->fifo_sample_size;
 	ssifsr = rz_ssi_reg_readl(ssi, SSIFSR);
 	sample_space -= (ssifsr >> SSIFSR_TDC_SHIFT) & SSIFSR_TDC_MASK;
+	if (sample_space < 0)
+		return -EINVAL;
 
 	/* Only add full frames at a time */
 	while (frames_left && (sample_space >= runtime->channels)) {
-- 
2.39.5



