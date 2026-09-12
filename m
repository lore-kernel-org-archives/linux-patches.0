Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35E629DB64;
	Sat, 12 Sep 2026 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228620; cv=none; b=qojEHpVTiJzJydkuZwORomIWuRNkw+9Oj0h2NfALoi8xJSTpeLTDvREFhpmbTbk6QUz3JRcvCtJgOKtNP3EfNEeudWwKihdAKk46bTv9vcVv15xxC6vWDrjhjWrA1kgsEPNmO31QRoPP5Laj2ozcMCETCiZ1U97kJmwqgVTsG7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228620; c=relaxed/simple;
	bh=yotreEF7T9M4ji1dRxs1AFaxuxw/GJUGTMCUNJwSQl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kR9JE3NEIMdDGhHlXTDzHdfraDNH17hN+GDIW+oxr9Xnge76fQqivMyd+QLj3xzCqF74UQpmofnHJm3D0jGN2Tc9ESSXmP/jlv9InVic8oCOdEnLbdMWt5SBwLFIGfiwpgUY7hBxUn3qzhjU8YvJEs6dKfH11a2dBt5sq6mn6Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gekyhles; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gekyhles"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC871F00893;
	Sat, 12 Sep 2026 15:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228618;
	bh=LVPGLafpijLGSWPT7+7THDQ4vmiM/KbU3mTXb5A3A6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gekyhleshtt0T4gSwfojgRjbU4yDErXiJbJBLPsK5/rOLWXlVJO/I74+YGn6cNPxV
	 F8MRoEGdq9CRbiaqm38hHMa2CN750gQSZXQv4Q0cTJC961firT0tUojJY+h849UGrJ
	 SsOYxn0roRW07wyIUSt/xMCHk0ke076W6R3y5lkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Krutskih <devsec@tpz.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0380/1191] media: tda18250: fix possible integer overflow
Date: Sat, 12 Sep 2026 08:51:48 +0200
Message-ID: <20260912065556.772831146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


