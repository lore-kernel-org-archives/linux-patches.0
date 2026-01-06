Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE38833DEFC;
	Tue,  6 Jan 2026 17:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721033; cv=none; b=fvHia2KKlLJqh5QFbL7gMc+lL4Q8gwLcm6TVnFKvCAyKa9N66yjOgL0miqpR9hcC4p4BptNRyfzl3auP+/KYYSgnjGGknWrdDT+rxzImPxYnQh+HCkBrfJ6AkfopsdfSPFH4JMFh7Vz3ATYi57p1J7AiltHWk7KEmp6VWWR2VuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721033; c=relaxed/simple;
	bh=08cRFT5ffzPMzLbrySKKKMP/7NncQ9y35ntrBTASUq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bji25Je2ZPrwd6fgNrn9TcBQpdaVIKp+tDANbpcwNHC3k3ZypKy/p4V6G6KKlo9Rp+Vp/kQ0uEEND6SgTiVoGAoaHo15m2YidbyTWzf8QG+fTL9OV+TW7GdZX5d1/m1bEedQ8Ek44LHNv1PUBSS6sdS3lDdNafcs1L/b7L7aXok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psdYJPk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psdYJPk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D013C116C6;
	Tue,  6 Jan 2026 17:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721032;
	bh=08cRFT5ffzPMzLbrySKKKMP/7NncQ9y35ntrBTASUq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psdYJPk/Msk9b3x1ATxkb1hfeJtML1eBUBedzO9u/HtNuZLgEyOD3/JXd9+hr143L
	 HaCqEpZegd2F0nEt6byXtrNdH7UZWLcfxSx4BVgvYAdNf5CZ9dPFKN7A4bng1kZpm9
	 A3WDekRWFB5txJ0TydJuQ1c20Z+/sZlyMtP2g2Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 414/567] media: i2c: adv7842: Remove redundant cancel_delayed_work in probe
Date: Tue,  6 Jan 2026 18:03:16 +0100
Message-ID: <20260106170506.659102212@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

commit e66a5cc606c58e72f18f9cdd868a3672e918f9f8 upstream.

The delayed_work delayed_work_enable_hotplug is initialized with
INIT_DELAYED_WORK() in adv7842_probe(), but it is never scheduled
anywhere in the probe function.

Calling cancel_delayed_work() on a work that has never been
scheduled is redundant and unnecessary, as there is no pending
work to cancel.

Remove the redundant cancel_delayed_work() from error handling
path and adjust the goto label accordingly to simplify the code
and avoid potential confusion.

Fixes: a89bcd4c6c20 ("[media] adv7842: add new video decoder driver")
Cc: stable@vger.kernel.org
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/adv7842.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3573,7 +3573,7 @@ static int adv7842_probe(struct i2c_clie
 	err = media_entity_pads_init(&sd->entity, ADV7842_PAD_SOURCE + 1,
 				     state->pads);
 	if (err)
-		goto err_work_queues;
+		goto err_i2c;
 
 	err = adv7842_core_init(sd);
 	if (err)
@@ -3594,8 +3594,6 @@ static int adv7842_probe(struct i2c_clie
 
 err_entity:
 	media_entity_cleanup(&sd->entity);
-err_work_queues:
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 err_i2c:
 	adv7842_unregister_clients(sd);
 err_hdl:


