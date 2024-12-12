Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640182EAE5;
	Thu, 12 Dec 2024 15:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015702; cv=none; b=lT2rBcfk1nHIoYNopCTbfntpNNYugnDcFolqUxI57GhrHE2DEgyckcjH4l1Gbc8Re/pPMt+ETVn1GNS6SksKuaxPMhOWot02umDgCsfaaFuAThSZ81p2e5MCAmH4z93IKBQ1mHDeJ4EhptDPz8pRFcp+0cLxxdT75+/eS7nMcpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015702; c=relaxed/simple;
	bh=AKxrJUjyZaxJ+SJGrEEjRUJWMMv4Sr0Z6gAfGNm2dIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncO4boYW0+N/pFXINdD0ErNgZMAeOjHl76FojcVi4NIxL1osornkebBP1x0dxC3GZeEvUcAcFQZExLVOwIJ+Y9q4IFjM/Ijv/a9Z0Sbgdx7QM72qszefVVPP4NRNZ7Lym2MaMc4wnP2d+qVaROm7EbQiECv3EAoIIbhvKzxxktc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HF+cy0zb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HF+cy0zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC23C4CECE;
	Thu, 12 Dec 2024 15:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015700;
	bh=AKxrJUjyZaxJ+SJGrEEjRUJWMMv4Sr0Z6gAfGNm2dIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HF+cy0zb02QDYL1ui/4kXlOTmkxg8Ucmb2+TMOAF8mdsIMMRw1FGAf3V48NTzYlkq
	 Vcdx6htXlzZfQZ3PVUlte1UQOpMhgIOAFYRo5U2VaJ+xBYrTiatR0l0ETPu3K406f1
	 kp8yomRg2EzryhM42Gbq0BjjzECD6S8XTRDt/3JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/466] ptp: Add error handling for adjfine callback in ptp_clock_adjtime
Date: Thu, 12 Dec 2024 15:53:10 +0100
Message-ID: <20241212144307.528589233@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c56cd0f63909a..77a36e7bddd54 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -150,7 +150,8 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 		if (ppb > ops->max_adj || ppb < -ops->max_adj)
 			return -ERANGE;
 		err = ops->adjfine(ops, tx->freq);
-		ptp->dialed_frequency = tx->freq;
+		if (!err)
+			ptp->dialed_frequency = tx->freq;
 	} else if (tx->modes & ADJ_OFFSET) {
 		if (ops->adjphase) {
 			s32 max_phase_adj = ops->getmaxphase(ops);
-- 
2.43.0



