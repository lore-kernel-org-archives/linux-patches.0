Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0401591E3;
	Wed,  5 Feb 2025 15:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767784; cv=none; b=F9iQPRT/Spqw7RK20kJ+vuVJGGp1akU3lVCi0dQOnQ7a7lmIpDJsL7EiqlzTO3+g96xzzh0Xf/rBR77d5jenzc21CmjglRqyOdt6ll7ab5LNnZmuRSYpcAkX0ppvVXd2FEF5gD3KYW9Ls4WBNl7dR/wGKx/cDUsxc4xtII6nkkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767784; c=relaxed/simple;
	bh=CuVGHUNyvajH4AYNQm8nOUfeSXKxoDKy3O4g8iMaIaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4E8IX567gfMkI/KaivAHwn/MR4sxOUaV0MKyBYJg6V0egQxs/F2MVPPutKZsBaTWd+lQH7y5DW9pa/yTkFIdTdCcgyBBpzLggBHNobesMpqTTR0kilNNrlygvoKd7WLZUDmYzHYmtjbEeLCyFecIu+dJu7xRKgDuQH+CCg7e2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmDjELdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmDjELdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0BDC4CED1;
	Wed,  5 Feb 2025 15:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767784;
	bh=CuVGHUNyvajH4AYNQm8nOUfeSXKxoDKy3O4g8iMaIaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmDjELdpp3HXTIQQy0TCqaMztRK51Lxm1DFzUp3udJDsJS/t4JMnAdzD9x9Wj6wl2
	 f/OodeCO+8gt5QDUlXFfx3lIXJLz4lTQxykBWBrr9fYRJWSPkngUfdLCxNqbdyJjXT
	 BoeW7gaUCeSjWqJ1ApSKeALqbbq8pwGO3fTAzUuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9446d5e0d25571e6a212@syzkaller.appspotmail.com,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 453/623] media: uvcvideo: Fix deadlock during uvc_probe
Date: Wed,  5 Feb 2025 14:43:15 +0100
Message-ID: <20250205134513.545681124@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit a67f75c2b5ecf534eab416ce16c11fe780c4f8f6 ]

If uvc_probe() fails, it can end up calling uvc_status_unregister() before
uvc_status_init() is called.

Fix this by checking if dev->status is NULL or not in
uvc_status_unregister().

Reported-by: syzbot+9446d5e0d25571e6a212@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-media/20241020160249.GD7770@pendragon.ideasonboard.com/T/#m506744621d72a2ace5dd2ab64055be9898112dbd
Fixes: c5fe3ed618f9 ("media: uvcvideo: Avoid race condition during unregister")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20241022-race-unreg-v1-1-2212f364d9de@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_status.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 06c867510c8fe..f37417634ee94 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -294,6 +294,9 @@ int uvc_status_init(struct uvc_device *dev)
 
 void uvc_status_unregister(struct uvc_device *dev)
 {
+	if (!dev->status)
+		return;
+
 	uvc_status_suspend(dev);
 	uvc_input_unregister(dev);
 }
-- 
2.39.5



