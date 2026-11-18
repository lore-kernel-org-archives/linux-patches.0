Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047928;
	b=QnU2H6jL91j+Gsc9+BsGv147mff78lmotujU41bgr+uGpcpcZpoLkmFTPRhdUi6e+eGy
	 hY8tIDIMpJ73t4TmLZ2MfklTLUpNnA0rv8W8UnFwibHVTfH73PQ5NGI5uRs0Lou+rTTXT
	 89x7rN0eyfobpJhyoou0msdC6RIR5woX+1hP6aBIplTWpx4oI8b6v5XB410SHoObjfLri
	 R1vfNMu45DqqQM6BgTqrmCMMH3W5d3KeTbT1LWd9QRcxL0YNdywGzFzM0FvM4lq3TaNuc
	 e+3pAVERhgVGAH5JHnk7u22TedGj+Q8rnkfJaqRYLpQxNh+T3zBHSeBfdoCMfDMKzbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9V8mDhUJuomHhixGX6zfauL7zMnDKds41FtoT8Wgykw=;
	b=aM66aTTlo/NmdYSluvSD4zjX0BJ0P+IgFKspt/z7d8nzjP2ARGpFIwVFXTT/HnLnehi9
	 2/Zemx4y4gzJGbItLLYkcbNKPfRQV2KPVpnDZNgZq3vq2WLsNr5BTGrEMdHLFPekMWuhh
	 FlFIZpddV0l4f2LQsNb866OS5mgNOjMG//mhoRWd0DE4vrKMaA2YPYGmNCYP6lV19eEoy
	 4dqOkrKTorteGM01gd6LOAYLxqgb9gXJZ5RE0a3JG1oVGf3Xyr/DCdvhk4HiavnUi8FFk
	 xiehhauvs+6wWhRcWl3SedXkHcbMjByni/grq6nMqHcdd0Q0ZuCbcNIOvVN68qwhw2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvrE6hEZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFA9606A320;
	Thu, 19 Nov 2026 00:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvrE6hEZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C1C1F000C9;
	Thu, 19 Nov 2026 00:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047928;
	bh=9V8mDhUJuomHhixGX6zfauL7zMnDKds41FtoT8Wgykw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvrE6hEZ8g9NYhG4tBSQjVpYpC+0e9k0eQOyctBEluYukXq1tf82OPe3CxoKSfa+2
	 s4a7uhDflmYZTtEJmOr6UyU3yQ8pWXRwNxEW/E0P09swgjEaw8IaMvOlk9FohYs/M7
	 KOf4VHEhz2mLn/z4Hsdkht9DDcwJgusMHoYuzCec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1811/2857] virtio_ccw: fix synchronize_cbs() after interrupt fallback
Date: Wed, 18 Nov 2026 15:47:25 +0100
Message-ID: <20261118150306.453944461@linuxfoundation.org>
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
index 630db9f4d9f5e..80f3e7636b53e 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -999,7 +999,7 @@ static void virtio_ccw_synchronize_cbs(struct virtio_device *vdev)
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct airq_info *info = vcdev->airq_info;
 
-	if (info) {
+	if (vcdev->is_thinint && info) {
 		/*
 		 * This device uses adapter interrupts: synchronize with
 		 * vring_interrupt() called by virtio_airq_handler()
-- 
2.53.0



