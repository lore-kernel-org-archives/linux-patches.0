Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029528;
	b=DTk6ipMLeS5iMwSN+HJZFKOA4MxspEaYm3V6csUIkT88XFQwb92KGo0r1i2kc4BeG6ir
	 9hBa6YS4bkz5LOPa/olw4z/52OU62Uvv/+1dZ6KTEphOGkLNZuyYxmcwT/htczd6gM45L
	 qVXVcej3dF8EijJWTymCEDurPeA73Z6YTwzB4qvMU7HoaafC8Z/RvyJPCvxR4D1R8UHR8
	 yk/6mMnsKi5LfQIvvkRjhM5vSouDTlyULNtRqGMKTa04X4fIochV+LVG/VsakRgYDLreX
	 /V0COnG9f5g2edXOQfpMobTVqAhYhqFenLblGwBZ1sMa0wRSqz9C1EM54CXEHoWhQdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+aKGUuRXxj76aGGzXI10xJYJl2+WR40Z7rI+hQTwgzY=;
	b=pePHeFneeMLc/0O005jkBV5kkBEqbw+viMhpsXeUxQBmrG8xf/Dw1TNnHQWKLU4ANW7w
	 tWrFkVrfCHmHTDvW4qMNQcMGAi/AuFO83HHMNl9PxG2oVS94cz2axgSLRppcU+cQY97XI
	 JTRbRjk9fFhrIJMwt8LPr9pbUCPIV4DTMsihhFeVTDUz1RLE9st6UzKFvOT9LU0azUwpe
	 KGwsuREqQYs6taUojJqpp6RFackol/HvMLRAsXDuNi5CKjddeUOmxXfDZo2DnWWmleyV4
	 GZGVVMIIjVtHjqt+EzX1KWXpAYNOW6Ey1un6iFrTU7CaQr4etDxTR1hitNc+o4o0qJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJCwLmWZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7768A606A31C;
	Wed, 18 Nov 2026 19:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJCwLmWZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19821F000C4;
	Wed, 18 Nov 2026 19:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029528;
	bh=+aKGUuRXxj76aGGzXI10xJYJl2+WR40Z7rI+hQTwgzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJCwLmWZXaftvVxyhAidW0C/w9kuRTNghImTFJkAivCtR/EJaanqifefG2p5okKSW
	 eB0YEth2ZbQFI4F4dB90nIzYAu4OzX54ehtx6+NxSzYRsmCUmvpEULRieacI44/T5/
	 ewChPsRRte9L0c7f6tw9EP9w6futyk/JAaIkbDs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0383/1756] virtio: synchronize callbacks after device reset
Date: Wed, 18 Nov 2026 15:41:50 +0100
Message-ID: <20261118150023.855721633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit dd75508e6fe77116589c49658d0d18897688dc0b ]

virtio_reset_device says:
	Note: this guarantees that vq callbacks are not in progress
but in practice, only virtio pci correctly synchronizes the cbs.

On other transports, a callback that is already executing, keeps running
while the driver tears down the state it uses.

Add virtio_synchronize_cbs to virtio_reset_device fixing this for all
transports that correctly implement synchronize_cbs().

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/all/20260818040433.66986-1-kmehltretter@gmail.com/
Fixes: c46eccdaadab ("virtio: document virtio_reset_device")
Tested-by: Karl Mehltretter <kmehltretter@gmail.com>
Acked-by: Karl Mehltretter <kmehltretter@gmail.com>
Assisted-by: LLM
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <8ae2995ee649adcfe1398f7f1c4fc9f7028c3db1.1789204858.git.mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 148ce610ccb83..078e5483b22f4 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -264,6 +264,8 @@ void virtio_reset_device(struct virtio_device *dev)
 #endif
 
 	dev->config->reset(dev);
+	/* Flush pending VQ/configuration callbacks. */
+	virtio_synchronize_cbs(dev);
 }
 EXPORT_SYMBOL_GPL(virtio_reset_device);
 
-- 
2.53.0



