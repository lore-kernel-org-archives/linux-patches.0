Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D5C37C11B;
	Thu, 20 Aug 2026 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238108; cv=none; b=pmS+Vxh3EZprkz6hbNclV12vaG2WifOe6XOK3ZJIp3IZ2j/c6TXjn2wRmKh5lXhBEuZPAByzEyHFQnShS/6pqWQj0/bNj9hu8k79zNYsVuDaAhUQxqnAxZagGGl5xZcjH/gIUdirj/wDrQ7rTFGYy7DHF+iIUAjXyAIKpIKvjAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238108; c=relaxed/simple;
	bh=4E2/5M1jPKsxo5SfoQ1h+yYOE2LjVuybILpj2gnLZ68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERmIALYU96r5CxccElDe5NE/XYJzfBScxTfxR2HfBHp8+FCsSoXK5EkhA4/gDvkUtPV3/8sOnSJ3XXanLBx737R1YMmlEn5lUQMy5tqF+QX4cZEIWykhzYPV+xawhuEubggiX/HvQKeOPieIlKy/2wAYBICRFA+n9Jx+HqH3L1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Fel/S4t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Fel/S4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D041F000E9;
	Thu, 20 Aug 2026 15:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238107;
	bh=W/lLr20OPAW3oLR7nwLDhHvOlzRCJ6yy8y4WslOr+LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Fel/S4tICCtWOLfOgK0+TJn87bstqM1g4JXce1VhXPZMlDh9+nXivocU6kUW5t2k
	 JAILjua0H7p5MoxJKo7s1UPpsMsoZbDg17tqDgo8xyCy+r06+TGsKx3PCMOZAuBVeF
	 R4KK3GAgOqOLg0P+5khLx2cl4bf91QFalQ7gj6IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 017/228] ASoC: SOF: sof-audio: Fix error path in sof_widget_setup_unlocked()
Date: Thu, 20 Aug 2026 16:52:39 +0200
Message-ID: <20260820145244.988642291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -146,7 +146,6 @@ static int sof_widget_setup_unlocked(str
 {
 	const struct sof_ipc_tplg_ops *tplg_ops = sof_ipc_get_ops(sdev, tplg);
 	struct snd_sof_pipeline *spipe = swidget->spipe;
-	bool use_count_decremented = false;
 	int ret;
 	int i;
 
@@ -225,9 +224,10 @@ static int sof_widget_setup_unlocked(str
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
@@ -242,8 +242,7 @@ pipe_widget_free:
 		}
 	}
 use_count_dec:
-	if (!use_count_decremented)
-		swidget->use_count--;
+	swidget->use_count--;
 
 	return ret;
 }


