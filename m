Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F380A51D513;
	Wed, 30 Sep 2026 18:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793357; cv=none; b=CHH22T1McIHV8iLj7s/PBXnDOLBsceYS9CcDPp/rxSy77syptevuBLleu5Eg/jmoHYamsx9ZcfmYM3gC4tSkTgG92etJouhK9rgOuq+QosdDvszi+cmUo3GrhxUqZ/a8aa4CKJWTzTUpmPVIOHJE+Jb8ZGVW8WYoqyGUOBLV5l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793357; c=relaxed/simple;
	bh=/+Y+tETINHs13HEo9xqGFknvGa5aMinYlIsReh9kYjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKaUsVLXbMvYurTqTJB0LA1Fkjrqybp+EW333+w9yZtDSWajI3Pe/o1qf5zFupMhxDJv931sNxHHa/ttvzqRF0qgCXl6K9Imd2zV1jLuFl4EewrlFUWCgePtUmk4LgPJhJo3DBJ9qOKEJk1VQ2PNjNOfUfwXGhTNkdcqrfXBBlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drPyoXqC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drPyoXqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546E11F000FF;
	Wed, 30 Sep 2026 18:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793355;
	bh=WYFcN2JJeCUz8W/HtKGget11Hefqvpqg4HaBgwPVpyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drPyoXqCDSwSzeLNDEulLRJr4Ji5AwPUJt0dtWh2h2nAYFJkfmeApOQ6P4nk5IUjW
	 8Wgw9zF/zn42/tWmBUVc2aEFfPbIwPwzKscyMB/qA5DGfuf2cc8jdL1c2xXe/iwea2
	 yUXxykOaQ1pQ2V2pmLLJycsTwqzln2ftESGLi1sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 219/395] cgroup/pids: Restore pids.events notifications in local mode
Date: Wed, 30 Sep 2026 17:28:01 +0200
Message-ID: <20260930152345.413543586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/cgroup/pids.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/cgroup/pids.c
+++ b/kernel/cgroup/pids.c
@@ -253,6 +253,11 @@ static void pids_event(struct pids_cgrou
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


