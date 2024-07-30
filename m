Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C3A1A76A2;
	Tue, 30 Jul 2024 17:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359752; cv=none; b=N8I7j6dDWJucZdcAfk6eviN6wkTG/iHBJkdAQGCx9gvStvPBNBsmT5Kajwzis3Peju0VY2fYOo6ZFiw3Zhq0aHO5jSDDatJfJq0cD/jofElQzOLSDwzTQ6SyyqTG/ZWNCQItBnCV1RN/APX13aSMz2BD6x9QT7TyXE1bPyF5CL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359752; c=relaxed/simple;
	bh=OWuTQSqFyaRpJpgswl+gJYF6AI9Lbzf04ajOYPNU5v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uilxE/VAyhilkCygGOaPqMbL4BQ5gDcyRi5l48dt41ESJ26A8u8l1u1jx/X3SKmmE6UnQzHDSiJIxE70fw1xZbhy05hyeZKO4i+aUJJYJWZZJ9DjX4y0SvV4QG7f3JdnA36sSqO1R1QE+iY7B/F/Y6+IjQVTxo9llg6JsP6eqQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIS57b5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIS57b5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327BCC4AF0C;
	Tue, 30 Jul 2024 17:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359752;
	bh=OWuTQSqFyaRpJpgswl+gJYF6AI9Lbzf04ajOYPNU5v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIS57b5BXlr2PNJdrrl4nsxlNHC6HuFMUvOaTCI4GlL15IQi94W4jeopeQKdjut+A
	 guIgKyI9ATDvRCAOBHCJUhq4xtL5E6eZXXSyZbc90NXPjgbmqSHiJ9gZQJuiv/HR45
	 An4nTpIl8NzT8Rl84dw3dvJhcJ+Vp08JjTYBFmW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Genoud <richard.genoud@bootlin.com>,
	Hari Nagalla <hnagalla@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 528/809] remoteproc: k3-r5: Fix IPC-only mode detection
Date: Tue, 30 Jul 2024 17:46:44 +0200
Message-ID: <20240730151745.593152873@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Richard Genoud <richard.genoud@bootlin.com>

[ Upstream commit a8631f6d6344d976096b1efafdb2fbb3111bd790 ]

ret variable was used to test reset status, get from
reset_control_status() call. But this variable was overwritten by
ti_sci_proc_get_status() a few lines bellow.
And as ti_sci_proc_get_status() returns 0 or a negative value (in this
latter case, followed by a return), the expression !ret was always true,

Clearly, this was not what was intended:
In the comment above it's said that "requires both local and module
resets to be deasserted"; if reset_control_status() returns 0 it means
that the reset line is deasserted.
So, it's pretty clear that the return value of reset_control_status()
was intended to be used instead of ti_sci_proc_get_status() return
value.

This could lead in an incorrect IPC-only mode detection if reset line is
asserted (so reset_control_status() return > 0) and c_state != 0 and
halted == 0.
In this case, the old code would have detected an IPC-only mode instead
of a mismatched mode.

Fixes: 1168af40b1ad ("remoteproc: k3-r5: Add support for IPC-only mode for all R5Fs")
Signed-off-by: Richard Genoud <richard.genoud@bootlin.com>
Reviewed-by: Hari Nagalla <hnagalla@ti.com>
Link: https://lore.kernel.org/r/20240621150058.319524-2-richard.genoud@bootlin.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/remoteproc/ti_k3_r5_remoteproc.c b/drivers/remoteproc/ti_k3_r5_remoteproc.c
index 50e486bcfa103..39a47540c5900 100644
--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -1144,6 +1144,7 @@ static int k3_r5_rproc_configure_mode(struct k3_r5_rproc *kproc)
 	u32 atcm_enable, btcm_enable, loczrama;
 	struct k3_r5_core *core0;
 	enum cluster_mode mode = cluster->mode;
+	int reset_ctrl_status;
 	int ret;
 
 	core0 = list_first_entry(&cluster->cores, struct k3_r5_core, elem);
@@ -1160,11 +1161,11 @@ static int k3_r5_rproc_configure_mode(struct k3_r5_rproc *kproc)
 			 r_state, c_state);
 	}
 
-	ret = reset_control_status(core->reset);
-	if (ret < 0) {
+	reset_ctrl_status = reset_control_status(core->reset);
+	if (reset_ctrl_status < 0) {
 		dev_err(cdev, "failed to get initial local reset status, ret = %d\n",
-			ret);
-		return ret;
+			reset_ctrl_status);
+		return reset_ctrl_status;
 	}
 
 	/*
@@ -1199,7 +1200,7 @@ static int k3_r5_rproc_configure_mode(struct k3_r5_rproc *kproc)
 	 * irrelevant if module reset is asserted (POR value has local reset
 	 * deasserted), and is deemed as remoteproc mode
 	 */
-	if (c_state && !ret && !halted) {
+	if (c_state && !reset_ctrl_status && !halted) {
 		dev_info(cdev, "configured R5F for IPC-only mode\n");
 		kproc->rproc->state = RPROC_DETACHED;
 		ret = 1;
@@ -1217,7 +1218,7 @@ static int k3_r5_rproc_configure_mode(struct k3_r5_rproc *kproc)
 		ret = 0;
 	} else {
 		dev_err(cdev, "mismatched mode: local_reset = %s, module_reset = %s, core_state = %s\n",
-			!ret ? "deasserted" : "asserted",
+			!reset_ctrl_status ? "deasserted" : "asserted",
 			c_state ? "deasserted" : "asserted",
 			halted ? "halted" : "unhalted");
 		ret = -EINVAL;
-- 
2.43.0



