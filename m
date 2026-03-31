Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563922D1F40;
	Tue, 31 Mar 2026 16:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975547; cv=none; b=Jg5UxG4qzLI64vJuZwIQLfBa6iFIVprdo5wHDsQxi4hGoqNn0KaomeiWO9ZoFbAPzoWnudd9O3bAhU7aFemw6c3MaXndEp6XHJts02EIDZI2O0Gt/o1/R82XfW2CaqVahJyc+JNQZb5yu1N6cY9FyQ0dXSBdD0y7/uUhL3/nBUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975547; c=relaxed/simple;
	bh=GmonAzmtSfSZ02SJSSqQ1GoIhdJzUpop43kXdb8ltdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxyEo61LikuNaCWd1VQr+uERKTP9YcNH+dpRgWkTQ0lhYTNqugu0o+vg68dk5/cxGnViELQyXW1PI2xmdPOm8NvWNu0vWtmzr/ogTMVfNjQJ0gBas62yJuEVbAgyMjj0Y8cGDkwhO4BOpCouAHWKVzD13yDOHcKecNIgkGWcSiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHixJqDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHixJqDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1336C19423;
	Tue, 31 Mar 2026 16:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975547;
	bh=GmonAzmtSfSZ02SJSSqQ1GoIhdJzUpop43kXdb8ltdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHixJqDflzN1CQD5e37yaaWeJmzzqIrhXioVAqysbOdfJd8SzcY9owEPw5W2uF7SR
	 n3LUA/n/aH8d/DT0S69jr7xpYXDfpxoSYIe7EPvMVjvzvI5wvqbU0fRK4znNX1xpJ3
	 JZcm9lYIDRpGvyiVq7OYCFOmrJxxHj55UVc9WNtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 336/342] irqchip/renesas-rzv2h: Fix error path in rzv2h_icu_probe_common()
Date: Tue, 31 Mar 2026 18:22:49 +0200
Message-ID: <20260331161811.266331634@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 897cf98926429c8671a9009442883c2f62deae96 ]

Replace pm_runtime_put() with pm_runtime_put_sync() when
irq_domain_create_hierarchy() fails to ensure the device suspends
synchronously before devres cleanup disables runtime PM via
pm_runtime_disable().

Fixes: 5ec8cabc3b86 ("irqchip/renesas-rzv2h: Use devm_pm_runtime_enable()")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260323124917.41602-1-biju.das.jz@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzv2h.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-renesas-rzv2h.c b/drivers/irqchip/irq-renesas-rzv2h.c
index 9b487120f0113..85eb194dfe3b2 100644
--- a/drivers/irqchip/irq-renesas-rzv2h.c
+++ b/drivers/irqchip/irq-renesas-rzv2h.c
@@ -567,7 +567,7 @@ static int rzv2h_icu_probe_common(struct platform_device *pdev, struct device_no
 	return 0;
 
 pm_put:
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_put_sync(&pdev->dev);
 
 	return ret;
 }
-- 
2.53.0



