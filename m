Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D476BB5B;
	Tue, 12 Aug 2025 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023386; cv=none; b=GDiymHrtUMLy1iyehh6itZbXnL+69AIBwkZ0oBxN2FlLeXSkUkyKX0/FEFf5IMiIwUtH47phitr+J2Rp/bXY8h19WKSxNGWoxIleHDhaQUMPoc+lU4brYrGyb9OvctSqwf0uGwkLRNIJm25ZBHFTQB9Vt4NYqra9vrhMX+EB32w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023386; c=relaxed/simple;
	bh=EznXsfCJZh+y9395wBjrBDI10+r8QC8COSPGobHgLPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hh12KBfASA3n0NsYH8gMuvA1X6ZQ9r6jPxO1t7DUltp8tSn1hMZy+fGzNORzBt8jkRqOcP02LExZrO2hO8qSap6CivHJIlfxLzKhe6BzJ6c/HlmyekooU+VRXdIO3oAKKeezwXZE4clfMIsdjY/7M1ns9WYy19oy3naUFyVKmhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGpykUz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGpykUz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71536C4CEF0;
	Tue, 12 Aug 2025 18:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023385;
	bh=EznXsfCJZh+y9395wBjrBDI10+r8QC8COSPGobHgLPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGpykUz4H7O+EFZMS/5F/88AGDG1z2OIUr2EfaBVUk43DWxz63ydFe/0nHZM6/b6w
	 RDzHzZe49O+cTQNUjs+y8yOjhe1bagTR4tvmXgytfIpku1NwmzKCheUh99qUzc3vQf
	 jcT3maqMs+mWLcKOkZ7s2ohP7cQxid+siaWLzMCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 031/627] ASOC: rockchip: fix capture stream handling in rockchip_sai_xfer_stop
Date: Tue, 12 Aug 2025 19:25:26 +0200
Message-ID: <20250812173420.511793054@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 5dc302d00807b8916992dd25a7a22b78d07dcd03 ]

Correcting the capture stream handling which was incorrectly setting
playback=true for capture streams.

The original code mistakenly set playback=true for capture streams,
causing incorrect behavior.

Fixes: cc78d1eaabad ("ASoC: rockchip: add Serial Audio Interface (SAI) driver")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Tested-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Acked-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://patch.msgid.link/c374aae92c177aaf42c0f1371eccdbc7e9615786.1749201126.git.xiaopei01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_sai.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_sai.c b/sound/soc/rockchip/rockchip_sai.c
index 602f1ddfad00..916af63f1c2c 100644
--- a/sound/soc/rockchip/rockchip_sai.c
+++ b/sound/soc/rockchip/rockchip_sai.c
@@ -378,19 +378,9 @@ static void rockchip_sai_xfer_start(struct rk_sai_dev *sai, int stream)
 static void rockchip_sai_xfer_stop(struct rk_sai_dev *sai, int stream)
 {
 	unsigned int msk = 0, val = 0, clr = 0;
-	bool playback;
-	bool capture;
-
-	if (stream < 0) {
-		playback = true;
-		capture = true;
-	} else if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		playback = true;
-		capture = false;
-	} else {
-		playback = true;
-		capture = false;
-	}
+	bool capture = stream == SNDRV_PCM_STREAM_CAPTURE || stream < 0;
+	bool playback = stream == SNDRV_PCM_STREAM_PLAYBACK || stream < 0;
+	/* could be <= 0 but we don't want to depend on enum values */
 
 	if (playback) {
 		msk |= SAI_XFER_TXS_MASK;
-- 
2.39.5



