Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A128646C4D8;
	Tue, 21 Jul 2026 17:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655774; cv=none; b=JWNHCh0cFvdGjQSme52WjHAvapxPJ2OXA3Q6InYIqzc3niLlGgLfPFLSmErb4TTVcpCbeNgzUbxYK3U6HAE+axbXxqpBgynqwnWXTW5gyHpvd/H144JBvMIDMsvEcj52xuT4OXRN64W6IU0GTjM8bTJ2vjGZZkAluK/Zij2WtQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655774; c=relaxed/simple;
	bh=Q2u4RrpeKLr29/B6gkEN2hqyM32m+gAssd71VYJHuz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0hgJur+vE3VOHJMpSF/HM0P/8x3SnLce0Sp5Bp/DkykA+OaRWt1MhXozcokpfomT1fKsCtu+wmsq/SrA0lzpSQTAeo5V5b+4LbVjN5lOpF/maSyyMwBo9X63o5SCxdFJiX9UdPfae/cEa4c2aJDj5ozzmAMmilHFfjpAyZRO6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrZPw9R9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrZPw9R9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8731F000E9;
	Tue, 21 Jul 2026 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655773;
	bh=vr/RL+03jcErnMIldPBXJgA0qBugNHpd1i/9maZZt34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrZPw9R91FCxob5PY9Ull0jGm4DZKmgotu5rXSir8EyTJMBNXxvpK2lsm+D9ojeh5
	 Sm1hDLOkGrBV9dqGTXLW7W2fsf650AZcy2GQDRPpF+5Jbs1FR3mxvs4hJNRgnENS2Z
	 EYq4XzBcJAenwrg0vttrsTmg849hh2TzbC5t2WuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0099/1611] watchdog: sprd_wdt: Remove redundant sprd_wdt_disable() on register failure
Date: Tue, 21 Jul 2026 17:03:35 +0200
Message-ID: <20260721152517.071049809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 96b3cfc3b8ad0524d12fed1e08bc5df3ff345f64 ]

The driver uses devm_add_action_or_reset() to register sprd_wdt_disable()
as a managed cleanup action.

When devm_watchdog_register_device() fails, the devm core will invoke
the cleanup action automatically.

The explicit sprd_wdt_disable() call in the error path is therefore
redundant and results in adouble cleanup.

Fixes: 78d9bfad2e89 ("watchdog: sprd_wdt: Convert to use device managed functions and other improvements")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20260223-sprd_wdt-v1-1-2e71f9a76ecb@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sprd_wdt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/sprd_wdt.c b/drivers/watchdog/sprd_wdt.c
index 4e689b6ff1418c..aacf04616fefe2 100644
--- a/drivers/watchdog/sprd_wdt.c
+++ b/drivers/watchdog/sprd_wdt.c
@@ -320,10 +320,9 @@ static int sprd_wdt_probe(struct platform_device *pdev)
 	watchdog_init_timeout(&wdt->wdd, 0, dev);
 
 	ret = devm_watchdog_register_device(dev, &wdt->wdd);
-	if (ret) {
-		sprd_wdt_disable(wdt);
+	if (ret)
 		return ret;
-	}
+
 	platform_set_drvdata(pdev, wdt);
 
 	return 0;
-- 
2.53.0



