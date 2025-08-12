Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722AF2F8BF1;
	Tue, 12 Aug 2025 17:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021502; cv=none; b=ThL5QAPzaEQLITfe0QH+9Fh4K6sziU2TbLDHbAT57r2Mek434boqMs6l5RU+Ak2ZjFsWUTlZOYmRQnb/XohS8q6e3SHnlbLSCGIVLqOhezvbxPuBAi6C2eWITFnlsV+ycsLMoVWQmC7nksTrNWW0o0tRoQ0GyCkN1eR4jQAEnNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021502; c=relaxed/simple;
	bh=vCj+aaJeuR99wM/3gTZmhjv+fz8P5fYlyCsH4rRVzOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fB89u9dMVP3UpqT2jPP9Kejd7Sct01c9LHsschqMBjm4b5+cEs3IgF7XkL/5tHY5XE0bRF3E4U/tMULI+mARona8LIyZnlVxYT5j4LAycQhgYop0v7qBLxWc/O2niOiY/bU95x1Hh5v4pPNiInHqqJg700gQNpcNciJhingOujs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cd5vHOcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cd5vHOcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90129C4CEF0;
	Tue, 12 Aug 2025 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021502;
	bh=vCj+aaJeuR99wM/3gTZmhjv+fz8P5fYlyCsH4rRVzOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cd5vHOcMv+Ny+uAQw3EzWmIFZKibuc3TOZ5INPBHcTQkSme85RFfqCzLjmrom14Ec
	 v8wxaIu84kBduO0Rg9f+b0nVWid6Lw9VVr/PAm5BWfGtYRid79iILsgM5AQmH61GGX
	 23AXwdlh11x99pi6A2F6E47a+UA/dXF2VT8BgSIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/262] hwrng: mtk - handle devm_pm_runtime_enable errors
Date: Tue, 12 Aug 2025 19:28:49 +0200
Message-ID: <20250812172959.102652803@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

[ Upstream commit 522a242a18adc5c63a24836715dbeec4dc3faee1 ]

Although unlikely, devm_pm_runtime_enable() call might fail, so handle
the return value.

Fixes: 78cb66caa6ab ("hwrng: mtk - Use devm_pm_runtime_enable")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/mtk-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 1e3048f2bb38..6c4e40d0365f 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -142,7 +142,9 @@ static int mtk_rng_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, priv);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, RNG_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 
 	dev_info(&pdev->dev, "registered RNG driver\n");
 
-- 
2.39.5



