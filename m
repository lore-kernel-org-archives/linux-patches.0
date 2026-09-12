Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D43537F8D7;
	Sat, 12 Sep 2026 19:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242250; cv=none; b=IPPR9rHxsaGFXvSirbUdUZI9U6Up4G3CDau50TYAq6ib1PHXLxRpk0GpUE4ZZyWbUfqDMF3i0BbNnAH8aD8vz6q/eRQe44U+RTNZjx8GrEmKMMzqqI0GfYQlUgrt5kIZf/8Q7vFtOFXkOlPNMYswtTYV51SW9IaJvZsJQNv9I70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242250; c=relaxed/simple;
	bh=O4Geqqy7xLM6sP0cem/OSmXAFv/Boy+YlniTeF4aKEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4Qq+Ucs0wH4bIX0YTvikNwF+LqIh0u2f3VCvyELjYJ2FahimSdxWYHrUsX989O3VzwspLTugWI7AYmHmvUKjHOtUnnEOMELlHt/aRjkoIAOuG9uc8iu/QF6AvHGUSPGbu5PnApzPJA3lltQ6LJizrGjTISrPuGcI5QhSY/Ot7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3UbbOUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3UbbOUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA5E1F000FF;
	Sat, 12 Sep 2026 19:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242248;
	bh=hcWYoXfsFeS0beeaC3B8UHk/ounQ1L7sXl3PVVJ3EHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3UbbOUu4dhx36d008NKvudkJhZZ3ZEdqbkp8/kOPjBUHDNRig1kaZJjVSi3dmlqP
	 rX6GouSY0jg++yuGolvmV/6CUv1apGvN0bDx32YoDyvoaFoaH48CFFM3aEjCcXWCks
	 jh5m9azoR2MrQr6tZEUFCBUatwtayORr2FoGY6gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 285/798] media: tda18250: fix possible integer overflow
Date: Sat, 12 Sep 2026 08:58:33 +0200
Message-ID: <20260912065523.695590409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


