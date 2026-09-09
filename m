Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D31E566C5B;
	Wed,  9 Sep 2026 14:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962738; cv=none; b=pL1u08tVhVqi4gkYJuntFnb8Nf1iBy8Og+6kz1cb0IaKh7rfkSyUmHFNGp4cgMSHIOEJafoTKEry/wans1lw6ajcJxdaLqpRIZiK70kX/jAE91140MHE5N77diX9vAWEGNzJtx3ZI5tWl+H1jxzP7Szz93S+oSm03lOFJast+74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962738; c=relaxed/simple;
	bh=9vAtxhLfseR31mbBTBMWKZBHOz9OnfGQKPqGEatwBcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYQe/gkckimK0zN5c8xGccihHuhl6H6Hh70+Ye2WZUwX5m9qJKOBL5YuaWh57eAHvwaFJvvdSPNgwGG/VGvAA+tGhm8i3ty1INbvv342LtqEiCSdq/EB/0wr5fbTHA71D5oEh4y1IEDLLXNymin26jsfFi1VXN1Wu9UEM16vJ/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rv+EU1Qi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rv+EU1Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2421F00A3A;
	Wed,  9 Sep 2026 14:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962737;
	bh=LFzAZ8ZApw136zWVpikq1x9TGu6AZjjZ/lHOqgPYnBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rv+EU1QiihMLTpNJn8IpQJvUz/QSaH/5gnYgyV8rc5MdE2h+XGABMqJVP8YTfgkQZ
	 qfgkaNrHrUiIfJ2IbwPVT6eBr2kIV4oErL/F9MriBaSi7mvm7Fvh/ulZr9Oa4ZKags
	 oWfD6HGOI/9s1JKw4RaAtCM3Fpi7TybFx/wqVcdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 395/556] media: tda18250: fix possible integer overflow
Date: Wed,  9 Sep 2026 15:41:15 +0200
Message-ID: <20260909134244.547199349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


