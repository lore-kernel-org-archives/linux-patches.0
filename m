Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEECB3290AD;
	Tue, 16 Jun 2026 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623707; cv=none; b=l0594irGjHuQ5o8HbBYbHi+aQSgf767xVsw4LimGO1MHY7ZIyFf5yQ57VRlgLmeH01bbkx1+QlW3FoYlJfRBQFzdsGC1ecZCueYoOQeltxQicse1GpTOKsRf4OikryitWcnkiIDwIe0aQ2z3FtcYkHeKsJVmnyv9sE/4CG4Ycmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623707; c=relaxed/simple;
	bh=Nx9Q6KozGpjZn3SIG+QjD2r2p/xJGG8/K99Yc6O0SLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4V0O8kpUiAjC14JlukOBTfDubtgoMvm0PnuJP88jvs2W/EYnfeOKV8plcoekedi6WS1q25y8cvgTo3/3RYZFbQS5UhoRBIWTevF6An+S8sWgvW0JDASfSDfl6p+3rJd4WtLaKUEfFj7+u4q/o1iDfv5NAlysmA4zo27i8J6V7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nk0P4Pl/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nk0P4Pl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B373C1F000E9;
	Tue, 16 Jun 2026 15:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623705;
	bh=7wqYO+2lakuINx6wTMfQAhjSMk09NYoLrFMQZPGTwFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nk0P4Pl/Juv3OUz1i7JQHIEhboYsWGwI0g6XD9YeX6vhCDJ4rmaKBiq64P4jcCztA
	 ghf1e92srIAIhv6xUeT24yd3wMD4VM6cpBDP3YGC5iw3SjxUS7orndnLGifkc4ulSk
	 x7tgaHbtY3J9D5rFKkMU2ciz/S3b7TyYmTEwwUy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 7.0 181/378] firmware: stratix10-rsu: Fix NULL deref on rsu_send_msg() timeout in probe
Date: Tue, 16 Jun 2026 20:26:52 +0530
Message-ID: <20260616145119.904941744@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@kernel.org>

commit bfd2eb9bba548a8f63c3339bb1fb9a2031a42d86 upstream.

