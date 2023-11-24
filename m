Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642782EAEA;
	Fri, 24 Nov 2023 18:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKh8bPdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB904C433C7;
	Fri, 24 Nov 2023 18:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850995;
	bh=5+4QT7N7GLummeBKlMooruYIbS2pxepfuZ/3J6Zo9AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKh8bPdPKwluCnxDPVFiKsnr1175qYEyjgvryyMDNZCaeDP6Qoa29GC5OBnrW2GcK
	 XRIDDLsp4CI/fBRz8ph9XnI9eZvQ+67b773J6p1dq0xBR1EKp5h3fsa1JuEAijFNW+
	 /HfrJsYsDxhCcyuZzYWR9I2CCox+OuittafnrP1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <bluca@debian.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 6.5 247/491] sched: psi: fix unprivileged polling against cgroups
Date: Fri, 24 Nov 2023 17:48:03 +0000
Message-ID: <20231124172031.980875640@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3836,14 +3836,6 @@ static __poll_t cgroup_pressure_poll(str
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
@@ -5243,7 +5235,6 @@ static struct cftype cgroup_psi_files[]
 	{
 		.name = "io.pressure",
 		.file_offset = offsetof(struct cgroup, psi_files[PSI_IO]),
-		.open = cgroup_pressure_open,
 		.seq_show = cgroup_io_pressure_show,
 		.write = cgroup_io_pressure_write,
 		.poll = cgroup_pressure_poll,
@@ -5252,7 +5243,6 @@ static struct cftype cgroup_psi_files[]
 	{
 		.name = "memory.pressure",
 		.file_offset = offsetof(struct cgroup, psi_files[PSI_MEM]),
-		.open = cgroup_pressure_open,
 		.seq_show = cgroup_memory_pressure_show,
 		.write = cgroup_memory_pressure_write,
 		.poll = cgroup_pressure_poll,
@@ -5261,7 +5251,6 @@ static struct cftype cgroup_psi_files[]
 	{
 		.name = "cpu.pressure",
 		.file_offset = offsetof(struct cgroup, psi_files[PSI_CPU]),
-		.open = cgroup_pressure_open,
 		.seq_show = cgroup_cpu_pressure_show,
 		.write = cgroup_cpu_pressure_write,
 		.poll = cgroup_pressure_poll,
@@ -5271,7 +5260,6 @@ static struct cftype cgroup_psi_files[]
 	{
 		.name = "irq.pressure",
 		.file_offset = offsetof(struct cgroup, psi_files[PSI_IRQ]),
-		.open = cgroup_pressure_open,
 		.seq_show = cgroup_irq_pressure_show,
 		.write = cgroup_irq_pressure_write,
 		.poll = cgroup_pressure_poll,


