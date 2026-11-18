Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041760;
	b=FGN5R8dIJcsTnxN6zUrWiO5CNLYfAfT74R9jD7uH56Ewep07L4J5EZ5SZ0uiSqDWDX1l
	 j8otIVHddHfqcbKLL4eCABZ49jz5wCSMO82NpaFItxclrg5bvm4i9G/VjRmd0sfOXqnLE
	 LmLYmF2pZU9+8zVb24GPtcmDUkdUbw1DXIfG6JGCFbY1fa5KZT6NS54pyyTU7ERXGzyUy
	 1guqPyBGGgTJeluM5WjE3gVynFIX9RvHi8qNTT+XYYoEcsRSsFSo36nC2fgKDXr+/OIXp
	 uBhF38IzLgsj8b+Eyp9frvN7aM9ZK4XyALaeIYkMXalL8VXVbiA8vrTq/C2kK3gbvYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=toQzoTpGJMFSZxI53yHMEieL9QUTlOgUGTVv7EUMXlg=;
	b=O+lRN/Cc3rEQfzDmjkf5hypVCN22CbNxyxJjMN8oCrHdAjDgKLrYddcLf60Pw7yOF7wt
	 uf2I422tCEjh8p2kL2hOTkxJXOFO7Z6Zmkm5XG5uUYDAJLmOZJUJ2iT66nlIB448WzK+P
	 /SiXPxCvI76NkKboY+qafYPyc+erR+vv1CA65cIE/8QYt+J1WXNxVB0ca0anVtOjNwZWT
	 MYGpM7+7MoLbVTqtfvKiJ69ttvyO29HVYK+e4A08vW+VI3pRbRV+k6xTtOiz6EVnyCP3Y
	 3B0FyW4OXFQux9yZh9MoBY0zRqHNy2LBRvj3HsPhdk7npEOBwg7A0Ge3sP+gHPQtivg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BlVF32kT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3C7606A325;
	Wed, 18 Nov 2026 22:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BlVF32kT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F401F000C4;
	Wed, 18 Nov 2026 22:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041760;
	bh=toQzoTpGJMFSZxI53yHMEieL9QUTlOgUGTVv7EUMXlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BlVF32kTq/TPiFOqmUSdiQndglenZeyN8KougzyyRFJfYvqJUcYPxGJ4aSm73wr7v
	 ZWxo/Y1s4sty90LqPMl2qPsUnxqDveSvd7KkjQxJcpDHOCCCZOAh79Ov9R7wOnWAKb
	 uNXaj5GVa+cuqMmoXWouKwbU1ZWB3y1KNi9BcRm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2928/3318] IB/rdmavt: Fix error unwind path for qp_priv_init() in rvt_create_qp()
Date: Wed, 18 Nov 2026 15:59:10 +0100
Message-ID: <20261118150448.232181827@linuxfoundation.org>
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
index d77ada17e9db6..e4c5f4f2d6874 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1175,7 +1175,7 @@ int rvt_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 		if (rdi->driver_f.qp_priv_init) {
 			ret = rdi->driver_f.qp_priv_init(rdi, qp, init_attr);
 			if (ret)
-				goto bail_rq_wq;
+				goto bail_qpn;
 		}
 		break;
 
-- 
2.53.0



