Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB95306754;
	Thu, 16 Jul 2026 14:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211247; cv=none; b=G8R1KUZzGDgSjno5NXYfXujGhO74flVsZ2QfqfPPhsg5sttAFpKVuG10ta99c9hZwK/94Jd6+6dBy/MTyXRhQFDMB4ELjzNgrwPjMQQhNmJiPqzanvsk2NLFc3IMdepV5TDKQ+cgOoYA128HqkJfjBUzpm8R8mFFg2ShIx2Il5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211247; c=relaxed/simple;
	bh=NbqERyr6gxB1AYWqN8n/TF+VeqyEPXdvSRQ5EKpO15M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXK2GZLqlsghzUkt1OKFa5NVFSd0x509qRPIqGALcw/cNyh+ggpt2XPifCgocfhIcnXYQGBWJfx+WLHmv4mv6hV5tLXv4SLqc6NfA9UJE2Qn/NO7Ou4+iq88qQMwNv17PaX5J/KJ/E/JogOCTpcvUseXBzrY91KC/PvgOT9Npkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHraRk1I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHraRk1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E851F000E9;
	Thu, 16 Jul 2026 14:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211246;
	bh=YETWqr/E/dBTt5E8ouZBWnk9VBOKvwfW5Od9jFY1w+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHraRk1I47vqXelr29NjnMfPQOKJaXdhworbKYXEfT00NruR4rlZaf6OM1ULkWIsX
	 hwwMvSoL8hUuXvg2wNlfUXhGx21CA176vNLSZ45gAbaG9reihDBVrB+rBXp8tFMUBc
	 kPu5RvRuIOWB9lvzhGudHQhO5sBVUZx0vOpDCF60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 354/480] crypto: tegra - fix refcount leak in tegra_se_host1x_submit()
Date: Thu, 16 Jul 2026 15:31:41 +0200
Message-ID: <20260716133052.463270924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


