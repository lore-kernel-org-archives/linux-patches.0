Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B828F35DA68;
	Thu, 20 Aug 2026 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247344; cv=none; b=KYQGRo6ohl3E9q1no2fPFv4fglW35FtpxlHA1yhWZALViqIHDHmxEBjDZc+nRXoLSamDn2JBkiyfNbpaN8KLiV2Czh1A/7F1lGeiL2RYyXYtYKKQKFeePANSSiVXyJmbNkdfz/942mz0eACDdPb88ka9F0ZQ7POZhKSyP2koFfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247344; c=relaxed/simple;
	bh=JXiBwqlsXmFBE9S0Wz1ZxsJt7nA6ZsXRMC3sGuHRDIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oupn9HzthtGXV0Xr3nAEjWB0HUGVkN8S+hUni5M1zWftt68GeHKaajnfYVw7qXqicIeXvViWvpN965MinIcxNZXj0OA/GuBoAyF8uao/5HzaPnp7959fIrB4KIRx7QyTm1FFnn82ZaGVzW4S+UcuoT02hwsByoZiCkR1V6Zwdco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hg/il3OO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hg/il3OO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221DF1F000E9;
	Thu, 20 Aug 2026 17:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247343;
	bh=A/zSd5/KoxXlojgiSfFm1ZcXDlto/CEg5hkOqDn7xco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hg/il3OOnSM8rnMg/FZv/hbovbM1n1u85dCp8dAXHgmQ0PHdVxySb7J0FkXNnF8i1
	 zbhEDM45795nxPWrg+/JnEjCsuDAvblXVHv+dCcvdncN/7jCNkMSkI6Iui0jaf8GRT
	 a4wt7btyqLZm3dYhj47Y5wxGkFrSbuE9hfymiW3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 014/166] ASoC: SOF: sof-audio: Fix error path in sof_widget_setup_unlocked()
Date: Thu, 20 Aug 2026 16:54:33 +0200
Message-ID: <20260820145211.619048025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -139,7 +139,6 @@ static int sof_widget_setup_unlocked(str
 {
 	const struct sof_ipc_tplg_ops *tplg_ops = sof_ipc_get_ops(sdev, tplg);
 	struct snd_sof_pipeline *spipe = swidget->spipe;
-	bool use_count_decremented = false;
 	int ret;
 	int i;
 
@@ -218,9 +217,10 @@ static int sof_widget_setup_unlocked(str
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
@@ -235,8 +235,7 @@ pipe_widget_free:
 		}
 	}
 use_count_dec:
-	if (!use_count_decremented)
-		swidget->use_count--;
+	swidget->use_count--;
 
 	return ret;
 }


