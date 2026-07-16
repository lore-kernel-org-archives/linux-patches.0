Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BF442643D;
	Thu, 16 Jul 2026 13:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209916; cv=none; b=JUJFUOlIR4Y87dktLUTTJgUZdQQZYNHnVCYDwDW2bZHZaE6Hd7fQ4tHAkhzPrvov780bnNaDCnwaYVxSh+DeXUTP27ZtH3FK6vUwgTQQgovCpPrp2OGnTPHtVE0q0+t5e7QfS93Af4sR11vtVVcBHIXDA11dinjRapeLdBGW9/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209916; c=relaxed/simple;
	bh=ORcRePxz1OWYKiA6nNW27/4ufIUoy4i2Q/iY5lpna0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3Se07ACk2bbYDXJes74FYhqVTL7HQUkpfgJlWGVEp1fqvlaD61pf2p5BEfHRizglR33gnzqjGgMP5e+mChvMsPg3C7Y/Gk1SPOdzr+Zu1V08O/9+j5ZCmlbKg4TSH7B37Pdrw1/xNmpU4hpwoDJ6BiINF6iLGQfcn+KycQ2dTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzfCEIjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzfCEIjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9232A1F000E9;
	Thu, 16 Jul 2026 13:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209915;
	bh=CD7waZv0l77fzu4FSYpnr7SxGIxdX2goh6lOkR/9Mec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzfCEIjRAPp4R/I9+AyouflL0wKqgFN0jzUnnSQ+5ngO4CeFWZ3dSlEYBTLMTdLoJ
	 YyQOeeCHY8vrHlqZdINL7KNThNP9SHJGs5ScFzLWxE0Za+JPNkOV8nXDdirLtE/CF9
	 u2BZ8eJZLtPU0O7kxk3dq91ZG2+hPbkQbyzlqHJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 368/518] crypto: tegra - fix refcount leak in tegra_se_host1x_submit()
Date: Thu, 16 Jul 2026 15:30:36 +0200
Message-ID: <20260716133055.881310827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


