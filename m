Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F047B1AD3FA;
	Mon, 23 Jun 2025 21:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715759; cv=none; b=rtkpxmQTxhT44i6kG6xeYRAzRExzd8RLRTMEMb0X6KlWiUuk3XK1qS7bce76rCLjlMcaNlfrepfMELrK+h23SF+7CkDUmnvX5FItEiDo0yoG2s0HUv8fDha7IGUHFT4f3yOkV77g0v66kTIGv0+HVsr29K97OpJHwzOMPK7Zbj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715759; c=relaxed/simple;
	bh=c8auwU4uCyW4j1csV2dEiOXyrb1E59ujc3Jqx+ZZ88M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJyj7zWz6JN0ZWWO2KUdnbnRlG/95qQPEBDK8e+d5N4fEfmVF/nlA645PRpucYpmLkMNOW4hMZWGYO7hFywzVPl059BXxlYOUsyi1H5dOXMH5Cz76HlZkMz96PUS1MJQiGFTxkjmgv0u0Z1Uvk7aP60dJywYywBC9lRIRNUjOQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/aRIYtq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/aRIYtq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F7AC4CEED;
	Mon, 23 Jun 2025 21:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715758;
	bh=c8auwU4uCyW4j1csV2dEiOXyrb1E59ujc3Jqx+ZZ88M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/aRIYtqzQ4wYJsNRQlhBLmAlrKTOATEqQx17Xa4AqnNgRQmpkyhIaHXi9KWJ/AGi
	 GZE5iLhXuRNlE4WHe4OmBeSnqTNeAyxCJPnGI+wMti6xvLzdGguPS4b9OYvV4f51l2
	 h6KoeKgzjfgLBYZeknapHOqprTteOGl3vg+vOi4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 219/290] scsi: storvsc: Increase the timeouts to storvsc_timeout
Date: Mon, 23 Jun 2025 15:08:00 +0200
Message-ID: <20250623130633.517678126@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dexuan Cui <decui@microsoft.com>

commit b2f966568faaad326de97481096d0f3dc0971c43 upstream.

Currently storvsc_timeout is only used in storvsc_sdev_configure(), and
5s and 10s are used elsewhere. It turns out that rarely the 5s is not
enough on Azure, so let's use storvsc_timeout everywhere.

In case a timeout happens and storvsc_channel_init() returns an error,
close the VMBus channel so that any host-to-guest messages in the
channel's ringbuffer, which might come late, can be safely ignored.

Add a "const" to storvsc_timeout.

Cc: stable@kernel.org
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/1749243459-10419-1-git-send-email-decui@microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/storvsc_drv.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -362,7 +362,7 @@ MODULE_PARM_DESC(ring_avail_percent_lowa
 /*
  * Timeout in seconds for all devices managed by this driver.
  */
-static int storvsc_timeout = 180;
+static const int storvsc_timeout = 180;
 
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
 static struct scsi_transport_template *fc_transport_template;
@@ -768,7 +768,7 @@ static void  handle_multichannel_storage
 		return;
 	}
 
-	t = wait_for_completion_timeout(&request->wait_event, 10*HZ);
+	t = wait_for_completion_timeout(&request->wait_event, storvsc_timeout * HZ);
 	if (t == 0) {
 		dev_err(dev, "Failed to create sub-channel: timed out\n");
 		return;
@@ -833,7 +833,7 @@ static int storvsc_execute_vstor_op(stru
 	if (ret != 0)
 		return ret;
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
+	t = wait_for_completion_timeout(&request->wait_event, storvsc_timeout * HZ);
 	if (t == 0)
 		return -ETIMEDOUT;
 
@@ -1351,6 +1351,8 @@ static int storvsc_connect_to_vsp(struct
 		return ret;
 
 	ret = storvsc_channel_init(device, is_fc);
+	if (ret)
+		vmbus_close(device->channel);
 
 	return ret;
 }
@@ -1668,7 +1670,7 @@ static int storvsc_host_reset_handler(st
 	if (ret != 0)
 		return FAILED;
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
+	t = wait_for_completion_timeout(&request->wait_event, storvsc_timeout * HZ);
 	if (t == 0)
 		return TIMEOUT_ERROR;
 


