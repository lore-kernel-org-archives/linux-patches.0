Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4E74C97;
	Tue, 11 Nov 2025 00:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822372; cv=none; b=UZn6mY+h00Cm7PlUzcOT1gccIYr9ClDilcEPiUIW/j/QApLWbrpSvP2wjkAw1f6k+Nrj1dJIUQCPEqS81kRNFMbvFGw3eue+dInMMFEVvm+53K1wykD7OPrDSf/6PtZJdI1PTMhM+LZzkPzN5f/Z7gq6EB+CgonMO/yPNshkqqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822372; c=relaxed/simple;
	bh=XNth8ypXzmVZ9M+PqR+Txtlx1S5UOnIbaqz0O2FL+PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGXejYOoEVd2pEbnZ+sd40b/7l1WcIlYG0gqAHBrQHWU5xcwo+EQcgSFyTdd+6ZTzQHvW/pw2I5jhnstOIH3IzJzeedIn7ryyc706VRhmL6shDdoIl2d2mVeIrCY73gy73Yv+KQliPK+Ak5Y58dURsyBP4n4PKLPk54LyuLWKWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQ2pZwyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQ2pZwyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0ED9C113D0;
	Tue, 11 Nov 2025 00:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822371;
	bh=XNth8ypXzmVZ9M+PqR+Txtlx1S5UOnIbaqz0O2FL+PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQ2pZwyhKo+RlLZl9JMreyoCXhMsbAtXfj6meCG2B3iUYxF2HVB7u3XaDeqNNn74r
	 Yzs2WZ6O1mffSkIJRY9iEkXm8/CVIes8EVRPuazi8zpnTAvziue8//SyZ0qJfpTa7j
	 qUPK1A+hPS2kbINa3QbYLLdGXCzNDBQL0as64kFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/565] ASoC: Intel: avs: Unprepare a stream when XRUN occurs
Date: Tue, 11 Nov 2025 09:38:12 +0900
Message-ID: <20251111004527.702037861@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit cfca1637bc2b6b1e4f191d2f0b25f12402fbbb26 ]

The pcm->prepare() function may be called multiple times in a row by the
userspace, as mentioned in the documentation. The driver shall take that
into account and prevent redundancy. However, the exact same function is
called during XRUNs and in such case, the particular stream shall be
reset and setup anew.

Fixes: 9114700b496c ("ASoC: Intel: avs: Generic PCM FE operations")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20251023092348.3119313-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 15defce0f3eb8..3041717632ed0 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -653,6 +653,8 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	host_stream = data->host_stream;
 
+	if (runtime->state == SNDRV_PCM_STATE_XRUN)
+		hdac_stream(host_stream)->prepared = false;
 	if (hdac_stream(host_stream)->prepared)
 		return 0;
 
-- 
2.51.0



