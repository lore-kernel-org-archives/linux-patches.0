Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037D92D0C94;
	Sat, 12 Sep 2026 18:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237772; cv=none; b=k8dF9QPJ/jFNyEejVMvYGsSjU9enHtwOiR+cyrWvGQ+0MnPO5yuNUlH6//uok6E/6GIqm2cRm8T0YzfXs/ppEAVjKpkQWKEWFsindB4Azor2D5UFOyRVOUyh0SM+syLz6im522PhFY2tT7XK9euqBBfXMSycTtftFgf3k2D9n8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237772; c=relaxed/simple;
	bh=ZVQVtyb3weMeyzjH8gyVugtWc1rfwLYhU+rveq7oYn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cy+n9M3GkBFBwbpULDK4BkxVU40DhjdxVJLPQCHoI8DlATi20V5+LAVM2ohb3Rc4giTurIQIakQQ7iD8QFQX01K07/SO6GQBp+xZ9aZ+NOCn/NJ6lGm6upL+C7lgDLAX/pO5kN5lzbSfuudDkosEg+1miw5dn8QCmuhgU8CJHyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZFF7Kne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZFF7Kne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17F51F000FF;
	Sat, 12 Sep 2026 18:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237770;
	bh=U0vGyV3cydLk7Oeoj4bKzWTOSVZchMowS0qzaSGX9Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZFF7Kne4YhlthYMyyilEMBEyI09J8Qbx8Tb0g9zka4qcADMukSivweqrGtiOglSc
	 MjiKDk9G2jNfqQfiXWNJBKayYPDhGtECv3MH+Rrjh4JwFKR2oTlbKfdePw/POUFMBA
	 QC/J9+1/xpwQrLyVAk/Hz50io1cLdEBlIGm0xLwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 326/935] media: tda18250: fix possible integer overflow
Date: Sat, 12 Sep 2026 08:55:56 +0200
Message-ID: <20260912065534.279733040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


