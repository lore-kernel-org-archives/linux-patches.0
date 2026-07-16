Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91C242E8E7;
	Thu, 16 Jul 2026 14:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212307; cv=none; b=GC+LRquo92l/Jy2HcBWwIKNnHVdbWgu+u7HaQFCQs/rZzNePIHgiIh3irej9swwRwBf/kMZgIBUOTcm3QqudmGZMdeq5zFgb25C5zKQQIN1JeVoBB7J8URWwLMPfddJ4qY1LMB+wSTUz5zmSEIvNzXbXC21yul/ZYO0rLLf9Azc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212307; c=relaxed/simple;
	bh=SiTSrOkK818f4XlO2omOc981/IwrqbuOoDq7AvEwlFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boqm8auG4QIdnahosdaMmrrrsRy22cwOCAuVREnjMdFMm46RRXOwa81WHlK/srklvItK61YeHIqHOI4T25t6Z0jOY8qQ2MEQTdkX7MVrYoJmY66rZn0p7g7ef0Lgtljad839h7QF8jn4vPlj5GjbAZfYYYVx5e5xEqaBezRR658=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1r+H+0q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1r+H+0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A09C1F000E9;
	Thu, 16 Jul 2026 14:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212305;
	bh=Ooik6rErTK2p5f3/9FThyAl3ZZ/Z36LmP/rtodH1Ax4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1r+H+0qlxIfkNXuHz/wcWhLqHLUArvpXlj2X7UDdhpBaA1PKbosdHwvipiZ0TliL
	 gbM4oUYU0yS/MaRx7HlGRbS24meyHAgFD6ZCwokqo8tCjnTulpgU33xgX5SZDrOn/c
	 Q5TvxShvcSqHg+1y0QCcMSwV26Sn6RiUlfPFBno4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 275/349] crypto: tegra - fix refcount leak in tegra_se_host1x_submit()
Date: Thu, 16 Jul 2026 15:33:29 +0200
Message-ID: <20260716133039.493955432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 6ea0ce3a19f9c37a014099e2b0a46b27fa164564 upstream.

The timeout error path in tegra_se_host1x_submit() returns without
calling host1x_job_put(), while all other paths (success, submit
error, pin error) properly release the job reference through the
job_put label.  Since host1x_job_alloc() initializes the reference
count and host1x_job_put() is required to drop it, omitting it on
timeout causes a permanent refcount leak.

Fix this by redirecting the timeout return to the existing job_put
label, ensuring the job reference and any associated syncpt
references are consistently released.

Cc: stable@vger.kernel.org
Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/tegra/tegra-se-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -180,7 +180,7 @@ int tegra_se_host1x_submit(struct tegra_
 				 MAX_SCHEDULE_TIMEOUT, NULL);
 	if (ret) {
 		dev_err(se->dev, "host1x job timed out\n");
-		return ret;
+		goto job_put;
 	}
 
 	host1x_job_put(job);