rsu_send_msg() can return -ETIMEDOUT when
wait_for_completion_interruptible_timeout() fires while the SMC call is still
pending. In stratix10_rsu_probe(), the error paths for COMMAND_RSU_DCMF_VERSION,
COMMAND_RSU_DCMF_STATUS, COMMAND_RSU_MAX_RETRY and COMMAND_RSU_GET_SPT_TABLE
call stratix10_svc_free_channel() - which sets chan->scl to NULL - but then
fall through and queue the next request on the same channel. The next svc
kthread that runs will dereference pdata->chan->scl in its receive callback
path, triggering a NULL pointer dereference identical to the one fixed by
commit c45f7263100c ("firmware: stratix10-rsu: Fix NULL pointer dereference
when RSU is disabled") for the COMMAND_RSU_STATUS path.

Apply the same cleanup pattern to the remaining failure paths: remove the
async client, free the channel, and return early so no further messages are
queued on a channel whose scl has been cleared.

While at it, clean up stratix10_rsu_probe() in two ways without changing
behavior:

- Drop redundant zero-initialization of fields already cleared by
  devm_kzalloc(): client.receive_cb, status.* and spt0/1_address
  (INVALID_SPT_ADDRESS is 0x0).

- Replace five identical 3-line error-cleanup blocks
  (stratix10_svc_remove_async_client() + stratix10_svc_free_channel() +
  return ret) with goto labels (remove_async_client, free_channel),
  matching the standard kernel resource-unwinding pattern and making it
  easier to extend the probe sequence without forgetting matching
  cleanup.

Also move init_completion() next to mutex_init() so sync-primitive
initialization is grouped before anything that could trigger a
callback.

Fixes: 15847537b623 ("firmware: stratix10-rsu: Migrate RSU driver to use stratix10 asynchronous framework.")
Cc: stable@kernel.org
Assisted-by: Claude:claude-4.7-opus-high Cursor
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: Add a minor clean-up of the function stratix10_rsu_probe() to have a
    centralize exit for all the rsu_send_async_msg() and rsu_send_msg().
---
 drivers/firmware/stratix10-rsu.c |   45 +++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

--- a/drivers/firmware/stratix10-rsu.c
+++ b/drivers/firmware/stratix10-rsu.c
@@ -723,15 +723,9 @@ static int stratix10_rsu_probe(struct pl
 		return -ENOMEM;
 
 	priv->client.dev = dev;
-	priv->client.receive_cb = NULL;
 	priv->client.priv = priv;
-	priv->status.current_image = 0;
-	priv->status.fail_image = 0;
-	priv->status.error_location = 0;
-	priv->status.error_details = 0;
-	priv->status.version = 0;
-	priv->status.state = 0;
 	priv->retry_counter = INVALID_RETRY_COUNTER;
+	priv->max_retry = INVALID_RETRY_COUNTER;
 	priv->dcmf_version.dcmf0 = INVALID_DCMF_VERSION;
 	priv->dcmf_version.dcmf1 = INVALID_DCMF_VERSION;
 	priv->dcmf_version.dcmf2 = INVALID_DCMF_VERSION;
@@ -740,11 +734,11 @@ static int stratix10_rsu_probe(struct pl
 	priv->dcmf_status.dcmf1 = INVALID_DCMF_STATUS;
 	priv->dcmf_status.dcmf2 = INVALID_DCMF_STATUS;
 	priv->dcmf_status.dcmf3 = INVALID_DCMF_STATUS;
-	priv->max_retry = INVALID_RETRY_COUNTER;
-	priv->spt0_address = INVALID_SPT_ADDRESS;
-	priv->spt1_address = INVALID_SPT_ADDRESS;
+	/* spt0/1_address and status fields default to 0 from kzalloc */
 
 	mutex_init(&priv->lock);
+	init_completion(&priv->completion);
+
 	priv->chan = stratix10_svc_request_channel_byname(&priv->client,
 							  SVC_CLIENT_RSU);
 	if (IS_ERR(priv->chan)) {
@@ -756,11 +750,9 @@ static int stratix10_rsu_probe(struct pl
 	ret = stratix10_svc_add_async_client(priv->chan, false);
 	if (ret) {
 		dev_err(dev, "failed to add async client\n");
-		stratix10_svc_free_channel(priv->chan);
-		return ret;
+		goto free_channel;
 	}
 
-	init_completion(&priv->completion);
 	platform_set_drvdata(pdev, priv);
 
 	/* get the initial state from firmware */
@@ -768,41 +760,44 @@ static int stratix10_rsu_probe(struct pl
 				 rsu_async_status_callback);
 	if (ret) {
 		dev_err(dev, "Error, getting RSU status %i\n", ret);
-		stratix10_svc_remove_async_client(priv->chan);
-		stratix10_svc_free_channel(priv->chan);
-		return ret;
+		goto remove_async_client;
 	}
 
 	/* get DCMF version from firmware */
-	ret = rsu_send_msg(priv, COMMAND_RSU_DCMF_VERSION,
-			   0, rsu_dcmf_version_callback);
+	ret = rsu_send_msg(priv, COMMAND_RSU_DCMF_VERSION, 0,
+			   rsu_dcmf_version_callback);
 	if (ret) {
 		dev_err(dev, "Error, getting DCMF version %i\n", ret);
-		stratix10_svc_free_channel(priv->chan);
+		goto remove_async_client;
 	}
 
-	ret = rsu_send_msg(priv, COMMAND_RSU_DCMF_STATUS,
-			   0, rsu_dcmf_status_callback);
+	ret = rsu_send_msg(priv, COMMAND_RSU_DCMF_STATUS, 0,
+			   rsu_dcmf_status_callback);
 	if (ret) {
 		dev_err(dev, "Error, getting DCMF status %i\n", ret);
-		stratix10_svc_free_channel(priv->chan);
+		goto remove_async_client;
 	}
 
 	ret = rsu_send_msg(priv, COMMAND_RSU_MAX_RETRY, 0,
 			   rsu_max_retry_callback);
 	if (ret) {
 		dev_err(dev, "Error, getting RSU max retry %i\n", ret);
-		stratix10_svc_free_channel(priv->chan);
+		goto remove_async_client;
 	}
 
-
 	ret = rsu_send_async_msg(dev, priv, COMMAND_RSU_GET_SPT_TABLE, 0,
 				 rsu_async_get_spt_table_callback);
 	if (ret) {
 		dev_err(dev, "Error, getting SPT table %i\n", ret);
-		stratix10_svc_free_channel(priv->chan);
+		goto remove_async_client;
 	}
 
+	return 0;
+
+remove_async_client:
+	stratix10_svc_remove_async_client(priv->chan);
+free_channel:
+	stratix10_svc_free_channel(priv->chan);
 	return ret;
 }
 


