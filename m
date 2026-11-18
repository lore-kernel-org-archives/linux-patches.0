Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047060;
	b=qLNeQQ37iSOl8KDCvIBMQPZ0GPbas8CwQpwZCd2yAq3YPHxmkB6QtEQwZdAvmOaecCXc
	 l/+ChNRghQ88Wnw9CdiYE+W0xx4NjSBeozkIKsl7As/NbF6sOik+pY+0SefNMMzW3zWaF
	 PnMax5ofa5H/pweiovXKPkeD1S0qVveqP6ffqlPJoPhee0CYpqb58rZfeemEqjE4Y0ard
	 nyhMrsFtaw1uEScCOQv2OAvGZdylsfDjBguRDqs0T3NK+se+TJdlFdZFqeUop1QLa7XDy
	 ydsUl814Uk7kfu5U+1J39Vt1i+d7bo05IXi6/Bq1UtmQ4bN1+v3es6sudJEX04KLiEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9u1J69Z9tgcJABDOCVmyKzura5D8HX5pQe2muYv852k=;
	b=mGSVAqIsXvI/BFwxsOtdSrPCpWKhvLczpoNopokXCJRFhYqodP3R7TkY6EyjUrLaNvXM
	 0ueokqFNz9DnqttHxRy2pOchI3xYFQgFG0sHKaELhpmbHi8exWAjwV4gqacIsJiNnDnC9
	 emg9KZKIlnM1wB+u4baC4KR8dqd2T0/eqpPUgOnKFGoUeVJxVfV4boW5/4iw/oVWN302m
	 TykpzWI7oydckDuWDKumUqbRF/2HbPOgDa/3Iye2d0UuRj2euhtPfW1h8fOt1nmykamvJ
	 a+kl2NsT/GEnF8Yx/g4uiiIWapgQBDKuHruBZx9IFsQV2HUfRgFx0Mw9Z4WhKL9AN/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L547bWDC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D85606A32A;
	Thu, 19 Nov 2026 00:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L547bWDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBC81F000C5;
	Thu, 19 Nov 2026 00:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047059;
	bh=9u1J69Z9tgcJABDOCVmyKzura5D8HX5pQe2muYv852k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L547bWDCp+r7Ym1gcDdNZ9z16wuDOaw8guPsdp98tk092Uo1sPu2Mp4dlBe1Rjmos
	 5L2W5WHTYqFr6c6plGTy2R4iaFrYdfpoM86QJiDJpvyOpD6cvhTnFKk9LlC3LhBetu
	 zfM8npoSwbKVjISq/NaQD2m8H6Sgvwayqq59gcq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1502/2857] xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()
Date: Wed, 18 Nov 2026 15:42:16 +0100
Message-ID: <20261118150255.419580166@linuxfoundation.org>
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

[ Upstream commit 6f165abe2b40ede71c98956cd74cd17c18505e75 ]

dmabuf_exp_wait_released() takes a reference on the exported
gntdev_dmabuf with dmabuf_exp_wait_obj_get_dmabuf() and passes it to
dmabuf_exp_wait_obj_new(), which drops that reference after adding the
wait object to the wait list.  When the wait object allocation fails,
dmabuf_exp_wait_obj_new() returns ERR_PTR(-ENOMEM) early and the
reference is never dropped, leaking a reference to the exported
gntdev_dmabuf.

Drop the reference on the allocation failure path so the reference is
consumed whether the wait object is created or not.

Fixes: 932d6562179e ("xen/gntdev: Add initial support for dma-buf UAPI")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260916170956.2086505-1-vulab@iscas.ac.cn>
[ sashal: adjusted allocation context from kzalloc_obj(*obj) to kzalloc(sizeof(*obj), GFP_KERNEL) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev-dmabuf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index 7df26330af424..8dd95385d3e46 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -96,8 +96,10 @@ dmabuf_exp_wait_obj_new(struct gntdev_dmabuf_priv *priv,
 	struct gntdev_dmabuf_wait_obj *obj;
 
 	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
-	if (!obj)
+	if (!obj) {
+		kref_put(&gntdev_dmabuf->u.exp.refcount, dmabuf_exp_release);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	init_completion(&obj->completion);
 	obj->gntdev_dmabuf = gntdev_dmabuf;
-- 
2.53.0



