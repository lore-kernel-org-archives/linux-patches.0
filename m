Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3432FA638;
	Tue, 17 Jun 2025 16:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178764; cv=none; b=MxY9Uh9tauCGp2yw84PSvVaJWM7CVcmnEsva0quRPp2goTwY34IIM4U7xjgDqD8hq+5yGeSk8bcJh2w1+UFKIeT/PxnX4ThGbTvEPE5ED1kqf8D31SDlel/6dLq+C5khiZgGKVGX7cqqNeLMWFXjS+O2cAD6dg9B71+NLWXANBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178764; c=relaxed/simple;
	bh=1k/XuY8h3BLNQOM2PH/lSBJ7OCF8RARDCRBNm3mAf+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZiJWmBvBvR6j3IYY1lGQZl0ZRVU7dfvmak2ZxUL14AtoRnNVookDk0BqhFoP81HE+5O47GhTSVLJ6RDbiTU2pha2hcXRVIXIlDV31kXeeRR1PEjA+WuBJ807e0eeyw6uwXbuuE1nIeAGvZGjnSyTovE9XpAgKL5lpuqEEoXJvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2U5N8UNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2U5N8UNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1BFC4CEE3;
	Tue, 17 Jun 2025 16:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178764;
	bh=1k/XuY8h3BLNQOM2PH/lSBJ7OCF8RARDCRBNm3mAf+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2U5N8UNUJBUyvarM8m5CNiYwP/JQtnL0rU1fR22W91uZ9tP/EeIwis572Awwrwt5j
	 CHYp+91HpqI9M0R56KOm9BTI63iD4EUn9y6OI6t0YlRxq7U9dSgp0JWci1+Qgo2iqU
	 j+KE+NodD28TghUCxKngpF68O6jyI8Kx5KN6h/tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 516/780] serial: Fix potential null-ptr-deref in mlb_usio_probe()
Date: Tue, 17 Jun 2025 17:23:44 +0200
Message-ID: <20250617152512.524527400@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 86bcae88c9209e334b2f8c252f4cc66beb261886 ]

devm_ioremap() can return NULL on error. Currently, mlb_usio_probe()
does not check for this case, which could result in a NULL pointer
dereference.

Add NULL check after devm_ioremap() to prevent this issue.

Fixes: ba44dc043004 ("serial: Add Milbeaut serial control")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://lore.kernel.org/r/20250403070339.64990-1-bsdhenrymartin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/milbeaut_usio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/milbeaut_usio.c b/drivers/tty/serial/milbeaut_usio.c
index 059bea18dbab5..4e47dca2c4ed9 100644
--- a/drivers/tty/serial/milbeaut_usio.c
+++ b/drivers/tty/serial/milbeaut_usio.c
@@ -523,7 +523,10 @@ static int mlb_usio_probe(struct platform_device *pdev)
 	}
 	port->membase = devm_ioremap(&pdev->dev, res->start,
 				resource_size(res));
-
+	if (!port->membase) {
+		ret = -ENOMEM;
+		goto failed;
+	}
 	ret = platform_get_irq_byname(pdev, "rx");
 	mlb_usio_irq[index][RX] = ret;
 
-- 
2.39.5



