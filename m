Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C731C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AFEC433C1;
	Wed, 23 Nov 2022 09:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194878;
	bh=JAzp/bmmzgXp7Dnkcg6VbWkmlAIBECEJA7rHCWslsfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSBups/YSOIEZdr1AL1i4MZMipVDir9Q1HpwnNoZGftE0uSrf6gJTKsfPmoaAFXqJ
	 P/MreFOnibQySSU4DvfM4oeyVZDtTuwkcorEVpvvjHM4QvcM3vGP3Z1S6KEOIpIX18
	 9Pa2SsbUftwSv8/DjLJbAsu0VnOqsyxpgLDADysI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/156] serial: 8250: omap: Fix unpaired pm_runtime_put_sync() in omap8250_remove()
Date: Wed, 23 Nov 2022 09:50:42 +0100
Message-Id: <20221123084601.072463535@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e3f0c638f428fd66b5871154b62706772045f91a ]

On remove, we get an error for "Runtime PM usage count underflow!". I guess
this driver is mostly built-in, and this issue has gone unnoticed for a
while. Somehow I did not catch this issue with my earlier fix done with
commit 4e0f5cc65098 ("serial: 8250_omap: Fix probe and remove for PM
runtime").

Fixes: 4e0f5cc65098 ("serial: 8250_omap: Fix probe and remove for PM runtime")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Depends-on: dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
Link: https://lore.kernel.org/r/20221028105813.54290-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 090acaced3b1..6e46524e0e73 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1273,6 +1273,11 @@ static int omap8250_probe(struct platform_device *pdev)
 static int omap8250_remove(struct platform_device *pdev)
 {
 	struct omap8250_priv *priv = platform_get_drvdata(pdev);
+	int err;
+
+	err = pm_runtime_resume_and_get(&pdev->dev);
+	if (err)
+		return err;
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
-- 
2.35.1



