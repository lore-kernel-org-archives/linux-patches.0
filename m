Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86F5222D58;
	Thu, 12 Dec 2024 15:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018092; cv=none; b=FvNaXmAUyQyMw3UsEhZMHbQV6TJOMmsMfuCYA92bUIy1Tw/rJdsVCBo8n0TrOsgqw3wGjDo/3QO1KSD7O1pNudkCFSYj3zgfyAAGY5FAHrPnfQ3gy18/oKSVUlnu6vAdQkdeiK1v69iftf94k/BmjzPOWnqBGdXaqsFH78jNMGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018092; c=relaxed/simple;
	bh=7Jd3WHBPl6ENSNdPtTyDOXWvepStNCW1Wrr2AkwrIYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibENIM4/gqJUwBaaAAFNsIs9IoaIuOphpAEMNjniHnzUF82T7H/4tuCAKZNsN0zyNEZPJsj2Hli+OyRzPvTazw++JiE+nzVHPGRd/IhCqhi+ETd/Dvl9ju1kRK/TZA7D8Rj2rw3mYVNxfSeKjC8YJpmmeSsRcvvHLcpOgCyfsZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDKABozu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDKABozu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24259C4CECE;
	Thu, 12 Dec 2024 15:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018092;
	bh=7Jd3WHBPl6ENSNdPtTyDOXWvepStNCW1Wrr2AkwrIYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDKABozuAAQL9uoyOppYBc3fSxgvYYyi9lyrWaEOhe3ATIHvXmTIbkglGS489Y35S
	 IDijKWPo4k6HHsaas7ZFN8HN1pGDe+3LFLDb4IrOJ5Vn/yRbDIxY5cjHu3TLrRBbTJ
	 z6TBU1+B6D43Vcd59JqAwoy/0A1HcmzRLjxyr/JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Radu Rendec <rrendec@redhat.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Andreas Herrmann <aherrmann@suse.de>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.6 165/356] cacheinfo: Allocate memory during CPU hotplug if not done from the primary CPU
Date: Thu, 12 Dec 2024 15:58:04 +0100
Message-ID: <20241212144251.153547478@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

commit b3fce429a1e030b50c1c91351d69b8667eef627b upstream.

Commit

  5944ce092b97 ("arch_topology: Build cacheinfo from primary CPU")

adds functionality that architectures can use to optionally allocate and
build cacheinfo early during boot. Commit

  6539cffa9495 ("cacheinfo: Add arch specific early level initializer")

lets secondary CPUs correct (and reallocate memory) cacheinfo data if
needed.

If the early build functionality is not used and cacheinfo does not need
correction, memory for cacheinfo is never allocated. x86 does not use
the early build functionality. Consequently, during the cacheinfo CPU
hotplug callback, last_level_cache_is_valid() attempts to dereference
a NULL pointer:

  BUG: kernel NULL pointer dereference, address: 0000000000000100
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEPMT SMP NOPTI
  CPU: 0 PID 19 Comm: cpuhp/0 Not tainted 6.4.0-rc2 #1
  RIP: 0010: last_level_cache_is_valid+0x95/0xe0a

Allocate memory for cacheinfo during the cacheinfo CPU hotplug callback
if not done earlier.

Moreover, before determining the validity of the last-level cache info,
ensure that it has been allocated. Simply checking for non-zero
cache_leaves() is not sufficient, as some architectures (e.g., Intel
processors) have non-zero cache_leaves() before allocation.

Dereferencing NULL cacheinfo can occur in update_per_cpu_data_slice_size().
This function iterates over all online CPUs. However, a CPU may have come
online recently, but its cacheinfo may not have been allocated yet.

While here, remove an unnecessary indentation in allocate_cache_info().

  [ bp: Massage. ]

Fixes: 6539cffa9495 ("cacheinfo: Add arch specific early level initializer")
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Radu Rendec <rrendec@redhat.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: stable@vger.kernel.org # 6.3+
Link: https://lore.kernel.org/r/20241128002247.26726-2-ricardo.neri-calderon@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/cacheinfo.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -58,7 +58,7 @@ bool last_level_cache_is_valid(unsigned
 {
 	struct cacheinfo *llc;
 
-	if (!cache_leaves(cpu))
+	if (!cache_leaves(cpu) || !per_cpu_cacheinfo(cpu))
 		return false;
 
 	llc = per_cpu_cacheinfo_idx(cpu, cache_leaves(cpu) - 1);
@@ -478,11 +478,9 @@ int __weak populate_cache_leaves(unsigne
 	return -ENOENT;
 }
 
-static inline
-int allocate_cache_info(int cpu)
+static inline int allocate_cache_info(int cpu)
 {
-	per_cpu_cacheinfo(cpu) = kcalloc(cache_leaves(cpu),
-					 sizeof(struct cacheinfo), GFP_ATOMIC);
+	per_cpu_cacheinfo(cpu) = kcalloc(cache_leaves(cpu), sizeof(struct cacheinfo), GFP_ATOMIC);
 	if (!per_cpu_cacheinfo(cpu)) {
 		cache_leaves(cpu) = 0;
 		return -ENOMEM;
@@ -554,7 +552,11 @@ static inline int init_level_allocate_ci
 	 */
 	ci_cacheinfo(cpu)->early_ci_levels = false;
 
-	if (cache_leaves(cpu) <= early_leaves)
+	/*
+	 * Some architectures (e.g., x86) do not use early initialization.
+	 * Allocate memory now in such case.
+	 */
+	if (cache_leaves(cpu) <= early_leaves && per_cpu_cacheinfo(cpu))
 		return 0;
 
 	kfree(per_cpu_cacheinfo(cpu));


