Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B992A2D978B;
	Tue, 10 Mar 2026 11:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141108; cv=none; b=cAqtAv6SLT1eNcPOhyOACWOqDvVOtRyaKkR/tYCMX1VTPCRKAtPoloySDQqV7CrBLWAcjKNQwh8GiZX/pgFVIqd/D3zHCopH9eVJrP8xlHPqCjP9KUzA6248i6DMguuNKc+KvydOYomZwiRqfz2ZANl3zgYvvnJEGtljUiDNpCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141108; c=relaxed/simple;
	bh=qmbPAktC7c4Roo1iij736yBJ8qErNypakE66f94CTX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cn/YFRG7aaxs+fm/Z+c6MmyXz+JPsHKhwltRzpXC6/pSe3e+V2FPFo70uwREYNkc2vqqBPmgRx8VGhsRM/z27XOBezgt48GbGFwgRFSm45em/T386rE19pARUP9y7K24quucW7ylM4cd9E/yGXHVRqCLiwIVg8LzgweD5+wEHdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nm7jSLRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nm7jSLRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE08BC19423;
	Tue, 10 Mar 2026 11:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141108;
	bh=qmbPAktC7c4Roo1iij736yBJ8qErNypakE66f94CTX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nm7jSLRQ58b0LHDZi5SguLPUQpqYKdzE+y/gVcWacPG21uN0FM4LFYnDAsIWf5dIZ
	 193oOLLyFReicC2sRgxmE5n7E8xt4dq34ZlIEv9Twq+thEp7H0abX7q80pwO9e3qyW
	 U2Kx8ZAT9ULhDRrsMVmHJYIZsau9Qm+ISQE/7qA43BSP8DHQoQYBJWBj/a8fRg6qbQ
	 0bFlX8gm7q0eIC7EPoclMwIhlS5yCw7fF/uc6mrP7ssn9mXR/e7ov4uR4CdWdrP6Ej
	 ie69/4JM+mTb3CPWF7zPazt6T65W/vnA/mq3riQ4t0VGkDUEdn/T/yLoFs+r0AJyNQ
	 zNxYdZfTyGjdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	stable@kernel.org
Subject: [PATCH 6.19 110/311] can: usb: etas_es58x: correctly anchor the urb in the read bulk callback
Date: Tue, 10 Mar 2026 07:02:37 -0400
Message-ID: <0617212515f09fd3540c5d475f32282194b9400d.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 5eaad4f768266f1f17e01232ffe2ef009f8129b7 upstream.

When submitting an urb, that is using the anchor pattern, it needs to be
anchored before submitting it otherwise it could be leaked if
usb_kill_anchored_urbs() is called.  This logic is correctly done
elsewhere in the driver, except in the read bulk callback so do that
here also.

Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Tested-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/2026022320-poser-stiffly-9d84@gregkh
Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 2d248deb69dc1..b259f61098083 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1461,12 +1461,18 @@ static void es58x_read_bulk_callback(struct urb *urb)
 	}
 
  resubmit_urb:
+	usb_anchor_urb(urb, &es58x_dev->rx_urbs);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!ret)
+		return;
+
+	usb_unanchor_urb(urb);
+
 	if (ret == -ENODEV) {
 		for (i = 0; i < es58x_dev->num_can_ch; i++)
 			if (es58x_dev->netdev[i])
 				netif_device_detach(es58x_dev->netdev[i]);
-	} else if (ret)
+	} else
 		dev_err_ratelimited(dev,
 				    "Failed resubmitting read bulk urb: %pe\n",
 				    ERR_PTR(ret));
-- 
2.51.0

