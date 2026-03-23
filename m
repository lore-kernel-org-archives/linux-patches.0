Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69643AEF4E;
	Mon, 23 Mar 2026 14:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275291; cv=none; b=ndpt1zC4ytjg8WKmLBe+20bh5rhGFGkRB7q/2IvfY25RX8Bd7FrItqQzsE/x0CTurk/M0BXCdeBLSsR67KstHq0RWQpgZzPRlIHkfKXL6nPFaunCYxII8by0aQTNcHCH8faofLdS6m0Agi1JAa4yifTO1tfMlnjqa2MCaZHrbb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275291; c=relaxed/simple;
	bh=wVAAR6h4eRmlZTtnwlQAVHMOgbcVxbijM+4imP8iHlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o27sUVkmehu0dutbPp7saXBZIe5T7CYLmJqe5CVTtD3Psw9Df3Xsk2zwQA78FxdP6VzdDSO2FbEof5LhvbPAbHLKVniflgv2DBQ0h42leuIr4oQcFiV1IocyoYLGFvv8lE9jFtqug80htMqcS2JoII4ruSNnVocrO6t3Z6CknZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpfr2cxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpfr2cxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48962C4CEF7;
	Mon, 23 Mar 2026 14:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275291;
	bh=wVAAR6h4eRmlZTtnwlQAVHMOgbcVxbijM+4imP8iHlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpfr2cxiutcnp9fWig+yw5Ik0QxLF/fo/mr2D2MsMxkTGf3lVO69rCxSxJTGjvLTb
	 8Cno/RHvDWKaYTx+TJzkO4BmAGGGaeAlqYwnoZ4wTem/A6JsD60RxqCACQO6Tutelx
	 TGynlSS6k0RnAcZVZuEKWMr66BVTjgpm418+fh9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Cotifava <cotifavamatteo@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/460] ASoC: soc-core: flush delayed work before removing DAIs and widgets
Date: Mon, 23 Mar 2026 14:40:39 +0100
Message-ID: <20260323134527.770796713@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
index 791197c1e05b9..ea6b39003461f 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2114,6 +2114,9 @@ static void soc_cleanup_card_resources(struct snd_soc_card *card)
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



