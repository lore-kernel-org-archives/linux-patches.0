Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFA352BE3E;
	Wed, 30 Sep 2026 17:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789398; cv=none; b=r6BGl5RodtxBj5/HszVxgtSQiduDnNNNMhtD6/X/3BUI/bY+O8ekLmZXjNvlCKTfwzHWisrA/JgcQhXacj0fTXTIrpAKbljjVx1lDHujM1EqJ5FJV+WcEBBf3fG/LWVjjezTA933KZS/pGPQAXtc6ORFWBQi9tD3d1OttrzOwAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789398; c=relaxed/simple;
	bh=//tgjwXKx1oaHZpJUeTi1peszXR4OefzQ23dGhE4VJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLlhXRQn+hkMmv/WJ66dD+MbdQv9eVELOQ8o1rqCfcbPQDZyNy0kmaUKwyMSpa6RS2lU6gVsAjOqmlEmbZY56xM0dlUgQvFTQUypDsLf03FsVm95+2Cbq9JohK4b6nIdhuFdWSq3pobNxnggWjhHLIs3epwbKX+Om9u6uw0/iHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciCRBUGV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciCRBUGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671DB1F000FF;
	Wed, 30 Sep 2026 17:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789396;
	bh=f2NRL8n3VOKoLP7lMOzS7vOAJ0x3JTaGjamrYs5jOMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciCRBUGVOOob1gqRkPby2lalLNR1wKFpmwKGdHBHX9Dj8OOh6FKkDMHKNcR8vPsx0
	 xwsTs0ALm6CGcqrvo49YXdqWpiMObDjc9H3bp/eV97ScqY/K2FNIrLZY4xVWtRibi+
	 jYVHMrFtj6uE+07J6tm9bAjgZLXaJOwGQM/yHpRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 464/877] cgroup/pids: Restore pids.events notifications in local mode
Date: Wed, 30 Sep 2026 17:22:55 +0200
Message-ID: <20260930152424.688564992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

commit 1765a153d985c231357145e26798f9408db10e42 upstream.

A fork rejected by the pids controller increments the counter reported by
pids.events. When local event accounting is selected, however, pids_event()
returns after notifying only events_local_file, leaving pids.events pollers
asleep.

On legacy hierarchies, pids.events.local does not exist. With
pids_localevents, pids.events reports the same local counter. In both
cases, pids.events changes without generating a notification.

This can be reproduced with a pids_localevents mount:

    mkdir /tmp/test
    mount -t cgroup2 -o pids_localevents none /tmp/test
    mkdir /tmp/test/t
    echo 1 > /tmp/test/t/pids.max
    cat /tmp/test/t/pids.events                 # max 0
    timeout 3 inotifywait -e modify /tmp/test/t/pids.events &
    sh -c 'echo $$ > /tmp/test/t/cgroup.procs; (true &)' 2>/dev/null
    wait
    cat /tmp/test/t/pids.events                 # max 1

Without this patch, inotifywait times out without reporting an event.
Notify pids.events before returning from the local event path.

Fixes: 3f26a885a068 ("cgroup/pids: Add pids.events.local")
Cc: stable@vger.kernel.org # v6.11+
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/pids.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup/pids.c b/kernel/cgroup/pids.c
index ecbb839d2acb..78cdc0558d0c 100644
--- a/kernel/cgroup/pids.c
+++ b/kernel/cgroup/pids.c
@@ -253,6 +253,11 @@ static void pids_event(struct pids_cgroup *pids_forking,
 	}
 	if (!cgroup_subsys_on_dfl(pids_cgrp_subsys) ||
 	    cgrp_dfl_root.flags & CGRP_ROOT_PIDS_LOCAL_EVENTS) {
+		/*
+		 * pids.events reports the local counter on legacy hierarchies
+		 * and when pids_localevents is enabled.
+		 */
+		cgroup_file_notify(&p->events_file);
 		cgroup_file_notify(&p->events_local_file);
 		return;
 	}
-- 
2.55.0



