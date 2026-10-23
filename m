Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774620;
	b=giZlBU6ZbcfXYwbww5YWd8VbuYd99Rf4CCZMy9lT7k2OcvfsDafdDPZOzPNqqXJbHxy9
	 G5pBs1E9o+qozQBgaEsSRSw2atrvb+Mxyc/SS1nGOudR7HyJHydhfaYxxarSGpwYYfkxf
	 HKpLI/z8g7ctVtU9WaeUpF94XKioFm3Vk895u3ip7/WQjPimoHQqTo8ovywjqdw08Eqle
	 ZSv1mqY0gfMyRhW6JMlCpMq5icgnhN7IUPYNusgIaukGhmRiJXjh2t5C9QiraGAQqjv7Z
	 A9cLxHHPRcHw1zljA4NOdHJKlx7Ps6qi9kyrX7fTFyD8lhMm4uo6YDoAkTWUC52bqVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ox2dlKHl9rLEBNSHBeX6UD0TdH988KXtQslWiJipwyk=;
	b=J6TsbSg9VwhDgO8SPeuQG1/DoWZeVwgaexiENxaqFAv3nZ10AhEdzLmue14kDDK4kOfb
	 SHvehTy2oceckrOAvmXhA3RNM8AEFa+7aWfFD2L+IAt2IseHVIiY4EsCxLelrwkPLq9Io
	 LWf/G2bU5tJVBB8x0BtBOqONXCWxc+SXb1kLqhUf5hRj/3pgwMSEdFmN/y30deGT3wSBT
	 N1q1KKh6fn3tHnwauQWwy3qQhU1Qy1Wsn3wUhIob8R6vKZRPIAKiR7CsFf33zA9WSnCSn
	 WANdrvtzA8k4u0uAHkV+bBIGvk79Q6MJdz6aZphUnw5fnBj9pDj1e22FKqPQ1ZTqeTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bIYSXyTQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873E3606A31A;
	Fri, 23 Oct 2026 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bIYSXyTQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D593B1F01825;
	Fri, 23 Oct 2026 16:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774620;
	bh=ox2dlKHl9rLEBNSHBeX6UD0TdH988KXtQslWiJipwyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bIYSXyTQd442bpc+zErHxpTDA7l+5CzbM6GEmcnKdBLjcTGpm/oW2wWtm6ogxUVgG
	 eA/xKena8/14Vqpy28/uHU+msmQczSWIeopjajEkhPfx79Isup54L6NoCXrs5m01Yx
	 3P4P88KBeqyj931OUiFkFZpvvknFbq0Wdo9QJ7Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 103/242] ASoC: SOF: ipc4-topology: Fix shift-out-of-bounds for aggregated ALH capture
Date: Fri, 23 Oct 2026 18:39:05 +0200
Message-ID: <20261023163716.218609412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 746de48c3a250f0c264105dcbfcdf0c5001e970b upstream.

When ch_count is smaller than blob->alh_cfg.device_count (e.g. a mono
capture stream, such as a SmartMic, aggregated across multiple SDW
links), step = ch_count / blob->alh_cfg.device_count truncates to 0.
The subsequent GENMASK(step - 1, 0) then underflows step - 1 (u32) to
UINT_MAX, causing GENMASK()'s internal shift to use an out-of-bounds
exponent:

  UBSAN: shift-out-of-bounds in sound/soc/sof/ipc4-topology.c:2363:13
  shift exponent 18446744069414584384 is too large for 64-bit type 'long unsigned int'

Treat ch_count < device_count the same way as the existing "channels
equal to output reference channels" case: apply the same ch_mask to
every aggregated device instead of trying to split channels that
can't be evenly divided.

Fixes: 0390a102cc18 ("ASoC: SOF: ipc4-topology: use different channel mask for each sdw amp feedback")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20261008090130.15135-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -2352,11 +2352,14 @@ sof_ipc4_prepare_copier_module(struct sn
 				ch_map >>= 4;
 			}
 
-			if (swidget->id == snd_soc_dapm_dai_in && ch_count == out_ref_channels) {
+			if ((swidget->id == snd_soc_dapm_dai_in && ch_count == out_ref_channels) ||
+			    ch_count < blob->alh_cfg.device_count) {
 				/*
 				 * For playback DAI widgets where the channel number is equal to
-				 * the output reference channels, set the step = 0 to ensure all
-				 * the ch_mask is applied to all alh mappings.
+				 * the output reference channels, or when there are fewer
+				 * channels than aggregated devices (e.g. a mono capture
+				 * stream split across multiple links), set step = 0 to
+				 * ensure all the ch_mask is applied to all alh mappings.
 				 */
 				mask = ch_mask;
 				step = 0;


