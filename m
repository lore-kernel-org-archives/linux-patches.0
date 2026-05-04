Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F79A3D9DBB;
	Mon,  4 May 2026 14:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904252; cv=none; b=ENl5BcmpZ4UOZAzOC0l5etktS7S8krzAcfM1HYIy5iZvr+74n0sExfB4rdDVMxhJmotmemqncZ2vueqZHuiNXUxYXjgGI7Tisc0H+kEG7UCrC879lXf8mzoD8RuRtsu4VZxBke+wxjWZyRM4sirYbGV1nXS3KfCFMgFHlpTdtn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904252; c=relaxed/simple;
	bh=Gn8ZZJvvtuOZlU5nzZPjeoZv56Uj8LofFhfRjTu7kUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjQuooQzSz2+k/Ek81flEX3fi2nrJnNhP2fHBneYbjHEfJLHNGsZwrmSctAZk++/YAIPEwiNxDjePJOt+OMG9EHclfgutZgyvBcAq/F487Fn7MGY2Ej2rATVvhxegXIH2aLgkpsQVrdPwHwgi7Y+9OtkVMuG9D2wFf6B+m9e0+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1jwC/4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1jwC/4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9957EC2BCB8;
	Mon,  4 May 2026 14:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904251;
	bh=Gn8ZZJvvtuOZlU5nzZPjeoZv56Uj8LofFhfRjTu7kUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1jwC/4BPFe2nwqOqBadWxTeG/tdibXNHrAmeWN5v6zTHnc/JhVW6mR9fNkbKcF6Z
	 vuquUr6l/L1Ux9ungP0XL5oIs9TMrhhXewN2XgWRm+t8CfEpExInshVFZRv7zGafNT
	 TcmBaQy88FynFyjN0wVAkVn/F0L31Gib30RtE6+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 243/275] sched_ext: Documentation: Clarify ops.dispatch() role in task lifecycle
Date: Mon,  4 May 2026 15:53:03 +0200
Message-ID: <20260504135152.068080324@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Andrea Righi <arighi@nvidia.com>

commit a313357a346839d40b3a4dec393c71bf30cbb34c upstream.

ops.dispatch() is invoked when a CPU becomes available. This can occur
when a task voluntarily yields the CPU, exhausts its time slice, or is
preempted for other reasons.

If the task is still runnable, refilling its time slice in
ops.dispatch() (either by the BPF scheduler or the sched_ext core)
allows it to continue running without triggering ops.stopping().
However, this behavior is not clearly reflected in the current task
lifecycle diagram.

Update the diagram to better represent this interaction.

Fixes: 9465f44d2df2 ("sched_ext: Documentation: Clarify time slice handling in task lifecycle")
Cc: stable@vger.kernel.org # v6.17+
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/scheduler/sched-ext.rst |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/Documentation/scheduler/sched-ext.rst
+++ b/Documentation/scheduler/sched-ext.rst
@@ -321,13 +321,15 @@ by a sched_ext scheduler:
                 ops.dispatch(); /* Task is moved to a local DSQ */
             }
             ops.running();      /* Task starts running on its assigned CPU */
-            while (task->scx.slice > 0 && task is runnable)
-                ops.tick();     /* Called every 1/HZ seconds */
-            ops.stopping();     /* Task stops running (time slice expires or wait) */
 
-            /* Task's CPU becomes available */
+            while task_is_runnable(p) {
+                while (task->scx.slice > 0 && task_is_runnable(p))
+                    ops.tick();     /* Called every 1/HZ seconds */
+
+                ops.dispatch();     /* task->scx.slice can be refilled */
+            }
 
-            ops.dispatch();     /* task->scx.slice can be refilled */
+            ops.stopping();     /* Task stops running (time slice expires or wait) */
         }
 
         ops.quiescent();        /* Task releases its assigned CPU (wait) */


