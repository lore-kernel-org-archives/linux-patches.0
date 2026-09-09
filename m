Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B444DF4DC;
	Wed,  9 Sep 2026 13:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961785; cv=none; b=ZrKFxhigmlwSipSHvERDontgUsnwTvZFXPwL94HPCNdEjSRYOmPlAiVRe/giajFgQR9Z4QkqBq6DXVjLT8Ck7dHjb40esj33lGizkn/747TF7vPZsNegLD2zHj7lnTbiHFgrDAp0Yw3n56h3zyJO9Rq6Gp5txLib8g1C9VztdVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961785; c=relaxed/simple;
	bh=k4uStM6O3ybIIp+HZv9HydD6vIEGccbOQLAlvacbbbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juvUf3A8uTMlRTMNwY/ni+qjavMtSSOIok+MYN/+08mjE44pq+7QSZ/lxHDsXtrnpTK8bANVBSjNOO83udOiDt0fX5dpPg0jYeUdVxSu339famXO4dHOZylHNuIvETpWIXHMEPzFhox4G31GePv/xVDkYI3oKRoksF9WsVl9Bmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OX+CYfw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OX+CYfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6BE1F00A3A;
	Wed,  9 Sep 2026 13:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961784;
	bh=x8bkS4lWtKBkpf8yH+aZFwH7WOi60+fixXMonQ4FMwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1OX+CYfwOD1I9FYL8gItIbXbcudUGnHbsRbb0JYM+pnzm5h1HY2uW6oePBYmV16jV
	 Jkoh9KuZFveW+yIwnDWwdaNWbYYeOThkRYUOVYD+ZXZmpW90xGp1orQd0qBv4pJiox
	 O5oKVR5+LAvavCqIhlQFqN5YuQmt2j/84jGOJt8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Kursad Oney <kursad.oney@broadcom.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 065/556] spi: bcmbca-hsspi: disable clocks on resume failure
Date: Wed,  9 Sep 2026 15:35:45 +0200
Message-ID: <20260909134232.750931536@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

commit d2f5a606710ad70c341dc609430a20a5645618d5 upstream.

bcmbca_hsspi_resume() enables the HSSPI clock, and optionally the PLL
clock, before restarting the SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves those clocks enabled. Propagate the error and disable the
clocks before returning.

Fixes: a38a2233f23b ("spi: bcmbca-hsspi: Add driver for newer HSSPI controller")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Kursad Oney <kursad.oney@broadcom.com>
Link: https://patch.msgid.link/20260804071904.860842-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcmbca-hsspi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcmbca-hsspi.c
+++ b/drivers/spi/spi-bcmbca-hsspi.c
@@ -594,7 +594,13 @@ static int bcmbca_hsspi_resume(struct de
 		}
 	}
 
-	spi_controller_resume(host);
+	ret = spi_controller_resume(host);
+	if (ret) {
+		if (bs->pll_clk)
+			clk_disable_unprepare(bs->pll_clk);
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }


