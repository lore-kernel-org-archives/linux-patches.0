Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34601865A;
	Sat,  3 Feb 2024 04:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933638; cv=none; b=ha5Y0jP5HV465zKd9i8+iZAyNLQ/5wKxRH/QbVQdoaNvElZgIUypSycPIPnnGikACtH/Q4DfVbfJONMP/yHJRyfh/Kwfg+QNue0DZ9G8rmf/uFcdQupMZpqSIf8Qe+8Lxq/QBG+JIE4LqUTK/YHsdPgdUAThT19eo8SLn7pKK0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933638; c=relaxed/simple;
	bh=IYAOPSXtpEI0rNohD9S/O6b5zvtDApKBmbpfbUouKG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHxCETjQzA96aCwl8cUjmGfIy6/X6tgGbVQdWXE1ibLqk1a51nPGtOYA4WPJEJlsPMmkTzdR76aTf++GcJBfc1sMsB59fuTss7ggaG7f9WhKZQLTRmMbrjNnvzZyS/nu47wN3I8yt5oUHddvZnTI10r6ezmVQo2hVEtmHTYgG6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7wTstIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7wTstIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0E3C433C7;
	Sat,  3 Feb 2024 04:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933637;
	bh=IYAOPSXtpEI0rNohD9S/O6b5zvtDApKBmbpfbUouKG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7wTstIE9/i0whzupHSPZxTCIGLdzffQ7c2BE9mvAdYG7LdtBJBQjOOyb3DDsdKB0
	 zcYUaPzkrlCG22FTJ8yQptnaAQuym5c7Ha4RbwYEcdhKQZIPArCmGmVlpaeN7XqM3R
	 9TSAAeEZeOqV+SvTREDUqZanLZVnwCQiXlZ9NAzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/322] pinctrl: baytrail: Fix types of config value in byt_pin_config_set()
Date: Fri,  2 Feb 2024 20:05:15 -0800
Message-ID: <20240203035406.284984518@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 1a856a22e6036c5f0d6da7568b4550270f989038 ]

When unpacked, the config value is split to two of different types.
Fix the types accordingly.

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index ec76e43527c5..95a8a3a22b2b 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -921,13 +921,14 @@ static int byt_pin_config_set(struct pinctrl_dev *pctl_dev,
 			      unsigned int num_configs)
 {
 	struct intel_pinctrl *vg = pinctrl_dev_get_drvdata(pctl_dev);
-	unsigned int param, arg;
 	void __iomem *conf_reg = byt_gpio_reg(vg, offset, BYT_CONF0_REG);
 	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
 	void __iomem *db_reg = byt_gpio_reg(vg, offset, BYT_DEBOUNCE_REG);
 	u32 conf, val, db_pulse, debounce;
+	enum pin_config_param param;
 	unsigned long flags;
 	int i, ret = 0;
+	u32 arg;
 
 	raw_spin_lock_irqsave(&byt_lock, flags);
 
-- 
2.43.0



