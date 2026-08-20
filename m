Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6A63C3C11;
	Thu, 20 Aug 2026 15:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239367; cv=none; b=hHkwPmZv/fzEHvIh0gTdXKveww84Jy0nqtUvMc1BQvC9EWfP7bt1lSQBht2BvemNupGp+PdUV9bVaBp0ugS6LYzx3T8t57Fe2G1PCtnE8PoLQek/YWneBfdRLGzc/rGj5yf3TXVOWcBEn/nu83U8XSzAQ46OFBy25m3Wk8GD/uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239367; c=relaxed/simple;
	bh=lWqC7ptL2VsCc52nE7/8uKDsEtNc4fHqnH8CyJ6c+nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRiwncI07VH4N2SjCTv2xV9Qa4urh2BOzNsBvo6ttAzfw/hSUQUxCZ5PlAGkfiO4FR1ZSLtmCZHBe9uUdm9vIcvl777WC5dImJoUTX49i1FG8zQJ8a3KTD1eqPrC7K3UgqZzMwjNcriXyzmZRGHeWdYOTXOPcUmaEv9GacqVlck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FELzcAjS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FELzcAjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BC61F000E9;
	Thu, 20 Aug 2026 15:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239365;
	bh=YujshTKnjWEn/sr6uppXxkgo8bd0TkA7wR/r6aq7Dxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FELzcAjSr+tVYU7koV66oabZpJDWZtAL5qufmJ3TlMckxFnvx09Fh9I0rB4RGoQA4
	 p20niSBFEI0MdyjxHw6VKu2WQU0qO+dJhPnYADVICy3UVmCO72H6vkOKZXUttFerfb
	 AgddHimSH9j3qbOeYnOg/rn7PD6D1GdYS4iQhXAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 025/220] ASoC: SOF: sof-audio: Fix error path in sof_widget_setup_unlocked()
Date: Thu, 20 Aug 2026 16:53:35 +0200
Message-ID: <20260820145224.261312727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit e780e4917d43683224812400fe3dc4816fceba75 upstream.

If either tplg_ops->dai_config or widget_kcontrol_setup fail during widget
setup we would double decrement the use_count of the widget because the
sof_widget_free_unlocked() would be called twice, similarly the core_put
would be invoked twice as well.

Since the use_count and core_put() is handled within the widget_free
function we need to return without falling through the pipe_widget_free
label.

The fixes tag is picked to the last change around this part of the code
which is adequately old enough for backporting purposes.

Link: https://github.com/thesofproject/sof/issues/10826
Fixes: 31ed8da1c8e5 ("ASoC: SOF: sof-audio: Modify logic for enabling/disabling topology cores")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260730085914.27546-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/sof-audio.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -136,7 +136,6 @@ static int sof_widget_setup_unlocked(str
 {
 	const struct sof_ipc_tplg_ops *tplg_ops = sof_ipc_get_ops(sdev, tplg);
 	struct snd_sof_pipeline *spipe = swidget->spipe;
-	bool use_count_decremented = false;
 	int ret;
 	int i;
 
@@ -215,9 +214,10 @@ static int sof_widget_setup_unlocked(str
 	return 0;
 
 widget_free:
-	/* widget use_count will be decremented by sof_widget_free() */
+	/* widget use_count and core_put handled by sof_widget_free() */
 	sof_widget_free_unlocked(sdev, swidget);
-	use_count_decremented = true;
+	return ret;
+
 pipe_widget_free:
 	if (swidget->id != snd_soc_dapm_scheduler) {
 		sof_widget_free_unlocked(sdev, swidget->spipe->pipe_widget);
@@ -232,8 +232,7 @@ pipe_widget_free:
 		}
 	}
 use_count_dec:
-	if (!use_count_decremented)
-		swidget->use_count--;
+	swidget->use_count--;
 
 	return ret;
 }


