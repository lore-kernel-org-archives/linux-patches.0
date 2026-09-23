Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4304A2058;
	Wed, 23 Sep 2026 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173270; cv=none; b=ELQ9at0VuSVBLylitXWrbOnr5NTtVEF7z7SzTTGBodcLH4niyIHR5I79uj8maPr6GHElE9mMyYA8PjqX+57toVhMTFMqZ9PPrrE2j76d3bLXYy/uKqouKD9z7vY8hXfj+KCYydBc8siPTRfUfWJDMHTP1BNEJgTFphh3AKk2t/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173270; c=relaxed/simple;
	bh=ODRVMSf4vMe0beiWnSr6goBR0lg6FDdos3Ocv7Ao51k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FY1Zexkj9I56AhVp7sEGA/BYz+6hfdc/suUt0QgbQFHNZ75QtO0TLax6C2oC32Hq9XivgtsJd9mtyLK0EI47Gs1JglHPthxpChhwds1twDJbyx0YFzgCkeJAFBiGpfcFQ4cMwzlAxqGFcRw/EO8kwTFXAcEfAfdmrBEBHJmQcSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnHpsm19; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnHpsm19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDB51F000FF;
	Wed, 23 Sep 2026 14:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173268;
	bh=PvSLfdrlyz+LEp+C3Tu9i2iYh/tY2NF4JV95zWHhKvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnHpsm19ldBb+t3RRelv1A1ox7CWXh5+MH8cUpnxCI1kFRZX/TgFG7EraKeIpxvSq
	 q1SUWX+clgIz0LJyROHjWf0MIjaZOZGoF2KiCT0QG7ZC/NB0EPKxV7HH18Yk30IYkR
	 xGg+yfks+wlsrK7xlHRx64tcRZMIeUTA7XHeztWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 195/438] drm/xe/i2c: Disable IRQ on unbind
Date: Wed, 23 Sep 2026 16:03:36 +0200
Message-ID: <20260923140649.812826421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit f0e9f963a3d209d7dc7ddd61116118ab5da2797d ]

Currently, struct xe_i2c is freed before SGUnit IRQ is disabled in unbind
path, leaving a potential UAF in case I2C IRQ is hit during this small
window. Explicitly disable I2C IRQ in xe_i2c_remove() and fix this.

Fixes: 0bb78ce09926 ("drm/xe/i2c: Wire up reset/postinstall for I2C IRQ")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260911121547.2407261-1-raag.jadav@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 8ba5c8b8ab3fd362267c11df2cd5a90ee46f6e24)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_i2c.c b/drivers/gpu/drm/xe/xe_i2c.c
index 5504cd9dd3596..6fce3de272965 100644
--- a/drivers/gpu/drm/xe/xe_i2c.c
+++ b/drivers/gpu/drm/xe/xe_i2c.c
@@ -277,8 +277,10 @@ void xe_i2c_pm_resume(struct xe_device *xe, bool d3cold)
 static void xe_i2c_remove(void *data)
 {
 	struct xe_i2c *i2c = data;
+	struct xe_device *xe = tile_to_xe(i2c->mmio->tile);
 	unsigned int i;
 
+	xe_i2c_irq_reset(xe);
 	xe_amc_exit(i2c);
 
 	for (i = 0; i < XE_I2C_MAX_CLIENTS; i++) {
@@ -288,6 +290,7 @@ static void xe_i2c_remove(void *data)
 
 	bus_unregister_notifier(&i2c_bus_type, &i2c->bus_notifier);
 	xe_i2c_unregister_adapter(i2c);
+	xe->i2c = NULL;
 }
 
 /**
-- 
2.53.0



