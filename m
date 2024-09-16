Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9344B1547C4;
	Mon, 16 Sep 2024 12:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488404; cv=none; b=QUrjd7JUSKUxqJeE0hbaZaOKdoCLnrpCN8SS0iRjQZgrqw9SP3f/iHQb+LgTfd4EqhgCNVdYyr/t07lUZDF7LJn/dAzWClQ2o+pvl6WwEqvmlkog0yEz1AjtfRrY0YGJK5kdSCW/+YQJI4T6+OHoJEz6M0MeGv96S90rnQkBA1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488404; c=relaxed/simple;
	bh=FvYtJr/hDmANuJ8UI8c9oQ+RSS3J1HF3KfgSapLYNT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=He1B48wrqGSHugXKIgv20EJEnZaKBoBkuJjbPhRZsfGAI4MrVCdxJWIgUKjBjg7FaBhMXOKAL0IkoJyh8xtrk63xHxRm3QULIhzTG0IdRAiZ5W/akuGcq8K4hv+JdAFICMDxMOrUEp5J8E8Px7Vu/V9uJDguFm4VWaSdjCxbjVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlBFGw8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlBFGw8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA73C4CEC4;
	Mon, 16 Sep 2024 12:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488404;
	bh=FvYtJr/hDmANuJ8UI8c9oQ+RSS3J1HF3KfgSapLYNT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlBFGw8XPrRQAZQwa+F6ehIip/IDAodZqD0Pn7483Vx5KZ2qVFo8PZs1mAru351ZJ
	 cXJx97/6f0ao1epO+J15GQ8svDXFICj3pZHAGxMsmVwkzw3U087ng3m8ON5dBAVBrG
	 J2CWd8sGdCz7pDuBqvGHopTH+41BkxExued7o1iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 094/121] net: dsa: felix: ignore pending status of TAS module when its disabled
Date: Mon, 16 Sep 2024 13:44:28 +0200
Message-ID: <20240916114232.236530804@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

[ Upstream commit 70654f4c212e83898feced125d91ebb3695950d8 ]

The TAS module could not be configured when it's running in pending
status. We need disable the module and configure it again. However, the
pending status is not cleared after the module disabled. TC taprio set
will always return busy even it's disabled.

For example, a user uses tc-taprio to configure Qbv and a future
basetime. The TAS module will run in a pending status. There is no way
to reconfigure Qbv, it always returns busy.

Actually the TAS module can be reconfigured when it's disabled. So it
doesn't need to check the pending status if the TAS module is disabled.

After the patch, user can delete the tc taprio configuration to disable
Qbv and reconfigure it again.

Fixes: de143c0e274b ("net: dsa: felix: Configure Time-Aware Scheduler via taprio offload")
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Link: https://patch.msgid.link/20240906093550.29985-1-xiaoliang.yang_1@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 85952d841f28..bd061997618d 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1474,10 +1474,13 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	/* Hardware errata -  Admin config could not be overwritten if
 	 * config is pending, need reset the TAS module
 	 */
-	val = ocelot_read(ocelot, QSYS_PARAM_STATUS_REG_8);
-	if (val & QSYS_PARAM_STATUS_REG_8_CONFIG_PENDING) {
-		ret = -EBUSY;
-		goto err_reset_tc;
+	val = ocelot_read_rix(ocelot, QSYS_TAG_CONFIG, port);
+	if (val & QSYS_TAG_CONFIG_ENABLE) {
+		val = ocelot_read(ocelot, QSYS_PARAM_STATUS_REG_8);
+		if (val & QSYS_PARAM_STATUS_REG_8_CONFIG_PENDING) {
+			ret = -EBUSY;
+			goto err_reset_tc;
+		}
 	}
 
 	ocelot_rmw_rix(ocelot,
-- 
2.43.0



