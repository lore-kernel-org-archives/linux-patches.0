Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6DB143C5A;
	Tue, 23 Apr 2024 21:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908502; cv=none; b=Q2/f4R3wGQh+WqEGEr3tzNd9MkQBkaFbM3aCn12p4z2uHVvX+rfs2WsDXpkU15iBn1XXso9RZGY5BSkDovYYZw0eeQxDz7CLDY2YSxRCKWddVLOavdJRSrILftMhvedYyCTOdEbpvAVzDeYVGpeuv9i1yHrlU/YnlXMZh+DIn2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908502; c=relaxed/simple;
	bh=p/XUCJVADU0pYA8bD0aI9iJx1VA6Do9SrF4FzBSNV6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTDsQ+8JB6JV0B02zAAbY73hDaMb7wHLK7rAlkNWeeue1SKXdFMl7WpGvqj5NEqyMtQsd0cYafBq1vVUWcYZvwEAgGiEAjOmVfNr0adL4YN9iFTs78U3Y+UQM2tSgoITwNHvwCeOTKVGzn6lNkOMLJTUqNc++FGgZBC0z9ejxGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=te33cjGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="te33cjGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17ADC4AF07;
	Tue, 23 Apr 2024 21:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908501;
	bh=p/XUCJVADU0pYA8bD0aI9iJx1VA6Do9SrF4FzBSNV6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=te33cjGbc9b/gKW7oodE3DY7LMp3iUB//UhVshRWSw7uqNgxzNTx1tS36CBiGWEap
	 p6Gn6rKRbnqcevdKoD2gpLzPYPCYaipIoBSRB+dfnWLzpLnh0+fzoWxGhpZeouCTH8
	 YslNIyCatdZYc9q2YK0oyllgN9O2AwrjHMBlVwqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 081/158] clk: Get runtime PM before walking tree for clk_summary
Date: Tue, 23 Apr 2024 14:38:23 -0700
Message-ID: <20240423213858.583240245@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 7162b45da91f8..cf1fc0edfdbca 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3321,9 +3321,7 @@ static void clk_summary_show_subtree(struct seq_file *s, struct clk_core *c,
 {
 	struct clk_core *child;
 
-	clk_pm_runtime_get(c);
 	clk_summary_show_one(s, c, level);
-	clk_pm_runtime_put(c);
 
 	hlist_for_each_entry(child, &c->children, child_node)
 		clk_summary_show_subtree(s, child, level + 1);
@@ -3333,11 +3331,15 @@ static int clk_summary_show(struct seq_file *s, void *data)
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
 
@@ -3346,6 +3348,7 @@ static int clk_summary_show(struct seq_file *s, void *data)
 			clk_summary_show_subtree(s, c, 0);
 
 	clk_prepare_unlock();
+	clk_pm_runtime_put_all();
 
 	return 0;
 }
@@ -3393,8 +3396,14 @@ static int clk_dump_show(struct seq_file *s, void *data)
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
@@ -3407,6 +3416,7 @@ static int clk_dump_show(struct seq_file *s, void *data)
 	}
 
 	clk_prepare_unlock();
+	clk_pm_runtime_put_all();
 
 	seq_puts(s, "}\n");
 	return 0;
-- 
2.43.0



