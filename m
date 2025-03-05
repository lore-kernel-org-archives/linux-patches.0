Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A146ADD;
	Wed,  5 Mar 2025 17:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197052; cv=none; b=bOR04v6cjrP6IBdjSPPAhPQUeySpfywWJorewxN8FMjChztGRbCJ7+dzNqUwRSkO7XTPRYQ+R+IK3rXFzmvHWn0QrpQZlhIp9bhK14yGAqj0BEEvrkexnQtW43+9o17XMB+zWxc+LFAEO9tnaT2R/SERG3DYLct1uzsetUR6+gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197052; c=relaxed/simple;
	bh=qlmUkqcHIkGdhRwb6GtT3FlXoAaRdma/TgTUbq6psDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rakmRieM1QjxBSxFfpPQE4mLUsBohXcR/AlJitstxE+55asz32Y2apX4BNyOm6NG6pyzsBfaysYxNYe1zDOl+xR6QE0XHxvoVQ6JLkRgSPz+bjozKJCZVehKnAh17vD/UMzNep2igu7LdZJvzdrFyJ5CSnzFm/hHYrzKGJ5KIcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMM7v39T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMM7v39T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D78C4CED1;
	Wed,  5 Mar 2025 17:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197051;
	bh=qlmUkqcHIkGdhRwb6GtT3FlXoAaRdma/TgTUbq6psDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMM7v39T0mFzq4WDEoyIOjZX/5FPHC9yd0qYd/StFU/wA4PsVQabjPwIBsyXGTPcw
	 QFe5ZM4SHnM+tm6JRjz8qkLjTs5vhdXx5dTjFNqgdGHtaXvXtxNtohtoaoSsLDa/i+
	 xy5TqvoHmYms/X0BHVbhPknQKIJNKxSmh0hJCBDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/176] ASoC: renesas: rz-ssi: Add a check for negative sample_space
Date: Wed,  5 Mar 2025 18:46:31 +0100
Message-ID: <20250305174506.352166983@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 468050467bb39..12e063c29a2ab 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -483,6 +483,8 @@ static int rz_ssi_pio_send(struct rz_ssi_priv *ssi, struct rz_ssi_stream *strm)
 	sample_space = strm->fifo_sample_size;
 	ssifsr = rz_ssi_reg_readl(ssi, SSIFSR);
 	sample_space -= (ssifsr >> SSIFSR_TDC_SHIFT) & SSIFSR_TDC_MASK;
+	if (sample_space < 0)
+		return -EINVAL;
 
 	/* Only add full frames at a time */
 	while (frames_left && (sample_space >= runtime->channels)) {
-- 
2.39.5



