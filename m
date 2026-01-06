Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F3536BCD5;
	Tue,  6 Jan 2026 17:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722176; cv=none; b=lzpJXUD6vuH9qtEUIoI5YbRvoLFQ/5CGMuMqZ8XU4tnGoprCCMUAqDcPT9YWMWwCMKyJRmgGrIjKGf9WeCDToeuYF7t+iK2P8dQRvti/t4DvcdXjXGjGpy9xMkNpJVcSA8P1Kb0Ry5n9+O3QqgVDkyNFLRj8NysUwJ+XTOUibdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722176; c=relaxed/simple;
	bh=ayhLWMcZ4PkVXneu1lwl8qgT4ZsTInIjqclB4Y+x3m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IH2l8n/Dlv25B56feNjtxO/un5CcuUGCskNS1598S78N38tJVRxDye+p2yzUnGpsNmxqUQ7f+ms8VWIdIqST5vqQIz8ztL/WtUWnOMofuBlHUWArL52XD8UZKU/6CriIjbeXwz6/kruANGz5j0l5//cICaHCPnF4DZet1LdnYYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbB0ZjTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbB0ZjTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08AFC116C6;
	Tue,  6 Jan 2026 17:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722176;
	bh=ayhLWMcZ4PkVXneu1lwl8qgT4ZsTInIjqclB4Y+x3m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbB0ZjTtq/fwpfagjT4qzEJO/B27cqcCE0qzuwEJpGW1lHeGtvc9jVn6gq1mT5rOn
	 KEsKwuS5JgPEUopvoGcEkmxf8bbu22wrrBQ7bDpG7hMHCS6MBiuJ3jMpsaICj+egE9
	 TMFInflPELl1UDioY0826YA85tgoKpP+kUG/kr40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 187/312] media: i2c: ADV7604: Remove redundant cancel_delayed_work in probe
Date: Tue,  6 Jan 2026 18:04:21 +0100
Message-ID: <20260106170554.593688870@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3670,7 +3670,7 @@ static int adv76xx_probe(struct i2c_clie
 	err = media_entity_pads_init(&sd->entity, state->source_pad + 1,
 				state->pads);
 	if (err)
-		goto err_work_queues;
+		goto err_i2c;
 
 	/* Configure regmaps */
 	err = configure_regmaps(state);
@@ -3711,8 +3711,6 @@ static int adv76xx_probe(struct i2c_clie
 
 err_entity:
 	media_entity_cleanup(&sd->entity);
-err_work_queues:
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 err_i2c:
 	adv76xx_unregister_clients(state);
 err_hdl:


