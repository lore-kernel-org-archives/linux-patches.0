Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3169318CC1F;
	Mon, 28 Oct 2024 06:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096854; cv=none; b=kiKCqkfU9HC9Yg0HhnmzZeM+9oq+rOq47A2sbHqMN71C5GqjXZ4zS7U6dmTQE9asMqp/wsB2OjafV+jS2QoQFTq+IPJaVSmyKUztkNBL87XYq1O5aRJwQ/est9IEoZ1B7zgggyAXGc34Q0bLEq/y66zjoBS5Y1vqgExLBvTyMmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096854; c=relaxed/simple;
	bh=XOf4maPFu9aecT3xdfC3PCeCiztJJ62zfUNKpwsHLdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpVPg/GP7ea229eim9xijwBLieAQ0fTrD9s7vqTRh7CXIl4g7PGO2HzyQEqkx2j3iYjTIBdM3y6Co6IM8FT60fUxn1UuUpHjFM2YIBCkCSpWnFHBYsCaJCacB3XVtYfqWsPhaO8C1zzLBpmo6UlqVd0JoBpXipOd0zaGqDGEd5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2P2tFnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2P2tFnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40D8C4CEC3;
	Mon, 28 Oct 2024 06:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096854;
	bh=XOf4maPFu9aecT3xdfC3PCeCiztJJ62zfUNKpwsHLdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2P2tFnYElFkBXJGD1KOmx3tqli8kiQFrwcxqB2Y/FCvcWp+GJqMPHu2WAj4v5vNx
	 EPolQiLA++NBHa2+mwR+L5bIg7b2kwhXKMk6jQOCB9WBftiD0IOUWWnp/ZaCDHUalG
	 4F7Vel0E0Hv1rZCc86jK6ZBzIYloxqIwoZRTAn2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/80] net: usb: usbnet: fix race in probe failure
Date: Mon, 28 Oct 2024 07:24:56 +0100
Message-ID: <20241028062253.070646518@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit b62f4c186c70aa235fef2da68d07325d85ca3ade ]

The same bug as in the disconnect code path also exists
in the case of a failure late during the probe process.
The flag must also be set.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://patch.msgid.link/20241010131934.1499695-1-oneukum@suse.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 47a587dae7463..2945e336505bf 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1872,6 +1872,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	 * may trigger an error resubmitting itself and, worse,
 	 * schedule a timer. So we kill it all just in case.
 	 */
+	usbnet_mark_going_away(dev);
 	cancel_work_sync(&dev->kevent);
 	del_timer_sync(&dev->delay);
 	free_percpu(net->tstats);
-- 
2.43.0



