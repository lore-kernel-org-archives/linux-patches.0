Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA9713D600;
	Tue, 23 Jul 2024 18:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760095; cv=none; b=GTIFj9gL0UhfQ+X1DshqP4bhBh0kFoeQelgrc766sleBvNqFvDQ6dFs5LEpBEFsa0DRDiEYcNCsNlRZJoxuzaKQgayKd2YWPKzWHVoR/00EjpF6Nq5Xzv1t7pxFFGJU3k7iCqe4nTGycfn7z82issj5nbJ416oH5S2MR0i4bQqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760095; c=relaxed/simple;
	bh=boQNfYcxqGs5+zlDj1f4mFQDtlgbabd9WZ7J5d4vPtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlqNeAjfajtKLG8Qcmb42MwOY1FiQkZK1A2X2SXxIEC9bKStN9z/R1gPf9OhzvNe5xb00/Db7Vp5lyvxPrEE5lgvM5wT7oJaXZ3IHjr+5uBGyZ8gTbY3AkUJJsa4+PGz5WKl5fxaulBXEzt18yIRYRSrvGoEx7bVBb5csTRAl60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFrJ5sxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFrJ5sxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181C4C4AF09;
	Tue, 23 Jul 2024 18:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760095;
	bh=boQNfYcxqGs5+zlDj1f4mFQDtlgbabd9WZ7J5d4vPtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFrJ5sxtOhfyaFaDCrT6u4ynPfkgHkB18dk00iSoPZciVHbfCDMTqQ7R/H9NPphVs
	 8lF9UzKD0ID2h2BMg5Dsyld+Ee6BL8B9CRFvgu8ySVUKvWCIZQOHKk/hTEBbcAv6XR
	 ZI7ZCXXPE1cNrp5NNMfV0yd2Ty4l1DNeQLr8Gk6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 099/163] ASoC: SOF: sof-audio: Skip unprepare for in-use widgets on error rollback
Date: Tue, 23 Jul 2024 20:23:48 +0200
Message-ID: <20240723180147.301152191@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 6f2a43e3d14f6e31a3b041a1043195d02c54d615 ]

If the ipc_prepare() callback fails for a module instance, on error rewind
we must skip the ipc_unprepare() call for ones that has positive use count.

The positive use count means that the module instance is in active use, it
cannot be unprepared.

The issue affects capture direction paths with branches (single dai with
multiple PCMs), the affected widgets are in the shared part of the paths.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20240612121203.15468-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-audio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index e693dcb475e4d..d1a7d867f6a3a 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -485,7 +485,7 @@ sof_prepare_widgets_in_path(struct snd_sof_dev *sdev, struct snd_soc_dapm_widget
 			if (ret < 0) {
 				/* unprepare the source widget */
 				if (widget_ops[widget->id].ipc_unprepare &&
-				    swidget && swidget->prepared) {
+				    swidget && swidget->prepared && swidget->use_count == 0) {
 					widget_ops[widget->id].ipc_unprepare(swidget);
 					swidget->prepared = false;
 				}
-- 
2.43.0



