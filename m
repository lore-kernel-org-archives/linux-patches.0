Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C2C18E778;
	Mon, 28 Oct 2024 06:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097284; cv=none; b=SuaKWC2Bieux2bDAuUzfzFAWWy9b/Gi3l1cLbFtlVIgIvzPTijdkD3jn+B8Dev0F79omkL4WBNMUgwIQK8icyPYYjhDVFKLi2YtADSujptTRdrxzaZqeuC3SfXqOQx9ksKktAKSylGG56lRvkVtlJk4Nzj/1dvlbJG3b9y0CNgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097284; c=relaxed/simple;
	bh=JFCj0FQxO/I67ZlNjlT9LnZmt4ddTAk4b16pKiSpAwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQ/RweonUXCEmR4C+uFg+ypHVrwC6p8oTNM2ZxugTDnYLNgG7tGj8Qcul06cLKaCgEjiw1V3s3WmmFQeVXOzdOJHQLipcjFd2cDyyLwUy+wIoPQCk/5gvblibyWncOB+3LADHX8biCnzShdlmawfOXvRvyX+XrdHaaV6q5tfIHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/87lgH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/87lgH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2B0C4CEC3;
	Mon, 28 Oct 2024 06:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097284;
	bh=JFCj0FQxO/I67ZlNjlT9LnZmt4ddTAk4b16pKiSpAwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/87lgH/2FbkZDvcfcXjwGm7qlSHNu2laV+RUsgiwpB6JJhySHZMQSO8l+XHRebEW
	 Uj3mdxoUKWZ7RDwWlvE4B4c4YM+4qgn9mDtB2s9XN5pupACBTtIwmA9KjePB+EfFwl
	 y0Ltr6kD0tkZ0JCdq58uyS4C9LBCUdu2KeP2xNWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/137] net: usb: usbnet: fix race in probe failure
Date: Mon, 28 Oct 2024 07:24:24 +0100
Message-ID: <20241028062259.478996683@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bd0b807db751d..ce587a12b894c 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1869,6 +1869,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	 * may trigger an error resubmitting itself and, worse,
 	 * schedule a timer. So we kill it all just in case.
 	 */
+	usbnet_mark_going_away(dev);
 	cancel_work_sync(&dev->kevent);
 	del_timer_sync(&dev->delay);
 	free_percpu(net->tstats);
-- 
2.43.0



