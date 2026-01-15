Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABCE3AE701;
	Thu, 15 Jan 2026 17:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498343; cv=none; b=FjanyGLoZtvejlIrUyCyNZ2Isi8Ip1wbYwY16yWImXj30lOPQxx7valt0b2xs4GgP0HIh7GnJoKrcRvyzxKa3MLTJNgmYNg2ybrIYqDMC8gZXhqraucop3HFK28Xjn2OtsiBfuzxGqG7eySALpdc41OwQ1gjhU2GDIyH0euhjig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498343; c=relaxed/simple;
	bh=5fwUWIpxp58EGaMa1nYy4RqhJlItmZ0x5F7Y7RJBsL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIBoupJlRqa2r8vK84KS0dxeJHTNmWqH0nIytOLzl7PqzAWlndPms+biD/pyQ9xeBH1BUwVIb7Ia3UYHe9AXvr+93k3UDtok2j2RmxudaPuBtu6dcLPQz6CCKM+pwMqoV37rSHbXWgtUEDLGSBFr0m9ovPPqKf3WHdvOjua0Tq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r91fHnrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r91fHnrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15216C116D0;
	Thu, 15 Jan 2026 17:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498343;
	bh=5fwUWIpxp58EGaMa1nYy4RqhJlItmZ0x5F7Y7RJBsL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r91fHnrvArivWAARUPWGsULU1D4cG2fApVZ2n5gRLZqstho8xq9Z/LTergo7+DCc1
	 +Njcb3yLDWP3DjcAb6e45gWpNlB2EDFMmXccYP0YyCtmWmKMn7FjFn+ptg1BxJfbwq
	 O9Pnsug8kJe7GzBDVJSziqOSBdZH9irIVVZqfiJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 399/554] media: i2c: adv7842: Remove redundant cancel_delayed_work in probe
Date: Thu, 15 Jan 2026 17:47:45 +0100
Message-ID: <20260115164300.677252234@linuxfoundation.org>
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
@@ -3575,7 +3575,7 @@ static int adv7842_probe(struct i2c_clie
 	err = media_entity_pads_init(&sd->entity, ADV7842_PAD_SOURCE + 1,
 				     state->pads);
 	if (err)
-		goto err_work_queues;
+		goto err_i2c;
 
 	err = adv7842_core_init(sd);
 	if (err)
@@ -3596,8 +3596,6 @@ static int adv7842_probe(struct i2c_clie
 
 err_entity:
 	media_entity_cleanup(&sd->entity);
-err_work_queues:
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 err_i2c:
 	adv7842_unregister_clients(sd);
 err_hdl:


