Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AF1488747;
	Wed, 23 Sep 2026 14:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172715; cv=none; b=eTzJ+y+bohbAhP1YkKQCN/Bc9j54rs3DAJLeyqWCHg+a/7MD9a4yhFGZOfiyYVLWMR8Dv05Nixkfe3mocXuU3LYHYcM4aoTqtGwX8rmrx0F1Vgmp+Gj/on+NeqFVmbia1aozvYlL8mkTlmAfK66pKFFDNDUuJABwG86fGe9ECeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172715; c=relaxed/simple;
	bh=O45c+kMoU2HFkJen+Of6msJ0BGUOS/kbJQ/N5qu0wAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsNQoer7bPquhiotAWCGUUfwKQAtmGY/V4yU7uMkw6bdt5wrD8KccjGbUemuJRoWn18oR64nUN0kzhc5zEsud/5wQEKSclfWU72yAFsKBNq+fqKAdbIf36km5z+sKGXI2EiIJfur9NE+dX2RFH//+/276t9C/Y+N+fZmXqG7LrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKa8BqOF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKa8BqOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACC71F000FF;
	Wed, 23 Sep 2026 14:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172713;
	bh=YUveBgPWX+QmF10yeIug1gX3SBVjAMd+TLQGxJkmHKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKa8BqOFVAOSYnypgt3t4fL10eYp3dGS8gtCxxUynyY4AhhuApuYdOYpnIdyeomUO
	 QPM2mG2nqiYWrilDU5bA5NzxV/Cfu/rBPiipFWIWjMZqrPubtl+m3yh85TvVc8FpDa
	 bQK6Ktbh1hm8mgDbOttslhUqyXsMaOedZhuGmg5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1695193198994f4e7fed@syzkaller.appspotmail.com,
	Ryan Mehri <ryan.mehri1@gmail.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 038/438] RDMA/rtrs: guard against null kobj name
Date: Wed, 23 Sep 2026 16:00:59 +0200
Message-ID: <20260923140645.772326865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Mehri <ryan.mehri1@gmail.com>

[ Upstream commit 99c24a8968ebef0573825b5cb89d5985d51635b9 ]

In the client, if `init_path()` errors, the callee tries to clean up
with `rtrs_clt_close_conns()`. However, this can lead to calling the
event tracing code with `clt_path->kobj->name` being `NULL` and thus
causing a null pointer dereference when trying to copy from it.

This just adds a guard to check that the name is not `NULL` before
copying from it. The server appears to have a similar pattern.

Fixes: 5a93929d9f9a1 ("RDMA/rtrs-clt: Add event tracing support")
Fixes: c16762b7bf54d ("RDMA/rtrs-srv: Add event tracing support")
Reported-by: syzbot+1695193198994f4e7fed@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1695193198994f4e7fed
Signed-off-by: Ryan Mehri <ryan.mehri1@gmail.com>
Link: https://patch.msgid.link/20260823034303.163403-1-ryan.mehri1@gmail.com
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h | 2 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h b/drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h
index 7738e26768557..29e23404bb7b8 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h
@@ -55,7 +55,7 @@ DECLARE_EVENT_CLASS(rtrs_clt_conn_class,
 		__entry->max_reconnect_attempts = clt->max_reconnect_attempts;
 		__entry->fail_cnt = clt_path->stats->reconnects.fail_cnt;
 		__entry->success_cnt = clt_path->stats->reconnects.successful_cnt;
-		memcpy(__entry->sessname, kobject_name(&clt_path->kobj), NAME_MAX);
+		strscpy(__entry->sessname, kobject_name(&clt_path->kobj) ?: "", NAME_MAX);
 	),
 
 	TP_printk("RTRS-CLT: sess='%s' state=%s attempts='%d' max-attempts='%d' fail='%d' success='%d'",
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h b/drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h
index 587d3e0330812..a7d7b971e6c80 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h
@@ -61,7 +61,7 @@ TRACE_EVENT(send_io_resp_imm,
 		__entry->msg_id = id->msg_id;
 		__entry->wr_cnt = atomic_read(&con->c.wr_cnt);
 		__entry->signal_interval = s->signal_interval;
-		memcpy(__entry->sessname, kobject_name(&srv_path->kobj), NAME_MAX);
+		strscpy(__entry->sessname, kobject_name(&srv_path->kobj) ?: "", NAME_MAX);
 	),
 
 	TP_printk("sess='%s' state='%s' dir=%s err='%d' inval='%d' glob-inval='%d' msgid='%u' wrcnt='%d' sig-interval='%u'",
-- 
2.53.0



