Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF74455614;
	Mon, 31 Aug 2026 13:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183635; cv=none; b=gfWce4BPNdlf+4tfmtU1u1GKD7AP87k37XfU+Yn7LyOzU92xr8elWtODpBMgO0b2K9oXfRSdr0hKM/1efQFJU7e8DcVh+a4aOsAOthDdrI2GpLiHRmCAL/lOpXs7wYlFw0BkRWr9ciNNEP4OCdogyCJAa5Nwb7nQ7fU9H/fywvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183635; c=relaxed/simple;
	bh=Gfgxnq/U6TaMcBnMqsRNjLP4VopQWhtIdCCMMKD7Rfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VArwPJpQpPAaS27vD0wHWUV3jDFdoQvOjNyWVnZZl4Er6Uo3anaj0lIOu9ad71qZ9u6nqpf0MgnZisuRwsi9ZGEIDzF2w4tm8qiipoVAPPPjEYskCfr4OYx8MGUMgMaMr2FRgi1HuCmAd8TAycPPUa1eBvHbGLT5iTfbjhxxcLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBZsgwYB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBZsgwYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0421F000E9;
	Mon, 31 Aug 2026 13:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183633;
	bh=SMJxjFW71nVkfBeMCdL6T7MLZjPBTAzstFvQ0aGmTcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBZsgwYBLQCk0GQAuYql0gEkVnboSq646dOU/5VQcR8iqFD4YxcgrbR3rU+Q5Fsyn
	 QprP/W5SJ+bz/ymcddIw+SMDTrRu9/nYXErV6F4YnjRnK3CYM2IhHijc6R/a1gf/Mx
	 P/I7BQPmbaydnorNRChPiZcxoIpBY9s0gDyebwc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 7.2 63/71] usb: core: Strengthen error handling in hub_hub_status()
Date: Mon, 31 Aug 2026 15:34:28 +0200
Message-ID: <20260831133402.516976909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit a29496745aa335d97f617385809583241e118610 upstream.

Add additional error handling after the call to get_hub_status() in
hub_hub_status().

get_hub_status() uses usb_control_msg() which does not verify that the
message is the correct length, substituting it for
usb_control_msg_recv() would also solve this issue but increase memory
allocations.

Instead, error handling is copied from the method used in
hub_ext_port_status(), which shares the same flow of logic as
hub_hub_status().

Assisted-by: gkh_clanker_t1000
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260722-usb_core_patches_2-v3-1-87622252bfdd@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -994,10 +994,12 @@ static int hub_hub_status(struct usb_hub
 
 	mutex_lock(&hub->status_mutex);
 	ret = get_hub_status(hub->hdev, &hub->status->hub);
-	if (ret < 0) {
+	if (ret < (int)sizeof(hub->status->hub)) {
 		if (ret != -ENODEV)
 			dev_err(hub->intfdev,
 				"%s failed (err = %d)\n", __func__, ret);
+		if (ret >= 0)
+			ret = -EIO;
 	} else {
 		*status = le16_to_cpu(hub->status->hub.wHubStatus);
 		*change = le16_to_cpu(hub->status->hub.wHubChange);


