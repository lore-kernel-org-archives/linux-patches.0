Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D021F8AD4;
	Tue, 17 Dec 2024 17:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456297; cv=none; b=ZXZIyeDCnMowULOO5zrm+eTTpAFyC3cG/vpZpNBmSmk6qfOhWKsyjRVScUaVzR3833fmD3g/Y1VWAG5hplVH2l6Sqb53SWTdm0MZS87QkdI3+WIEFyDZ17t5ZTesoKUHFaQKp04/7rRmxKtUfgZwdzwFVfK+YuuHjA09SaNwzVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456297; c=relaxed/simple;
	bh=HOs/6hjSb0jtFT7uYPQIBoNHQ6kSQERTm39zckzoIiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCTVBCUFpdu4NhGMsmarlDUwDZrpmlXF6qS+8heX9f9ICIodM4aRf8tZ1kq9J+++f0kjVHJoW2kuo2u5pfcVsTiv24QH3dDA2cNs4AKpUiU9PxqeVjf85V0PIJC9jc4VOqft/ztjdvQbjv0N5GhEkCw4Rr+FplhS8dkzqVJ9Eaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXQL+deg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXQL+deg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC0EC4CED7;
	Tue, 17 Dec 2024 17:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456297;
	bh=HOs/6hjSb0jtFT7uYPQIBoNHQ6kSQERTm39zckzoIiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXQL+deg0pCiZuspTMSXW0Bp7evfkbHW2eCg0AfM5R7kUQ/YfNpO7emn25whzEHQd
	 yh/O7cWrC9tvGIeHZmioqpJogkbb8Kzxhc4jX2pSPy1m4Zeq0xstm49pw9/PRGDUgr
	 Afbp/hc+/7pXpRytmAno80iQw41yXz0O9VAjF17g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.12 005/172] perf/x86/intel/ds: Unconditionally drain PEBS DS when changing PEBS_DATA_CFG
Date: Tue, 17 Dec 2024 18:06:01 +0100
Message-ID: <20241217170546.453701016@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1468,7 +1468,7 @@ void intel_pmu_pebs_enable(struct perf_e
 			 * hence we need to drain when changing said
 			 * size.
 			 */
-			intel_pmu_drain_large_pebs(cpuc);
+			intel_pmu_drain_pebs_buffer();
 			adaptive_pebs_record_size_update();
 			wrmsrl(MSR_PEBS_DATA_CFG, pebs_data_cfg);
 			cpuc->active_pebs_data_cfg = pebs_data_cfg;


