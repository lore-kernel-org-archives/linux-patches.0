Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AA925335B;
	Tue, 29 Apr 2025 17:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949255; cv=none; b=umDuP5ZRD0tZX3Zzk+yUMZl3na8gmU4WII579ba8mZM6XUNSwcpTkPTsG8MciQZ5UekhC6F32vLHOi+yiibrMVKhYBtR/PlegGf7Vu4ebqlwc61TsKrRE7x+XMNtIrqq8w/r1AS02IKuqAufotKJC3+tesKvdLquT/9SK0FBxwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949255; c=relaxed/simple;
	bh=3tm7VyLCJE3e8LJLXpGCjoL5pH5qxQMLOpoqziPI4is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOIYrA/Xw9hvGWnZWTQKLomIQA80kw2n8Jyhu8aczlbEVGfvMAt1jx//QAUCjfj4AoQmXl+RqQmIl47q6EPocHT/6CPlaRpCJRLUgs2tfcfU4Ex6AaoaDzQc+UWsLkvPSPO8Y/KsQziDIlzMwnya3VkpFhM16y9uwuDqf7f5qEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxLNnU4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxLNnU4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94A2C4CEE9;
	Tue, 29 Apr 2025 17:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949255;
	bh=3tm7VyLCJE3e8LJLXpGCjoL5pH5qxQMLOpoqziPI4is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxLNnU4RFQQmTmjVzbvqKKSzxhlPr06f9zqPppTyrxp2Xn1tAB5TuP/YAeJvYbfnm
	 LIm0CqE4qhyXtxUlUDwXWWntnewy8mJH7a0D5Sqpg3vguIir/I1sAqtSDeC7uRHTLa
	 PwdLElDqgxJYAusdDJwI/sZa1FO3C9PigeIe2dnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 261/373] auxdisplay: hd44780: Fix an API misuse in hd44780.c
Date: Tue, 29 Apr 2025 18:42:18 +0200
Message-ID: <20250429161133.855870505@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 9b98a7d2e5f4e2beeff88f6571da0cdc5883c7fb ]

Variable allocated by charlcd_alloc() should be released
by charlcd_free(). The following patch changed kfree() to
charlcd_free() to fix an API misuse.

Fixes: 718e05ed92ec ("auxdisplay: Introduce hd44780_common.[ch]")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/hd44780.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/auxdisplay/hd44780.c b/drivers/auxdisplay/hd44780.c
index 7ac0b1b1d5482..8b690f59df27d 100644
--- a/drivers/auxdisplay/hd44780.c
+++ b/drivers/auxdisplay/hd44780.c
@@ -313,7 +313,7 @@ static int hd44780_probe(struct platform_device *pdev)
 fail3:
 	kfree(hd);
 fail2:
-	kfree(lcd);
+	charlcd_free(lcd);
 fail1:
 	kfree(hdc);
 	return ret;
@@ -328,7 +328,7 @@ static void hd44780_remove(struct platform_device *pdev)
 	kfree(hdc->hd44780);
 	kfree(lcd->drvdata);
 
-	kfree(lcd);
+	charlcd_free(lcd);
 }
 
 static const struct of_device_id hd44780_of_match[] = {
-- 
2.39.5



