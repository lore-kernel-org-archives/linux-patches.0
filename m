Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240534B7A41;
	Thu, 17 Sep 2026 15:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659878; cv=none; b=A42cN9ec7N0pwiELfKySa3uXP2+AUSRLrMU4evkQibGD6iUsDviwq/BX3t8YVX4+TwEwXm5fA/yLzgkOYPQsSEQb4pJ3KBnhdQEgwH20NrUjuFnVQoTFdJFCC7HEZ7v0s69pg1oWXSSZ3T+a10uTmoUIdGRn8ij4Zij7uL+/2HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659878; c=relaxed/simple;
	bh=N+X+zqgK0aGnwg2TcE3dLpmMYCEH6OsVLAujV59rIh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMj1kTr4HRQkHM9+ujo2NrFaZlN3ShI1rR1ctSoU/qjRbGXVoBr6z0e4g0OQzWNsSQaGDkHaYcH85TZWcr3ezVffXsMkZ6TU/Y61LC9tjztAuIQR4agcTOVMbBW9ZbaMCUy68mgsRjj2n0lqDZDd7DxPo439SA+Nr+F4TrOcVmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqgWHjDJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqgWHjDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954F61F00898;
	Thu, 17 Sep 2026 15:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659872;
	bh=AgQ/cd0+cHz5FA8CB3x89FLpHN+eaFnB8KlCJ9VVbzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqgWHjDJa/SPXZKUEcxiN9j6Guug1O5BzXOxsQTRlmWxo67KnoxBGweFsV4jWSEcg
	 RVBf5rpTHqTQTMSr333QjvTzZdYc+YCdYKugU1nTqq2vYK3BWuI72fjxmt9QBR3aAQ
	 0XHs6gtl3QmdhOKhDkJEn4ujcT4MUE/D3zALa6vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 401/733] hwmon: (aspeed-pwm-tacho) Propagate reset deassert errors
Date: Thu, 17 Sep 2026 16:11:49 +0100
Message-ID: <20260917151401.730214784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 1c5945d4ba377..bfce589c3fb1f 100644
--- a/drivers/hwmon/aspeed-pwm-tacho.c
+++ b/drivers/hwmon/aspeed-pwm-tacho.c
@@ -934,7 +934,9 @@ static int aspeed_pwm_tacho_probe(struct platform_device *pdev)
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



