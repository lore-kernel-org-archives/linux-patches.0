Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9632D360745;
	Thu, 20 Aug 2026 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238720; cv=none; b=O4FE+5eXr8FGRjMA5nK3su4P3JZd1sLrv2c7rwXvORiIbh2wbwilqnDK0ppgeLaL4nXStUpWiHaRVpG6yxVwB35hmmtgBLH6E1lU88kROeSxHeYnpWTvmnp7bsulVE/LV9UHaLw0+BNWzV67CGWITVNALCMaFdikwXMz+8sEkmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238720; c=relaxed/simple;
	bh=s8dFBS4fnlmhHMqX5NGKsw1vHyz20WEQWVZ8Ps3BqJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXv/Kf6++QEZEWd3E+3WYyX7YfQgO2b9k5hNv3+8OCkgN/lIpoxECPk1Wcevvr0a1baNwiQPvdTnh9lMGcSt625fmfosZLSVrG3fh+oUuOBlpO4UxZ9WZ0Sd9qWoE2tFfvuvt5yUyGo7CbEHiLcXTYGX4kDQ2lXxUk8l3W8Rga0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fRDQMlB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fRDQMlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05711F000E9;
	Thu, 20 Aug 2026 15:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238719;
	bh=L/JxAs0iBggb9jHqZpUtZuoGzTJ7zVhBcIMIeSACzbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fRDQMlBzJ6UVXr1J6PVCL5BlJ2BPwDK1UAzl7D2ZX+CAppoa8qQ94iu1jtix+iyJ
	 VJCu2lpNrH3cd6tisJ8uSrOOHkS0wM35UkiJJ2mWHn1MCt4wyYiEicdtta0rDzL4QL
	 7EmHzyxrZIslrtlEQDaY1SdipO5eJT96sHa5uc/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 018/217] ASoC: SOF: sof-audio: Fix error path in sof_widget_setup_unlocked()
Date: Thu, 20 Aug 2026 16:53:06 +0200
Message-ID: <20260820145238.172623977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


