Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9106217109B;
	Mon, 28 Oct 2024 06:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098146; cv=none; b=fSULXpBOh+SG3H3/v5zUu6Rj8koInNWnbr9W0pDxnmxoCkPq2oGiT6Wv/Tx5EXbGS1pZuQY2cfW+196bdeZ6wkVi9E5cKtMe1zl0KYT1StteRfwVzYBQ7FgZSn+HYHALON4ZkTs/swiymc9AKUsrZSbfQgOr/aCoC8b5ZbrPnNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098146; c=relaxed/simple;
	bh=RL93jTN1q1vLXvRI9FyJvmDMqg1ABQGNuDvhTPEpIjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+TAD7Om6LK2B6AA3NUKGAFdqaS6HjjW/c/JFw2ScCL4ivW4ninAsQc8kZaWCyTi+dCJxJMaBAn0aEUIeY/BhH9aCphuxvZK9Ui+7FQyBs+TiUcA+8fObGIhEQU+7qINv29uBwo7ul0yhWb7rN/SyJ8BXOVwoCnMHVgxxIXpZkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVsk0Tnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVsk0Tnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E393C4CEC3;
	Mon, 28 Oct 2024 06:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098146;
	bh=RL93jTN1q1vLXvRI9FyJvmDMqg1ABQGNuDvhTPEpIjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVsk0TnxtjVLjD5UeJSKiAMLHIBSVm32MKMQLb6Zq4ImALO7kC/A+u/SZDlKWd240
	 J0hoRfvD39Jv1cgDMY8fnSffkT7ZZEJK+GKJfSrX7Ai/6iPejW5nPcmkXw7BpEMUZR
	 rgDEaEQleUm37UFGsNNoQg756vTHcAa7Lq4/d/2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 060/261] net: usb: usbnet: fix race in probe failure
Date: Mon, 28 Oct 2024 07:23:22 +0100
Message-ID: <20241028062313.531475217@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 2506aa8c603ec..ee1b5fd7b4919 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1870,6 +1870,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	 * may trigger an error resubmitting itself and, worse,
 	 * schedule a timer. So we kill it all just in case.
 	 */
+	usbnet_mark_going_away(dev);
 	cancel_work_sync(&dev->kevent);
 	del_timer_sync(&dev->delay);
 	free_netdev(net);
-- 
2.43.0



