Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036588;
	b=Rm4nFND4cQaJ8m3RK9YMhBzqxS4oNLQCPghw/kFgc5Sz7Ncc2gc/sms6NUU4op44JMYG
	 v5IX6BnesXZZ2bm+iNbHyuPzrxBjCPTL5OMe3r1OdSSUqgULIsQps4Rtn6jzq8S5qb5bb
	 RqLCAcxO5SCZN7rAafHyS0NNeH4O8vnbHHKC2ZhM8F/fxFSyRWqPT6f2e0LGAbkZRde0h
	 34AwwWLv5uP2QGg0W4Zv1kayq3bDhc9fFIzHDrggljrGFCfdoIDr9llvkEMdjTdkNeC7I
	 eLTZwX6OD1j6uzooZ3v88CIItPAU5u0GV0ccbUHYdGjoNvqmz3dMtRasupS1n+K78NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0uJxjv1K4MbWWVC721JhyRgHaUBS60E0US9OURDTKos=;
	b=xgDyvLhj+5BGb47xrisiWP0nOAfk3M0AKXnG3fOYogEK0t1wIhhRItJqR4XoF/puCX48
	 fDGkKAhrRpTXeE2fIDS84o+MH3mOG80y/x8Srixv5e94WTj8Y+A8dfiBUmT1YpvC8zmnP
	 REK95MQeWwpHQDpbswapZRHMmLk3wTqvp8d6WkocI/6OOly401JWGOaPX61UZlQ1KiATj
	 ymapAJa0EZ8Rnm7bnqVwBVFLF10Ozp02Pds3Ta82Z/1ISA5jdk5N5b8d6qr0+aBCCPK3y
	 R3dt+qZYL29/ZgCe8k8fjEuwLjKwwE70UZe1504AVVAG8z2fbIhf2cjZBXXHAhz6uiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WECWTY/s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0A9606A32C;
	Wed, 18 Nov 2026 21:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WECWTY/s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C26D1F000C4;
	Wed, 18 Nov 2026 21:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036588;
	bh=0uJxjv1K4MbWWVC721JhyRgHaUBS60E0US9OURDTKos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WECWTY/saFusRvEyW2yvnOs1HXeLblbTPBJv3NB/PjDEfSCAhFA+UZFjDM6cRcyMZ
	 /7ML/2TuuMiuBbN/Yud9K488PCnCfmD2/rrmP6vRo5RbZGoAPRAGuMoop9v0oJ3e3B
	 2ylCI5mW1CHzHb78Q4aSpI69r8EQNRHJ1+syYe5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Seongjun Hong <hsj0512@snu.ac.kr>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1060/3318] vfio/mlx5: Fix boundary check in set_report_output()
Date: Wed, 18 Nov 2026 15:28:02 +0100
Message-ID: <20261118150351.754854574@linuxfoundation.org>
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
index 82558fa7712e4..b6d203906cd67 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1493,7 +1493,7 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
 	int i;
 
 	buf_offset = index * qp->max_msg_size;
-	if (WARN_ON(buf_offset + size >= qp->recv_buf.npages * PAGE_SIZE ||
+	if (WARN_ON(buf_offset + size > qp->recv_buf.npages * PAGE_SIZE ||
 		    (nent > qp->max_msg_size / entry_size)))
 		return;
 
-- 
2.53.0



