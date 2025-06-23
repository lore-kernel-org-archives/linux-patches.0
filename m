Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787611ACEDA;
	Mon, 23 Jun 2025 21:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713143; cv=none; b=SAiVQUsmt5rZxz/Sw5G1H0qK9EsFq8RFKBn37YZl+tCS/8jX600owMcFKqpgCXZbuG8l6P+j/QQaSX2+kAYxAFtAG55zOh6+FFhnM/+VGs8aTi/fMgqVmquodC5h4ltNQPBH63kIo/msocd80vqI3dq50Pk5VFuvw1OPVcKqkp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713143; c=relaxed/simple;
	bh=DrjwLZcnicdte8Ps+ED/tV4AbMT52oGvE7dLof2yZxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nI6iibTQNb4Wz5ZyiahTvFtaiGY1PNhPwnMhSX53RLfO8tVJJYEE2zVx3x6zp50WrY1/yglAsGjw/mqFHsuhB5HgqBRxKtUBE7bPBDD8geZ/Dqtno7fWZoX1RDxvMuQ7cxjRaeZaDqDE040ce6TmVtMeJAhQ65Zts8TsJNzmrMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuI4qaRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuI4qaRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD965C4CEEA;
	Mon, 23 Jun 2025 21:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713143;
	bh=DrjwLZcnicdte8Ps+ED/tV4AbMT52oGvE7dLof2yZxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuI4qaRsoLV/ALYtvdlLdWf4Q3wBf7cY124hBDCXAalfSV5MKz9LKQ5orJTuIzRYT
	 tuH5WnmOekC5gDnOolxqOG3P2/LXNHK5BbbdV/9cvysSdJNcACgHnWhjnO7s76PGA3
	 ZVZ0v/sCgce0CmF2QEki89PEX9nbqVEWjkp3WDbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 190/222] scsi: storvsc: Increase the timeouts to storvsc_timeout
Date: Mon, 23 Jun 2025 15:08:45 +0200
Message-ID: <20250623130617.946393537@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -393,7 +393,7 @@ MODULE_PARM_DESC(ring_avail_percent_lowa
 /*
  * Timeout in seconds for all devices managed by this driver.
  */
-static int storvsc_timeout = 180;
+static const int storvsc_timeout = 180;
 
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
 static struct scsi_transport_template *fc_transport_template;
@@ -707,7 +707,7 @@ static void  handle_multichannel_storage
 		return;
 	}
 
-	t = wait_for_completion_timeout(&request->wait_event, 10*HZ);
+	t = wait_for_completion_timeout(&request->wait_event, storvsc_timeout * HZ);
 	if (t == 0) {
 		dev_err(dev, "Failed to create sub-channel: timed out\n");
 		return;
@@ -768,7 +768,7 @@ static int storvsc_execute_vstor_op(stru
 	if (ret != 0)
 		return ret;
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
+	t = wait_for_completion_timeout(&request->wait_event, storvsc_timeout * HZ);
 	if (t == 0)
 		return -ETIMEDOUT;
 
@@ -1200,6 +1200,8 @@ static int storvsc_connect_to_vsp(struct
 		return ret;
 
 	ret = storvsc_channel_init(device, is_fc);
+	if (ret)
+		vmbus_close(device->channel);
 
 	return ret;
 }
@@ -1503,7 +1505,7 @@ static int storvsc_host_reset_handler(st
 	if (ret != 0)
 		return FAILED;
 
-	t = wait_for_completion_timeout(&request->wait_event, 5*HZ);
+	t = wait_for_completion_timeout(&request->wait_event, storvsc_timeout * HZ);
 	if (t == 0)
 		return TIMEOUT_ERROR;
 


