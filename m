Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D03735A952;
	Fri,  9 Jan 2026 12:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960985; cv=none; b=VL7FW3QbLI98cNErVYeFrrT4b19NWahmzQl8KmymVfsRyT5OnwkBnORjbDV+8XjDGbazWEEWhyJ6ZD2KcnzVzCzFsxY5VqR2oZjAN3HfrtbR9qP2sslVS8fwibJF/K6Q+Ov0Gs3hfkeL/eaRDA26tiehZGYzGRuk9aPKrBjNkp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960985; c=relaxed/simple;
	bh=Jeno3/cLI1Bx7fg3TDNJhOqgPJFllchbmemGOQNyLLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeUONmxNKDq9TCl+uzu21N6A6mffmIXOur3M2KehKjV0irinkmm8LvQ6XqqyOgQdkhW12UKZvVnih0b85PwhIeAzUQYpu6Ql5pKVG1MIzmFVgKMf5upEtUlemG/SKsyT5DwolK8ISdARNdec+e5NjcOT6cXOeKlGwmzYEnadt44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arG2ZxVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arG2ZxVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D844AC16AAE;
	Fri,  9 Jan 2026 12:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960985;
	bh=Jeno3/cLI1Bx7fg3TDNJhOqgPJFllchbmemGOQNyLLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arG2ZxVGZbwAYMKgWQeobmvAw6mQ0EQKce7pabqPfRak6RO4rlbPe9hjHZnpRCkYM
	 5ziCuWYWzAWTZGOHHvTTWc50o4P+sJPyFUqWGyY5bL3QxWGK6byP9R+qwL2eyxAGdd
	 BNxfDJnt7ttwbS5OV5AaJ3p06r2ukJApZVxOyyqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 594/737] media: i2c: adv7842: Remove redundant cancel_delayed_work in probe
Date: Fri,  9 Jan 2026 12:42:13 +0100
Message-ID: <20260109112156.346966731@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -3564,7 +3564,7 @@ static int adv7842_probe(struct i2c_clie
 	err = media_entity_pads_init(&sd->entity, ADV7842_PAD_SOURCE + 1,
 				     state->pads);
 	if (err)
-		goto err_work_queues;
+		goto err_i2c;
 
 	err = adv7842_core_init(sd);
 	if (err)
@@ -3585,8 +3585,6 @@ static int adv7842_probe(struct i2c_clie
 
 err_entity:
 	media_entity_cleanup(&sd->entity);
-err_work_queues:
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 err_i2c:
 	adv7842_unregister_clients(sd);
 err_hdl:


