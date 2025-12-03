Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F61258CD9;
	Wed,  3 Dec 2025 16:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778153; cv=none; b=bDU2tztLxJce7wyhMA3ILqVJ8TcxVUNtwweWbzg4cHZhzpGP70glrtyZ4KFl5fS1jUcQzV+1xAVKKCGRM4LX2024/GfO+SNcA57cfFqJqcfbrnZqZYKPzeGCHFLh/9nkdXXhf+5V0fl0/TSTcJgeGzed7Cnwt3Hm/UMjmb4Im8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778153; c=relaxed/simple;
	bh=OMcFbTEdJ0pRtDrK7IKwSVaW0VhsYiUNEOyOd7Q1gkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3/pWeeDfSFke8WOztDMx/n47cKL007IzD6N+KqLsyfTwqSFxnTNlEv8rpJk5iXNy8NqLFfSpwCB/6WwmNgGKG+9U/hIXMiWNk8VPnlYXxR1oypfy1m9GtRndDvT1z0VIcPe3iRopnxStmfUX+lr9K7hvPmIzE5a0HAQIoD2qxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7QqU1rg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7QqU1rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49049C4CEF5;
	Wed,  3 Dec 2025 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778152;
	bh=OMcFbTEdJ0pRtDrK7IKwSVaW0VhsYiUNEOyOd7Q1gkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7QqU1rgayZ6dSKov/534qGzFiRrOqfBxZKBPi9fxFOBb6EZT9Hlnakg37K73TI/N
	 9wpONH1EJSYshvgMET81AhGl6hU3m3CM5iy2AszbSqJ6fCniB6NKcXfsf08dVVhG6Y
	 vrcUkB+bMxjpt8kJjgwghASvJvvT7UCC9Ib1uCWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 259/392] regulator: fixed: fix GPIO descriptor leak on register failure
Date: Wed,  3 Dec 2025 16:26:49 +0100
Message-ID: <20251203152423.698938076@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 636f4618b1cd96f6b5a2b8c7c4f665c8533ecf13 ]

In the commit referenced by the Fixes tag,
devm_gpiod_get_optional() was replaced by manual
GPIO management, relying on the regulator core to release the
GPIO descriptor. However, this approach does not account for the
error path: when regulator registration fails, the core never
takes over the GPIO, resulting in a resource leak.

Add gpiod_put() before returning on regulator registration failure.

Fixes: 5e6f3ae5c13b ("regulator: fixed: Let core handle GPIO descriptor")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251028172828.625-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index fb163458337fc..adc21b1bad94b 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -290,6 +290,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		ret = dev_err_probe(&pdev->dev, PTR_ERR(drvdata->dev),
 				    "Failed to register regulator: %ld\n",
 				    PTR_ERR(drvdata->dev));
+		gpiod_put(cfg.ena_gpiod);
 		return ret;
 	}
 
-- 
2.51.0



