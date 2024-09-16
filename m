Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE051146A79;
	Mon, 16 Sep 2024 12:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488675; cv=none; b=pCDPMKWzpE5+4VnmUfHSrBjVe4dnBbnr3UkO2RZja3D1CfAoc9Uh2vYevLNAsZH5Ce3Vg49BzuBFewuHswlkj4Dg9QxlyMwx3lDBBK5xxORY6m6lEyeJpxngyxWoivW1eeC09FGoTcMzudRmZmvnbFIWr+BCSycBXh24p0voDEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488675; c=relaxed/simple;
	bh=DnaxPdYtel76XLph+gaSO3w2l6Ki9yEGdI0Pahg1HQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIfs8sn0gqYQV/OzDPkPXRUDABnx9Yhwzo9caJy4S/LisxKCbkHhHDxGqF2HlIIOspqQ+IYwWZ11/FOvilKhkr3/IHWDWNzA41A1B6wXfhP/8ELCIPDXdFus29lyNfx8bKNpL/odeO2POhnw8l885bDWE5mo3St+Vx8o8c9+ku8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mi0DB3mR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mi0DB3mR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41518C4CEC4;
	Mon, 16 Sep 2024 12:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488675;
	bh=DnaxPdYtel76XLph+gaSO3w2l6Ki9yEGdI0Pahg1HQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mi0DB3mRUPi8mfGf4oNeF3Oul357Ah+DzSEYbKxc76OLe01yG7A86k9DRDsWpnnl3
	 MnmybGXQlK07hqiHVVNTid5CQOwnpxvSJ9cDlSRiEqY5o6mc27zETA88AenWjaZSEB
	 5mXZ0J8GNtVy8Py+cwxwOwx+yXeGFHmbbytbDIS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 74/91] net: dsa: felix: ignore pending status of TAS module when its disabled
Date: Mon, 16 Sep 2024 13:44:50 +0200
Message-ID: <20240916114226.915670759@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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
index 3c5509e75a54..afb5dae4439c 100644
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



