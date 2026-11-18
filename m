Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039701;
	b=Phydev8hyY0mZ67R9wLaX7WCHtjlNtrO4gqBVUfgnssDk5xQ0nqo9EnqYr75OkXDERTV
	 JmUpEknovZ2a8XKr0LWL5IZA9cvvxO7zUKgI6+/kVQn+ZWFnepJqJG9VSRU5hw9dPycqb
	 UOh6DqgvLiR+7HjdT+3CIMPQzDYTp09nvOcFCRiLbrDLgzevSIK54U+K478L8T7G8tpSt
	 8evqNnOf9uyBGX9cEbU8S9rNpOXj2Lovmm7ywbAa2LskwofXp5S1gGo23Lw+7cg3u68ux
	 EIkVV0e9qRO3xuMW1HGPrGCUyZJs6nwSRWDNjB3E2ZFJJ+tEhdColmABZ1QH0TV4LPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1xdXYqd3nPB0nVrcOjNJbkr4xqAudy/L7eHmYkGXhEc=;
	b=ZEmTfhBsXkNDpF82qRR3y8s2ipGza5BLZkhV+dZE1xYyJwhLoeGsPsIHmByEBJO4OEKP
	 0jE0llJNctE38MpNSMp6GRQEieykQKSjFCVUt71fqLLZSxUbPK+NwIH9TEtranyOwpwgD
	 5zIZE4W1YOgLNLunyvgq9NUS2cO6Lk/AH0dKnJqwmkf0XH788En3CRUWc6P/ItjFIqWGF
	 hBVJqECJTjy2fiKZeOd/7Jlwbs2ACvx8DlHNuZ6za5y3Md82hggp2pkfpJwpnAS+ZYfeT
	 KVWfaDSsQDcVyiOx0EH3LcdCDo8YrcROKPx3dQKz87wnYOKhlwEeZ8WzK1yj0on6BmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qulnZ6O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B653606A31C;
	Wed, 18 Nov 2026 22:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qulnZ6O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51871F000C4;
	Wed, 18 Nov 2026 22:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039701;
	bh=1xdXYqd3nPB0nVrcOjNJbkr4xqAudy/L7eHmYkGXhEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qulnZ6OYqn71uxNgzQo9Q4iaIOC2LqN+yrQf7im6zTfrpwtdJ7Nn6bhIngKWE9NY
	 JNUG16BP6/XURGw8etYxFA2aKEZemU9G3qywcQPfIy3IIjLQUobfDgdcSm9Kk1qoBy
	 FaUy0RiTo5AOQfjVoLH2oSG1WJA26wO+2vEt54Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2195/3318] virtio: synchronize callbacks after device reset
Date: Wed, 18 Nov 2026 15:46:57 +0100
Message-ID: <20261118150427.790878914@linuxfoundation.org>
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
index d09ab0ee74d6b..630f3d1d453b1 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -231,6 +231,8 @@ void virtio_reset_device(struct virtio_device *dev)
 #endif
 
 	dev->config->reset(dev);
+	/* Flush pending VQ/configuration callbacks. */
+	virtio_synchronize_cbs(dev);
 }
 EXPORT_SYMBOL_GPL(virtio_reset_device);
 
-- 
2.53.0



