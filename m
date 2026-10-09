Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE7E3B2FDB;
	Fri,  9 Oct 2026 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555428; cv=none; b=Yv75nsqBuhr+mXPR17TQrgb3pEbPsgD/8wdagv2Bg7atkTKCruEp2ePio+NEq3IXF1eIkGYu27FOSl5nkl0x3WlTJ7ZZHOhQQ1hSUKcxQuCGc7fNxvjLdvZvEEjz/fMG45InO4btKxa2MtkTt1FjTluYVWFVl7DIrbNwdmhjaeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555428; c=relaxed/simple;
	bh=QvA89OudjQj8guuWOPTg8VvqvoZG38EcVwwV3tDPp+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9lahYki+/l4wEGZEirg6hN+o9w0k/JCId+/kdlJdaQpJ90B3sA6+RmlgZa6ZxOVnZV90l4znwOXdzDK6h0yPVqGBE6MwmhjuyDP2h5rlEKOu48I3tK8KRxAb++SuYmxtf+W/uyYgySFpA6br9xspnYj5PuMVYBC5lPecLvcidY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svClu7TJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svClu7TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E7C1F000FF;
	Fri,  9 Oct 2026 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555424;
	bh=2bHP4pmppg0v9HD3uPnwwMMjSvhA3VpQG8jkX5KAS3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svClu7TJOrte6CGbMS/ksEN2y/QGXIUxs8AlqaK7lmDf/q1dj/9e2CXdLTWGlSSXX
	 VDq2nIz4DDOqy/C9+WLZ3pT5UJfFVLPG8z57piMH6i7Zb/DAm+lmhANYrGo19ppYN/
	 VQaqR0MgldY5KF53F2BNKINzSQuj0yt6tb88LpOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 052/403] wifi: wlcore: Fix runtime PM leak in wlcore_remove()
Date: Fri,  9 Oct 2026 16:06:53 +0200
Message-ID: <20261009140953.318975288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit a8b8881d0c1aff544fae190469d86db7b07f43a9 upstream.

pm_runtime_get_sync() keeps the runtime PM usage counter elevated even
when it returns an error, so the reference taken at the beginning of
wlcore_remove() has to be dropped on every exit path. When the device
was not initialized the function returned early without doing so,
leaking the reference.

Release it with pm_runtime_put_noidle() as done on the other early error
paths of this driver.

Fixes: fa2648a34e73f ("wlcore: Add support for runtime PM")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917122325.2150910-1-vulab@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ti/wlcore/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6835,8 +6835,10 @@ void wlcore_remove(struct platform_devic
 
 	if (pdev_data->family && pdev_data->family->nvs_name)
 		wait_for_completion(&wl->nvs_loading_complete);
-	if (!wl->initialized)
+	if (!wl->initialized) {
+		pm_runtime_put_noidle(wl->dev);
 		return;
+	}
 
 	if (wl->wakeirq >= 0) {
 		dev_pm_clear_wake_irq(wl->dev);


