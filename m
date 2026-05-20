Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1704834EEF7;
	Wed, 20 May 2026 18:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302513; cv=none; b=UC5mNoiCs4WVPv584ae5hOoNbIMflTAgH3W0HFUGKuVjFyaxg3J1posQPjIRaeWOGYTlTZFFBv9Vvtg90zELPiTKCzxjHXzyff3b/TnH+NA4jtzZg6BTaVZdcrDW0Z+OvU2Ol4KzL7mvn061KWXbdS+Hbq3JGl74bChzzLFjl6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302513; c=relaxed/simple;
	bh=iTFmew2ifSlInJw8J8f8qX1GlmvKViku1/xp2FekjaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1Ps0+xkMPnOBQNnkpZZSBuT1YvAFu9CMnfxAZh4yPzg7fmgVIhBppPPyaqJ+We+A/sZCFyDz1bfAXgor2iStUCcCiBChRi+5Is2UvlYs0KMBrS2IAUjA1T+5S7siRyVg02V7rdJX4TGg7bFryvWJGWYAfEsQTzUlKMu27lFj8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqoxq4+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqoxq4+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560C01F000E9;
	Wed, 20 May 2026 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302511;
	bh=sNpR3Q0vE5/tXnCr1PAFAad+vFOHCtcNrpDLO6CZl2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqoxq4+ObirxzLEg+EqXye2MYqeVa2sL16eCw4GqA4c33AmKnMWXllU2Vg4litXJz
	 P1BVUlnx1auP8ypNbUypJ4dr+ARGUu/7R1Bhfzd+JCnDMc54F3Z3q0OOV7i4jTLqnl
	 0kL915awRCXdo+aA6tT5e4mUyadpsAyn+SSnaXi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jorge Marques <jorge.marques@analog.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 258/508] i3c: master: Fix error codes at send_ccc_cmd
Date: Wed, 20 May 2026 18:21:21 +0200
Message-ID: <20260520162104.236146409@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Jorge Marques <jorge.marques@analog.com>

[ Upstream commit ef8b5229348f0719aca557c4ca5530630ae4d134 ]

i3c_master_send_ccc_cmd_locked() would propagate cmd->err (positive,
Mx codes) to the ret variable, cascading down multiple methods until
reaching methods that explicitly stated they would return 0 on success
or negative error code. For example, the call chain:

  i3c_device_enable_ibi <- i3c_dev_enable_ibi_locked <-
  master->ops.enable_ibi <- i3c_master_enec_locked <-
  i3c_master_enec_disec_locked <- i3c_master_send_ccc_cmd_locked

Fix this by returning the ret value, callers can still read the cmd->err
value if ret is negative.

All corner cases where the Mx codes do need to be handled individually,
are resolved in previous commits. Those corner cases are all scenarios
when I3C_ERROR_M2 is expected and acceptable.
The prerequisite patches for the fix are:

  i3c: master: Move rstdaa error suppression
  i3c: master: Move entdaa error suppression
  i3c: master: Move bus_init error suppression

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-iio/aYXvT5FW0hXQwhm_@stanley.mountain/
Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Jorge Marques <jorge.marques@analog.com>
Link: https://patch.msgid.link/20260323-ad4062-positive-error-fix-v3-4-30bdc68004be@analog.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index f74ef65d257d7..84fe0de5a9bc7 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -792,11 +792,17 @@ static void i3c_ccc_cmd_init(struct i3c_ccc_cmd *cmd, bool rnw, u8 id,
 	cmd->err = I3C_ERROR_UNKNOWN;
 }
 
+/**
+ * i3c_master_send_ccc_cmd_locked() - send a CCC (Common Command Codes)
+ * @master: master used to send frames on the bus
+ * @cmd: command to send
+ *
+ * Return: 0 in case of success, or a negative error code otherwise.
+ *         I3C Mx error codes are stored in cmd->err.
+ */
 static int i3c_master_send_ccc_cmd_locked(struct i3c_master_controller *master,
 					  struct i3c_ccc_cmd *cmd)
 {
-	int ret;
-
 	if (!cmd || !master)
 		return -EINVAL;
 
@@ -814,15 +820,7 @@ static int i3c_master_send_ccc_cmd_locked(struct i3c_master_controller *master,
 	    !master->ops->supports_ccc_cmd(master, cmd))
 		return -ENOTSUPP;
 
-	ret = master->ops->send_ccc_cmd(master, cmd);
-	if (ret) {
-		if (cmd->err != I3C_ERROR_UNKNOWN)
-			return cmd->err;
-
-		return ret;
-	}
-
-	return 0;
+	return master->ops->send_ccc_cmd(master, cmd);
 }
 
 static struct i2c_dev_desc *
@@ -926,8 +924,7 @@ static int i3c_master_rstdaa_locked(struct i3c_master_controller *master,
  *
  * This function must be called with the bus lock held in write mode.
  *
- * Return: 0 in case of success, a positive I3C error code if the error is
- * one of the official Mx error codes, and a negative error code otherwise.
+ * Return: 0 in case of success, or a negative error code otherwise.
  */
 int i3c_master_entdaa_locked(struct i3c_master_controller *master)
 {
@@ -979,8 +976,7 @@ static int i3c_master_enec_disec_locked(struct i3c_master_controller *master,
  *
  * This function must be called with the bus lock held in write mode.
  *
- * Return: 0 in case of success, a positive I3C error code if the error is
- * one of the official Mx error codes, and a negative error code otherwise.
+ * Return: 0 in case of success, or a negative error code otherwise.
  */
 int i3c_master_disec_locked(struct i3c_master_controller *master, u8 addr,
 			    u8 evts)
@@ -1000,8 +996,7 @@ EXPORT_SYMBOL_GPL(i3c_master_disec_locked);
  *
  * This function must be called with the bus lock held in write mode.
  *
- * Return: 0 in case of success, a positive I3C error code if the error is
- * one of the official Mx error codes, and a negative error code otherwise.
+ * Return: 0 in case of success, or a negative error code otherwise.
  */
 int i3c_master_enec_locked(struct i3c_master_controller *master, u8 addr,
 			   u8 evts)
@@ -1026,8 +1021,7 @@ EXPORT_SYMBOL_GPL(i3c_master_enec_locked);
  *
  * This function must be called with the bus lock held in write mode.
  *
- * Return: 0 in case of success, a positive I3C error code if the error is
- * one of the official Mx error codes, and a negative error code otherwise.
+ * Return: 0 in case of success, or a negative error code otherwise.
  */
 int i3c_master_defslvs_locked(struct i3c_master_controller *master)
 {
-- 
2.53.0



