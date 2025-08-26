Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649B1223335;
	Tue, 26 Aug 2025 14:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219131; cv=none; b=eX8n2ZWn4q94nfYw3Vmxb88TQdNpF7rzycD/5hecHhX4IGr/HxmaU80XH9TSC8IlEj9/VwyRGlMqSiiuZ277xJQ0HyyijlEB42K4cfsvGpnE5rThBarT6XtTZfL+/Dk+6Y0RbZc4zpKZwrTw9sa/1DxF7Kjui54+krCvvRd2cW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219131; c=relaxed/simple;
	bh=oLa1j9307947sg8k9v3/JT1yq25QIXWtVqskmnVenZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwuZWr/4fTteREX7wP4qXOUwZEwfjPel1TOK9O77WmuyuTCCAYEJrb5aasMzrZjNJsFlWPlNiHUim1EzUeVptcWZWW5CtQAYgMUwHTGJQ9wRpklEYuIvyDnoeykkUCH5YiQrZxWn4Sm/uceOL2+YoW9kJGztGVjMGk0z7Nf/B0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKF3dWXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKF3dWXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F21EC4CEF1;
	Tue, 26 Aug 2025 14:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219130;
	bh=oLa1j9307947sg8k9v3/JT1yq25QIXWtVqskmnVenZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKF3dWXp6Tucnt42ER0He866AURq7D7kI+ftvFyV62t+Ow3TcI9FW16hvqDYNVuSS
	 YrVEp4ZP3NHuVOnPxccgnsxVNvtlL/TNIlWNzFWbackAo+AGa2bhGJRsNXOH9hsaW4
	 T2M9TER0eCaRn35OPf3Lm6lwHzBSDRYttkpmvur0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 265/403] ipmi: Fix strcpy source and destination the same
Date: Tue, 26 Aug 2025 13:09:51 +0200
Message-ID: <20250826110914.131098804@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

[ Upstream commit 8ffcb7560b4a15faf821df95e3ab532b2b020f8c ]

The source and destination of some strcpy operations was the same.
Split out the part of the operations that needed to be done for those
particular calls so the unnecessary copy wasn't done.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506140756.EFXXvIP4-lkp@intel.com/
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_watchdog.c | 59 ++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 17 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index ccb62c480bdd..ac2099f3f41a 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1192,14 +1192,8 @@ static struct ipmi_smi_watcher smi_watcher = {
 	.smi_gone = ipmi_smi_gone
 };
 
-static int action_op(const char *inval, char *outval)
+static int action_op_set_val(const char *inval)
 {
-	if (outval)
-		strcpy(outval, action);
-
-	if (!inval)
-		return 0;
-
 	if (strcmp(inval, "reset") == 0)
 		action_val = WDOG_TIMEOUT_RESET;
 	else if (strcmp(inval, "none") == 0)
@@ -1210,18 +1204,26 @@ static int action_op(const char *inval, char *outval)
 		action_val = WDOG_TIMEOUT_POWER_DOWN;
 	else
 		return -EINVAL;
-	strcpy(action, inval);
 	return 0;
 }
 
-static int preaction_op(const char *inval, char *outval)
+static int action_op(const char *inval, char *outval)
 {
+	int rv;
+
 	if (outval)
-		strcpy(outval, preaction);
+		strcpy(outval, action);
 
 	if (!inval)
 		return 0;
+	rv = action_op_set_val(inval);
+	if (!rv)
+		strcpy(action, inval);
+	return rv;
+}
 
+static int preaction_op_set_val(const char *inval)
+{
 	if (strcmp(inval, "pre_none") == 0)
 		preaction_val = WDOG_PRETIMEOUT_NONE;
 	else if (strcmp(inval, "pre_smi") == 0)
@@ -1234,18 +1236,26 @@ static int preaction_op(const char *inval, char *outval)
 		preaction_val = WDOG_PRETIMEOUT_MSG_INT;
 	else
 		return -EINVAL;
-	strcpy(preaction, inval);
 	return 0;
 }
 
-static int preop_op(const char *inval, char *outval)
+static int preaction_op(const char *inval, char *outval)
 {
+	int rv;
+
 	if (outval)
-		strcpy(outval, preop);
+		strcpy(outval, preaction);
 
 	if (!inval)
 		return 0;
+	rv = preaction_op_set_val(inval);
+	if (!rv)
+		strcpy(preaction, inval);
+	return 0;
+}
 
+static int preop_op_set_val(const char *inval)
+{
 	if (strcmp(inval, "preop_none") == 0)
 		preop_val = WDOG_PREOP_NONE;
 	else if (strcmp(inval, "preop_panic") == 0)
@@ -1254,7 +1264,22 @@ static int preop_op(const char *inval, char *outval)
 		preop_val = WDOG_PREOP_GIVE_DATA;
 	else
 		return -EINVAL;
-	strcpy(preop, inval);
+	return 0;
+}
+
+static int preop_op(const char *inval, char *outval)
+{
+	int rv;
+
+	if (outval)
+		strcpy(outval, preop);
+
+	if (!inval)
+		return 0;
+
+	rv = preop_op_set_val(inval);
+	if (!rv)
+		strcpy(preop, inval);
 	return 0;
 }
 
@@ -1291,18 +1316,18 @@ static int __init ipmi_wdog_init(void)
 {
 	int rv;
 
-	if (action_op(action, NULL)) {
+	if (action_op_set_val(action)) {
 		action_op("reset", NULL);
 		pr_info("Unknown action '%s', defaulting to reset\n", action);
 	}
 
-	if (preaction_op(preaction, NULL)) {
+	if (preaction_op_set_val(preaction)) {
 		preaction_op("pre_none", NULL);
 		pr_info("Unknown preaction '%s', defaulting to none\n",
 			preaction);
 	}
 
-	if (preop_op(preop, NULL)) {
+	if (preop_op_set_val(preop)) {
 		preop_op("preop_none", NULL);
 		pr_info("Unknown preop '%s', defaulting to none\n", preop);
 	}
-- 
2.39.5



