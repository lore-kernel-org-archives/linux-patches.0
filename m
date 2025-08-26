Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402193A1B5;
	Tue, 26 Aug 2025 13:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213275; cv=none; b=eHHUKbfhaG5qs+lSXc6yMK5R9HkN1v0tk7+/Y+JHT0hkGrIOt4YxZ3eZQ7FvcXfw5gMOjnw+5n8c4GIXf4rI9ozYlMvEImkGEBHknFz6BjlFXcQ7aWOioEhoWy3u5b304jfNQZYVOxwycbmHC4JajYHeIcBWuDQS7MS2JYmCZfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213275; c=relaxed/simple;
	bh=bkgD5nGQlXNYZ6TrqK+lcVhjFQx6Twxes37VsY+tYlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8PCrGKcfRAH1vr4C2g9aK5AZv8KyJSlvWmKF+WPS81mw1/wzt26Qlu+gvt88lU6XnAwllTZXKFtiNoiIZ79B64dBCI2BzxdEQyVAW5w3ABd6CdNWDmMPcen+0p5ECo2leJq5z3UbUrJK+ABpXEF0hdx8XgQplfMnCgL5mh0vno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKZ8fnZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKZ8fnZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CCAC4CEF1;
	Tue, 26 Aug 2025 13:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213275;
	bh=bkgD5nGQlXNYZ6TrqK+lcVhjFQx6Twxes37VsY+tYlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKZ8fnZWw5ek2iaYCjPukWTNEzsqKQhXDyWVb5DVGfr10hi3HwFOWXI4jHWtBrABq
	 mmG1zxtUwzpfKFJCcz+mD2CmyNQtD0dE45ctXJ+D1S3XGlB82rCVs7/RdhqOxDqpGu
	 6dRvi+LcLMB84jhoZ3HF0etCV1xIGyeOViyM8pxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 285/587] ipmi: Fix strcpy source and destination the same
Date: Tue, 26 Aug 2025 13:07:14 +0200
Message-ID: <20250826111000.179711621@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9a459257489f..ca149ca8ccd6 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1190,14 +1190,8 @@ static struct ipmi_smi_watcher smi_watcher = {
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
@@ -1208,18 +1202,26 @@ static int action_op(const char *inval, char *outval)
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
@@ -1232,18 +1234,26 @@ static int preaction_op(const char *inval, char *outval)
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
@@ -1252,7 +1262,22 @@ static int preop_op(const char *inval, char *outval)
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
 
@@ -1289,18 +1314,18 @@ static int __init ipmi_wdog_init(void)
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



