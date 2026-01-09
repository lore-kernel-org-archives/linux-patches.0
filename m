Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C75815ADB4;
	Fri,  9 Jan 2026 12:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962841; cv=none; b=OHJVP2PwYp8CZUGMEVqRLyoCtsNE38r/R2ejaCiHk71M8rrmv41D1sHpotJuzGOwnrYNc6Dh0A3bciNS53U/Lkfa6r9nv9TFJDZZA5y+2z5gui94E3WFiwUWRY2dd6sInQJhXkdigc8htQnV7W9gD0s+S6JgLf2lRbrUiegGgL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962841; c=relaxed/simple;
	bh=urb5GoPVSel5Vzn8AqHco8THmyRjEjWIWFSZjkA/dx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Va/ILFanRYinoMaNjo0d3zt2j9c5NgkysTNYy5TjpJdCfQks0BnTdVy4S/9hkgWVjUlZZOo22XDf5DRsWjGwKvU2LC/5eBF+2FWkR+1o6yOiwEg8Tg8e+P0+pEQGlHeUlOeGFBSYIfvLFoowDfFnXpNy1iR2/CwEc3x5PQHa0DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJuaWicb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJuaWicb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD9BC4CEF1;
	Fri,  9 Jan 2026 12:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962841;
	bh=urb5GoPVSel5Vzn8AqHco8THmyRjEjWIWFSZjkA/dx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJuaWicb5eSBk216bAfqCGukvPYZryXmTnJ+dsb229a0jBKgAvzfzdAki0omAynyz
	 P1e39pK0B284o7McOzi6yxDbhCm5TvgLfhhPvq0r0SdfAeBRF2YatheGiqm/4AKka0
	 yeZOf/ATjSh3b+ms90/lind+girCg3ygGwlGLtFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 489/634] media: i2c: adv7842: Remove redundant cancel_delayed_work in probe
Date: Fri,  9 Jan 2026 12:42:47 +0100
Message-ID: <20260109112135.946137241@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3565,7 +3565,7 @@ static int adv7842_probe(struct i2c_clie
 	err = media_entity_pads_init(&sd->entity, ADV7842_PAD_SOURCE + 1,
 				     state->pads);
 	if (err)
-		goto err_work_queues;
+		goto err_i2c;
 
 	err = adv7842_core_init(sd);
 	if (err)
@@ -3586,8 +3586,6 @@ static int adv7842_probe(struct i2c_clie
 
 err_entity:
 	media_entity_cleanup(&sd->entity);
-err_work_queues:
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 err_i2c:
 	adv7842_unregister_clients(sd);
 err_hdl:


