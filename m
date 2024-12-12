Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D637222D6A;
	Thu, 12 Dec 2024 17:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024541; cv=none; b=lMKC8eQnuA1MRQTDo/eJjwlL+HNfuHNyb6vYYKmcJo1Sow4iqutRmfzTjTGTQc6/6zySWanm3Va5yuqvhQSCjXThpkXl9oQCfO5wv+U47D2Xwo/L26TCZTSv5+GevbVi7AOOl2rCaOoyYEy0VS52UtlVQKdmHAKtZE25xmfPpKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024541; c=relaxed/simple;
	bh=xf02eN22ER5yOFuM9xQU3eYxFCRwqMm2aM3LoV4RoPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRpQ1JHBaa90fBy9z/djCCYK1wNtMu6D150yGdUxA8lCdcPXQczu0irCoG/k0QZzH2OuQhd+LpA/6n10N5mcA7XD45NUSGTBX4CniCTIu17mqiunoiA98P+6hN8hZhrtoj25QbWrv9kXN2izgl1wFJRtLMJxE0uRtqn7EMjAgCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQHgGSv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQHgGSv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C0FC4CED3;
	Thu, 12 Dec 2024 17:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024541;
	bh=xf02eN22ER5yOFuM9xQU3eYxFCRwqMm2aM3LoV4RoPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQHgGSv2BLmytNt9nzlquHSc8gz/E3sv7NoeSjdhYXIEnIoXiGhSI0AFI2vTqlvmd
	 UJHE5LzklukOqQST1v0C0XGqj16fpW+hF03NYyPSIlo7jJSem0lGuzAQQTGMF1ZlHv
	 +Rgu+RCkujUFqQFgqTi99EwxCOBKPTMihLnbr+/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 331/459] ptp: Add error handling for adjfine callback in ptp_clock_adjtime
Date: Thu, 12 Dec 2024 16:01:09 +0100
Message-ID: <20241212144306.740446882@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ajay Kaher <ajay.kaher@broadcom.com>

[ Upstream commit 98337d7c87577ded71114f6976edb70a163e27bc ]

ptp_clock_adjtime sets ptp->dialed_frequency even when adjfine
callback returns an error. This causes subsequent reads to return
an incorrect value.

Fix this by adding error check before ptp->dialed_frequency is set.

Fixes: 39a8cbd9ca05 ("ptp: remember the adjusted frequency")
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://patch.msgid.link/20241125105954.1509971-1-ajay.kaher@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index ed766943a3563..4d775cd8ee3ce 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -146,7 +146,8 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 			err = ops->adjfine(ops, tx->freq);
 		else
 			err = ops->adjfreq(ops, ppb);
-		ptp->dialed_frequency = tx->freq;
+		if (!err)
+			ptp->dialed_frequency = tx->freq;
 	} else if (tx->modes & ADJ_OFFSET) {
 		if (ops->adjphase) {
 			s32 offset = tx->offset;
-- 
2.43.0



