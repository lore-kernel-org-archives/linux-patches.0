Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE45492502;
	Mon, 31 Aug 2026 14:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185132; cv=none; b=d0jCweIp7Zy6qk4oARNY9rfwVH+dMxHOsB3Wwt1bqU5sviNQMq/jMl1r9I2pnE9KUNCLKHS7CDSWUInEqGw54SWuG1iR2mf+qcRP5Mqc9fg5Io5SsH+2OCZ2rZVXf+ZXB4BcZ5P2DD+VqnqWmIYEH15J1L9nGmpea/82opNkj+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185132; c=relaxed/simple;
	bh=YvF8+fjs21ZVN99SD+AZsBgOR2jI9k+BvgHtiG5PCbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avt3fY4MjJbD79T95XelOS2Cks2+JY1AfB1nND71WwMX6QhFiqhiDexQKdgBOVfEpYX7JS1I3EjYB+m5zCJL2ioG+tHR7Wec1YmXBssOa44yKy1EWtU2AavfbQzD12RakPCKYItmBIyLMuB0ySIFPoXe0pWVU7DZyuWMn2j7RyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5NBgDB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5NBgDB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA56A1F00A3D;
	Mon, 31 Aug 2026 14:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185130;
	bh=WgXcbNjtxyAqdzVZH6RNMKP/mfk8PREmRc8UmQpiaYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5NBgDB+Pis6Zu7AxxA7s5kfY2gItXt90Pos/2/rklV/qLCT1N0OT7WQLiZw6yMiM
	 UtTUxZfCrz9IVS4vz7X4hbftZVJDRG40ViwIkw1UBPMAOmYx4AttCmDFZt+YeYkNWt
	 S9395guvQGVUxGPA8rr8tBqp8XV0jnL/8mEQ1CIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 5.15 63/69] usb: core: Strengthen error handling in hub_hub_status()
Date: Mon, 31 Aug 2026 15:35:36 +0200
Message-ID: <20260831133401.888783807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -955,10 +955,12 @@ static int hub_hub_status(struct usb_hub
 
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


