Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51455151CD0;
	Tue, 20 Feb 2024 21:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463094; cv=none; b=cHIF9+1/qkL7Wyp74sb0cztKWqzL50ommOlBLwNUg0/80Pd+HWGT8BeE+CxKE1zq4lq1mJw6W3NiGcZu7+l3zMmPn6uNdj5Q4iMASEMn1vYsT3D6BGAeqDDem64D3F14uUwC/0RBtPZ0Ul7XFPOUSXzdm3QJCdYS88o+fF0jmk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463094; c=relaxed/simple;
	bh=cL2S7uccxT9awrwAvBsx9wFsWAK5TjMpv3a7Z85zxEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vz7hHr75VQJmntX5Ya3u5NVdwLjKpUQr+m1uDd4IPe6q2eCMMh5I9lTtsjkFyXN/Neb78O0Ho5SUc2uMsJri7qe8R7z+10f+NPe1LNhAjwnJUe/fz6+kOlYVHLf8qR9DbJhSZqoa4fSMLeiq+/cT21pU5BDSqcmjf1JBW1l2eVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewPRp9gs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewPRp9gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD638C433C7;
	Tue, 20 Feb 2024 21:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463094;
	bh=cL2S7uccxT9awrwAvBsx9wFsWAK5TjMpv3a7Z85zxEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewPRp9gsVJyww2uhqDcCYhQa95gkh1fF8/bi9WR3Bta9Ab1aucitv+IJb6DnIlmuQ
	 xGWB3CX5CHu+y303Qsab/q40g9sk21r7lpXeS9cvqE5z27H1rDIfKjg9XDUKTTpBI0
	 EVHg5IGbHEAZqMLk115YFXYYS1Szbyyz4fuMLCyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 132/197] mmc: slot-gpio: Allow non-sleeping GPIO ro
Date: Tue, 20 Feb 2024 21:51:31 +0100
Message-ID: <20240220204845.025051338@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit cc9432c4fb159a3913e0ce3173b8218cd5bad2e0 upstream.

This change uses the appropriate _cansleep or non-sleeping API for
reading GPIO read-only state. This allows users with GPIOs that
never sleepbeing called in atomic context.

Implement the same mechanism as in commit 52af318c93e97 ("mmc: Allow
non-sleeping GPIO cd").

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240206083912.2543142-1-alexander.stein@ew.tq-group.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/slot-gpio.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/slot-gpio.c
+++ b/drivers/mmc/core/slot-gpio.c
@@ -62,11 +62,15 @@ int mmc_gpio_alloc(struct mmc_host *host
 int mmc_gpio_get_ro(struct mmc_host *host)
 {
 	struct mmc_gpio *ctx = host->slot.handler_priv;
+	int cansleep;
 
 	if (!ctx || !ctx->ro_gpio)
 		return -ENOSYS;
 
-	return gpiod_get_value_cansleep(ctx->ro_gpio);
+	cansleep = gpiod_cansleep(ctx->ro_gpio);
+	return cansleep ?
+		gpiod_get_value_cansleep(ctx->ro_gpio) :
+		gpiod_get_value(ctx->ro_gpio);
 }
 EXPORT_SYMBOL(mmc_gpio_get_ro);
 


