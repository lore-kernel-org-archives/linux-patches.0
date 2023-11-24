Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CED39FFC;
	Fri, 24 Nov 2023 18:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFYQerc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D056CC433C8;
	Fri, 24 Nov 2023 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849642;
	bh=Nlnr+231Ped/2URce3VuIwX/2VY8IpPUCFryaHYIegA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFYQerc12BYWN/iVEspAe7inb+JK0WHz4v6Po9YYkGcec5sabMd2bUJ75MJViKXid
	 KW1NUQaZikPloNlATOpZNE8sW8RHwHJZWEqw+nzxwnT6juaR0qPOh8fOG/BiW89O5C
	 vWPRJtYoW5xzFx48qc0xxcJVomMy6A6THXfqMiMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <bluca@debian.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 6.6 262/530] sched: psi: fix unprivileged polling against cgroups
Date: Fri, 24 Nov 2023 17:47:08 +0000
Message-ID: <20231124172036.016386054@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Johannes Weiner <hannes@cmpxchg.org>

commit 8b39d20eceeda6c4eb23df1497f9ed2fffdc8f69 upstream.

519fabc7aaba ("psi: remove 500ms min window size limitation for
triggers") breaks unprivileged psi polling on cgroups.

Historically, we had a privilege check for polling in the open() of a
pressure file in /proc, but were erroneously missing it for the open()
of cgroup pressure files.

When unprivileged polling was introduced in d82caa273565 ("sched/psi:
Allow unprivileged polling of N*2s period"), it needed to filter
privileges depending on the exact polling parameters, and as such
moved the CAP_SYS_RESOURCE check from the proc open() callback to
psi_trigger_create(). Both the proc files as well as cgroup files go
through this during write(). This implicitly added the missing check
for privileges required for HT polling for cgroups.

When 519fabc7aaba ("psi: remove 500ms min window size limitation for
triggers") followed right after to remove further restrictions on the
RT polling window, it incorrectly assumed the cgroup privilege check
was still missing and added it to the cgroup open(), mirroring what we
used to do for proc files in the past.

As a result, unprivileged poll requests that would be supported now
get rejected when opening the cgroup pressure file for writing.

Remove the cgroup open() check. psi_trigger_create() handles it.

Fixes: 519fabc7aaba ("psi: remove 500ms min window size limitation for triggers")
Reported-by: Luca Boccassi <bluca@debian.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Luca Boccassi <bluca@debian.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org # 6.5+
Link: https://lore.kernel.org/r/20231026164114.2488682-1-hannes@cmpxchg.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3867,14 +3867,6 @@ static __poll_t cgroup_pressure_poll(str
 	return psi_trigger_poll(&ctx->psi.trigger, of->file, pt);
 }
 
-static int cgroup_pressure_open(struct kernfs_open_file *of)
-{
-	if (of->file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RESOURCE))
-		return -EPERM;
-
-	return 0;
-}
-
 static void cgroup_pressure_release(struct kernfs_open_file *of)
 {
 	struct cgroup_file_ctx *ctx = of->priv;
@@ -5275,7 +5267,6 @@ static struct cftype cgroup_psi_files[]
 	{
 		.name = "io.pressure",
 		.file_offset = offsetof(struct cgroup, psi_files[PSI_IO]),
-		.open = cgroup_pressure_open,
 		.seq_show = cgroup_io_pressure_show,
 		.write = cgroup_io_pressure_write,
 		.poll = cgroup_pressure_poll,
@@ -5284,7 +5275,6 @@ static struct cftype cgroup_psi_files[]
 	{
 		.name = "memory.pressure",
 		.file_offset = offsetof(struct cgroup, psi_files[PSI_MEM]),
-		.open = cgroup_pressure_open,
 		.seq_show = cgroup_memory_pressure_show,
 		.write = cgroup_memory_pressure_write,
 		.poll = cgroup_pressure_poll,
@@ -5293,7 +5283,6 @@ static struct cftype cgroup_psi_files[]
 	{
 		.name = "cpu.pressure",
 		.file_offset = offsetof(struct cgroup, psi_files[PSI_CPU]),
-		.open = cgroup_pressure_open,
 		.seq_show = cgroup_cpu_pressure_show,
 		.write = cgroup_cpu_pressure_write,
 		.poll = cgroup_pressure_poll,
@@ -5303,7 +5292,6 @@ static struct cftype cgroup_psi_files[]
 	{
 		.name = "irq.pressure",
 		.file_offset = offsetof(struct cgroup, psi_files[PSI_IRQ]),
-		.open = cgroup_pressure_open,
 		.seq_show = cgroup_irq_pressure_show,
 		.write = cgroup_irq_pressure_write,
 		.poll = cgroup_pressure_poll,


