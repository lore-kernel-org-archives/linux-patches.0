Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C810769950;
	Tue, 14 May 2024 10:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683765; cv=none; b=kzost9HS18U+APjuDdbTNZt6GfG22HUHVWau/sjWmftbDpooTcaDTxS30Lo7zM1JiO6dUMr1+HorlPb6xBQi62r8q64Qsap3WIlEB99KjSL13i+2kAc4YQof+r/FR4mBDBGFuEkKdO2fpEOhR+hrMTPTK2jcJ5PsfEW5mleWXoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683765; c=relaxed/simple;
	bh=Cpi58TQ3Eo5GQ4tFKSocLdGmFP+y9O0tkmR1tVDNG88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPvah4XjXLOy0akHu3kwXczGi/WMGB1y93zoRMW3/JGFQNaFwPkCvUHs0Gmf5tOZfwGtoOzPoCHoxq9f+LJslkaWo013WGl59F5NvpSRKHZYNF/PvFqenLs/yIyaJrFeGTRMTvColoVkzd7BSaJYFBv5vHOs6ozNsps6NfkNgBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mhlq2UXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mhlq2UXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319C4C2BD10;
	Tue, 14 May 2024 10:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683765;
	bh=Cpi58TQ3Eo5GQ4tFKSocLdGmFP+y9O0tkmR1tVDNG88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mhlq2UXMMXUfsz5TJo/h0oCzHmwBVC7t95aQjtKh/SGgFlRTA8JygkaPB+jon9QUP
	 VxZu2D/1AzSoTP/L5Wxfru+YRqxYsVSqmInXOBbBMQEFRaK8Xk94WvbJOfnFbGXi0u
	 EA2ayLjxIFJ6SEjt8eeMhYp3jhOvUYfonYywrspw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Detal <gregory.detal@gmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 270/336] mptcp: only allow set existing scheduler for net.mptcp.scheduler
Date: Tue, 14 May 2024 12:17:54 +0200
Message-ID: <20240514101048.814591647@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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
@@ -96,6 +96,43 @@ static void mptcp_pernet_set_defaults(st
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
@@ -148,7 +185,7 @@ static struct ctl_table mptcp_sysctl_tab
 		.procname = "scheduler",
 		.maxlen	= MPTCP_SCHED_NAME_MAX,
 		.mode = 0644,
-		.proc_handler = proc_dostring,
+		.proc_handler = proc_scheduler,
 	},
 	{
 		.procname = "close_timeout",


