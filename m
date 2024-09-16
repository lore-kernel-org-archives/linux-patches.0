Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91814154452;
	Mon, 16 Sep 2024 12:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488475; cv=none; b=DsRH1Qu2ormeEjJX8eBNK8ECXS8ERQFDARfrqwg4anxt6WA2Z6xC+u1ElsZbF8EaH6Vs+vQBWH+vUjK1YGFzCDGAdfITtmH8Y9MbJHkPNhkkrzV5CtMX6GNj/hAKrG1mMCzCN5hil4E33MgNn9e1GG0ErefSTtMN1zWbsfgQDcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488475; c=relaxed/simple;
	bh=qnio3qtwt4l+IQ/NLNPP7DCCdvEHYBgpOK79e9vlAK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XwUILsuEZy6DHy569kTYnhe9YZ7u4gOwP6mrmhxgzZ5J25U9U4I6kEaqbArG2/WOQoWMTWDCucQoYmJWDr3kZmbJ8zTe5t+bJ1QM0t580llcoFQUdLiM4gdcegqxzC29pBAaXJtDN+XzF9EtCdTbC2HVQ91tcZYtyvGJ5uTFweg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/7siPAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/7siPAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3A1C4CEC4;
	Mon, 16 Sep 2024 12:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488475;
	bh=qnio3qtwt4l+IQ/NLNPP7DCCdvEHYBgpOK79e9vlAK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/7siPAtnlUSuSANx/gLEqvj1phQwp9myf092gJmK4fQo4b9c7RA5Qa1XnNovREXP
	 3O3W2BI2RusJCwZruwP1VES2id0XNA5JppB85heTQjamCwpWlIqNL0uMXL+gDB26td
	 +CjsTfcBZSqwEQM9Gz/RyAb9VNWkgSTGxUjImVIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyu Jin <xingyuj@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.10 100/121] drm/syncobj: Fix syncobj leak in drm_syncobj_eventfd_ioctl
Date: Mon, 16 Sep 2024 13:44:34 +0200
Message-ID: <20240916114232.427714712@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: T.J. Mercier <tjmercier@google.com>

commit 8c7c44be57672e1474bf15a451011c291e85fda4 upstream.

A syncobj reference is taken in drm_syncobj_find, but not released if
eventfd_ctx_fdget or kzalloc fails. Put the reference in these error
paths.

Reported-by: Xingyu Jin <xingyuj@google.com>
Fixes: c7a472297169 ("drm/syncobj: add IOCTL to register an eventfd")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Reviewed-by. Christian König <christian.koenig@amd.com>
CC: stable@vger.kernel.org # 6.6+
Link: https://patchwork.freedesktop.org/patch/msgid/20240909205400.3498337-1-tjmercier@google.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_syncobj.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -1464,6 +1464,7 @@ drm_syncobj_eventfd_ioctl(struct drm_dev
 	struct drm_syncobj *syncobj;
 	struct eventfd_ctx *ev_fd_ctx;
 	struct syncobj_eventfd_entry *entry;
+	int ret;
 
 	if (!drm_core_check_feature(dev, DRIVER_SYNCOBJ_TIMELINE))
 		return -EOPNOTSUPP;
@@ -1479,13 +1480,15 @@ drm_syncobj_eventfd_ioctl(struct drm_dev
 		return -ENOENT;
 
 	ev_fd_ctx = eventfd_ctx_fdget(args->fd);
-	if (IS_ERR(ev_fd_ctx))
-		return PTR_ERR(ev_fd_ctx);
+	if (IS_ERR(ev_fd_ctx)) {
+		ret = PTR_ERR(ev_fd_ctx);
+		goto err_fdget;
+	}
 
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry) {
-		eventfd_ctx_put(ev_fd_ctx);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_kzalloc;
 	}
 	entry->syncobj = syncobj;
 	entry->ev_fd_ctx = ev_fd_ctx;
@@ -1496,6 +1499,12 @@ drm_syncobj_eventfd_ioctl(struct drm_dev
 	drm_syncobj_put(syncobj);
 
 	return 0;
+
+err_kzalloc:
+	eventfd_ctx_put(ev_fd_ctx);
+err_fdget:
+	drm_syncobj_put(syncobj);
+	return ret;
 }
 
 int


