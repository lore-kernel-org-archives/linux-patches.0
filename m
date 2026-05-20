Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647B73D3CE5;
	Wed, 20 May 2026 16:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296069; cv=none; b=KloLfDdnuF8biIIYEn65tRQUMrjl02gyiSERWAgO1xLh7Ak8VA9LKSoNI8Ko8aRkdM1De5DUWN9t4sc+GK5mBEe8F2Mw9TjxpJ8WZrxnVi98fv2Ms0tekJn1XyKJrersjGqyHUIubUBgTLl25P8LlRRT7OQhlrDYwl3oVvRxzbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296069; c=relaxed/simple;
	bh=FYEBR+FBmrYvPGeYUNFHoFq5SC2JL+5Uw8bML0X2Jtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTEqYVIk0zrSb5baG03FiyqrD9GQdqzu83VCi6nJ7CXzNhlYLP/plo5CqmpcxFtMG6Y4uFFIbuTqlh3O+xzT+7l7RTtPVfrv9Wx4vGxnHswlE/J7/3v3X9M/m2L0Xn/pGS/L37BlMab4eITgZ+eQfGGa8JXE84aAfozVw2Jfol0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1CiKdcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1CiKdcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C770D1F000E9;
	Wed, 20 May 2026 16:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296068;
	bh=AfnYNJEHxMed9qYtJvLO+K6/XkI4pn9YO8XxJVMPmsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1CiKdcOG0tIJJwHE+BJ0pijPKGFicc7Cb3rc6sxlJk85I6+FT7cTwRiAY+LckEQy
	 KWoDNB5pWgFx8nVH9S6FfJYq/qzXLpZ/OLv+X2PjPV+m7fROci5fjT6rgO1i82OSNv
	 /U031FSW18lAp0HHJ2i6pN0d0RtHu8+CS1PczN/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jorge Marques <jorge.marques@analog.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0660/1146] i3c: master: Fix error codes at send_ccc_cmd
Date: Wed, 20 May 2026 18:15:10 +0200
Message-ID: <20260520162203.122077007@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 9e6be49bebb2c..930c4dad632fc 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -898,11 +898,17 @@ static void i3c_ccc_cmd_init(struct i3c_ccc_cmd *cmd, bool rnw, u8 id,
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
 
@@ -920,15 +926,7 @@ static int i3c_master_send_ccc_cmd_locked(struct i3c_master_controller *master,
 	    !master->ops->supports_ccc_cmd(master, cmd))
 		return -EOPNOTSUPP;
 
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
@@ -1032,8 +1030,7 @@ static int i3c_master_rstdaa_locked(struct i3c_master_controller *master,
  *
  * This function must be called with the bus lock held in write mode.
  *
- * Return: 0 in case of success, a positive I3C error code if the error is
- * one of the official Mx error codes, and a negative error code otherwise.
+ * Return: 0 in case of success, or a negative error code otherwise.
  */
 int i3c_master_entdaa_locked(struct i3c_master_controller *master)
 {
@@ -1085,8 +1082,7 @@ static int i3c_master_enec_disec_locked(struct i3c_master_controller *master,
  *
  * This function must be called with the bus lock held in write mode.
  *
- * Return: 0 in case of success, a positive I3C error code if the error is
- * one of the official Mx error codes, and a negative error code otherwise.
+ * Return: 0 in case of success, or a negative error code otherwise.
  */
 int i3c_master_disec_locked(struct i3c_master_controller *master, u8 addr,
 			    u8 evts)
@@ -1106,8 +1102,7 @@ EXPORT_SYMBOL_GPL(i3c_master_disec_locked);
  *
  * This function must be called with the bus lock held in write mode.
  *
- * Return: 0 in case of success, a positive I3C error code if the error is
- * one of the official Mx error codes, and a negative error code otherwise.
+ * Return: 0 in case of success, or a negative error code otherwise.
  */
 int i3c_master_enec_locked(struct i3c_master_controller *master, u8 addr,
 			   u8 evts)
@@ -1132,8 +1127,7 @@ EXPORT_SYMBOL_GPL(i3c_master_enec_locked);
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



