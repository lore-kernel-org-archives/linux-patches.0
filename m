Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9856F358D30;
	Fri,  9 Jan 2026 12:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962809; cv=none; b=qRjGZKNWmTvXCXUMXSZNLPfw+inBrNypxXIdhJ4anHVJPjpp2/9kR+Lxe77VulRX8kbOB/g5rKS/bJmPL4OVzpaQJTLygB5zAc2AVn9/KsUdVmhGRwoJn3tGzpcyfPA3xm4SlnMW7WI6R0OI/+NV3fLhU8mXRy4ANGo2pZJSHE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962809; c=relaxed/simple;
	bh=QX+KWCdPEY14Kcd5HxedPMy9E8rUVwMaG681hBnDhoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWw6FqeehHZVi9xAMrb1wroTaXFRPfNJt06uOFzU2yxEGAxIbYJwd4b9k7V7uaSC6b4sPDmnIqYYASn8z9Gw3thHjrC7qdMxdkJlsWtbl4imKwUd4GpP4lu0dPe7+VBpwdFz1mNx9zlHtc2HKOkr48i76jzxvsZ58k1IKVtOmfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySmubJwl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySmubJwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E565C16AAE;
	Fri,  9 Jan 2026 12:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962809;
	bh=QX+KWCdPEY14Kcd5HxedPMy9E8rUVwMaG681hBnDhoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySmubJwlI9qrXYfwqpO3SOVlHKYNKqKg2XsvdtDvaLLLg/qDCBZwbGcPm2nPIw984
	 OzW/sJXHbF6oRM+BKyUSiNJrWlA4mONxQ9oIh0dXROaUWhoeCv/4O/RJXOTzz2N4xB
	 /c5Pvokg7Hff28+XqCZMWCpycxAAmQzEeaVv13SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 488/634] media: i2c: ADV7604: Remove redundant cancel_delayed_work in probe
Date: Fri,  9 Jan 2026 12:42:46 +0100
Message-ID: <20260109112135.908550715@linuxfoundation.org>
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
@@ -3617,7 +3617,7 @@ static int adv76xx_probe(struct i2c_clie
 	err = media_entity_pads_init(&sd->entity, state->source_pad + 1,
 				state->pads);
 	if (err)
-		goto err_work_queues;
+		goto err_i2c;
 
 	/* Configure regmaps */
 	err = configure_regmaps(state);
@@ -3658,8 +3658,6 @@ static int adv76xx_probe(struct i2c_clie
 
 err_entity:
 	media_entity_cleanup(&sd->entity);
-err_work_queues:
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 err_i2c:
 	adv76xx_unregister_clients(state);
 err_hdl:


