Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045119;
	b=cjpM4CPykSlmjFItGvO8tTNms9Gi/cRTEh6IbPbPZEnf8Uv8N6zuA01S7XphuUUvNMtk
	 TWEqtgJd3weO2qOU5QJ+8PPifqoGdT4oLc2muiWB8KN/ZtZGdjzbPO1qE3PlXph14IGUV
	 l9lokwxVg4bFcTpRaN/AnwO9/1hASbAm9HHCF3fgUo3m0pn10vtnJ2qZlu13qdRzGQAUk
	 gRv8A0MywMJyF9xtNVmel7rEzbfdzmSGYPMIlUirZDpKpOoEj0bitgd48vfKkZtXXy+Wp
	 h++KRovwixPKZgfIk22Zgieq60gYs1y0Zm8k22wqkmegWsd0HQUYHq1YSHvt5oUtFBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=plcK0eAj+hL92CxFzTY9nHOuzYNB58o/H2SPCFTPxcE=;
	b=XfpUW9DkuGwYYeuPlv+1ChgjcfdBGTvCFH0LnZ2hTMPw4brGyQSaLTqxX8jBOPjvV8gj
	 NpmJFlXSR0bd2ffrJZJOrBdUYf1xGVNlOrpTeQl7+w5lBv6S6ZpG18kGT9jbUUDm8fBAL
	 C31p8k2TVlyeuq+O7h5JdFPL8OeFZ5ZHJp6WztfyjmVu2jCpsgHMhVbMyHYCNmUgHQ/a1
	 KWd+wuEAIdJ1Bmjl6+4fm1BTyn3Dde25Zs6lUxZvEdI6dO11j3vR2WjQg5SgKP8l5bBHf
	 grqCdjW5zpN+aevobsaHTV2TnC/jaWvhu5NutLQQsHMSj02ZTpxGB3Kgj/DEGMJMRCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lym9wkkY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7690606A325;
	Wed, 18 Nov 2026 23:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lym9wkkY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDE11F000C4;
	Wed, 18 Nov 2026 23:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045119;
	bh=plcK0eAj+hL92CxFzTY9nHOuzYNB58o/H2SPCFTPxcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lym9wkkYaqPzL8neuSsYvxqrv64UXCHOQ6liE+D1OXDKNtoIE1zoW8DUVeWPROv0c
	 M9UmbsVZbTD4NoiNffD0NbbkDh1AZYyZsk5YNYYuNykJh8NqFnen9AMzaXckmgagph
	 XtviXuyP8QMRXxEo4S1/3uUJjSp+lZmyJdBZCzi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0810/2857] media: au0828: Fix media device leak in au0828_usb_probe()
Date: Wed, 18 Nov 2026 15:30:44 +0100
Message-ID: <20261118150230.737278318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 7b7a69c91c0537d48150942d9707614a4fdd3766 ]

au0828_media_device_init() takes a reference to a media device with
media_device_usb_allocate().  When au0828_v4l2_device_register()
fails right after, the error path only unregisters the entities and
frees au0828_dev, so that reference is never released.

Release it with media_device_delete() on that path.

Fixes: 812658d88d26 ("media: change au0828 to use Media Device Allocator API")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/au0828/au0828-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 877e85a451cbe..3b8caedf79c49 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -702,6 +702,10 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	retval = au0828_v4l2_device_register(interface, dev);
 	if (retval) {
 		au0828_usb_v4l2_media_release(dev);
+#ifdef CONFIG_MEDIA_CONTROLLER
+		media_device_delete(dev->media_dev, KBUILD_MODNAME,
+				    THIS_MODULE);
+#endif
 		mutex_unlock(&dev->lock);
 		kfree(dev);
 		return retval;
-- 
2.53.0



