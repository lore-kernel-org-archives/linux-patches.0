Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57DA24B28;
	Wed,  8 Apr 2026 18:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673116; cv=none; b=EI92khpTbtn/CqYd1bJryJW/CeIR0+gf41j1L2MHP2nItnbE4FPNti4Lge2i5Cql3Bk2ewQ9C7gwI1UDVkxG8X6CdR2QzeKx0oJK3pnfzb1YdQYQxOCXwF8OFhuJkVYOlPl4Y8Ms0FA4IoQzeiT9nZKgT9wyjUFXIpDJk+nFHRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673116; c=relaxed/simple;
	bh=I6Ali0TIK4XhFwEKmZKblIZqJJs0AOgEFnLsfXCGGcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GNGwz8iUbbujebZYEBoo044Ga9dQZPW8wyUiqsdARThJM+kL7m/ct46AdrZxve5VxOvXW1bWOf0xTJjTh18w+h78IMIssO7TYKnORs8pKrSA1sobUUdMSKbbiUMHGGdnPY369Ys7b8rxqJOOCMo6cJ+OR29WpBxZQDWm/coiQBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxXFyO45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxXFyO45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A890C19425;
	Wed,  8 Apr 2026 18:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673116;
	bh=I6Ali0TIK4XhFwEKmZKblIZqJJs0AOgEFnLsfXCGGcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxXFyO45SZ0vUzfv0N7mmS3t7zXzGeLQuqWCwaEWB+c/QrZyiu2O7uQMe1z1Sgqnm
	 uGeruz9nTHHTJcnyWu9S7PWJOKBrDu4ga6wgx1BLO1fK/EWT4LN4dJB0BC2LyfnfIn
	 tFk9L6r/8LVBn5c0vCB0QtwVRU4st1l7Y7dbvsBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/277] gpiolib: clear requested flag if line is invalid
Date: Wed,  8 Apr 2026 20:01:31 +0200
Message-ID: <20260408175937.831165866@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Pőcze <pobrn@protonmail.com>

[ Upstream commit 6df6ea4b3d1567dbe6442f308735c23b63007c7f ]

If `gpiochip_line_is_valid()` fails, then `-EINVAL` is returned, but
`desc->flags` will have `GPIOD_FLAG_REQUESTED` set, which will result
in subsequent calls misleadingly returning `-EBUSY`.

Fix that by clearing the flag in case of failure.

Fixes: a501624864f3 ("gpio: Respect valid_mask when requesting GPIOs")
Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20260310204359.1202451-1-pobrn@protonmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 497fda9bf8f1e..9dd22b4bbff54 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2447,8 +2447,10 @@ static int gpiod_request_commit(struct gpio_desc *desc, const char *label)
 		return -EBUSY;
 
 	offset = gpiod_hwgpio(desc);
-	if (!gpiochip_line_is_valid(guard.gc, offset))
-		return -EINVAL;
+	if (!gpiochip_line_is_valid(guard.gc, offset)) {
+		ret = -EINVAL;
+		goto out_clear_bit;
+	}
 
 	/* NOTE:  gpio_request() can be called in early boot,
 	 * before IRQs are enabled, for non-sleeping (SOC) GPIOs.
-- 
2.53.0



