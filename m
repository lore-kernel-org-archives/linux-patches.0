Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480BC23E342;
	Mon, 13 Apr 2026 16:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098815; cv=none; b=rW5RTZgcIthsaLild19FBXED87PDPtsMJ//cypwzNtMTxRd1oS2J4WJDATaPCZZqqkWOPdU5NR6gHMxZZhFn7AuObZUTxp0fMuPbgQhp035O+2UqLYUAmKyw3i+b8mrJdIKG4lXfzr8zuJci0xdbEmaLxNdcU7MYhYnrXPtRjNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098815; c=relaxed/simple;
	bh=nJ7QoS90WipLbaqirFzE77SkGZIVrOb6M0FPkvyzBDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ix1BT3/oUn0pnT4W0IoVuTEF/uxgIWfgTHz1JTBvfw2TeDrubZ1rOfmo0tPX8mwYd+9pSjn3PMYZRoUczRSRK/FUmxHPm8iUMdXvWZtW1NKL1BAwdIayelqK8eS+lHXED1EthFMxM2zg8kDyvsY5h2OykRF91pqyOSeDONeMxMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHmqRQU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHmqRQU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AADC2BCAF;
	Mon, 13 Apr 2026 16:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098815;
	bh=nJ7QoS90WipLbaqirFzE77SkGZIVrOb6M0FPkvyzBDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHmqRQU4cjnh1SSQazrCFys3e4fp2ZsxSCMRt3InJG96i9X0iaw1eh/uFOlEhA0IQ
	 yg5iLGieP3082a5haKYPmX0E9yANvJ2Lfvktgl3Ci1TR2NQ1QaL6e/JAPOYGO0qqGp
	 T+0SxzoSoNQgEVhrW4RGQjLkkpIz4hSHdJRHMr80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Cotifava <cotifavamatteo@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/491] ASoC: soc-core: flush delayed work before removing DAIs and widgets
Date: Mon, 13 Apr 2026 17:55:17 +0200
Message-ID: <20260413155821.741739691@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: matteo.cotifava <cotifavamatteo@gmail.com>

[ Upstream commit 95bc5c225513fc3c4ce169563fb5e3929fbb938b ]

When a sound card is unbound while a PCM stream is open, a
use-after-free can occur in snd_soc_dapm_stream_event(), called from
the close_delayed_work workqueue handler.

During unbind, snd_soc_unbind_card() flushes delayed work and then
calls soc_cleanup_card_resources(). Inside cleanup,
snd_card_disconnect_sync() releases all PCM file descriptors, and
the resulting PCM close path can call snd_soc_dapm_stream_stop()
which schedules new delayed work with a pmdown_time timer delay.
Since this happens after the flush in snd_soc_unbind_card(), the
new work is not caught. soc_remove_link_components() then frees
DAPM widgets before this work fires, leading to the use-after-free.

The existing flush in soc_free_pcm_runtime() also cannot help as it
runs after soc_remove_link_components() has already freed the widgets.

Add a flush in soc_cleanup_card_resources() after
snd_card_disconnect_sync() (after which no new PCM closes can
schedule further delayed work) and before soc_remove_link_dais()
and soc_remove_link_components() (which tear down the structures the
delayed work accesses).

Fixes: e894efef9ac7 ("ASoC: core: add support to card rebind")
Signed-off-by: Matteo Cotifava <cotifavamatteo@gmail.com>
Link: https://patch.msgid.link/20260309215412.545628-3-cotifavamatteo@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 39d511c21796e..7ecbea296e917 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1938,6 +1938,9 @@ static void soc_cleanup_card_resources(struct snd_soc_card *card)
 	for_each_card_rtds(card, rtd)
 		if (rtd->initialized)
 			snd_soc_link_exit(rtd);
+	/* flush delayed work before removing DAIs and DAPM widgets */
+	snd_soc_flush_all_delayed_work(card);
+
 	/* remove and free each DAI */
 	soc_remove_link_dais(card);
 	soc_remove_link_components(card);
-- 
2.51.0



