Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056399;
	b=vJNWi6AxG+zCqGU4ogsQuyv12IJ/wmXt1D6N3dMR5VFZARdrmW2vhIps13AR4hYq/lu3
	 ZNBjsHYRID+RXxYaDkpw0SulfW2gcO+C8bGcICAbbgNKZwUNypq5Cfl6TRBT6ookAele2
	 3ogF/fTx5CSn69coynwv5KkdcfMKZkVrpVy17wVVRfpTl1iOJNwNbf9dEbtqpk/Hz6OjH
	 jVN1xzgCM0/PXHuLHzyE7qIFICCyvhOhLdRQhunEFZekc2fLomoiSIg7fnfWKBAGdk+iq
	 nFVajhVhQLEHGQFYolMd7AMElmJxg/VIwJYLAXK9gs47Mo+nWjTSSycATK0fyA6zE8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HVk2xoehmMmUgEocmWnzaVRmwfiEboCKZ3CvLjCbSIQ=;
	b=A7gwINqA16alN/fs8jPG8jR/00HagueK/BpncC+S72aftKet++VxZiu5hIjuUQnrcMz/
	 BQ3MuReGAVe5a5oit55SuIjjQhHgdxJFhkQdeAYVOhS4Az1rv7OgZ2FHosVDQrMWMwlfI
	 5B1cWEfVFxdsQgjrIAQEtfOO9wJX8frPATRlGWfcZun6nNb9I/BzJTAf0j/HvNUyBtoNT
	 CKEZO7o7znD9zGzlh3m+CJ9ydUwAqtsZ0sCrW6qcsPhzUbLUJLIT2YayxdtPo+Id+2DJN
	 inM+SMevXFmdx5BxmZMZtZxGS8M/bxUmnLsQyUgQ4zON5nlKxJ1n4UrsUPYR1TiF5cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jZNmPFoG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2ED606A32A;
	Thu, 19 Nov 2026 02:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jZNmPFoG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1971F000C4;
	Thu, 19 Nov 2026 02:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056399;
	bh=HVk2xoehmMmUgEocmWnzaVRmwfiEboCKZ3CvLjCbSIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZNmPFoGMgNoPNk9jHBJKz5oE5QdDmmRXCugMkip2KcEYdcW/8i87gNbNLWbxbUSi
	 7DpVHVtNAnxK2tMHbrM8/GoGJU1Hdq/yzzMKq4K/CoawtO+OiQJxUvN/5TpTzMhUXD
	 XoWGQ8pE4oYlmpXWfF2F6qlLnGzrFiI8+hXhTYGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1974/2214] IB/rdmavt: Fix error unwind path for qp_priv_init() in rvt_create_qp()
Date: Wed, 18 Nov 2026 16:00:50 +0100
Message-ID: <20261118150129.867666098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit dd36137b218ad6f18ed15e6279412d7fc160980c ]

If driver_f.qp_priv_init() fails, execution jumps to bail_rq_wq, which
bypasses bail_qpn. Because alloc_qpn() has already succeeded at this point,
the allocated QP number is left unreleased.

Jump to bail_qpn instead to ensure the QPN is properly freed via
rvt_free_qpn().

Fixes: 5190f052a3654 ("IB/hfi1: Allow the driver to initialize QP priv struct")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261015102518.15780-1-serhatkumral1@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 2bdc4486c3daa..a40d3ca339aa7 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1177,7 +1177,7 @@ int rvt_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 		if (rdi->driver_f.qp_priv_init) {
 			ret = rdi->driver_f.qp_priv_init(rdi, qp, init_attr);
 			if (ret)
-				goto bail_rq_wq;
+				goto bail_qpn;
 		}
 		break;
 
-- 
2.53.0



