Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192BC569F10;
	Wed,  9 Sep 2026 14:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964117; cv=none; b=qYfDFWl9rX2azh5Wp0JDElu1jWi3q2SOSQP3DS0oNzX0ZKFPpnDs/6GpuF3KgwBuvhEAFiakm3+zLElUh/P74oI8MxqdPOxP5ks7rnpxn1trzJMZqPjMCoiiMFnM8F/uv6T7ZXHtd7T9PWXAGQcvCQbFIG/OmGSeosiE6O8qbiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964117; c=relaxed/simple;
	bh=NDB5UFSwX1f/Phx7EVW38wGZOVPZ7s66/HF9ZxG816k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWqI21jXu4ghqLHtO39NviLf1PGne3Wi2/jA6diN+Eayi/ZTLZJVhxnJl09aBk9QQ8NTKWdnZS7UCWxWKjpZKQWQkEVkqwIcQUxVmF+OL9ucjiKk+sHH3oHJ2G982liw3TtA95HY2kPq6qAclpCGBZkJngJ55xpCCb6X4RaKvxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOsrfLC4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOsrfLC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C061F00A3A;
	Wed,  9 Sep 2026 14:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964116;
	bh=5sgvVDrMYrMajhyky2v+1ZVSE4q4dIhSFvNtwxL9r18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iOsrfLC4LDHBSqIhdm3Aq85fgt6jq0YmYthD+268rMMM0IQDe46LU/NJV8VAL83/D
	 WdYu2fW65bJ4EObtIrzFOgmd64UbUzGyL5f0In8wWly5u5T69xJO9T3DBshri6AfCM
	 qJpLiqdEQagCjcEhi2utD3sorb1H3eDdfnGQersg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 310/583] media: tda18250: fix possible integer overflow
Date: Wed,  9 Sep 2026 15:39:55 +0200
Message-ID: <20260909134248.752116735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Krutskih <devsec@tpz.ru>

commit 6dd8e257f7cafda7fbf10d81b3c55c9bba4825f4 upstream.

Integer overflow may occur, when variable exp equals to zero. Result
of shift 1 << (exp - 1) may then leads to undefined behavior.

Fixes: 148abd3b5b14 ("media: tda18250: support for new silicon tuner")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Krutskih <devsec@tpz.ru>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/tuners/tda18250.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/tuners/tda18250.c
+++ b/drivers/media/tuners/tda18250.c
@@ -440,8 +440,8 @@ static int tda18250_pll_calc(struct dvb_
 		goto err;
 
 	exp = (uval & 0x70) >> 4;
-	if (exp > 5)
-		exp = 0;
+	if (exp == 0 || exp > 5)
+		exp = 1;
 	lopd = 1 << (exp - 1);
 	scale = uval & 0x0f;
 	fvco = lopd * scale * ((c->frequency / 1000) + dev->if_frequency);


