Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039C6226536;
	Thu, 12 Dec 2024 16:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019926; cv=none; b=e1+isZov1OlpDStlDoG3PWrt1NLuzwFCtZ4uB2ocJmWrilsl6hcvjYKLoRCkSGyHvzOL3mGdRlqttpe8rYXS+aI+fEZeYSCb4PBKT/xIWCn7fJN77a6Q7giY5kAKhP22sry7Cii/x1qAtbzJxe6mjuLa9OZd1oPyFyakQ7BcXcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019926; c=relaxed/simple;
	bh=jeHTmQwDSDM1wsNAeaAPEU11bCTpBAtLb5xEA/A8bq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpbXs4UPj6p1YYU/lBre71Q8A4SyGwzSBG/jZF6Pf4Vvk1b03fji6lUr7qw8Pv8GjuwpjwC/Qdb5fWvzycm0xVMAKb3qPe2g7TovNuOvVmy6QWMyWoEqMDvDiH16L9i2DsI4OZfo2JZybdGgpIo4LJj0f3Q8hSA4rkMfrOYM56E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJcZzoGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJcZzoGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682D4C4CECE;
	Thu, 12 Dec 2024 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019925;
	bh=jeHTmQwDSDM1wsNAeaAPEU11bCTpBAtLb5xEA/A8bq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJcZzoGVtLigTZp7RBbnFKPIx7WJmoctGC1U6v+jttKpgMdGATyFbPWe1h2eTlTvW
	 DVyY7LP70ke37/wJGviLP8JiCOtJGtZjtZ/Ix5Q5EXHa6h1xD+JkM5Y66EC7S4k5h+
	 iQnU4HtKkQqHV3lq0hLTg6A2X6ZD41l9O5o6cJlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Panis <jpanis@baylibre.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 333/772] counter: ti-ecap-capture: Add check for clk_enable()
Date: Thu, 12 Dec 2024 15:54:38 +0100
Message-ID: <20241212144403.663227864@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 1437d9f1c56fce9c24e566508bce1d218dd5497a ]

Add check for the return value of clk_enable() in order to catch the
potential exception.

Fixes: 4e2f42aa00b6 ("counter: ti-ecap-capture: capture driver support for ECAP")
Reviewed-by: Julien Panis <jpanis@baylibre.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://lore.kernel.org/r/20241104194059.47924-1-jiashengjiangcool@gmail.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/ti-ecap-capture.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/counter/ti-ecap-capture.c b/drivers/counter/ti-ecap-capture.c
index fb1cb1774674a..b84e368a413f5 100644
--- a/drivers/counter/ti-ecap-capture.c
+++ b/drivers/counter/ti-ecap-capture.c
@@ -576,8 +576,13 @@ static int ecap_cnt_resume(struct device *dev)
 {
 	struct counter_device *counter_dev = dev_get_drvdata(dev);
 	struct ecap_cnt_dev *ecap_dev = counter_priv(counter_dev);
+	int ret;
 
-	clk_enable(ecap_dev->clk);
+	ret = clk_enable(ecap_dev->clk);
+	if (ret) {
+		dev_err(dev, "Cannot enable clock %d\n", ret);
+		return ret;
+	}
 
 	ecap_cnt_capture_set_evmode(counter_dev, ecap_dev->pm_ctx.ev_mode);
 
-- 
2.43.0



