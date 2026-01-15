Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CE03D6464;
	Thu, 15 Jan 2026 17:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499718; cv=none; b=FgCxFRSrPTg9d+/PDNDX7AZgz+0c1O3KE//V0f8S2ngWfAomEaXFA/LtVnyANBIoGQv6dXkh5s36r6XNKihjVaZSpK2Qbw7afmQDNAgGutwPdraFfEe2OlwFq1IqYTgAh8ADRB9pooM+rIKYjUMJGl3OZlNLbj1qPqy8SsunXgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499718; c=relaxed/simple;
	bh=RAxjgPIIjjsTg+E5QwLbG+L9Ddr37E9WxXX8QHXU/Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmCiIehIrXHDtvh/HiQRr/bnZMz4UR1i8Rw0lKSqMD3l6G4Va7SArWqeGOjTAOZJo7NY8hNU72NuVeowqWSXpOmkNpSJ1+g/GwI6dN2VKLs60vhOhbw3dPsUaP748oST78C7jV9C48ot1YoxuZTIPEVoTO+4lwo0cXiP5dluBaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnHRtmT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnHRtmT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82769C116D0;
	Thu, 15 Jan 2026 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499717;
	bh=RAxjgPIIjjsTg+E5QwLbG+L9Ddr37E9WxXX8QHXU/Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnHRtmT1PgEZ9u9bM5ZBoUwHrPgCMF127HTJcAPfVLbrgBxse/LMEE7Agv1JLMUlO
	 DQuXaB6WjR1sKwIO0558lsteW50YFQH2h+Z0EcGZcNHpZL2C/jrnzjt68dnbfgnmes
	 G8lsUSK9Q0mQVYL6e57DwJI4JXoFLuB/UOfKV2a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 325/451] media: i2c: ADV7604: Remove redundant cancel_delayed_work in probe
Date: Thu, 15 Jan 2026 17:48:46 +0100
Message-ID: <20260115164242.655773015@linuxfoundation.org>
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
@@ -3561,7 +3561,7 @@ static int adv76xx_probe(struct i2c_clie
 	err = media_entity_pads_init(&sd->entity, state->source_pad + 1,
 				state->pads);
 	if (err)
-		goto err_work_queues;
+		goto err_i2c;
 
 	/* Configure regmaps */
 	err = configure_regmaps(state);
@@ -3602,8 +3602,6 @@ static int adv76xx_probe(struct i2c_clie
 
 err_entity:
 	media_entity_cleanup(&sd->entity);
-err_work_queues:
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 err_i2c:
 	adv76xx_unregister_clients(state);
 err_hdl:


