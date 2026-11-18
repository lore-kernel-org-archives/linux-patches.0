Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049949;
	b=V7krmC/5Qu+FcgK/xfkOzPijaDcoL1rW4UJ5a7gr48SbFoJgqRhnW5KA1fkJdbSB8y6f
	 xU9rDup5/1tVQY4b+slcKt1KaFrwDId5kVg5A7g5rHMlEhFVxbrDzo5o4MeMomhAlLSQV
	 cXgU8gLCcXijYyAJkPmVLFHAlNcdbA11fGvB0oy/rsxVhxivh58YmjczZseI8DHY62Oqu
	 sd09kFX1mvME8V3u7Cn8EotKJOBC3GCqP7Vbj4vVWNPbJAtnDn8s/OpZBwfsoRu5f9juk
	 lQZBJFJSRo6A3vbXRZxNSVWjJoErtKqDNur9VmKMEetMbQoSZ7KZJAOTGE818Knx/nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ovyZfToDK55mEPqcKVq465GlyIrqUJA68Vg98Ytd6Vk=;
	b=hz5DgWI11nRsuboO+gkH04pYZqibUFqVl19/+7VthYyhxDxTYHj1ptObnOadbUaUwRqJ
	 3rLVYANTUNyWNGjNz8bbcuA4Ni3kJ5EDa1axboBQff8Uw8aLHm+esB6j72Xjn8ognkRd2
	 Jap+zWiSSO3Yi+fgARVw7Y0gHndhXmguxCfxICzayRLJ0a1nqTbo9BU6uqv6SlIqKRgg1
	 0E5YAuB+0iP8Lbm6TRoAX/7VJNSBhoqJRbnyEgTTbeR1/sRDvjsRaBRjngrvKoffK5ZTG
	 KrgZNZZ9hyxWnPkf5Qoq82YTpx2tW0cTGZ9GESclPPK32oZyp/SYV+n3akovQIwwjjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ydyC23RN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972C8606A31C;
	Thu, 19 Nov 2026 00:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ydyC23RN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1F71F000C4;
	Thu, 19 Nov 2026 00:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049949;
	bh=ovyZfToDK55mEPqcKVq465GlyIrqUJA68Vg98Ytd6Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydyC23RNJTjIOzXOHdbElTcbnpQWoh5yllP+CUz6jhdR/RSQKNYJuixYN7pI2Ygu1
	 Izn2Jl5AgV+sYLIXCIuG1VquiMXKFMSsazzZeGmRwGT+zQL/4MIuq1PtMEAr8siPj0
	 Tsp3Ty0FjoVXVYD32oNmyDvdMvlAMo5DA8XWcP5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2532/2857] IB/rdmavt: Fix error unwind path for qp_priv_init() in rvt_create_qp()
Date: Wed, 18 Nov 2026 15:59:26 +0100
Message-ID: <20261118150332.703637034@linuxfoundation.org>
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



