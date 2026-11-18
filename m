Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026941;
	b=3zq74GQwTmc9f1k91u5F2KmJUf09CZ4gb6nn6ixzdcxfse02mDA3o69D128gHBdAWPv5
	 57VZNHxNMhjF6XgIDTaZqVt5MkNi09WI6WhXngY0FC/BlH4C3thZMN+31dV5OpCiiLfkv
	 3XoVpN1Fwo2HL2gWbuEGUZTjbv499oBQOQV/cq+3tXAm1hzHH3Et0apTNh4YNNbUQJJjH
	 I026e7yqN+gb8ZhqM+6b2eMdJylP7d+gGqTQgOLYJ/rXQN+xhBYAGvb1EtIQW4Efpz4Kv
	 BHfokS+e2SOdDZgS/Loy1sR1/A/mnZgO4GZyPBraCP26Xdtb5mZ4x2tQAISbNqGkApg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=de7FvWI40MObwGJNwiTrvVG7risZJLEx2dAmtj/zwhY=;
	b=AwHkCPOn3dq+RphcGr4BvMb9L5sZCGB6e+OZuVzUK/PLck9QWipr5gT9a9JJvJBHldwB
	 f/9KsAsqwNEJ5Bgg5uU+PpHQDG5RkX4ng1f27K07JUJJjI7iqn2vE71EuXimJBeD3y1eu
	 QYGhL14Feb6wq8/Gz1ar/bC5SwzX+vIXM9vRB7KhkHVwMEwg1uVSdIVaeXkny8FkUc9Ap
	 cMaojudmWjBGdXcyN2lHUkUXSwYl5rxqRE1Y75sfJLp1jxB86toHWyk9v7QnNNg5pklKQ
	 dOaATva9kt22MrtaTjLK80H+D5q8DcA98zFruoEVsVRD/MFuApx0lFTp3Qjr9xfZBMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n77+3WP2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70F0606A32A;
	Wed, 18 Nov 2026 18:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n77+3WP2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269D01F000C5;
	Wed, 18 Nov 2026 18:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026940;
	bh=de7FvWI40MObwGJNwiTrvVG7risZJLEx2dAmtj/zwhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n77+3WP2M/0xL5MT4RhtX0s4wEn6LDMYN9Ic3g4pFMzCiHF9hUOV4hD07ZSa1gD0M
	 bTc7oW8Qwp/24ubrzBbdfCvwOyq+jJ/Ai2y+9JTAUOREU0lAbNUtZeZdb7G8L3f0f8
	 mrudTChMCCSQqPo454vdVFAAe88h1RmHW09ED7WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1614/2151] IB/rdmavt: Fix error unwind path for qp_priv_init() in rvt_create_qp()
Date: Wed, 18 Nov 2026 15:55:49 +0100
Message-ID: <20261118150220.671683539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 3467797b5b01d..7b8dc8fcfc67c 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1173,7 +1173,7 @@ int rvt_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 		if (rdi->driver_f.qp_priv_init) {
 			ret = rdi->driver_f.qp_priv_init(rdi, qp, init_attr);
 			if (ret)
-				goto bail_rq_wq;
+				goto bail_qpn;
 		}
 		break;
 
-- 
2.53.0



