Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032406;
	b=eb43qR1EbNRw75KPIpuX+fjH3RB+KqctkilymrJnu+guC6XY3croIDX6xYohxGaif3Zd
	 T+wkIhtQKcjtbV32dj5h+YAD8TKgjekSR/sNqqb4LC7V791cyXe3mVvCVJ0RY0MD4BT5a
	 Mo9LMIwX/k3be1UE0h3+YNwOtUHE9hIsiv5gz7J35EdgPWG3Ukw2q8rMLN4mRkZn6BaZq
	 1Rj8HqIl3pL9eRk/PfWP+FGa4iwHGqj34C72V9CCIOgNOrP2u1tH3BFNVekM4Rra/2bUj
	 +ft0feHk3RMiCgxLqyYhfiUdrksxEbMtUO+djQoG5gHu7M+SZq5EGjGl27au8Bn+pmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E9WNtgkvdvniF7yeQ+tx35aHQ+kk9T9NPEEb9/Q68R0=;
	b=D5BRMmpG3oAutiGkxK1uFxvgRl8I7Gll5ApM9fm6w+cXiuaDKlVKnEwq35LfqniXtWeY
	 IkfIgCSQY5eA2/8eqTIlL5+6j7Ftrl+ZLiag4eIyz7+Rnjy1Ucb9IsCK52LjIvVzzqTtS
	 Mc8kak4/YlB2SEU8Doqs1QpuPhb+Sa98LYjZq3fKKShrAxcLp+Y66BZJR9omQOkkp8vW1
	 eTpKGBmqscEv9u1yTNPvsfAhHHHGDjySxxI7vjwyoX35xy1orkWpOXc2UrKE6W7prWjiB
	 1WKsc+bdrQm0xtyED7EDq7kkRsowMHNugRa7QwC0SSQFW6lUeVMxHAL/M9Vg68U3aEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmI86nBZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FF3606A335;
	Wed, 18 Nov 2026 20:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmI86nBZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45231F000C4;
	Wed, 18 Nov 2026 20:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032406;
	bh=E9WNtgkvdvniF7yeQ+tx35aHQ+kk9T9NPEEb9/Q68R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmI86nBZyLL1rmTWPMP8a68st21BHhO+Mx3X1Q7wwvUgm8/3WykcByBpXqbzCJHnM
	 YYSTTRVrUL9MDuMyTm1bzwvpYTS65ZMsMtYYzXogdhDAEcg8rT50963it+qsAHjqOm
	 GpLEiUzQrjZcKnaKzdU0vC7oB8IZW4RPAo9YA3OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1400/1756] RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()
Date: Wed, 18 Nov 2026 15:58:47 +0100
Message-ID: <20261118150104.932533773@linuxfoundation.org>
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

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit 9dd8b9a337af844291edcd9139c927d0f7958dbe ]

In flowinfo_read(), 'left' tracks the remaining space in the 512-byte
stack buffer 'buf', but it is initialized to 'count'.

Initialize 'left' to sizeof(buf) instead of 'count'.

Fixes: 9f637f793602 ("IB/usnic: Expose flows via debugfs")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261017185028.1019445-1-serhatkumral1@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/usnic/usnic_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infiniband/hw/usnic/usnic_debugfs.c
index 10a8cd5ba076e..ece7c6e714997 100644
--- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
@@ -76,7 +76,7 @@ static ssize_t flowinfo_read(struct file *f, char __user *data,
 
 	qp_flow = f->private_data;
 	ptr = buf;
-	left = count;
+	left = sizeof(buf);
 
 	if (*ppos > 0)
 		return 0;
-- 
2.53.0



