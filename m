Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590280;
	b=0r66oRB0+I0Sr0YjKChPZSNTgN8yq8btmztr6O56hrotweZCG/dEerybEb4H464ljnIJ
	 uS4FSjaIFuWTmiEnUuiAI/C+b9e4h+PWzO/BrvoI3z8JxqDzPVRwy2TUyzBLmcQH+PVyO
	 Ne5Cf0a6ccZeN8yvgegkfL/mOdveqbQYdFseLkX+0YJkOtXCDAcV/htT92VqxC84HGfpW
	 9Ubtg3ERvJ5are/udEsQDNBhCbMah4C6OPTVS0luK1/gF+Mv4qUKML3i9jUodK1/zZ/XH
	 TqHUcQ7E0eT4jYhpglXujKtrXm02CkYvM4rkmPZ5xoGugtKRoTxdSUv5CMUa19hebMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pGAwHnL0yjWJuRX0rYNnwtwvMDAgUF+p+Cbh9DmK07U=;
	b=MmVZH4wYzcmaEWvuOKeK7irDxYuZqaPxto7uL7TFLLjLJNfoTCr2vI7CHP4MfALn7y/E
	 u4MHlfth6WdFVvlTl82X5FaowtJ0EQFr2v3D6AfeYcvhR2MX3XsJE/+R8+7KFtFHuISYK
	 q9zNP327v8ts2J2jLU6SVEmtrVTZDX91Kprh600rHvk7an9eM/ZylLrfQ0Y8FkhNv3tJM
	 5WPGF1C587nx0h8UUOUO67bNZwuVxCxAV5/hbjKSzsMNUZkOi0eoBgmku5nmIjIa9KJ6Z
	 h7VvF9rd7dfBzPdiqMEVi6voG5aMkSe37EodIdD4+hj0/nnUFuWGxvF8NAHo7QjvJcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHfJdM6q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CB260A5BD5;
	Fri, 13 Nov 2026 17:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHfJdM6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56441F000C4;
	Fri, 13 Nov 2026 17:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590280;
	bh=pGAwHnL0yjWJuRX0rYNnwtwvMDAgUF+p+Cbh9DmK07U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHfJdM6qFv74BuS4cN7bCyE+Us7SqztHJeQPJVdftuRulh8R9SVguq67/MYVjXLlB
	 kbIsW9rfAnFiWxDRQv+rEX8obddlO1Y/hBPQjcSYzVitma1KDk/JwgBBf+QOQVBpj3
	 mXQNQEIORlLffza6Myazxq0RZqRP5q9jT8wE6l50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 268/686] vringh: reject empty / undersized indirect descriptor tables
Date: Fri, 13 Nov 2026 10:46:41 -0500
Message-ID: <20261113153830.097967638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit 60a792b97933a686316737838cd007d27963011e ]

move_to_indirect() validates an indirect descriptor table only with
"len % sizeof(struct vring_desc)".  A descriptor flagged
VRING_DESC_F_INDIRECT with len == 0 passes that test, so *desc_max is
set to 0 while *descs points at the empty table.  __vringh_iov() then
copies one struct vring_desc from descs[0] -- 16 bytes past the end of
the table -- before the "indirect_count > desc_max" loop detection
aborts the walk.  The over-read value is discarded when the walk aborts
and is never used to map anything, but the access itself is out of
bounds.

Reject any len smaller than one descriptor, alongside the existing
stride check, so an empty table is refused with -EINVAL and no
descriptor is ever fetched from it.

Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Message-ID: <20260926160755.21485-1-fangxy@xiaopeng.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index c753a0cee240d..3391413379579 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -197,8 +197,9 @@ static int move_to_indirect(const struct vringh *vrh,
 	}
 
 	len = vringh32_to_cpu(vrh, desc->len);
-	if (unlikely(len % sizeof(struct vring_desc))) {
-		vringh_bad("Strange indirect len %u", desc->len);
+	if (unlikely(len < sizeof(struct vring_desc) ||
+		     len % sizeof(struct vring_desc))) {
+		vringh_bad("Invalid indirect len %u", desc->len);
 		return -EINVAL;
 	}
 
-- 
2.53.0



