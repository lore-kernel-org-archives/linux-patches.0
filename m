Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D862339C00B;
	Wed, 20 May 2026 16:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296282; cv=none; b=az5YfYz6RVQQJmm91F41BxZtMa4ZCniLMths7qk92pi2+L6KQwYCEEgFPY/39T7YnGLYKRSu84Y/wHVkxLj/VqQZ9msSoUASi9uA7FRfV6mNy3nUgdGYs5g4zGI1trANVT+YIPuVwAesj6NLYYWvb2AaNzxABx2syUVL/vcBkmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296282; c=relaxed/simple;
	bh=/Svxyi5ElMIT2P7J3EENI/DneMrdKnC2BqKKXB0oIZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bN5OCHt3HVqO/xUHujFGFRcy2ER0peeKrBhzeUcUM7CKbGOjbB+WXunn3nisypCALFa7J9sWuL/i60ebOJy7bj6WPq9ntkIr9K8QkUDUdfp7sDlR2Y5OFEeeDxOg5aCALWv89UidTCGQaJGJQbCbHBMIlLiBb8cLk1AmG4S84QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjpwhKZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjpwhKZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7B01F000E9;
	Wed, 20 May 2026 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296281;
	bh=ry85zMWprDhGR9tTx3jUFfIOmJsSbsDAKGyMjN27tW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjpwhKZNqTZ3kYLxk55ToTQSIbwd1cYWo5ItlHFKqJB1v00kQk1Kl1bqxoTKq+mR1
	 hc4MTfjz0Sg5NHZInVZOHZzsBxTzOQohkTx6eV+QkTio+9aEDZXNY/OBNTXszM3uMJ
	 F3kI0/j4zEzmnyQYnBy6M9qAvTD0EeLTANbo+tL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Emre Cecanpunar <emreleno@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0689/1146] platform/x86: hp-wmi: fix u8 underflow in gpu_delta calculation
Date: Wed, 20 May 2026 18:15:39 +0200
Message-ID: <20260520162203.782503865@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emre Cecanpunar <emreleno@gmail.com>

[ Upstream commit cb4daa450f05447c1f914eaef75b2577c25a0fcd ]

gpu_delta was declared as u8. If the firmware specifies a GPU RPM
lower than the CPU RPM, subtracting them causes an underflow
(e.g. 10 - 20 = 246), which forces the GPU fan to remain clamped at
U8_MAX (100% speed) during operation.

Change gpu_delta to int and use signed arithmetic. Existing signed logic
in hp_wmi_fan_speed_set() correctly handles negative deltas.

Fixes: 46be1453e6e6 ("platform/x86: hp-wmi: add manual fan control for Victus S models")
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Emre Cecanpunar <emreleno@gmail.com>
Link: https://patch.msgid.link/20260407142515.20683-5-emreleno@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 273fa95bc9bab..dd0f86b8807fa 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -460,7 +460,7 @@ enum pwm_modes {
 struct hp_wmi_hwmon_priv {
 	u8 min_rpm;
 	u8 max_rpm;
-	u8 gpu_delta;
+	int gpu_delta;
 	u8 mode;
 	u8 pwm;
 	struct delayed_work keep_alive_dwork;
@@ -2554,8 +2554,8 @@ static int hp_wmi_setup_fan_settings(struct hp_wmi_hwmon_priv *priv)
 {
 	u8 fan_data[128] = { 0 };
 	struct victus_s_fan_table *fan_table;
-	u8 min_rpm, max_rpm, gpu_delta;
-	int ret;
+	u8 min_rpm, max_rpm;
+	int gpu_delta, ret;
 
 	/* Default behaviour on hwmon init is automatic mode */
 	priv->mode = PWM_MODE_AUTO;
-- 
2.53.0



