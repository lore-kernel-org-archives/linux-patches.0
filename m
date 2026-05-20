Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A7C3BBA0E;
	Wed, 20 May 2026 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296269; cv=none; b=RDZ3c/f98QiNlvjwiK5b1liAWopGlzuEBjFgFni1Euw1DZymVHHU590y+KCHVQkxNW+jyUWf2AjPQFVSDAWRZpbrdkBG3XdeyLeQ5WRzoYbP+s+Hghk0YHvsr2H1e40A+GCELs0hCu0BSwaEKprxkl4nK8p/Kk1mc8l/Tp8CD4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296269; c=relaxed/simple;
	bh=tvWxVgHsbCbG3R1XCLS4Qpub7pKpACDjmQ2p2tSFuSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J/dIgPkQBZ/UTY8GUnB3FIRqzr7r/RQyl0bGd8beW/X7G2DVw3rSUnnfAxxbdDHcbSoipz0Zlo/g2vUmXwslXIPc8kqOPl1f1jfo05V5S57IiqIThkPtwM+VW36dhmnfacCinFN8FkcVak7uvZ50dIPGosUNoCu5QYeF8hY3KK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntjJZyAz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntjJZyAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95241F000E9;
	Wed, 20 May 2026 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296268;
	bh=KaDzNgLm2U5hEOD7Rh6vL+3TrDaWWwE9FLKn2djVhu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntjJZyAztPCLe198H6EcQ4dw+eU8hjIj3Ktsw/KcS2nyOxmGKkx7651tkQbUiX7ak
	 S4U3JHnNeYctl2lQ38Z9jpj1/BXDDi6aUkf1rqMLFoswjA27Ob8WsVStwz1GXSdmGy
	 qrupu+dQozgCwwcfcpB3U3spRlNHWZEwZkF79fUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0694/1146] platform/x86: hp-wmi: fix fan table parsing
Date: Wed, 20 May 2026 18:15:44 +0200
Message-ID: <20260520162203.894771584@linuxfoundation.org>
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

From: Krishna Chomal <krishna.chomal108@gmail.com>

[ Upstream commit 9d317a54e46d3b6420567dc5b63e9d7ff5c064a3 ]

For Victus S devices, the BIOS fan table header was being incorrectly
parsed as:
struct {
	u8 unknown;
	u8 num_entries;
}

The first field should be num_fans and the second should be unknown. It
is pure coincidence that interpreting an "unknown" field as "num_entries"
worked on multiple device, however for board 8D87 (in an upcoming patch),
this assumption fails, and the hp-wmi driver fails to load.

We fix this by correcting the header definition and compensating for
num_entries by parsing each entry of the fan table until an all-NULL row
is obtained, mirroring the behavior of OMEN Gaming Hub on Windows.

Fixes: 46be1453e6e6 ("platform/x86: hp-wmi: add manual fan control for Victus S models")
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260410191039.125659-2-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 41 +++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 851056bee6146..75682bb4cc52a 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -468,14 +468,14 @@ struct hp_wmi_hwmon_priv {
 };
 
 struct victus_s_fan_table_header {
+	u8 num_fans;
 	u8 unknown;
-	u8 num_entries;
 } __packed;
 
 struct victus_s_fan_table_entry {
 	u8 cpu_rpm;
 	u8 gpu_rpm;
-	u8 unknown;
+	u8 noise_db;
 } __packed;
 
 struct victus_s_fan_table {
@@ -2562,7 +2562,9 @@ static int hp_wmi_setup_fan_settings(struct hp_wmi_hwmon_priv *priv)
 	u8 fan_data[128] = { 0 };
 	struct victus_s_fan_table *fan_table;
 	u8 min_rpm, max_rpm;
-	int gpu_delta, ret;
+	u8 cpu_rpm, gpu_rpm, noise_db;
+	int gpu_delta, i, num_entries, ret;
+	size_t header_size, entry_size;
 
 	/* Default behaviour on hwmon init is automatic mode */
 	priv->mode = PWM_MODE_AUTO;
@@ -2577,13 +2579,36 @@ static int hp_wmi_setup_fan_settings(struct hp_wmi_hwmon_priv *priv)
 		return ret;
 
 	fan_table = (struct victus_s_fan_table *)fan_data;
-	if (fan_table->header.num_entries == 0 ||
-	    sizeof(struct victus_s_fan_table_header) +
-	    sizeof(struct victus_s_fan_table_entry) * fan_table->header.num_entries > sizeof(fan_data))
+	if (fan_table->header.num_fans == 0)
+		return -EINVAL;
+
+	header_size = sizeof(struct victus_s_fan_table_header);
+	entry_size = sizeof(struct victus_s_fan_table_entry);
+	num_entries = (sizeof(fan_data) - header_size) / entry_size;
+	min_rpm = U8_MAX;
+	max_rpm = 0;
+
+	for (i = 0 ; i < num_entries ; i++) {
+		cpu_rpm = fan_table->entries[i].cpu_rpm;
+		gpu_rpm = fan_table->entries[i].gpu_rpm;
+		noise_db = fan_table->entries[i].noise_db;
+
+		/*
+		 * On some devices, the fan table is truncated with an all-zero row,
+		 * hence we stop parsing here.
+		 */
+		if (cpu_rpm == 0 && gpu_rpm == 0 && noise_db == 0)
+			break;
+
+		if (cpu_rpm < min_rpm)
+			min_rpm = cpu_rpm;
+		if (cpu_rpm > max_rpm)
+			max_rpm = cpu_rpm;
+	}
+
+	if (min_rpm == U8_MAX || max_rpm == 0)
 		return -EINVAL;
 
-	min_rpm = fan_table->entries[0].cpu_rpm;
-	max_rpm = fan_table->entries[fan_table->header.num_entries - 1].cpu_rpm;
 	gpu_delta = fan_table->entries[0].gpu_rpm - fan_table->entries[0].cpu_rpm;
 	priv->min_rpm = min_rpm;
 	priv->max_rpm = max_rpm;
-- 
2.53.0



