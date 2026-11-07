Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062281;
	b=k+l2ItH0P9pgsMp9z0bLoonR15TNKHodQPttnShOpNTd8ZkN2XhlGrOaMccLNmOFmCi+
	 0PQMYESlbOvG+LIDtH/NAHzeOXj92dwGX95kA85MqE87XCzxbrKI7ioofVZElDAMuVXn1
	 l43+g1kr/QyX4M0SsQk9+WTzBLFfZdRwVRKd4YQJ+sg0AzmIbYSE6YP5VCmWN6Km/aK19
	 LnljBKUDC5nEZj2p+FYQKCfe0NeisSNNDkq0Zo29WRi1CWEF/3ydg/Dv/l7hbLwndkWd+
	 C2XynHJfb+s+s7qAZwBqlCxuxYTKpKYQlGNQ9NKiW1AuuD5mb+Txmw7DkQyp46zGvww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9EVZua8LKSDOlbN2RgUCmTUIkevYd/cHi3+altah/gU=;
	b=JUAKmEsXrU/kAAPX9BOG+lIxNNdwjY3zWDRORReg/shV6GiHIyEbzrzGfB8I8wZ7L7c7
	 FTJtB4HQta0SeClabW+S8KaV7QW9DXOOC+qDiluACuMVopPePVLBFFtEpF247kHegA1Nk
	 2KDKualpe2Vqfl6T9mn6e+H7nYgF9NBxhxYWTseWztKq9lXL7m1ahzhoSyKSVMaQrRzvc
	 Qi0RfqPn3he4RC0svyz804FXelpKd4lfKG7X0eLgZ4GXH56ojscr+GYuO0k/fzUlR5oxs
	 Aqv7Sk/IA2SeWhuSU8jIrXRqvW/NEH/sEfFkCYU0LVjvFiuzLbVfVHgSMctnSJAsz9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YiH43onA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC80D606EE9A;
	Sat,  7 Nov 2026 14:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YiH43onA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B84D1F0089F;
	Sat,  7 Nov 2026 14:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062280;
	bh=9EVZua8LKSDOlbN2RgUCmTUIkevYd/cHi3+altah/gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YiH43onAcx4ioX1xXu6vwT54TKlgXu2KVz0pQ+k7YKjw8iGIggXKXTrUtbQJbVdAW
	 JmW85gnKCXF/0Gvrik/01QQTstYXvfMT/2YR4wgcdWF9jZHAg3VmMK8FwT/X+edkrj
	 xorhPwVbHShi3rQxgawSSfwEAWddzspbXRSJbjIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Seongjun Hong <hsj0512@snu.ac.kr>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1220/1536] vfio/mlx5: Fix boundary check in set_report_output()
Date: Sat,  7 Nov 2026 08:53:56 -0500
Message-ID: <20261107135032.021040224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Seongjun Hong <hsj0512@snu.ac.kr>

[ Upstream commit 37b2ee6747b7857920ebc71eabc25208a39164a4 ]

Use > instead of >= on boundary check of recv_buf to avoid the bug which
the full message in the last slot of recv_buf is ignored even though the
received data size does not overflow the recv_buf.

Fixes: 9c7c5430bca3 ("vfio/mlx5: Align the page tracking max message size with the device capability")
Cc: stable@vger.kernel.org
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
Link: https://lore.kernel.org/r/20261005-vfio-mlx5-fix-boundary-check-v2-1-75599d2f4497@snu.ac.kr
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/mlx5/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index e7d2251db6267..fd50d19364a30 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1642,7 +1642,7 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
 	int i;
 
 	buf_offset = index * qp->max_msg_size;
-	if (WARN_ON(buf_offset + size >= qp->recv_buf.npages * PAGE_SIZE ||
+	if (WARN_ON(buf_offset + size > qp->recv_buf.npages * PAGE_SIZE ||
 		    (nent > qp->max_msg_size / entry_size)))
 		return;
 
-- 
2.53.0



