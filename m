Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6C6151CCC;
	Tue, 20 Feb 2024 21:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463688; cv=none; b=OgqpAQmF6Pv7CdWd19+DJ9VwxeQ71Ry1f/HbX+joRuBBj86a/qRcpkWxnHeHc1NfHWPfMyVvGLFblAZXwwkNvUuicNiUMPcA7dl5F7rdB1M1rLFjkwUEbzRvxyHF813w5K3ivqZUDzoQnACKRx2WsagODrP+iuTXk8qBEv4k67g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463688; c=relaxed/simple;
	bh=LYYkLzsn/uye/7BccpT5nBCrxVh2k6BRgvHsMIwzjt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTYTxLSO7b0xtpnqWYmPQ0GEYSozlQ/lwYq0pOSxXxFdcMa04c6Sp30lj5/sdUb8JGYUE2IJ0MoB3aPF8zwqWO45O6TTQfuv9QoTqCIsCq4/Iv/iIQxonrdYWLIzhSjhAhLetSG+29knqKPsG3fPM75xFhQNP+hfMFuuaCZt+V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAUMd9SM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAUMd9SM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D82C433F1;
	Tue, 20 Feb 2024 21:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463688;
	bh=LYYkLzsn/uye/7BccpT5nBCrxVh2k6BRgvHsMIwzjt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAUMd9SMQdJZZSJfnLaIkliHoLU9uHOUvye0RMkq3C9y0hyF9ZMfD/dQiriAwZrvI
	 VaHeK3lQw6/BMU9SKJeCmJ1SIvx/aD5++dwisyVdgsurg+XtsuBf7sgzI7s3vhcOdB
	 DaH5LNmxxb5kGjZ/mRv4CO1qtdZS202n3AsGOKJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udipto Goswami <quic_ugoswami@quicinc.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 083/331] usb: core: Prevent null pointer dereference in update_port_device_state
Date: Tue, 20 Feb 2024 21:53:19 +0100
Message-ID: <20240220205640.204957672@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Udipto Goswami <quic_ugoswami@quicinc.com>

commit 12783c0b9e2c7915a50d5ec829630ff2da50472c upstream.

Currently, the function update_port_device_state gets the usb_hub from
udev->parent by calling usb_hub_to_struct_hub.
However, in case the actconfig or the maxchild is 0, the usb_hub would
be NULL and upon further accessing to get port_dev would result in null
pointer dereference.

Fix this by introducing an if check after the usb_hub is populated.

Fixes: 83cb2604f641 ("usb: core: add sysfs entry for usb device state")
Cc: stable@vger.kernel.org
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20240110095814.7626-1-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2047,9 +2047,19 @@ static void update_port_device_state(str
 
 	if (udev->parent) {
 		hub = usb_hub_to_struct_hub(udev->parent);
-		port_dev = hub->ports[udev->portnum - 1];
-		WRITE_ONCE(port_dev->state, udev->state);
-		sysfs_notify_dirent(port_dev->state_kn);
+
+		/*
+		 * The Link Layer Validation System Driver (lvstest)
+		 * has a test step to unbind the hub before running the
+		 * rest of the procedure. This triggers hub_disconnect
+		 * which will set the hub's maxchild to 0, further
+		 * resulting in usb_hub_to_struct_hub returning NULL.
+		 */
+		if (hub) {
+			port_dev = hub->ports[udev->portnum - 1];
+			WRITE_ONCE(port_dev->state, udev->state);
+			sysfs_notify_dirent(port_dev->state_kn);
+		}
 	}
 }
 


