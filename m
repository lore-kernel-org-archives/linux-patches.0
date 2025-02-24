Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B538189919;
	Mon, 24 Feb 2025 14:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408436; cv=none; b=ovLIadHX/lQqLAd/aOCW2+hlBiUBdfgG0Q3nl08b373wHpFZsc98G2o4VZQFayIReg5ho9WcN/ZHXDGL9qd7/njIS9ucDI2e73opde4XZAyN/HoRXhC6KySESTojcscjnubl+PZUDUhGCk78s7mmhEjZ9zftuD9XHrXi0sAPGDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408436; c=relaxed/simple;
	bh=Z5u/lBxIPfrSHStZ172akTW2SZBJqgRypqOzzZzQDeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhL8Nq4vloHEuvnG+DOGVXZVYc09KcEZ43mD3XwtFNjTDb1d0mDbAF3SiA/CW1N1QuFeGLul/tK709Epb+jA9zzHjWMYRCUsxA4/p2kURDE/6XhtLLOadTzrUDfA+4WGDPSS6a6Txopb8RQvGQd8A4cpRvYfRCE041zfxVqqRhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JX3Zhd87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JX3Zhd87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A1AC4CED6;
	Mon, 24 Feb 2025 14:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408436;
	bh=Z5u/lBxIPfrSHStZ172akTW2SZBJqgRypqOzzZzQDeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JX3Zhd87U6T4oZAyfA/Vn5MFU3CN8joHZIk7bk+uMNFnEXnDTLGgM5N4+KqmO2bu6
	 XykZm/JVm7WjtyVkDEMMMHWpxn3XWsFJJQJwoCFZ393u5teOPZJWYPlCTar2ttiLHG
	 xa55Sj9jg59iAnShthk2fOqafxhVO83FqHnGQ7VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/154] ASoC: renesas: rz-ssi: Terminate all the DMA transactions
Date: Mon, 24 Feb 2025 15:33:44 +0100
Message-ID: <20250224142608.068117202@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 541011dc2d7c4c82523706f726f422a5e23cc86f ]

The stop trigger invokes rz_ssi_stop() and rz_ssi_stream_quit().
- The purpose of rz_ssi_stop() is to disable TX/RX, terminate DMA
  transactions, and set the controller to idle.
- The purpose of rz_ssi_stream_quit() is to reset the substream-specific
  software data by setting strm->running and strm->substream appropriately.

The function rz_ssi_is_stream_running() checks if both strm->substream and
strm->running are valid and returns true if so. Its implementation is as
follows:

static inline bool rz_ssi_is_stream_running(struct rz_ssi_stream *strm)
{
    return strm->substream && strm->running;
}

When the controller is configured in full-duplex mode (with both playback
and capture active), the rz_ssi_stop() function does not modify the
controller settings when called for the first substream in the full-duplex
setup. Instead, it simply sets strm->running = 0 and returns if the
companion substream is still running. The following code illustrates this:

static int rz_ssi_stop(struct rz_ssi_priv *ssi, struct rz_ssi_stream *strm)
{
    strm->running = 0;

    if (rz_ssi_is_stream_running(&ssi->playback) ||
        rz_ssi_is_stream_running(&ssi->capture))
        return 0;

    // ...
}

The controller settings, along with the DMA termination (for the last
stopped substream), are only applied when the last substream in the
full-duplex setup is stopped.

While applying the controller settings only when the last substream stops
is not problematic, terminating the DMA operations for only one substream
causes failures when starting and stopping full-duplex operations multiple
times in a loop.

To address this issue, call dmaengine_terminate_async() for both substreams
involved in the full-duplex setup when the last substream in the setup is
stopped.

Fixes: 4f8cd05a4305 ("ASoC: sh: rz-ssi: Add full duplex support")
Cc: stable@vger.kernel.org
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20241210170953.2936724-5-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rz-ssi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/rz-ssi.c b/sound/soc/sh/rz-ssi.c
index 32db2cead8a4e..1b74dc1137958 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -416,8 +416,12 @@ static int rz_ssi_stop(struct rz_ssi_priv *ssi, struct rz_ssi_stream *strm)
 	rz_ssi_reg_mask_setl(ssi, SSICR, SSICR_TEN | SSICR_REN, 0);
 
 	/* Cancel all remaining DMA transactions */
-	if (rz_ssi_is_dma_enabled(ssi))
-		dmaengine_terminate_async(strm->dma_ch);
+	if (rz_ssi_is_dma_enabled(ssi)) {
+		if (ssi->playback.dma_ch)
+			dmaengine_terminate_async(ssi->playback.dma_ch);
+		if (ssi->capture.dma_ch)
+			dmaengine_terminate_async(ssi->capture.dma_ch);
+	}
 
 	rz_ssi_set_idle(ssi);
 
-- 
2.39.5



