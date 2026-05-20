Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFFC3ED5C8;
	Wed, 20 May 2026 17:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298747; cv=none; b=edo59k0ZgPdYSvVqvnF4rhX8HMC5Q/LU95/orBY1/5l7uh/xXnfJaeu+6+pGf+Wkc01VwwNYpmH1fIn1tte7Q+jIeoSxnxhxbi2giTUc49EcpceRu08dN0OzuhRQAREDnLg8NYnB3fee1Oi9FThAxdC8s40QvLanxN2qEfgWUfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298747; c=relaxed/simple;
	bh=Q6WAKmcZhZPEhiRIMN2e4F7307ahk+tycQ7MHMHYHJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csaJ2vh636jpmpBYX1QfvSX/zW7SFgaYdxaBXwcY4FM/YOs9PT3fKCCb2iOVGlGgkhUpT6ZxGlbtN+QPGX0q2qOXZjsPdcLJDtBavCYGTNA/bqU9JvFlUwuCwjOAf3aJ2e+EZC+pcMARBFX4/8bzg+UFWShd6cJf4RRD2gIZ3KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZnHg8gj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZnHg8gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716931F000E9;
	Wed, 20 May 2026 17:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298745;
	bh=O/JOVQJP7nn3NPi5CnBSpoNXGMg2rAtR7q9HJLVoCRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZnHg8gjmREP35fg0DO2RKzj289J7aKgnouxAvTv2fmKTBom9MnQctECNIWcNvpBk
	 K/3o4+W/qIMyQ1oa1casaF0yyC3QdUQrxtSMORdpfA788bkxpIlBWawrm0LD/mZJqL
	 nEeaRYAAuwERZ3dRAsebVhJhaIYDKqNlrIQAaAzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jorge Marques <jorge.marques@analog.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 526/957] i3c: master: Fix error codes at send_ccc_cmd
Date: Wed, 20 May 2026 18:16:49 +0200
Message-ID: <20260520162145.941429819@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 425e36b36009b..4ecbabcec48b4 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -826,11 +826,17 @@ static void i3c_ccc_cmd_init(struct i3c_ccc_cmd *cmd, bool rnw, u8 id,
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
 
@@ -848,15 +854,7 @@ static int i3c_master_send_ccc_cmd_locked(struct i3c_master_controller *master,
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
@@ -960,8 +958,7 @@ static int i3c_master_rstdaa_locked(struct i3c_master_controller *master,
  *
  * This function must be called with the bus lock held in write mode.
  *
- * Return: 0 in case of success, a positive I3C error code if the error is
- * one of the official Mx error codes, and a negative error code otherwise.
+ * Return: 0 in case of success, or a negative error code otherwise.
  */
 int i3c_master_entdaa_locked(struct i3c_master_controller *master)
 {
@@ -1013,8 +1010,7 @@ static int i3c_master_enec_disec_locked(struct i3c_master_controller *master,
  *
  * This function must be called with the bus lock held in write mode.
  *
- * Return: 0 in case of success, a positive I3C error code if the error is
- * one of the official Mx error codes, and a negative error code otherwise.
+ * Return: 0 in case of success, or a negative error code otherwise.
  */
 int i3c_master_disec_locked(struct i3c_master_controller *master, u8 addr,
 			    u8 evts)
@@ -1034,8 +1030,7 @@ EXPORT_SYMBOL_GPL(i3c_master_disec_locked);
  *
  * This function must be called with the bus lock held in write mode.
  *
- * Return: 0 in case of success, a positive I3C error code if the error is
- * one of the official Mx error codes, and a negative error code otherwise.
+ * Return: 0 in case of success, or a negative error code otherwise.
  */
 int i3c_master_enec_locked(struct i3c_master_controller *master, u8 addr,
 			   u8 evts)
@@ -1060,8 +1055,7 @@ EXPORT_SYMBOL_GPL(i3c_master_enec_locked);
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



