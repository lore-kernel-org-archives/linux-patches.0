Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D149E3B813A;
	Sat, 17 Oct 2026 18:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260606; cv=none; b=cFZEwje4YKx/JsDPrgKwnS4VKDSvEJ5cG1rs1FtEjZ0imuUFi0SvifVhGAaDttU8JeiSjLdvyd0NBWF/IXZZmSfiDbppO0S4KMocsqvO/DE09MqOgh8fAyu94lu/+ozXgS7yO8ivjG+H739KdFMzpVL/5rBaTSqldmGKn8cayj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260606; c=relaxed/simple;
	bh=VSjU8hRwTC2jsdgtNsiPtHjNfKTkmpM+cELBHPYA38g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euLi8c7MJpN1LRKHNkXm1R7hHc+UoIyeyhgtyJVFsbng+pv0Rp9qfcoF2xfL3CNMR/KGDlk9zmgVTXO6L4FeFzwrgm2BlD20BdnPIoo2jnP+rczwLM598c5fAOYX8LXSwAPePYpdQgkLv5Qcbq1m0gFr0K46qjZ5vspXMWnxYPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Lc9TEMx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Lc9TEMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1721F000C5;
	Sat, 17 Oct 2026 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260604;
	bh=kwBoCABDhxbAPm78idIUA2GyXzfe25LdvCffMxfQa+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Lc9TEMxuit60fIs8r5B7GKPCVmgnqGCJHHST9aEyW5DVwBPnSgJ+KHjswnfrktpo
	 +HqfEIdi4tMRBEgqcyiFTQjyVtFxvAf6S6gCKFELmEGWO09dsBd1rYE6Nuwmc7iHRX
	 t8L3oIJ2RKuq04usGFo8NtvUZvKeM+lHGRKYteF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1601/1674] tracing: Take the reference before publishing the named histogram trigger
Date: Sat, 17 Oct 2026 18:04:33 +0200
Message-ID: <20261017160512.180579410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 0fe23b8eaba0d3372c66b7b31204408da0715edc ]

event_hist_trigger_named_init() puts the trigger on the global
named_triggers list and only then takes the reference on the trigger it
shares its histogram with:

	data->ref++;

	save_named_trigger(data->named_data->name, data);

	ret = event_hist_trigger_init(data->named_data);
	if (ret < 0) {
		kfree(data->cmd_ops);
		data->cmd_ops = &trigger_hist_cmd;
	}

	return ret;

event_hist_trigger_init() fails when alloc_hist_pad() cannot allocate, and
nothing takes the trigger back off the list on the way out.
event_hist_trigger_parse() frees it, and the next lookup by name reads the
freed object:

 BUG: KASAN: slab-use-after-free in find_named_trigger+0xac/0xc0
 Read of size 8 at addr ffff888009346860 by task init/1
  find_named_trigger+0xac/0xc0
  hist_register_trigger+0xc1/0xa00
  event_hist_trigger_parse+0x3146/0x6af0
  event_trigger_write+0xce/0x160
 Freed by task 67:
  kfree+0x154/0x420
  trigger_kthread_fn+0xfd/0x160

Do the reference first and publish once it has succeeded, so that nothing
which can fail runs after the trigger becomes findable.

Cc: stable@vger.kernel.org
Fixes: 7ab0fc61ce73 ("tracing: Move histogram trigger variables from stack to per CPU structure")
Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-trace-kernel/20260907092944.3950E1F00A3D@smtp.kernel.org/
Link: https://patch.msgid.link/20260907124420.607097-2-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Acked-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index cfa10517350dd..60ec8c7c6b679 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6333,11 +6333,17 @@ static struct event_trigger_ops event_hist_trigger_ops = {
 
 static int event_hist_trigger_named_init(struct event_trigger_data *data)
 {
+	int ret;
+
+	ret = event_hist_trigger_init(data->named_data);
+	if (ret < 0)
+		return ret;
+
 	data->ref++;
 
 	save_named_trigger(data->named_data->name, data);
 
-	return event_hist_trigger_init(data->named_data);
+	return 0;
 }
 
 static void event_hist_trigger_named_free(struct event_trigger_data *data)
-- 
2.53.0



