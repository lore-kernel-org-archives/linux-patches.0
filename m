Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032504;
	b=GNsi8KrI99y6QXO4pnKOJm4b9S2H/uKWo+YzfbuXngZHUiwPv9Fb9Ea4zsMlibqyEFIg
	 SzWuPxGMNO8d94xB8EHNxllE0qOyz+aCZSy0jHFFrrDZSAX7g1et9/2DqO3AmLARITdUD
	 oBr2hXcGOaPhHJaC8sHFKKxIZwuDq1RZrGYQfnadWuEexw8bH3GlIIkz3Qe93ZqCgEogl
	 X9H6+uHvZ6cJmeEZFqVV4SQE+nlApwOCXAc6xLStEx1BCSFiKuYHtSgP2O+bCNUTaeYtO
	 SSuJu9yfaXMDepOarCcEP8DkQqMEVFFX9O2RDumjWJ3WVv/KfL9k3PY6oqXKqj/jl+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IO/hHoAAozMC77a8IbqC76HC4N1PxOi9DiGB11vFXwM=;
	b=yuutHr4rCdJOQiZV1yAncHdejgc1NDo/yrDuhQ3UpHt99AuwAZjK1DRRieQtJQT7Kkuu
	 yvxP+lRFnZZV60JXu0BgdlyLvk61NwqwIf7dh96G8Yab5BmJh1kSRpNpPL/DtFJ1C0DZG
	 iZrOvCjtv4tRiwmP0qodF9ZuJ6ZNR6fIN7x6oCDXf+0piMCq6ba9G5rcGF+5IYZ3LUNY/
	 lovTFeYW3y3voQJXxpTWIDyumwp/oHLXcDOzWMQ9rB+BnLQWf/5+LY+CE5tPrBUXQRD4Z
	 r8+gn5AIZLP0llXKvInSueUwS2PIPWvJvnyAY2EtaWiQzaDU+iL9hS5oOCXSuUT9NeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N2cHPvjD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBC7606A864;
	Wed, 18 Nov 2026 20:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N2cHPvjD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BA11F000C4;
	Wed, 18 Nov 2026 20:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032503;
	bh=IO/hHoAAozMC77a8IbqC76HC4N1PxOi9DiGB11vFXwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N2cHPvjDOB0hW13MwmO4oxbGfTl18ex/pcQxLZtqjdtPbxYVtSM1JYBtdWJyyOVFr
	 mXygZUH/sgdE4ts0dIMqQIvgio7udu8XCptyxnPaqAVONn5UJ0t/YqmuK3tAd3js0F
	 dyN/O4g+UjvV4EUTJjtZl1gL7HapHM4KpTwQy/Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.12 1435/1756] vhost: vringh: use get_user()/put_user() for IOTLB 16-bit accesses
Date: Wed, 18 Nov 2026 15:59:22 +0100
Message-ID: <20261118150106.299768413@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 95a214f31a3b1ef40034f1e1cb3b9d758a374f01 ]

getu16_iotlb() and putu16_iotlb() use __get_user() and __put_user() when
the IOTLB maps to user virtual addresses.  Nothing nearby checks the
translated address: that relies on the mapping having been validated
against the user's VMAs when it was set up.

Use get_user() and put_user(), which do the same single, untorn access
and also check the address.  The only atomic-context use, the vdpa
simulators' notification check, now disables page faults around it, so
the might_fault() in the checked accessors stays quiet there.

This is part of getting rid of __get_user() and __put_user() entirely.

Tested-and-acked-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: 42823a871fd4 ("vringh: support VA with iotlb")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index db012d6b549e5..8a5356620834b 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1290,7 +1290,7 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 		return ret;
 
 	if (vrh->use_va) {
-		ret = __get_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
+		ret = get_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
 		if (ret)
 			return ret;
 	} else {
@@ -1329,7 +1329,7 @@ static inline int putu16_iotlb(const struct vringh *vrh,
 	tmp = cpu_to_vringh16(vrh, val);
 
 	if (vrh->use_va) {
-		ret = __put_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
+		ret = put_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
 		if (ret)
 			return ret;
 	} else {
-- 
2.53.0



