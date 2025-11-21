Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7675E35471D;
	Fri, 21 Nov 2025 13:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733410; cv=none; b=b2s2u8N63HcNq68qenKKcMOTSLjlyym9IV2eodoPIvDuCzbDZaeymhS+APwLUd1pBzfLGfcjmldDYPDXUaesfXJK8ErivkKpXW1hBx6ZEmzaKz9MTMztRJE/oa7SB82Lis1B+kk/YgvPqktj75f15Y3/rNpheukdvJHY0tk8O68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733410; c=relaxed/simple;
	bh=v4SRas69A6it+qUSoFVw4Pu41iobKI+IVm3H+DXAFmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dw+kExPHkgnXJZi/fz0GZdyPYt/zQejXWfEA5V/S67TQc4qG+PCbavgUnwNER27vh61F+sGMzxZREUvRLKsKth2hqd/A2FGj/wKHduQ3RNfssq6QHXjnHBa9C3u+lBPs/G5qkVW+tt5WQS7ARXMQuT3Y1makkkBv/d14N+gv0Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+1Ga2hl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+1Ga2hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A072C16AAE;
	Fri, 21 Nov 2025 13:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733410;
	bh=v4SRas69A6it+qUSoFVw4Pu41iobKI+IVm3H+DXAFmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+1Ga2hlEwBQzxym62gulvCvhV3E65X+UIrks0X0tDaqB7IPj59ZhpdzLQafF1TGT
	 o2zm4+kMQmjNso6blWH0GSOt9rAQ71raLFLPzsEUDWisBtA4ngtJAIdQj3ZZyG7qOi
	 j8s2RHuBRnGdSXccFHGhEoTCxS8joN1iU01ti+6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 425/529] regulator: fixed: fix GPIO descriptor leak on register failure
Date: Fri, 21 Nov 2025 14:12:04 +0100
Message-ID: <20251121130246.137369115@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 636f4618b1cd96f6b5a2b8c7c4f665c8533ecf13 ]

In the commit referenced by the Fixes tag,
devm_gpiod_get_optional() was replaced by manual
GPIO management, relying on the regulator core to release the
GPIO descriptor. However, this approach does not account for the
error path: when regulator registration fails, the core never
takes over the GPIO, resulting in a resource leak.

Add gpiod_put() before returning on regulator registration failure.

Fixes: 5e6f3ae5c13b ("regulator: fixed: Let core handle GPIO descriptor")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251028172828.625-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 55130efae9b8b..4477bdeb9e60f 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -286,6 +286,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		ret = dev_err_probe(&pdev->dev, PTR_ERR(drvdata->dev),
 				    "Failed to register regulator: %ld\n",
 				    PTR_ERR(drvdata->dev));
+		gpiod_put(cfg.ena_gpiod);
 		return ret;
 	}
 
-- 
2.51.0



