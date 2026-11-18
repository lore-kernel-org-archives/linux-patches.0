Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024136;
	b=lBFAKadUbJ50hQQghgM7uYRkcSvaj76Giucg8jk71gZUL7dSgBOB6KaUj9DBikD6J2Vs
	 Is1Y6mSvwUwrwkYFqnnXVLPutj1PoOTZtkTjBrnO3bcy1OFm/eID2lAKtabPqioMNxDcl
	 pwtNUDWEyMSZeV5M2wvddeYuHR9JsHyMmYQsEVIEybe2hA+gE0KYa431zO1+OWbBDiyTZ
	 5YlziuIoERnGIKpn+4mbRRnTb+lAvftfk7SVV8ImnuH5k2h+CFtLvWh3G6GZVqnvmfE0P
	 OresacLYVWuLQ3tzV+95zvryesjyrweuGwPIZ1QeOFjrIQAFVyjzHGReJptMSKrUv8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DMUuCYyA1/zosyFHFZ7W3qfg8jN6qPKQybXBzPuYeO8=;
	b=NLMhnR+ktB35bpkq6840HJirJrBOXxcVzjBJ5QxIgo0EFMY5A7BhrBW/RZxkcSMhuj/n
	 uRIu6i0Mnjse1lRPJ8dUkgNGGDLQCkjW5PF7sVVvZLu93Bee7w+MCe4HuxPzvZH0QpGMz
	 xuwcOkHwSaSERCjNXNGS0+bnLBCWzGqgwC0SJnMaWfARCUUGndjDGBkkL9Q6I2GWJM8pX
	 emlUIEHNhaHe24t8Z8J61OKx6EEZPkqiKdtZraiwOjDztTtKUOwSAs6Vc2FiUhmRuicQJ
	 c7c5rKqVscpvJZwGKs1lPOrER9WRkRl4H1wYTsxZj992NjKvH1pipc8/7GQmu7+a5iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2u9lyhvq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E392D606A31C;
	Wed, 18 Nov 2026 17:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2u9lyhvq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3981F000C4;
	Wed, 18 Nov 2026 17:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024135;
	bh=DMUuCYyA1/zosyFHFZ7W3qfg8jN6qPKQybXBzPuYeO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2u9lyhvqL46er2Qfy3ks8h2hOmL+6ezBZjmaXK4SsMvC/zkjn5TkZjanlGir04rLJ
	 t+KpJxWfUsZBfkNhoPo9o2EI65WEtaFMj4FbL7FrM8MBwIaX2NO1YSTuBkdwGQmpJZ
	 DvbAZ+fOUiNXXeVmssmQnO/2mXMBkp2bZZxDAnUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0619/2151] RDMA/siw: Fix qp use-after-free in siw_get_base_qp()
Date: Wed, 18 Nov 2026 15:39:14 +0100
Message-ID: <20261118150144.464722533@linuxfoundation.org>
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
index 5168307229a9e..87de6c127aba4 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -217,8 +217,11 @@ static struct ib_qp *siw_get_base_qp(struct ib_device *base_dev, int id)
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



