Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE916285043;
	Tue, 12 Aug 2025 19:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025765; cv=none; b=Im/m3WoF6ZwwlSvQ74CFyZKuuUAb3uI7TroHWEXSy0emVy8d+V7IDtF8s08G3WfRy+4EFl1Q2nv4ie0LfpYBmrV00+AyUtl5ASqhz2Z2iLWYLMdpthiWxna0PtjP9ddQDq5OJmRx8iC+9zkYqcjsfH5Fhc7/GiAsORBIRfNz96k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025765; c=relaxed/simple;
	bh=tA/DcjRvrwChYhsW9GYrNuvVoztch5kiyo/GCRJM/ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/jSFx9z8uuXK2l/Mot8XLgZSqul8kwt9erouln9egSDvNbJbBH+1YyBGCjnaQDgv+lInVDi0oKaOp7TOOo1arkZ1esMbxY3MBtTLvt2X7KLHblk0acXsyjEeJU6+xYMmZjfiHzJMH0WiT1Rek7a87+h93MslOfwo+wJQBy2DoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZC07U49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZC07U49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9D8C4CEF0;
	Tue, 12 Aug 2025 19:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025765;
	bh=tA/DcjRvrwChYhsW9GYrNuvVoztch5kiyo/GCRJM/ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZC07U49+er/Lx8jZmsG9q3iFfQen8IW3WM9ILuvZCKYBWZ5gqgM/ZN4+ri2qSSKO
	 YfK/O4IdUSrNW3B6KH/0olAunNgN2jRwqBKBHiyHZqoP3RanqaND5/QHcRH7gotYzU
	 k8YxpUbEtm6SrZjr4HCY8Wc2N8ksCybMJE8vYkug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Sadovnikov <a.sadovnikov@ispras.ru>,
	"Neeraj Upadhyay (AMD)" <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 137/480] refscale: Check that nreaders and loops multiplication doesnt overflow
Date: Tue, 12 Aug 2025 19:45:45 +0200
Message-ID: <20250812174403.177806557@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Sadovnikov <a.sadovnikov@ispras.ru>

[ Upstream commit 005b6187705bc9723518ce19c5cb911fc1f7ef07 ]

The nreaders and loops variables are exposed as module parameters, which,
in certain combinations, can lead to multiplication overflow.

Besides, loops parameter is defined as long, while through the code is
used as int, which can cause truncation on 64-bit kernels and possible
zeroes where they shouldn't appear.

Since code uses result of multiplication as int anyway, it only makes sense
to replace loops with int. Multiplication overflow check is also added
due to possible multiplication between two very big numbers.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 653ed64b01dc ("refperf: Add a test to measure performance of read-side synchronization")
Signed-off-by: Artem Sadovnikov <a.sadovnikov@ispras.ru>
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.upadhyay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/refscale.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/refscale.c b/kernel/rcu/refscale.c
index f11a7c2af778..ab7fcdc94cc0 100644
--- a/kernel/rcu/refscale.c
+++ b/kernel/rcu/refscale.c
@@ -85,7 +85,7 @@ torture_param(int, holdoff, IS_BUILTIN(CONFIG_RCU_REF_SCALE_TEST) ? 10 : 0,
 // Number of typesafe_lookup structures, that is, the degree of concurrency.
 torture_param(long, lookup_instances, 0, "Number of typesafe_lookup structures.");
 // Number of loops per experiment, all readers execute operations concurrently.
-torture_param(long, loops, 10000, "Number of loops per experiment.");
+torture_param(int, loops, 10000, "Number of loops per experiment.");
 // Number of readers, with -1 defaulting to about 75% of the CPUs.
 torture_param(int, nreaders, -1, "Number of readers, -1 for 75% of CPUs.");
 // Number of runs.
@@ -1140,7 +1140,7 @@ static void
 ref_scale_print_module_parms(const struct ref_scale_ops *cur_ops, const char *tag)
 {
 	pr_alert("%s" SCALE_FLAG
-		 "--- %s:  verbose=%d verbose_batched=%d shutdown=%d holdoff=%d lookup_instances=%ld loops=%ld nreaders=%d nruns=%d readdelay=%d\n", scale_type, tag,
+		 "--- %s:  verbose=%d verbose_batched=%d shutdown=%d holdoff=%d lookup_instances=%ld loops=%d nreaders=%d nruns=%d readdelay=%d\n", scale_type, tag,
 		 verbose, verbose_batched, shutdown, holdoff, lookup_instances, loops, nreaders, nruns, readdelay);
 }
 
@@ -1238,12 +1238,16 @@ ref_scale_init(void)
 	// Reader tasks (default to ~75% of online CPUs).
 	if (nreaders < 0)
 		nreaders = (num_online_cpus() >> 1) + (num_online_cpus() >> 2);
-	if (WARN_ONCE(loops <= 0, "%s: loops = %ld, adjusted to 1\n", __func__, loops))
+	if (WARN_ONCE(loops <= 0, "%s: loops = %d, adjusted to 1\n", __func__, loops))
 		loops = 1;
 	if (WARN_ONCE(nreaders <= 0, "%s: nreaders = %d, adjusted to 1\n", __func__, nreaders))
 		nreaders = 1;
 	if (WARN_ONCE(nruns <= 0, "%s: nruns = %d, adjusted to 1\n", __func__, nruns))
 		nruns = 1;
+	if (WARN_ONCE(loops > INT_MAX / nreaders,
+		      "%s: nreaders * loops will overflow, adjusted loops to %d",
+		      __func__, INT_MAX / nreaders))
+		loops = INT_MAX / nreaders;
 	reader_tasks = kcalloc(nreaders, sizeof(reader_tasks[0]),
 			       GFP_KERNEL);
 	if (!reader_tasks) {
-- 
2.39.5



