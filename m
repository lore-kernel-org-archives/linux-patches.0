Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F503EAC83;
	Wed, 20 May 2026 16:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294468; cv=none; b=sKzZM8IBp93Fx7HAsgYf27n8neplaBWSxdNTFEBOrZs8dRZYkUAxA034kn4kdrDVcXvUPIJn4mLLtTbm9A6kpLjiguTNTJeJ4KVgU/+lhD2kQfxcoHUl6G+HlZuyQ21apRHu5RYLSAlt84K9NEKfxJ5BNAgWwFa8pUEo3bEJKWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294468; c=relaxed/simple;
	bh=xnghIO0jLWqZZI9Iv78VymRjMfoG27rLm1uvFq6oBBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jhqp2bAcB59ZI6HT707nXU02Xu+VSXwqBan87qd+woFLdQ6voAbgjLEddLrMnDdPL6Q1qPw5cMV4FF9l6dSeBJN98AWwezFq77HMUXOha76RSHDg7hfEf93JQuEpnldB4izL6r812pxDvti6mtophbCPmLfajjMEQVPSkMsiqOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/cZkAmG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/cZkAmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BFD1F00893;
	Wed, 20 May 2026 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294466;
	bh=ZIVfmAk+yRcji5LkFmC6jEqT59J5Ry5ezw8JRlp6IR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/cZkAmG/sVPjdvSPnsCegr0AvOxHYeHwAGxNqewubltm1T5lMyoNgLRrtZMglxnv
	 POH8Pexj5bqHDozdWlSPJp604VRAYbNI9X3NFlGF30oMFbtK9Lu2lmkok24LAtlpLg
	 QCsJYibx4yZI9Fab62KVAhmao60GaNNprvR7kUWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0051/1146] perf/amd/ibs: Account interrupt for discarded samples
Date: Wed, 20 May 2026 18:05:01 +0200
Message-ID: <20260520162149.528921999@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit 01336b5559785a136de1cac49705f63a70a755bc ]

Add interrupt throttling accounting for below cases:

  o IBS Op PMU: A software filter (in addition to the hardware filter)
    drops samples whose load latency is below the user-specified
    threshold.

  o IBS Fetch PMU: Samples discarded due to the zero-RIP erratum (#1197).

Although these samples are discarded, the NMI cost is still incurred, so
they should be counted for interrupt throttling.

Fixes: 26db2e0c51fe83e1dd852c1321407835b481806e ("perf/x86/amd/ibs: Work around erratum #1197")
Fixes: d20610c19b4a22bc69085b7eb7a02741d51de30e ("perf/amd/ibs: Add support for OP Load Latency Filtering")
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://patch.msgid.link/20260216042216.1440-2-ravi.bangoria@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index aca89f23d2e00..705ef43325be3 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1293,8 +1293,10 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 		 * within [128, 2048] range.
 		 */
 		if (!op_data3.ld_op || !op_data3.dc_miss ||
-		    op_data3.dc_miss_lat <= (event->attr.config1 & 0xFFF))
+		    op_data3.dc_miss_lat <= (event->attr.config1 & 0xFFF)) {
+			throttle = perf_event_account_interrupt(event);
 			goto out;
+		}
 	}
 
 	/*
@@ -1326,8 +1328,10 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 	} else {
 		/* Workaround for erratum #1197 */
-		if (perf_ibs->fetch_ignore_if_zero_rip && !(ibs_data.regs[1]))
+		if (perf_ibs->fetch_ignore_if_zero_rip && !(ibs_data.regs[1])) {
+			throttle = perf_event_account_interrupt(event);
 			goto out;
+		}
 
 		set_linear_ip(&regs, ibs_data.regs[1]);
 		regs.flags |= PERF_EFLAGS_EXACT;
-- 
2.53.0



