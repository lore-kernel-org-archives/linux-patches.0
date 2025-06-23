Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB29D19049B;
	Mon, 23 Jun 2025 21:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715633; cv=none; b=bbbyxh1cqm1iOyhjPrRDmWjeCXgh8jYtLVUh7NBSbLVfUBFe/8puvcrg4HHFExKtX+aahPm4BuWqcZ2IWJI2tTpax41lqjH/XZ8iZkNk73pm0YcVCb8/2+xEoK9WfRYoLjRQVM1eFKSgMYRGCH2y9d5Mu5Xcq4vq9obclSdiEbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715633; c=relaxed/simple;
	bh=T6TQdJ3VxVcN64hMg3SFnfdQXcGS9tZ7rza/qk/uGBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1KecdZEe2XggUi536QK+942tDRL/RqHtSyXMNAD9bfnpmfMU6stRFXIGJEnFJwzg5EkfsYxuVFvs8WSUb4Kgg2JCqAH9kQPp8WUsagnNYowtMrK7jSTbfo4fcdfujsdDawGYIXM6hetlypewxbx24OHUi97p5pFyUCX+KpIrAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IoBHboK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IoBHboK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51410C4CEEA;
	Mon, 23 Jun 2025 21:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715633;
	bh=T6TQdJ3VxVcN64hMg3SFnfdQXcGS9tZ7rza/qk/uGBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IoBHboK1C2jJ9R7PHShnAMXPc8isWw41ddbyedjzwRPyZ9ZJpUNhoi+WvCkgIP51r
	 MiGqtv+TZpR+BEp+6fIO5oKdvuRFrr2I4VgK7NhY3mc2NPLC8Kc1a8q/0DMxN+ZQYm
	 mT+K388GV6hIJLxmoEC1M/VBR/19TN+r+PvoMhic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 287/355] scsi: storvsc: Increase the timeouts to storvsc_timeout
Date: Mon, 23 Jun 2025 15:08:08 +0200
Message-ID: <20250623130635.403917815@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -400,7 +400,7 @@ MODULE_PARM_DESC(ring_avail_percent_lowa
 /*
  * Timeout in seconds for all devices managed by this driver.
  */
-static int storvsc_timeout = 180;
+static const int storvsc_timeout = 180;
 
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
 static struct scsi_transport_template *fc_transport_template;
@@ -779,7 +779,7 @@ static void  handle_multichannel_storage
 		return;
 	}
 
-	t = wait_for_completion_timeout(&request->wait_event, 10*HZ);
+	t = wait_for_completion_timeout(&request->wait_event, storvsc_timeout * HZ);
 	if (t == 0) {
 		dev_err(dev, "Failed to create sub-channel: timed out\n");
 		return;
@@ -840,7 +840,7 @@ static int storvsc_execute_vstor_op(stru
 	if (ret != 0)
 		return ret;
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
+	t = wait_for_completion_timeout(&request->wait_event, storvsc_timeout * HZ);
 	if (t == 0)
 		return -ETIMEDOUT;
 
@@ -1301,6 +1301,8 @@ static int storvsc_connect_to_vsp(struct
 		return ret;
 
 	ret = storvsc_channel_init(device, is_fc);
+	if (ret)
+		vmbus_close(device->channel);
 
 	return ret;
 }
@@ -1623,7 +1625,7 @@ static int storvsc_host_reset_handler(st
 	if (ret != 0)
 		return FAILED;
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
+	t = wait_for_completion_timeout(&request->wait_event, storvsc_timeout * HZ);
 	if (t == 0)
 		return TIMEOUT_ERROR;
 


