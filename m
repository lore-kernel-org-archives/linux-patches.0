Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D633115A6;
	Thu, 27 Nov 2025 15:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255808; cv=none; b=G5Y8RJRaBHvgPk7j6/iBPl/D8n9oYPtFaFYP75npF6GEhQWI1k+qAXAmQaEUiUuHQ/ruTKwbrMPSaCrDkM+xQneRii0i1oyfI1IcYE99oIBK+zMSiz3l4GV1nphhSDA0kNTcil4F5n38k2xyZkRlCFTYKHHa2LJVbGDA95OkR10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255808; c=relaxed/simple;
	bh=xYv6EgIX/omxZgtRDnzF7AvG9nNMITzmzNuouDY245s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZB4E8O3+zzzm/o1CyJbnmx7n+V5j5upMNOuY18HY1nVN5siGqSHLNpaBpsbyGAePhq6PQ9SFzakSkhr6XJdYf01/GDEa0krj8kM5EYCuRAutjMI5fD1KmW/z6ekkBlNLfEWPUBaZ16Ww/CxAHmkeKGB2Vbt0E3p1XIS/izgo6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfgB12j/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfgB12j/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945C1C4CEF8;
	Thu, 27 Nov 2025 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255808;
	bh=xYv6EgIX/omxZgtRDnzF7AvG9nNMITzmzNuouDY245s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfgB12j/iOwC4MQKa0RuGRDogay0cerJ14aNGvcW5gPC3wikbRknssd7sLcWCjm/L
	 aoMh00kcc8XVuOcX3FFzoFwbccpOQN556+CWMpLeAAG+xD8yt9K4HN1Pie2oeVx35+
	 sdjnB1J6yvqoOn+hWVj48+3FfnhnIys+hshGHZ2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Kangas <jkangas@redhat.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 121/175] pinctrl: s32cc: initialize gpio_pin_config::list after kmalloc()
Date: Thu, 27 Nov 2025 15:46:14 +0100
Message-ID: <20251127144047.379260272@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared Kangas <jkangas@redhat.com>

[ Upstream commit 6010d4d8b55b5d3ae1efb5502c54312e15c14f21 ]

s32_pmx_gpio_request_enable() does not initialize the newly-allocated
gpio_pin_config::list before adding it to s32_pinctrl::gpio_configs.
This could result in a linked list corruption.

Initialize the new list_head with INIT_LIST_HEAD() to fix this.

Fixes: fd84aaa8173d ("pinctrl: add NXP S32 SoC family support")
Signed-off-by: Jared Kangas <jkangas@redhat.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nxp/pinctrl-s32cc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/nxp/pinctrl-s32cc.c b/drivers/pinctrl/nxp/pinctrl-s32cc.c
index 51ecb8d0fb7e8..35511f83d0560 100644
--- a/drivers/pinctrl/nxp/pinctrl-s32cc.c
+++ b/drivers/pinctrl/nxp/pinctrl-s32cc.c
@@ -392,6 +392,7 @@ static int s32_pmx_gpio_request_enable(struct pinctrl_dev *pctldev,
 
 	gpio_pin->pin_id = offset;
 	gpio_pin->config = config;
+	INIT_LIST_HEAD(&gpio_pin->list);
 
 	spin_lock_irqsave(&ipctl->gpio_configs_lock, flags);
 	list_add(&gpio_pin->list, &ipctl->gpio_configs);
-- 
2.51.0



