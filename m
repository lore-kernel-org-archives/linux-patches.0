Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEB833C1B6;
	Fri,  9 Jan 2026 12:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960982; cv=none; b=KQ9yjpgD5ojWUTOymMHNQexRNCWffPlW3qSOqjozc2qKN8bE56vYmrQQjwEQumiyubbl3Fvw5YLT5SJBjqlxeqaLc4uxaX+TpO2F4RmY54L9dRBn7uKDaDi/xmpn2qR4kW0IjzUI92DCyaSQaOeRBSfWbrhOrgP87bxkF0rhJwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960982; c=relaxed/simple;
	bh=PUCYHNXeD9u0bVYf9fMsqlXRiL/EZ6pl4SjsuY1C75E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUh0AwwpfzWaiJX0a2FOvh6PQvUY15Z8SvKL51opU2UrMcyEd+t/jZbrLDPwgJ7N1ecWGO9HXD57EcX9Bo4e8peRG1Rd47h9yUmMSgtbARI21up+i3OzCCyp6xMhG6CH5QlYoW8v5LQJFbD5tOIcrJyqTbasjzmNghWXDrGdnd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Abputwot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Abputwot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114F3C4CEF1;
	Fri,  9 Jan 2026 12:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960982;
	bh=PUCYHNXeD9u0bVYf9fMsqlXRiL/EZ6pl4SjsuY1C75E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbputwotXK1eOSLMNqpkChRbnliEA6v7frPL9+hXbhgO/1cLIZRrvbxQWtTu8wxy6
	 1aeD34y70fD3HP6V2bUYb4qBLc0UW2AH/anbTcIsKIQp8UKdEfeW19P6ycjF4B0For
	 m4U0amyFSWk2aP7blgS3yBPVK1xFOTZCYEBBnCqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 593/737] media: i2c: ADV7604: Remove redundant cancel_delayed_work in probe
Date: Fri,  9 Jan 2026 12:42:12 +0100
Message-ID: <20260109112156.310199338@linuxfoundation.org>
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


