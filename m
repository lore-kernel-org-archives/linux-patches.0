Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866D226E6F2;
	Mon, 13 Oct 2025 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367029; cv=none; b=jU3eQlsKaVmeUHS/IUWbgjkC9ra37Jt9VjN6qVftq8MSVQpiOzpZf/ns+57FM2CSQInWlFthL2kk5aOcZhNy0iEInhja+Z84tLQMvmd4+oR2oxWAQtyMfUX5DHtuaP+sOfNc4PyfA0WCrdouu+mjR9mgAz2rp4UgBidqhaU36gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367029; c=relaxed/simple;
	bh=FrTsbUrrIVFZhFHgtecaqD+gRxlmKYLpXPdoMLkoWvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBXtEp9M453sRoBGda3eDhp43bKAY6V4rNnpmd74RFjs2WICkwfQsfSR2lnTtV9UZA+BjOCl1gGfZwPMkFo9hKX5+CthxyQCZHKpNMvCiXSVRrZa2LkvFyXzRF8vbDGhuZ8A2Ka2Gya6K+XpgC6O/c1FKg5ZO6flG7YStHufk7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlTS3O5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlTS3O5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B90DC4CEE7;
	Mon, 13 Oct 2025 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367029;
	bh=FrTsbUrrIVFZhFHgtecaqD+gRxlmKYLpXPdoMLkoWvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlTS3O5u5jtQnnMrAPC08q+vLceD66nmuwT5GVSJ7+/8R2yqkFgauS5socHiceF1e
	 AQxdloOp97eeWoBSXBlukdRpTpaOBC9S3A5QAZ0iZTpAT4MPKeu4JRjTDgAacvdasW
	 bjeNmRyq3nQCJd4zDcz2MPFt6a6vmvOcFcH7oRe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/196] PM / devfreq: mtk-cci: Fix potential error pointer dereference in probe()
Date: Mon, 13 Oct 2025 16:44:01 +0200
Message-ID: <20251013144317.039353152@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit fc33bf0e097c6834646b98a7b3da0ae5b617f0f9 ]

The drv->sram_reg pointer could be set to ERR_PTR(-EPROBE_DEFER) which
would lead to a error pointer dereference.  Use IS_ERR_OR_NULL() to check
that the pointer is valid.

Fixes: e09bd5757b52 ("PM / devfreq: mtk-cci: Handle sram regulator probe deferral")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Link: https://patchwork.kernel.org/project/linux-pm/patch/aJTNHz8kk8s6Q2os@stanley.mountain/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/mtk-cci-devfreq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/mtk-cci-devfreq.c b/drivers/devfreq/mtk-cci-devfreq.c
index e5458ada5197a..a68f51cc5ef96 100644
--- a/drivers/devfreq/mtk-cci-devfreq.c
+++ b/drivers/devfreq/mtk-cci-devfreq.c
@@ -385,7 +385,8 @@ static int mtk_ccifreq_probe(struct platform_device *pdev)
 out_free_resources:
 	if (regulator_is_enabled(drv->proc_reg))
 		regulator_disable(drv->proc_reg);
-	if (drv->sram_reg && regulator_is_enabled(drv->sram_reg))
+	if (!IS_ERR_OR_NULL(drv->sram_reg) &&
+	    regulator_is_enabled(drv->sram_reg))
 		regulator_disable(drv->sram_reg);
 
 	return ret;
-- 
2.51.0



