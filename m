Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEAF33A6F1;
	Wed, 30 Sep 2026 19:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795561; cv=none; b=qwEUEfPvtuR12VhXYiEsGj6lkfP0cNtjD8hUQRajdJyw8KiCMRVpWYa1BX8ELcECNJZv3QIAz9SfNtV325DDZxmEC7dYpO0SHATWbC0nfODjrRMbO8bs83qkbgTuz78TbNyh6limVMh/gxrmsyY3BJwEWxINBnJudXcVmiCy1tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795561; c=relaxed/simple;
	bh=iMHypYcCGFZ75Ivv+U2+Z+9KaHjWc4XcD/dOXxBr3jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCmMfBH0YJIrrwZ4OZoSh98srzqydk3D5c6L6qkYnKZOEM8m9Kt55cKVfTSQaWWOvOjM9CsKlWkDQbwRnqS78byQI16VWwPy928tdk7tZeAPhvEf3BNMHXULez8o4IPIXzM+cR1QW6igXwgJBW7Ys7KmO0afeYxYqz3+wOzo5Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cl2hfX/i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cl2hfX/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B721F000FF;
	Wed, 30 Sep 2026 19:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795560;
	bh=bdbSqVksgxgo7Y7B/jf/xQ8ouEmwbujBmvlhGI6/dps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cl2hfX/i4RVfO8kY9iqLKPfemh9z3zqqT3UlkFkptFhk9UiZp6yEvkhPcb6z5xX00
	 xhMFYglnSX3aW7Z4ErkqAZT7kCnMlmAdo0jXTh7uVGp1IpeEjgBPiVjeXIgFvEgPzV
	 OyzOaRwJ+eOBAiUZRfDAWZHfjGCwaizPa4/RHTDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0567/1193] hwmon: (aspeed-pwm-tacho) Propagate reset deassert errors
Date: Wed, 30 Sep 2026 17:20:51 +0200
Message-ID: <20260930152446.838708608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 09a9e1746a87845d7d8e2b4e23bb613306effdff ]

aspeed_pwm_tacho_probe() installs its reset cleanup action and configures
the
controller after an unchecked reset deassertion.

Stop probing when the reset controller rejects the transition, before the
hwmon device becomes visible.

Fixes: 18c514cc0e02 ("hwmon: (aspeed-pwm-tacho) Deassert reset in probe")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260830125044.97718-1-pengpeng@iscas.ac.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aspeed-pwm-tacho.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/aspeed-pwm-tacho.c b/drivers/hwmon/aspeed-pwm-tacho.c
index b2ae2176f11fe..3b314ce8dc956 100644
--- a/drivers/hwmon/aspeed-pwm-tacho.c
+++ b/drivers/hwmon/aspeed-pwm-tacho.c
@@ -921,7 +921,9 @@ static int aspeed_pwm_tacho_probe(struct platform_device *pdev)
 			"missing or invalid reset controller device tree entry");
 		return PTR_ERR(priv->rst);
 	}
-	reset_control_deassert(priv->rst);
+	ret = reset_control_deassert(priv->rst);
+	if (ret)
+		return ret;
 
 	ret = devm_add_action_or_reset(dev, aspeed_pwm_tacho_remove, priv);
 	if (ret)
-- 
2.53.0



