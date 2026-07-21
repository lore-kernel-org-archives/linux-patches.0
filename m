Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80FA471272;
	Tue, 21 Jul 2026 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657424; cv=none; b=kxbXqeSpu4hfwvf5tARf0u1BffWztFeXJSG9V847gJdRMgsxM3vdt4kdL1MDywXkvHErXwUahp6xvASDzVhBMqhQZ7SBJIlEPcoEc9CqDhx1iX2e5qQig4jgQuinaOMhyopfzZFKNHdMHOTctGW0qR/419vLkzQCot9WPnmlVjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657424; c=relaxed/simple;
	bh=haORXwi7inMW6N9JjbybNzTV0DA0sCPdOD/30FiUgno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmKPcNVj0JMQHEEK8reqAHaS79U33KAEApmSTtAvrgDmbnOtsGSY+HAL2WsBQmrIs7MDMhwsM0uXh914YUYrxN153GZZzwKhPxIx3pybW/stglrLHGjopez1ZQXMOwQwfNOu708WNROnBFs1EWCGGa2O8jWFJTVzZ+nm5XLK0o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LU8FCmeW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LU8FCmeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E651F000E9;
	Tue, 21 Jul 2026 18:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657422;
	bh=WFHhauW9bPD3LgHeaSRZdxlYi1Dd/PbBKD6241aSels=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LU8FCmeWff0O+t864qpi0YOPUjpZq61pJSOieailbd6zVbR9XbPpJ2s73O6k+fsvY
	 XfrU2V4xKI/1SJT2MqqP6iMnxgtAcJJzcpAegrRSZY5E+uNFPlSqeaPiMQ0EWED14Y
	 4FxwUuIApKhbg5aysHN2z7y4Dt3NpzAF+g7ydebg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jorge Marques <jorge.marques@analog.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0760/1611] i3c: master: Move rstdaa error suppression
Date: Tue, 21 Jul 2026 17:14:36 +0200
Message-ID: <20260721152532.472328444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 19a1b61fa623748f37f467e7813c58a2a792b90c ]

Prepare to fix improper Mx positive error propagation in later
commits by handling Mx error codes where the i3c_ccc_cmd command
is allocated. Two of the four i3c_master_rstdaa_locked() are error
paths that already suppressed the return value, the remaining two
are changed to handle the I3C_ERROR_M2 Mx error code inside
i3c_master_rstdaa_locked(), checking cmd->err directly.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Jorge Marques <jorge.marques@analog.com>
Link: https://patch.msgid.link/20260323-ad4062-positive-error-fix-v3-1-30bdc68004be@analog.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 3f79dac3ea1c ("i3c: master: Defer new-device registration out of DAA caller context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 0430e5898dae42..6cbd0ab0520f58 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1018,6 +1018,10 @@ static int i3c_master_rstdaa_locked(struct i3c_master_controller *master,
 	ret = i3c_master_send_ccc_cmd_locked(master, &cmd);
 	i3c_ccc_cmd_dest_cleanup(&dest);
 
+	/* No active devices on the bus. */
+	if (ret && cmd.err == I3C_ERROR_M2)
+		ret = 0;
+
 	return ret;
 }
 
@@ -1796,11 +1800,8 @@ int i3c_master_do_daa_ext(struct i3c_master_controller *master, bool rstdaa)
 
 	i3c_bus_maintenance_lock(&master->bus);
 
-	if (rstdaa) {
+	if (rstdaa)
 		rstret = i3c_master_rstdaa_locked(master, I3C_BROADCAST_ADDR);
-		if (rstret == I3C_ERROR_M2)
-			rstret = 0;
-	}
 
 	ret = master->ops->do_daa(master);
 
@@ -2096,7 +2097,7 @@ static int i3c_master_bus_init(struct i3c_master_controller *master)
 	 * (assigned by the bootloader for example).
 	 */
 	ret = i3c_master_rstdaa_locked(master, I3C_BROADCAST_ADDR);
-	if (ret && ret != I3C_ERROR_M2)
+	if (ret)
 		goto err_bus_cleanup;
 
 	if (master->ops->set_speed) {
-- 
2.53.0



