Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020511;
	b=UEHW3vOPQ8ciHquFH+Hzvia0KLN3nBAusfLF7O/cSLbDsOSJr6JAP63DM+UFcLk7jxA5
	 sZ0AhtNO0f/ftpaUk7UR2NqsqTnYHGp+jrZxG7TvHldVnkcwGujahDttLz4kwEMb/OpUm
	 2SXP0i+LTqDforW1nLDoA5+e5TC+KaQkU9NK7qHZ1JN1ES2NAL9VoIPIgSaTFZxq0V6kI
	 Gpf5ssCgir2D4NyqZFkgOALBpcWEEP8rtHVRWT3E9AGldkJb0ufOZD2oEuVh318MMj5JL
	 iFjDZwB6MkUsySbMQ+6MpvdvY19GwwbyyUBxbz4T25lKQvNc2h83OJgSdZPmQ99E3eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0hhbWKKz5YwkRLCfBZJi2T64whXNiuynYqSDHIKDzSA=;
	b=iowoWLkYD27UweQX03jveZzIGqsxmyqrHZV2SgXNJz4ZapSCq9o2ua5RxrAAGk8NWoRs
	 NNWSLm1GmJ7DMiGhPvgunqdLyQn41PgJGri4GRGURtT1HzFvh2GoLRvu0FX3Wtv8l8bz4
	 QGNW8uet5pyjUnDXPk74tyFUxRuii7dKE/jZKYrjzsHXsIh3Yv4z7ET06wQmGronO596H
	 Imzert4BggdK0krUKrgLDz+nUCrqIdb9GzAhK+chd/pzLRBjcAR2mNP06BTT5s9vzB8q6
	 9O/tKlMvy3CPNFQs13JnkBHM0/LLLdjIr/LsBq1LwsbHV+8X7ioLq6Rvf03GJEp0kKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DuAiqkG/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31A1606A332;
	Wed, 18 Nov 2026 16:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DuAiqkG/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409F31F000C7;
	Wed, 18 Nov 2026 16:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020510;
	bh=0hhbWKKz5YwkRLCfBZJi2T64whXNiuynYqSDHIKDzSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuAiqkG/qzZJ6EQ5FS730gQLc2GvwJWYzGboc2rvCfvzsN8YHxKqPteRsSzxXteyF
	 yt6KusksnLS7i5Ar9nlWMMBFbRbP8p9QrALYqDjXOj8IdwMPn+XckjZnfj8FK+ydMU
	 5Oc+2yy8Zhi7O027b4UUkojbnxvN1wbD4tqmRoj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1978/2651] IB/rdmavt: Fix error unwind path for qp_priv_init() in rvt_create_qp()
Date: Wed, 18 Nov 2026 15:53:38 +0100
Message-ID: <20261118150357.633907567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c40cce69e9457..ec64a595ce03e 100644
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



