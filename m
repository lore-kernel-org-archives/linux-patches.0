Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AD2374A12;
	Sat, 12 Sep 2026 09:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204514; cv=none; b=RH3IkuLZq7Id9SttgwIEPS/62gIZywk77PY+qzDKkU8KpGUM4wU/vpRXJNSqU1VOGbL9pj0y6apJzvBRnIHNE0REfbFDqcK8NnUk18bSDOc1WSj39MDlZkXulhAc0MgARoaHk1QtkqMMs9lXc6OdzYqcsi8ZjmPkDyCKmjkzOpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204514; c=relaxed/simple;
	bh=TNiYQJ38nA4zEt1qWtX4GWdSS4OkjjTal/7BYhsl23M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrSwcidmu7117mJveN8CE2pyeoFM7Dn0ozv3xwAi9KEs5IctjbEtvKU6Ev/g0MRvE4SrUDxtlku+ZDAZ/HQspkdQuAKI+1/KRZBOa9x4XzsUzXSrdItz5qD9QrSO7AtooP7e0HH7ELWExVQr6ZLjdNKdz+b9f2FKyC6jW+oVMZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nbg2SAwg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nbg2SAwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78371F000FF;
	Sat, 12 Sep 2026 09:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204512;
	bh=8YPFyQpiihx68jxHx2TbhUxW/tNHKMDpAfUWOD0lEFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nbg2SAwgRX99KcsnP2KKzLy2/QzE/P3PAkcgv6dpRoEtQYqwceHM7bLKInhtxJC+8
	 Qcw+NbWIRS3P93v6YxyAeXE+eHBbLW2UWWbETXFT9OXbTn6YWJdMpkgCTNIvCm0WGg
	 Uyr95Pcbt/vkJmfgkupsQO/75joDVC0evb3aVKAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Ding <yi.s.ding@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1628/1815] rtc: pcf8563: fix clock provider leak on unbind
Date: Sat, 12 Sep 2026 08:56:18 +0200
Message-ID: <20260912065727.206389066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Ding <yi.s.ding@gmail.com>

[ Upstream commit 9c48a53685040bb0de45a640b34055cbbfc69d4f ]

pcf8563_clkout_register_clk() registers the CLKOUT clock provider with
of_clk_add_provider(), but nothing ever unwinds it: there is no
of_clk_del_provider() call and the driver has no remove callback. Each
of_clk_add_provider() allocates a struct of_clk_provider, takes a
reference on the OF node and adds an entry to the global of_clk_providers
list, none of which is released when the device is unbound. Every
bind/unbind (or module reload) therefore leaks a provider structure and
an of_node reference.

The clock itself is already device-managed (devm_clk_register()); only
the provider registration was not. Use devm_of_clk_add_hw_provider() so
the provider is removed automatically on unbind. Tie it to the parent
i2c device, whose OF node carries the #clock-cells and clock-output-names
properties (the RTC class device has no OF node of its own).

Fixes: a39a6405d5f9 ("rtc: pcf8563: add CLKOUT to common clock framework")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yi Ding <yi.s.ding@gmail.com>
Link: https://patch.msgid.link/20260602035135.62264-1-yi.s.ding@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf8563.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 81d13733b1e93..a90dc940474bf 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -449,7 +449,9 @@ static struct clk *pcf8563_clkout_register_clk(struct pcf8563 *pcf8563)
 	clk = devm_clk_register(&pcf8563->rtc->dev, &pcf8563->clkout_hw);
 
 	if (!IS_ERR(clk))
-		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+		devm_of_clk_add_hw_provider(pcf8563->rtc->dev.parent,
+					    of_clk_hw_simple_get,
+					    &pcf8563->clkout_hw);
 
 	return clk;
 }
-- 
2.53.0



