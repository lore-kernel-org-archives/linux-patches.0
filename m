Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040003;
	b=xUap+Ap2DUDh+/kjfcQ/uhrnpzsWjjvj6y9/OBFRc0fV5h2sdnQilLFAxJpUenfRvGkr
	 9hFEIK/Eldh+byncDZFMJxZcVihybEZinVjzkX0Y3C+zqfEAXZhRe97cIOEg5mD9V9d09
	 b9JpXWt3hFqN7FeE+kUQE8aC36hfqpMFbWm06Fok4xdkmxQZvt40MpW9I8pV8SSxJU73B
	 arO0WWnh+QJq7rJooJlMsolmNUD0ycgXsfNJcIH3zqC31J4Y17t/U5VCIYr3jHcbzOMvW
	 2NxITxhY65s+YI/ZdaH6n9Pf/c4pKahypEwdnPGzLLWwIVxAV1htWRffGoECOmzyXSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F/dDtAQAAz8gIW5ucxbUC+0sLIB0ZEGHUrY+PG4VJsI=;
	b=WdjFkhc9MTuuYjWNvLI9v/1hshSgIJQ364d477daKTACi9xx/LhZvMIYkHnkZSCtbIoJ
	 wibLd8sAjj1T6c7SUC5lU5Q+WabHkhYzlqz8PM7aCyNI3IIETMTA8ZhqSOkHursvZXgb3
	 totedAnQE9e/a416tPwIPxTgKbCU5g7gesZP/0c4SfJIq3r4mV0JABuiRUt9CSv3qUK2t
	 rhr4EjqYnjYiBg+4Zw6tn7P/nOp3gjzX4yclPGneuLLCOG4CD9c9P7bhzhzM8uZ2cUAjP
	 6VqS4e7immOGzzALTioODXLo7FsoF1RPzyD4BmMOr1P0FyTPKMQ8EPYcRQq8ZPvF/2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nj7aaWr6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD23D606A320;
	Wed, 18 Nov 2026 22:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nj7aaWr6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3379F1F000C4;
	Wed, 18 Nov 2026 22:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040003;
	bh=F/dDtAQAAz8gIW5ucxbUC+0sLIB0ZEGHUrY+PG4VJsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nj7aaWr6/ZhOq9QIh8CZjJm7uaG+rLR8hFW12ElRJa1SsAyu23tDzp3ObJCClyDAc
	 tPNanafVcIMqEznl+BkwmEHfkbjCxJmIzreZmXiY3ILczpMhbmwzQlMHphlAZ527ns
	 3AqwRleY8kTeQ4SSQHlzgaBgN1k5DNsiRgifJXR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2301/3318] RDMA/siw: Fix qp use-after-free in siw_get_base_qp()
Date: Wed, 18 Nov 2026 15:48:43 +0100
Message-ID: <20261118150430.743790214@linuxfoundation.org>
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
index c82f0af046afa..a082985ef537d 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -220,8 +220,11 @@ static struct ib_qp *siw_get_base_qp(struct ib_device *base_dev, int id)
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



