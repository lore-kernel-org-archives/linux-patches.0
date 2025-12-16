Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5E2450FE;
	Tue, 16 Dec 2025 12:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888715; cv=none; b=Bt3q9M3G18WSPN5a8lCtwOfT+2kAynayaN4EbqLWtlLFrpuikpycyo6AhAXpVcsYpHdtbDQcMnKHcEWHCQmwUrwArU26X9llrDR/XF//uEwXslJrDdkuACb+ggOX1LEYknwrgw3ffBaodcfK2Ts2uIVZjq431roGcibnV2ipGno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888715; c=relaxed/simple;
	bh=+ZZkIIz1logkQvhADNQboLj3DbVD7aHEjjy1MKbFgdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhZoRH4sZTNuM2cCAujQ6YN50PV9RNI2sZMb/6ssvOMbFdhtYmidhDJJqjDKS1sbGPGzXQLVbxUlNzCZ8L8aEijl2yOLXbV47sEk2xct14x5yv7OvAX5GaRND6bvJhj4IN6AWy0JLEPRSaFlAZD4XUWRxqo6S3waEAhY7tpAF+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+nf2GTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+nf2GTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B05C4CEF1;
	Tue, 16 Dec 2025 12:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888715;
	bh=+ZZkIIz1logkQvhADNQboLj3DbVD7aHEjjy1MKbFgdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+nf2GTuxAuHEAfxMGz/sPeTmyjYkgmWPtxAqjRKpZat+VwnWZFUFLmH6f+qd0o1T
	 TMzAFDHa25E5EeIS9Q7UyZAWIn42VFuKPpRyHFygnlOUyGnaMU08HLHQHf+EpRkhN9
	 J8Rs5XX5URmx1ZqBkYxKYIaSrfet4NaJ3HQatTaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kitta <kitta@linux.alibaba.com>,
	Evan Li <evan.li@linux.alibaba.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 600/614] perf/x86/intel: Fix NULL event dereference crash in handle_pmi_common()
Date: Tue, 16 Dec 2025 12:16:07 +0100
Message-ID: <20251216111423.132398654@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Evan Li <evan.li@linux.alibaba.com>

[ Upstream commit 9415f749d34b926b9e4853da1462f4d941f89a0d ]

handle_pmi_common() may observe an active bit set in cpuc->active_mask
while the corresponding cpuc->events[] entry has already been cleared,
which leads to a NULL pointer dereference.

This can happen when interrupt throttling stops all events in a group
while PEBS processing is still in progress. perf_event_overflow() can
trigger perf_event_throttle_group(), which stops the group and clears
the cpuc->events[] entry, but the active bit may still be set when
handle_pmi_common() iterates over the events.

The following recent fix:

  7e772a93eb61 ("perf/x86: Fix NULL event access and potential PEBS record loss")

moved the cpuc->events[] clearing from x86_pmu_stop() to x86_pmu_del() and
relied on cpuc->active_mask/pebs_enabled checks. However,
handle_pmi_common() can still encounter a NULL cpuc->events[] entry
despite the active bit being set.

Add an explicit NULL check on the event pointer before using it,
to cover this legitimate scenario and avoid the NULL dereference crash.

Fixes: 7e772a93eb61 ("perf/x86: Fix NULL event access and potential PEBS record loss")
Reported-by: kitta <kitta@linux.alibaba.com>
Co-developed-by: kitta <kitta@linux.alibaba.com>
Signed-off-by: Evan Li <evan.li@linux.alibaba.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20251212084943.2124787-1-evan.li@linux.alibaba.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220855
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 9b824ed6fc1de..32d551f2646a7 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3249,6 +3249,9 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 
 		if (!test_bit(bit, cpuc->active_mask))
 			continue;
+		/* Event may have already been cleared: */
+		if (!event)
+			continue;
 
 		/*
 		 * There may be unprocessed PEBS records in the PEBS buffer,
-- 
2.51.0



