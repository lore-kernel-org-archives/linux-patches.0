Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3DE196DB1;
	Thu,  6 Jun 2024 14:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682932; cv=none; b=mGWkokK6ect2OYHVbCKot7n3fbHTZToc6Y+W/6Ppy2q4p7upD3/Nw6oNQepEHaPuOhmy8ZSn5rZtu7MnmIVWm92JS9PyXwWb7/98abnikFcpH2yVdBGKEt7EueFAfTjNgjFN4pKpO6CoYJmyYLIv8RMAAFMaJo9VEcfEUSlBoWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682932; c=relaxed/simple;
	bh=zndD0tINat8XcwFvE0qvdWon7OiJwV2kTuuGaXlOG+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUQoL/iNfs61MiDRQfKAZMdmYZZz6q3079wV0S6TjeNpFmQ4swjf/B5Y3VkgPJd2cyTE6RLkG1UVzgbZJVCz3iVYpEdxNzO1l6E+LClx4caJCSEhB2pU2m4nKNNmCvDdib029UpP2vWsr0zr1c36uzIrA5lYoogAyz3GT8W7b2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efql1g4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efql1g4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3CFC2BD10;
	Thu,  6 Jun 2024 14:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682932;
	bh=zndD0tINat8XcwFvE0qvdWon7OiJwV2kTuuGaXlOG+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efql1g4KQMZRFqY/cu1IY4IaODw/K+ouWt9WWQeIfh3r81hf9RH6vYyH3zMdFajUo
	 k6OvruCXvXfSq3+DPv4lrWn8k1clVlg/M9RQ1Xh2mTqL1vYwBo5P65+FCqOURkOwO9
	 DRShTyh6bhvF48HkloS2erdlF2W44H3c59+HUChY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 080/374] watchdog: sa1100: Fix PTR_ERR_OR_ZERO() vs NULL check in sa1100dog_probe()
Date: Thu,  6 Jun 2024 16:00:59 +0200
Message-ID: <20240606131654.535155018@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 5d2df008b92a5..34a917221e316 100644
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



