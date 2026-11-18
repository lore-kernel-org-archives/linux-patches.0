Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039370;
	b=hbKxZFQbK9IZ7M6SfgwNa4CNlL7kyzZdqoobh2EbMtTQgEvcTeviSSp6TKS3YDMBX3lP
	 Q50WJAYxlUV4Hmkl7dwW9owaUHpB2GARMDR2pFbZudpvT7J22Qjv30tuOg5MzeZKRKJjz
	 2Yu6o8bOMd7cT+QDze3RrQvZnwsE62zSDJUXXjDVeSIiZwj98MDaFudqhoNl/rTmABGNJ
	 9NYfCe4P5hUGnQNEvsfMGdPCBMIzR6QXLr8t6MzSOF+pY5VWpURmkdE7d55lGWptbWlQt
	 EhBs0AfAtn1Y94Xm450ZpVWPJgaWVx4+tf4OFzLeJMAlF+/jvhXPrWulD4fQAF4VJnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ga/Rcvzgpwr0mfCgkJhWX40uqIvsmUmY8EmTWDqfBO0=;
	b=MbYcMWHPNLaSzNy+fJTmZ+NztHdGS9kbL/AB1SFA5h3Usns5ttdITiiWWaG/MX4ZHFvL
	 9rGu+jX4q8yZir5T1VbyNalhUgkIAQ3OHeZWu4MYsope8jYoHytuoj//GticiBO2nKl95
	 qaJUJDIS0WEqSXQ+cFl/Z7jcOLQqh528gghXoZgoieEF/5WQe944H+P3Joee4lU5h5+Bg
	 I50vn7zw1nvrcFSWtaqgxE+bORJgaNPxDvS8ZLgp1MUf8R532xQxH+LTGi2pUByvnd3jW
	 QWktuq3+9SOoBDvG/EtihbgC0ODeuPiK1ey1gZR0Bm5fyHz+NkPbXl/3/jW48Y+ft/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CreBBHOs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D5F606A32C;
	Wed, 18 Nov 2026 22:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CreBBHOs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2774C1F000CD;
	Wed, 18 Nov 2026 22:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039370;
	bh=Ga/Rcvzgpwr0mfCgkJhWX40uqIvsmUmY8EmTWDqfBO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CreBBHOs5Uo5adeK9WesxT8r982KvS33qPTlxBljfDQ/4q4fKfBDNTFISMvQaCI9Y
	 2GMbifQfrreEwmn47MyEssjxABSnl2YqinjfrIPthq5TqD7yE+3W30ICFLg2hh+Ta1
	 kNq0bIbrRvtLBXR1M9IrA/oDPS2l5qQrA0RouZAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2076/3318] virtio_ccw: fix synchronize_cbs() after interrupt fallback
Date: Wed, 18 Nov 2026 15:44:58 +0100
Message-ID: <20261118150424.365419941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 6e484b870b71eb6acb3fa7a10b8e71098e242033 ]

virtio_ccw_synchronize_cbs() assumes the device uses adapter interrupts
when vcdev->airq_info is not NULL. If registering adapter indicators
fails, virtio_ccw_find_vqs() falls back to classic interrupts but can
leave airq_info set.

With VIRTIO_HARDEN_NOTIFICATION enabled,
virtio_ccw_int_handler() invokes callbacks under vcdev->irq_lock.
synchronize_cbs() instead takes the indicator area lock, so it does
not synchronize with those callbacks.

Use vcdev->is_thinint, which the fallback clears, to select the lock.
Keep the airq_info check because is_thinint can be set before the
first find_vqs() call, when airq_info is still NULL.

Fixes: 3a232277c1ac ("virtio-ccw: implement synchronize_cbs()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260908053817.26065-2-kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/virtio/virtio_ccw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index ac67576301bf5..e83262ef56e10 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -1016,7 +1016,7 @@ static void virtio_ccw_synchronize_cbs(struct virtio_device *vdev)
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct airq_info *info = vcdev->airq_info;
 
-	if (info) {
+	if (vcdev->is_thinint && info) {
 		/*
 		 * This device uses adapter interrupts: synchronize with
 		 * vring_interrupt() called by virtio_airq_handler()
-- 
2.53.0



