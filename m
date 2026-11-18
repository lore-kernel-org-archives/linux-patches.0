Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048465;
	b=AHansm34HD82it/brudFChTGVXiXE/LwgF03nG6YdHZ0j52PphwDJzdLBNxk+txY7X3E
	 bQzW4EeCSpa0y5rgyJ/Mg6Nkk87e6qS7DiA+D5kDheaoCXrU87OFU5KIsdQPxDl59BxjC
	 tjHPv6xEJ2Z+7ZsGPNk+xVe/iMear+u/qMfAaKTGtTADu8l2gOl92nEhQn6oU3708Ou8R
	 Gou5u5LKEQ+hl/E9Cal9u+dqwMVNEluqwmevsAj2jSqKofUDnOsLQ7scPvFqVSUqxVO/Q
	 /cz6IHsVXjEoFUpvtPkkvXVvEUfl6Bb3980T+ZvlI4SJXNhpBeNMYrA4yXlVF2DwYjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GFMb77v48OM3/aOWfUFT9znV1pJaIsGKJc5VLYI4GDM=;
	b=J4TBNo3d0jIPfAcObhwE8LuH9T1/hCjchYP5GawqPHgY/d23TfGfOFzdW7HCsMvfD/z1
	 HcLAq6xWekDB7Atl3JDe/OOAa0qZvmuz7xgGRlI8Mcq1Sj4GF2qjSDUTdPSAksByLzjc3
	 Ue43EY2/2IOGbknYCAItghGA6bw46wolDEYUlsjfNbO6EPe0CqAfWQAFCHTi9b1mNrKPN
	 W8LqNffhlEGlq/8CykMLkRZN6zgiFQyVOsDX+xaKL1kp1jfw7HhkEEbCMOJLttpLZw/Sv
	 SjlXmjBi5PaetmGPGn5DpUfC2cUjVL71s3WmzRGgN9tmQql1BzvoHSTburpvzMca77Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XAgjivI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5BA606A32A;
	Thu, 19 Nov 2026 00:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XAgjivI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61321F000C4;
	Thu, 19 Nov 2026 00:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048465;
	bh=GFMb77v48OM3/aOWfUFT9znV1pJaIsGKJc5VLYI4GDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1XAgjivIxN/jA6+AhsbhMm+j3dxzR67GkzDk6TFY80slAU26VrVyfkNeRemDP/OK9
	 j1Rf0ziUCZ2VVMvjFmW8XInuo5zkezJlemWOj/fSPbrUa99dkCMiaEghTod8A0HKQ3
	 iBCrO+33Fk4ZvDvaJWh1VJs9EEO3rww1/AJQ9Kbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2005/2857] RDMA/siw: Fix qp use-after-free in siw_get_base_qp()
Date: Wed, 18 Nov 2026 15:50:39 +0100
Message-ID: <20261118150313.589320499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit ef15197f81ffedf29560edf2221199d92fd83dc2 ]

The reference taken by siw_qp_id2obj() is dropped before the address
of the embedded ib_qp is taken from the QP.  If that reference was
the last one the QP is freed and the pointer returned to the iwarp
core is dangling; the core only pins the QP with iw_add_ref() after
the call has returned.

Copy the pointer while the reference is still held.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916184400.2093106-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index f45600d169ae7..f8cee147455aa 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -243,8 +243,11 @@ static struct ib_qp *siw_get_base_qp(struct ib_device *base_dev, int id)
 		/*
 		 * siw_qp_id2obj() increments object reference count
 		 */
+		struct ib_qp *base_qp = &qp->base_qp;
+
 		siw_qp_put(qp);
-		return &qp->base_qp;
+
+		return base_qp;
 	}
 	return NULL;
 }
-- 
2.53.0



