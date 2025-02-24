Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA2F2571CE;
	Mon, 24 Feb 2025 14:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408439; cv=none; b=UjlfIJC5IYSfMOiEpdeQPkj3KrNzRpS2aQrhe3KZI87AeUU685ze7KSSBLgl02XvN8PtoLyl68jOVzouBp/W7sWG5iRf8lFY069ws6lTU11mtCC+GXNM7DTqNRJoTsIhRegwe6NZIjx9auw3T/BNPwP220BeIu0vZE9J8MUtask=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408439; c=relaxed/simple;
	bh=W02ISFssbtXD5wXs8qbeSsDfbd41zDKgnNkovUqfHSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnIONzb5YZ0jFsDKBdcruVmleeWtamO3/Oco+i6ZvZd2L9MWS/H9ta5J4TC0XVxat7F6Kxn4mFjiSNXS9Lfy/KhnuRu5s6SOQxqxP7eaCkHUNt/OIgmlXa6G/fwQ9wUNV7WZTqiEvB0FnANzOxff1pgTa5t5JhOsxF7ZXCAN5Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lvfi0UYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lvfi0UYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF2CC4CED6;
	Mon, 24 Feb 2025 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408439;
	bh=W02ISFssbtXD5wXs8qbeSsDfbd41zDKgnNkovUqfHSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lvfi0UYRweSctLjhxnWzBg0NWq0mzYGO67cdMIDwHv/BWGjJqCamukIdw0Q+zqBod
	 2mOwcNU3PQTsYfJb2XjIh/0Wico68wkorzJDNqK8KPtTibZQUaeMBJ/wfgR8gUjOTP
	 /KDmghwURkfw2TkklGnfxMHhxPUYuf5t32Weoh6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/154] ASoC: renesas: rz-ssi: Add a check for negative sample_space
Date: Mon, 24 Feb 2025 15:33:45 +0100
Message-ID: <20250224142608.107743378@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1b74dc1137958..4f483bfa584f5 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -528,6 +528,8 @@ static int rz_ssi_pio_send(struct rz_ssi_priv *ssi, struct rz_ssi_stream *strm)
 	sample_space = strm->fifo_sample_size;
 	ssifsr = rz_ssi_reg_readl(ssi, SSIFSR);
 	sample_space -= (ssifsr >> SSIFSR_TDC_SHIFT) & SSIFSR_TDC_MASK;
+	if (sample_space < 0)
+		return -EINVAL;
 
 	/* Only add full frames at a time */
 	while (frames_left && (sample_space >= runtime->channels)) {
-- 
2.39.5



