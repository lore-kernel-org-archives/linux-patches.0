Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E329428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68889C433EF;
	Mon, 30 Jan 2023 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086955;
	bh=IjdQCOwY+5jE7+z9IGogYRj0Y2flj86Xw072f41f4iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAKyGlHHKnketxe29GokqmA0b2xGRctkUQQihEcI+QxFYSoALbBXuWUBTEovW2BEj
	 7ZZZf93eeRy0hdigweCjyxYz2EYvUnVUIMhONUw9de52o/3GMobP4fmKoCV4gvog/v
	 1g1m5CkO6pgSCKIL4XmXx/TimWaM6gryZ9xznBO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/313] PM: AVS: qcom-cpr: Fix an error handling path in cpr_probe()
Date: Mon, 30 Jan 2023 14:48:07 +0100
Message-Id: <20230130134339.126370127@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6049aae52392539e505bfb8ccbcff3c26f1d2f0b ]

If an error occurs after a successful pm_genpd_init() call, it should be
undone by a corresponding pm_genpd_remove().

Add the missing call in the error handling path, as already done in the
remove function.

Fixes: bf6910abf548 ("power: avs: Add support for CPR (Core Power Reduction)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/0f520597dbad89ab99c217c8986912fa53eaf5f9.1671293108.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/cpr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/cpr.c b/drivers/soc/qcom/cpr.c
index e9b854ed1bdf..144ea68e0920 100644
--- a/drivers/soc/qcom/cpr.c
+++ b/drivers/soc/qcom/cpr.c
@@ -1708,12 +1708,16 @@ static int cpr_probe(struct platform_device *pdev)
 
 	ret = of_genpd_add_provider_simple(dev->of_node, &drv->pd);
 	if (ret)
-		return ret;
+		goto err_remove_genpd;
 
 	platform_set_drvdata(pdev, drv);
 	cpr_debugfs_init(drv);
 
 	return 0;
+
+err_remove_genpd:
+	pm_genpd_remove(&drv->pd);
+	return ret;
 }
 
 static int cpr_remove(struct platform_device *pdev)
-- 
2.39.0



