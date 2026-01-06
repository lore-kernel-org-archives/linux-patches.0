Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F4233DEDF;
	Tue,  6 Jan 2026 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721026; cv=none; b=FKVOaONrpclq7PXXg5IguP0J3DXAQFk+9H9E7gEIWf4VQT1HmX6qlAqGRZ11F8kCo8XV5trfPTwgvLls8785GNpVCaQ7P6mDlhyKlIFT4cD1GMHPgPYhgFV+NDmlb8bwM+unBAW4go70nIz2mYAyvqIWzSMEmVYHCo38dQ1loe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721026; c=relaxed/simple;
	bh=fHl/v6Cix+XBUddxrAmLTHkjQJRqAIa6exq/ISI8eF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSHOYcSOW2BXthXEkDhqtvNOZH4qcFOiVaLX08Thuem+6IIxoA5DP/UMTaeEeJp1iRUbUOEs/i47mxopB9+pQ4u1uYY5S46UlevlTGXlBzTsgUlCOkimC9CDgELTCLKxrkyHw58SuRbpnVqscrQSrzd57MrVv7RqgpZxaVy3FMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZB0ufoeW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZB0ufoeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FBCC16AAE;
	Tue,  6 Jan 2026 17:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721026;
	bh=fHl/v6Cix+XBUddxrAmLTHkjQJRqAIa6exq/ISI8eF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZB0ufoeW1x5jHcTm3eLnfqHYe/zkgkQ0AfjaNb0lT+raVlCRpVeQu/qxRd0H/DG61
	 VGY65aTzwC8PGGWCd9BQuTIaMA/5nJuIjPkKSgxM75vVqyPyvVlPAh2/zrOunl+6Mm
	 BY4iTGGXKtuXaXEMRjbe87Jv5UzV8Q2ps1HpBbK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 413/567] media: i2c: ADV7604: Remove redundant cancel_delayed_work in probe
Date: Tue,  6 Jan 2026 18:03:15 +0100
Message-ID: <20260106170506.623045957@linuxfoundation.org>
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

commit 8f34f24355a607b98ecd9924837aab13c676eeca upstream.

The delayed_work delayed_work_enable_hotplug is initialized with
INIT_DELAYED_WORK() in adv76xx_probe(), but it is never scheduled
anywhere in the probe function.

Calling cancel_delayed_work() on a work that has never been
scheduled is redundant and unnecessary, as there is no pending
work to cancel.

Remove the redundant cancel_delayed_work() from error handling
path and adjust the goto label accordingly to simplify the code
and avoid potential confusion.

Fixes: 54450f591c99 ("[media] adv7604: driver for the Analog Devices ADV7604 video decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/adv7604.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3620,7 +3620,7 @@ static int adv76xx_probe(struct i2c_clie
 	err = media_entity_pads_init(&sd->entity, state->source_pad + 1,
 				state->pads);
 	if (err)
-		goto err_work_queues;
+		goto err_i2c;
 
 	/* Configure regmaps */
 	err = configure_regmaps(state);
@@ -3661,8 +3661,6 @@ static int adv76xx_probe(struct i2c_clie
 
 err_entity:
 	media_entity_cleanup(&sd->entity);
-err_work_queues:
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 err_i2c:
 	adv76xx_unregister_clients(state);
 err_hdl:


