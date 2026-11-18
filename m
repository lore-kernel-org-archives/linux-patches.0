Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035962;
	b=i5AtK5q0mtMu8x3CXpgnkmSBmIKfOuMMDrCqZZRkJgnQhRmINMM9+i7aCZCfbornaSBg
	 yYhQ/WqnjI1fBReddb3xxLwGE3Eg32Bg3JiF7m8NftipnEqrdJJCrCzcrcHBZCEIqsDKE
	 dx2u9+8oxov9pH5e+7yOO7U1RlGCBZJhy2SQVsa3tts01hH8IoAev2W4O40QSKQthZ/Ve
	 YzQDag0jnawRwIVOInx3UQBmOdEoqTUdq6H0drf5TTwMwDaXdfiHflM72g0rwhQwzWbzg
	 5IeqPuoQDXign6NxxPiEE1olv691dtAirvbts05DR6l/SxZu7dWuF0Zrj+49DaZeCFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rv8tx7lkIFBCurRZYhwP+xF8hP65DNL4aFFk7EbYGxo=;
	b=ll76rd94lpDD4r5Zs+iVgfIMVNV3ueqMzrJ+N+ZwGJZ1BFjLx80+IwScViYrPr4K2NOu
	 XzlyyLFi1HaMduNcIob4OIsAwhx6Ja4LW8+gtt4HtoXTta+QkK6Zu0SyWRnozTHJQ1PXO
	 wtHT88ef5h5dGsVSE/pNV5tCrof5Vpm++BzstVIKeWvNmwXcVAhHwBSTiJ87hkkgaKJvi
	 gdYAf6mrae8mUe5LfwpU6+BVJBnHG+FnJqYoHHIwJ1zITlJ2fZuuE6Hrb/iRpn8uGx24/
	 Gd4TWpY5UYYWCRVkft+NUUsvYHOK+6T8NvF2zmFXjQyYGAepLSaCnmh60ZxSmat7XRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=15y9gLXp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6645D606A325;
	Wed, 18 Nov 2026 21:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=15y9gLXp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA741F000C4;
	Wed, 18 Nov 2026 21:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035962;
	bh=Rv8tx7lkIFBCurRZYhwP+xF8hP65DNL4aFFk7EbYGxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15y9gLXpYEJzjyQ8zC13gvpKCiNg/jG7z1SWnRVO3H4I9cni5JWCGkAinQn6YbSV7
	 4Rkq/OF30f7kU4dnDA2iK6osSasNfcjgeXrJAoTdloArtE1MULmg2VTdsaTMNPNSW3
	 PjApGOYSsVjEJ+gbmJFYJ40EB+h0q+lL7x4IDSXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0890/3318] regulator: core: Fix c_rdev reference leak in regulator_resolve_coupling()
Date: Wed, 18 Nov 2026 15:25:12 +0100
Message-ID: <20261118150346.122198097@linuxfoundation.org>
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

[ Upstream commit c41b69e9f76fd9632662714c1d37860468e8d773 ]

of_parse_coupled_regulator() returns the coupled regulator with its
device reference incremented, but regulator_resolve_coupling() returns
without dropping it when the coupled regulator belongs to a different
coupler, leaking the reference.

Fixes: d8ca7d184b33 ("regulator: core: Introduce API for regulators coupling customization")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917142535.2156720-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ce69d37cfaa90..9707e90ddf0c2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5411,6 +5411,7 @@ static void regulator_resolve_coupling(struct regulator_dev *rdev)
 		if (c_rdev->coupling_desc.coupler != coupler) {
 			rdev_err(rdev, "coupler mismatch with %s\n",
 				 rdev_get_name(c_rdev));
+			put_device(&c_rdev->dev);
 			return;
 		}
 
-- 
2.53.0



