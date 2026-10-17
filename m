Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945373B05BC;
	Sat, 17 Oct 2026 16:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255684; cv=none; b=IoIQ35YRsuFEjN4yiJ++vmIYDT2BgSONkAKynrvOE7GNvDaW5nqTEBPFCPgc23WSzgwZNJepL1v3TQ7wnnFMr50Ag72FG+/ILffitWK2wZb20JL5giUn+82gUV0CAob5rd8UHz0SsOPUI0fkOJF/sGE6zYJCY6SJELOFWW3zxq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255684; c=relaxed/simple;
	bh=frapSTHJdI3Y6gZL9QFOnZCyON1LLtPFiQf1rvsLPAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CVvora+sbxVdr8eLhtJiPWdP9oMpAmyzuFEn+8qaDO2SJTgCu5wkM72hp3RybP0X7Seuxh+Zf2qcJrXT5RdCOTaF+AqMDCEGp9/VzNFQkgHSAlCCRXXLtT7rUlqKRfl+7ahu45o+DQke2CURSkdh0Qrckne/JM42UhstclNwdgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpsRqJt7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpsRqJt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDFB1F000C4;
	Sat, 17 Oct 2026 16:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255683;
	bh=5RproU3OpvW9ifZQ5xJRFVrmnIbNL/1wBP4Qi7BpyMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpsRqJt7+8JNs2oBInrNfvkDugW3BpfuU1j7p5rOxzdNuiMhWLS5QC0xxieZlnhKU
	 KpkQAW4b4pXQKWk91SbBUSeEAjNXhbCNRkNbeShWrDa+I7jz/PPpkGn0meOT2mOtkB
	 ojsxOa5BjdhhXMUXdaK7aL+dIznJV2qjRebKQQ0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 857/869] gpiolib: initialize return value in gpiochip_set_multiple()
Date: Sat, 17 Oct 2026 18:01:38 +0200
Message-ID: <20261017160058.832716422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 99dfa46baba29513d1094c8f30bc86c6ef88543a ]

gpiochip_set_multiple() falls back to setting lines one by one when the
chip does not provide set_multiple(). If the fallback path receives an
empty mask, the loop is skipped and ret is returned without being
initialized.

Initialize ret to 0 so an empty mask is treated as a successful no-op.

Fixes: 9b407312755f ("gpiolib: rework the wrapper around gpio_chip::set_multiple()")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20260620155319.79994-1-ruoyuw560@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 1e012d5a575e5..144f1e174c545 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3437,7 +3437,7 @@ static int gpiochip_set_multiple(struct gpio_chip *gc,
 				 unsigned long *mask, unsigned long *bits)
 {
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
 	lockdep_assert_held(&gc->gpiodev->srcu);
 
-- 
2.53.0



