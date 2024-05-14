Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD81E1E4B0;
	Tue, 14 May 2024 11:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685782; cv=none; b=GttqWanSdS7AsFIZJYi8/BvyscM5hUUu6rwNF4UOrx6VKoN8pkNhvVeW42THVzkj51HsCPT6z8jlTGNiLhgVUfXnQrsGLQt8kvUugrT5WLRYkyfjGaWGkmPq7yxuSi0kpiJ9BXgf2gz46lDDyrGp/fPvsx6LmV0F/QR4oCrvh0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685782; c=relaxed/simple;
	bh=b2V42LHfTuhH81wsryyW1ks/WLDrd8KJcGMSmgCrKoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hu3HYtSoPaM5Nx6oB2Y9/ErcOVWvVK+mg+ol6kb1f5DtZm77hfXEBdwo7Z/9zy+uOjrLAV0ISW+uQpXQINzxEB1tGdQYwn3wCp7WQLjbXI6knUAzpEgbKu8itD9N0ePKZal92L16olkfCSz8zMEgs158nx6gZXDaAClnKa8LQxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0hPnjxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0hPnjxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E867C2BD10;
	Tue, 14 May 2024 11:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685782;
	bh=b2V42LHfTuhH81wsryyW1ks/WLDrd8KJcGMSmgCrKoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0hPnjxdlerZJBZuoQfQHqdkNP1QPDV96Bpn8Rjo+I52VegkpDrYyiUiLOMuvRIim
	 ayG5AdKh0AXTV8IriAZW9DGNNPZptS0/q9VQ5eWRZFPMvifNwbNBSwCUG6GINzvY92
	 NQAXfBPTO9ISETF8sKED9ydqksTX5q7JpeXLsYx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Detal <gregory.detal@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 246/301] mptcp: only allow set existing scheduler for net.mptcp.scheduler
Date: Tue, 14 May 2024 12:18:37 +0200
Message-ID: <20240514101041.543718007@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Detal <gregory.detal@gmail.com>

commit 6963c508fd7ab66ae0b7ae3db9a62ca6267f1ae8 upstream.

The current behavior is to accept any strings as inputs, this results in
an inconsistent result where an unexisting scheduler can be set:

  # sysctl -w net.mptcp.scheduler=notdefault
  net.mptcp.scheduler = notdefault

This patch changes this behavior by checking for existing scheduler
before accepting the input.

Fixes: e3b2870b6d22 ("mptcp: add a new sysctl scheduler")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Detal <gregory.detal@gmail.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Tested-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240506-upstream-net-20240506-mptcp-sched-exist-v1-1-2ed1529e521e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/ctrl.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -87,6 +87,43 @@ static void mptcp_pernet_set_defaults(st
 }
 
 #ifdef CONFIG_SYSCTL
+static int mptcp_set_scheduler(const struct net *net, const char *name)
+{
+	struct mptcp_pernet *pernet = mptcp_get_pernet(net);
+	struct mptcp_sched_ops *sched;
+	int ret = 0;
+
+	rcu_read_lock();
+	sched = mptcp_sched_find(name);
+	if (sched)
+		strscpy(pernet->scheduler, name, MPTCP_SCHED_NAME_MAX);
+	else
+		ret = -ENOENT;
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static int proc_scheduler(struct ctl_table *ctl, int write,
+			  void *buffer, size_t *lenp, loff_t *ppos)
+{
+	const struct net *net = current->nsproxy->net_ns;
+	char val[MPTCP_SCHED_NAME_MAX];
+	struct ctl_table tbl = {
+		.data = val,
+		.maxlen = MPTCP_SCHED_NAME_MAX,
+	};
+	int ret;
+
+	strscpy(val, mptcp_get_scheduler(net), MPTCP_SCHED_NAME_MAX);
+
+	ret = proc_dostring(&tbl, write, buffer, lenp, ppos);
+	if (write && ret == 0)
+		ret = mptcp_set_scheduler(net, val);
+
+	return ret;
+}
+
 static struct ctl_table mptcp_sysctl_table[] = {
 	{
 		.procname = "enabled",
@@ -139,7 +176,7 @@ static struct ctl_table mptcp_sysctl_tab
 		.procname = "scheduler",
 		.maxlen	= MPTCP_SCHED_NAME_MAX,
 		.mode = 0644,
-		.proc_handler = proc_dostring,
+		.proc_handler = proc_scheduler,
 	},
 	{}
 };


