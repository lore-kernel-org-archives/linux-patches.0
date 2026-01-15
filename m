Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3673D605F;
	Thu, 15 Jan 2026 17:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499721; cv=none; b=IABDge/YuPbbVYGvcXhtz7KkLiRiBCzcIqDgUmUZ/op3Au25+cITpTwNYbViFx5Hrk0RBgyU5voYpWVXEYBjaET1hFfSyzHzf1x7WyiHj33ckhfW0JsAN1ohjXSpchfa+DTIIOhTz0aDbzOo6R+KxtmDhhAAlfMXQyzEPKievDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499721; c=relaxed/simple;
	bh=95aOj5KeigYmAh5PgcbFpL807adaFbwKlGoYALmRbHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+MCZ/a0bFjUJU+KuscMC6jWARx41DwR58TDSRaO+iEAzklcdd8QUSKoSQa9/gPMBBg7w1N9RdrRQjgDOERCmzi99bLEvpcelkgVEU+Q0ZxSgkTOLRoAGlYeMLygciPcsdS1N/P5coR/lfFrcfCQ/1UJ/QwIAh0Dvq27WXT8tgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQKb07Kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQKb07Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD1BC116D0;
	Thu, 15 Jan 2026 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499720;
	bh=95aOj5KeigYmAh5PgcbFpL807adaFbwKlGoYALmRbHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQKb07Kkf2RIgKocqsGxBITGeqwm60oIKP1NB3KPP4pYySzmEmvH07PJbJTXDVtla
	 afULRCZKWD95vYUEEFgpWU9w+RD2noHhxGma3Z+2LfhjnZYz8OqGJkNz6XrUDq4FaQ
	 Jhxb8j9CV6ioOjrL51dVYwBh49F45E7kDQpeo1yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 326/451] media: i2c: adv7842: Remove redundant cancel_delayed_work in probe
Date: Thu, 15 Jan 2026 17:48:47 +0100
Message-ID: <20260115164242.691121734@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3552,7 +3552,7 @@ static int adv7842_probe(struct i2c_clie
 	state->pad.flags = MEDIA_PAD_FL_SOURCE;
 	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err)
-		goto err_work_queues;
+		goto err_i2c;
 
 	err = adv7842_core_init(sd);
 	if (err)
@@ -3573,8 +3573,6 @@ static int adv7842_probe(struct i2c_clie
 
 err_entity:
 	media_entity_cleanup(&sd->entity);
-err_work_queues:
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 err_i2c:
 	adv7842_unregister_clients(sd);
 err_hdl:


