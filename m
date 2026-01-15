Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFFE3C1970;
	Thu, 15 Jan 2026 17:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498341; cv=none; b=ljYb3jLb+whyTwQzVRK1316E+4wYwz8xjgZEnoBXsAreTuCvilS0dO3aBR+W5hbhjc3XOwsRy8fU7rv13OQJQJ9mvHB5XrrGj80vuDylPuFyPYUcVfIgr7S1EvCPPWHhCeLTQC69gSoBAx53VdM5ezjHtjQLF3WDpoxpA+Bd0AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498341; c=relaxed/simple;
	bh=QufKhM/MPodqN935JrNF9rXp1+bdJbsPzIJTkNavftg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VleIJBuW5Sp1uxcu7hBhiXDrKR2tHZHtxGrtgPA2Bl9YqwTKs9lKMn52XJY5teCJX1rMop4Mwz5HYUSMXXFlHwlCxV1+R9ZdIRfAMEFAVepgcrxh+UAj+kiDqkN39Awc85Vad0CLV+0j9tA2wB1NHy0rJ+upejcvXpVRHCRyA9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwEXrxcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwEXrxcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE57C116D0;
	Thu, 15 Jan 2026 17:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498340;
	bh=QufKhM/MPodqN935JrNF9rXp1+bdJbsPzIJTkNavftg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwEXrxcsKHgCQWC/bHBc3qpEUd2gAXsEVz8n8rtAIiOyHkQ06Y237nSQGj870OdFj
	 fZg6QoCfDZDuDWOj9dGIoe19WLZTTb0sKJR59Mk6Ukh2qQUYUY8axYV6iT5eYO6bB2
	 rW3yRIUqXT4X9Ar32y02k/5RrnlvJgScNef839kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 398/554] media: i2c: ADV7604: Remove redundant cancel_delayed_work in probe
Date: Thu, 15 Jan 2026 17:47:44 +0100
Message-ID: <20260115164300.641519265@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3615,7 +3615,7 @@ static int adv76xx_probe(struct i2c_clie
 	err = media_entity_pads_init(&sd->entity, state->source_pad + 1,
 				state->pads);
 	if (err)
-		goto err_work_queues;
+		goto err_i2c;
 
 	/* Configure regmaps */
 	err = configure_regmaps(state);
@@ -3656,8 +3656,6 @@ static int adv76xx_probe(struct i2c_clie
 
 err_entity:
 	media_entity_cleanup(&sd->entity);
-err_work_queues:
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 err_i2c:
 	adv76xx_unregister_clients(state);
 err_hdl:


