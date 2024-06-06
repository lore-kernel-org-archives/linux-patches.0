Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A609519CD15;
	Thu,  6 Jun 2024 14:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683443; cv=none; b=iDaPLIiA4axeHoy8I1bMw16gM4nmjD7VsxjKv2xoFIFWN8ZMSvjk7ElIb6z5aDFIG3mo0QvDaha/W+hGUZiNdwtYa/TK9IuTfv6DgqXHNQDW+IbgOCLIDtQx0LKOhTJQjckdVOJ5RBKlqc/QzWKoF1/sbjo70conxOiAdtsx1U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683443; c=relaxed/simple;
	bh=n82TMrTSYF3JuL4DuPqX3hHKo71fzYcV/WktfZruGOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3wWaMC/pMr9EluWjlGXVuunmjsLj0CcLqitXG8HZJtNTuMO+h8t4tDu8k85hMUMFi50Z7G+pcsu2UqvfSdvd0b1+Hizx/5Nx5cv5Ar6Fff66ctMfj07HgerM0q7yFzuk+wg3/L8hfHO+EbW+YGbrBkhJ/h+MrPQtsFixTqAms0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdtaqAxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdtaqAxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785EEC32782;
	Thu,  6 Jun 2024 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683443;
	bh=n82TMrTSYF3JuL4DuPqX3hHKo71fzYcV/WktfZruGOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdtaqAxpM3W7eLfeQ/wtLqZkSuo5RKh3PB6G37ekkkcCpP2N7/xqz0hxaGuUfZKW6
	 lK+V92BcIGQlNupPzjvy7np0pG54RDsjp/PJKGGj834JUBLrAOO0RyTPboLKqucC9p
	 4XvDzOKoLsFPyuHUKxmAoDN3gswA0F+zV0wfGLJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 328/473] watchdog: sa1100: Fix PTR_ERR_OR_ZERO() vs NULL check in sa1100dog_probe()
Date: Thu,  6 Jun 2024 16:04:17 +0200
Message-ID: <20240606131710.778261392@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 413bf4e857fd79617524d5dcd35f463e9aa2dd41 ]

devm_ioremap() doesn't return error pointers, it returns NULL on error.
Update the check accordingly.

Fixes: e86bd43bcfc5 ("watchdog: sa1100: use platform device registration")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240426075808.1582678-1-nichen@iscas.ac.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sa1100_wdt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index 82ac5d19f519e..1745d7cafb762 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -191,9 +191,8 @@ static int sa1100dog_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENXIO;
 	reg_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
-	ret = PTR_ERR_OR_ZERO(reg_base);
-	if (ret)
-		return ret;
+	if (!reg_base)
+		return -ENOMEM;
 
 	clk = clk_get(NULL, "OSTIMER0");
 	if (IS_ERR(clk)) {
-- 
2.43.0



