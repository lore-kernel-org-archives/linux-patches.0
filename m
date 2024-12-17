Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59081F76A1;
	Tue, 17 Dec 2024 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455978; cv=none; b=GGyQTRBmjMEY2wlqPoIU7osH5XYYuM772euQP7YhmUDKfEe/vmEEHfYUvH9WkSOCz/rUwJgknsha88zRSA0arokQKPEpZsQflrol09z45rY9Cnv2B0nlo/esji94P33QQL6+2zdSiVOBIHTSJI/NxRCeGpF5pv66nlMuXxAJorg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455978; c=relaxed/simple;
	bh=z/a7oUjGp29zSvPvZTFrVkVKlkfCD1mlv2ai4gsmbZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljl3ujCcehsjydcXlEE9fLs7u2IU5o2pWg29RTG7g1nzOk40RXPfZlJfmuMQL5kUCTBMG3swbnO7JU/d2BDg5B58KPP8Nuott4d7vX2XOTmJx4BWPYRx3sBDA0wUOH+BOx4pFiHbDOCvtRsM44T0666KylzCjmr8lfCOGJvw3Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxITcIbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxITcIbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5FFC4CED3;
	Tue, 17 Dec 2024 17:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455978;
	bh=z/a7oUjGp29zSvPvZTFrVkVKlkfCD1mlv2ai4gsmbZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxITcIbviOAvMWWPaY8DQz/7Ovig7RuAvltiL+VE3YDJmzTy95M2D9KmFMySMSoGX
	 RnT7PSRjlh2pBJ3Iq1fZ4lwLBd8pirOgFvIBvjKFxBaSCkH8PrdaR8Nq/+7dptSN+f
	 EX69b8W4AVaKwJrbPouxFd7edwLbt5vzaCec19ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 002/109] perf/x86/intel/ds: Unconditionally drain PEBS DS when changing PEBS_DATA_CFG
Date: Tue, 17 Dec 2024 18:06:46 +0100
Message-ID: <20241217170533.434662788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

commit 9f3de72a0c37005f897d69e4bdd59c25b8898447 upstream.

The PEBS kernel warnings can still be observed with the below case.

when the below commands are running in parallel for a while.

  while true;
  do
	perf record --no-buildid -a --intr-regs=AX  \
		    -e cpu/event=0xd0,umask=0x81/pp \
		    -c 10003 -o /dev/null ./triad;
  done &

  while true;
  do
	perf record -e 'cpu/mem-loads,ldlat=3/uP' -W -d -- ./dtlb
  done

The commit b752ea0c28e3 ("perf/x86/intel/ds: Flush PEBS DS when changing
PEBS_DATA_CFG") intends to flush the entire PEBS buffer before the
hardware is reprogrammed. However, it fails in the above case.

The first perf command utilizes the large PEBS, while the second perf
command only utilizes a single PEBS. When the second perf event is
added, only the n_pebs++. The intel_pmu_pebs_enable() is invoked after
intel_pmu_pebs_add(). So the cpuc->n_pebs == cpuc->n_large_pebs check in
the intel_pmu_drain_large_pebs() fails. The PEBS DS is not flushed.
The new PEBS event should not be taken into account when flushing the
existing PEBS DS.

The check is unnecessary here. Before the hardware is reprogrammed, all
the stale records must be drained unconditionally.

For single PEBS or PEBS-vi-pt, the DS must be empty. The drain_pebs()
can handle the empty case. There is no harm to unconditionally drain the
PEBS DS.

Fixes: b752ea0c28e3 ("perf/x86/intel/ds: Flush PEBS DS when changing PEBS_DATA_CFG")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241119135504.1463839-2-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1354,7 +1354,7 @@ void intel_pmu_pebs_enable(struct perf_e
 			 * hence we need to drain when changing said
 			 * size.
 			 */
-			intel_pmu_drain_large_pebs(cpuc);
+			intel_pmu_drain_pebs_buffer();
 			adaptive_pebs_record_size_update();
 			wrmsrl(MSR_PEBS_DATA_CFG, pebs_data_cfg);
 			cpuc->active_pebs_data_cfg = pebs_data_cfg;


