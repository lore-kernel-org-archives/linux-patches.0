Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A27404BF6;
	Tue, 21 Jul 2026 22:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673573; cv=none; b=EvltgKoF+RjRwaZlYYPz9vbcYfvc+CZNegDfP94bixFX4co6XsiNf37CzUR8+UlCxx+Dk2x83tneadpUqr6P1xdOiUb2rZCFPAm7HJnNHgVp3mfSae7AXHwfq+wQ/idByvgfn7Mk8EZXjeyW6L+DMvKyDGReJMH0sJpJQNlGZvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673573; c=relaxed/simple;
	bh=ce0SFexq1oo91KVwE3i7DrNBD+p5N1XQ3chcLKZgmyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKp5/mX5Sl5pxON54/4+ugMyQlevTZfuRbVJMpArrKmLodfINSv5pCcyZsgstSnn0aDbjAKYgY7UKXGoqACZM06VOfYd0HDIf6X1J3wwXepbLYccWPWezToQHvWXxS+ex+5UC5F/KMI2cabbTsSlsEeg4eIIm1XathiVIB1U9JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUYGzhNy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUYGzhNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D94E1F000E9;
	Tue, 21 Jul 2026 22:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673572;
	bh=0QRd/mC3Jmpo/IAihn/GSZfeGJha/2vTTQLUmEXGukM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUYGzhNyODpv1GUFQzE78rOC2jpYY6wvKpyr366T/zbTOTkC4JFXPE6a+lkS5KAc1
	 LSMvZOOrY8iaK4gaJEfLzAJOkmMOE0+d3jYWASrGsT1aSYfzLWAnwpJ0sMO57R7c1B
	 roJEomN5XRP0c29JF7e6iYVIUOKnmQurbBuj2yVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/699] watchdog: sprd_wdt: Remove redundant sprd_wdt_disable() on register failure
Date: Tue, 21 Jul 2026 17:18:55 +0200
Message-ID: <20260721152359.669868672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b9b1daa9e2a4c7..9f1e20b49b2568 100644
--- a/drivers/watchdog/sprd_wdt.c
+++ b/drivers/watchdog/sprd_wdt.c
@@ -317,10 +317,9 @@ static int sprd_wdt_probe(struct platform_device *pdev)
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



