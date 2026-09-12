Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244AB33555F;
	Sat, 12 Sep 2026 14:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221842; cv=none; b=mKw2cDIIHgTusyLWyc3zCwZRqQW9XymT2YqXHiyOrQNutf6Sh4Q4r3wAHyQ+AZHkZgnstnV9VLYWO6Gv09hxlhrRVnebmpdTxaTUPmxp6NZAP6qyYSE9Z54xiPJRDq2wtmG3soYAYjq4Js7fQ0BV056sR2JpgXP1ME+QF1bKbqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221842; c=relaxed/simple;
	bh=DkBOAe8xRFvC86rvaRRiUxzDwqb52x62uNduzTswBaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJJiv6ojTlCbp9d5WllZ9EZ24laO1+JbJdPgnUnaYJZ0gcjAQFY7Z6yB7R3/8ylNnLeKFqcu6+HUceyDmg0WCc9o8ehj0NmiouWnUXg3vjmZALPQJqc6TES+REEw7cw7KOIDsIENpjkE7y/PpGh1oEhABbjE+unoWhwfndA9X1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obYuhhvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obYuhhvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21611F00893;
	Sat, 12 Sep 2026 14:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221836;
	bh=TsINv1FMQm6v2/Xl7lBkwCJ2A4eGoy5wdVznDKiSmjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obYuhhvFOcE8LUsqskQ9oFlX/w19YUs6HwGe9vGeiyaidlZPjG9REMO9nBgEofInT
	 /ITNh9JyV0BEdnYSvq98vQUUikDIJzHL0s8Gl3mOxg/tiZO/4x/rtzlaUb6uum3lq4
	 A4PRk61WRw/nFc73ltdIfHrpiVI989pzDE9xMHJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0464/1424] media: tda18250: fix possible integer overflow
Date: Sat, 12 Sep 2026 08:48:16 +0200
Message-ID: <20260912065617.678050858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


