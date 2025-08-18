Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEF6335BCF;
	Mon, 18 Aug 2025 13:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524261; cv=none; b=ZZAdUytPLyBtlFA0u5DaeSusqzM5Kf+2e1PC1faTF+IPEnCw4RceCb5Y9qmGelfghUScEsChGjCWQWdzn0W4tJtMXh0ImDw5kOHhj5Y9DK9KUGsaUK+czDIEny9Ld+8s1pDYUAkAxqrWxFTkGXn1AhHNmJuGqTvkYbBNTpv45Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524261; c=relaxed/simple;
	bh=KbXpWfhsR4m7SRqTmywFNxW3+UOgUDrQq3VyN05iG1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQe9MG/v4BR/KEUeofV5B2JtjNMpVPCF2Kbqfq9R7faDhQd6DbOeDDbPqPH6tB8l1Wkb79eRGxF/WRVXNs+2J3XXeA/sJWrKPP5pOXNTJ7IcB0+G2lXFo9b4UQ6+uz8gfBIsGGyEOhEXUNaqQXEOHFEz5fV4+ECY4hEgj4NB2fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1Cl3Fqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1Cl3Fqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1980DC113D0;
	Mon, 18 Aug 2025 13:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524260;
	bh=KbXpWfhsR4m7SRqTmywFNxW3+UOgUDrQq3VyN05iG1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1Cl3FqhNHQ8MpJeIaIDaRsQWY9e/J+RsrqXFrd9lG0GdxBA2QDwV0hEnzpcLTasl
	 sDnNGEXU/QdZv1S5tChGs2LUM5655cuzSU6E5W78/55Bq0T4JHAGgeWrzuOG+n0mFG
	 Yzw8Tv+vmaERqZDjOmBP0qFNaUNeeW0mMYmnkKFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 417/515] ipmi: Fix strcpy source and destination the same
Date: Mon, 18 Aug 2025 14:46:43 +0200
Message-ID: <20250818124514.478937543@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index f1875b2bebbc..f798d4cbf8a7 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -1186,14 +1186,8 @@ static struct ipmi_smi_watcher smi_watcher = {
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
@@ -1204,18 +1198,26 @@ static int action_op(const char *inval, char *outval)
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
@@ -1228,18 +1230,26 @@ static int preaction_op(const char *inval, char *outval)
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
@@ -1248,7 +1258,22 @@ static int preop_op(const char *inval, char *outval)
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
 
@@ -1285,18 +1310,18 @@ static int __init ipmi_wdog_init(void)
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



