Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D82143C49;
	Tue, 23 Apr 2024 21:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908725; cv=none; b=NJJ3EPNzOzU6HB2jUTYsL2ljMz/GN38M2G1bH61BFMcCcGBCkOCF9N9Z3A1ctgGRZQD/LmtzTp+COxHTHJJa+VjB2vPP3HOpDfSYT1ZniBCpew+tGcWKAkd6dSvVROeGTDB9iD51a6ciTPogwWOK4uyuQG5u3yZgsfhHZCUyuwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908725; c=relaxed/simple;
	bh=0dna9pcrj1OIaP1tioC4eoqJZTNXlSkxRJwxQ1Q46Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDzxwjwdjjeY4l2AAdqfIYJFwdYOWcq9ilQo6jcIMHm4cDTkAmdnDoqnI2Zf4iBK6c/1F7ph2Wd3ZJEczl6xLMdiuDio4coTsqQEm420ZAn22xdbxhpPjZoUjWrgqVI0o8vqlE/JU9X0l/xs1NxiGoqjpgiP7rQ3nLnqkLL1+Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drOy8IPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drOy8IPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AEFC3277B;
	Tue, 23 Apr 2024 21:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908725;
	bh=0dna9pcrj1OIaP1tioC4eoqJZTNXlSkxRJwxQ1Q46Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drOy8IPlF0/dfQmVuIA6SwEdB6jz6if0JnMCEUwz/STI9UWm7vB5yPFpFl9BaBSdh
	 kxCXCD4cTCfZhe/Hcu+Q6M6PlH8Uyx6JiirYIG/iu/GvILkA7/pU5iGe8MxZeNakAy
	 myEOx6/qYgtklmTzCh4ImK/lyAXG+zkwmpyncrbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/141] clk: Get runtime PM before walking tree for clk_summary
Date: Tue, 23 Apr 2024 14:39:17 -0700
Message-ID: <20240423213856.074086570@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 9d1e795f754db1ac3344528b7af0b17b8146f321 ]

Similar to the previous commit, we should make sure that all devices are
runtime resumed before printing the clk_summary through debugfs. Failure
to do so would result in a deadlock if the thread is resuming a device
to print clk state and that device is also runtime resuming in another
thread, e.g the screen is turning on and the display driver is starting
up. We remove the calls to clk_pm_runtime_{get,put}() in this path
because they're superfluous now that we know the devices are runtime
resumed. This also squashes a bug where the return value of
clk_pm_runtime_get() wasn't checked, leading to an RPM count underflow
on error paths.

Fixes: 1bb294a7981c ("clk: Enable/Disable runtime PM for clk_summary")
Cc: Taniya Das <quic_tdas@quicinc.com>
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20240325184204.745706-6-sboyd@kernel.org
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ded4a51323d2e..fe1d45eac837c 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3247,9 +3247,7 @@ static void clk_summary_show_subtree(struct seq_file *s, struct clk_core *c,
 {
 	struct clk_core *child;
 
-	clk_pm_runtime_get(c);
 	clk_summary_show_one(s, c, level);
-	clk_pm_runtime_put(c);
 
 	hlist_for_each_entry(child, &c->children, child_node)
 		clk_summary_show_subtree(s, child, level + 1);
@@ -3259,11 +3257,15 @@ static int clk_summary_show(struct seq_file *s, void *data)
 {
 	struct clk_core *c;
 	struct hlist_head **lists = s->private;
+	int ret;
 
 	seq_puts(s, "                                 enable  prepare  protect                                duty  hardware                            connection\n");
 	seq_puts(s, "   clock                          count    count    count        rate   accuracy phase  cycle    enable   consumer                         id\n");
 	seq_puts(s, "---------------------------------------------------------------------------------------------------------------------------------------------\n");
 
+	ret = clk_pm_runtime_get_all();
+	if (ret)
+		return ret;
 
 	clk_prepare_lock();
 
@@ -3272,6 +3274,7 @@ static int clk_summary_show(struct seq_file *s, void *data)
 			clk_summary_show_subtree(s, c, 0);
 
 	clk_prepare_unlock();
+	clk_pm_runtime_put_all();
 
 	return 0;
 }
@@ -3319,8 +3322,14 @@ static int clk_dump_show(struct seq_file *s, void *data)
 	struct clk_core *c;
 	bool first_node = true;
 	struct hlist_head **lists = s->private;
+	int ret;
+
+	ret = clk_pm_runtime_get_all();
+	if (ret)
+		return ret;
 
 	seq_putc(s, '{');
+
 	clk_prepare_lock();
 
 	for (; *lists; lists++) {
@@ -3333,6 +3342,7 @@ static int clk_dump_show(struct seq_file *s, void *data)
 	}
 
 	clk_prepare_unlock();
+	clk_pm_runtime_put_all();
 
 	seq_puts(s, "}\n");
 	return 0;
-- 
2.43.0



