Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865C2414A1C;
	Tue, 21 Jul 2026 21:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670564; cv=none; b=giYm+HPTfyv2szwV62PZPHg5nVgo5UDn0pMs2ue5cIunH19ZGoR38du4FST6LK4L5UMbhQ9SYWEdTbM4Lewi4+rHhoLG9SMEYLfKlknMwSyPjB03MWg8361Drd/esjiD/vRbz5fwDdgXFBH828r/x3chFvep/QCbS2p6Cq8NP0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670564; c=relaxed/simple;
	bh=p5Rz6Zi7ruAgAvs1xsezZzz9P2Kw3SypnM4HJZKQxdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5IhgYr1gJmspQytOfF7DrqRR1JeFTpyLNIWstO/RC2vPDfkT7qhReHt7AZ9pf8Rkg1EAd+AgWaKo8sdarF/xuVBwCfz+mV2tnwdabf2A0OzvYCdaBtzyr1jOHiHBoyDvzb3h42x1PVsqMqUNBYE2ddlEXQQl0WHgH/JughhH40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00+2TAk2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00+2TAk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9361F000E9;
	Tue, 21 Jul 2026 21:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670563;
	bh=4/HylmvvTKZ1BxJwAtJLcaBQrOg61ooZ3j+0Lt2PDMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00+2TAk22UtYAQQurG3eD1yfaOVcOonj6JN+RNwj15UhHdSLA908VY85w2j9GhpTe
	 hX6RtbNZ2818XhAfbpVTriQ4V7yaStM988PUBMTnEl7YoP5aKeocdAiy0iYMgIbsY8
	 oFXjh0b4ZnxwbS1sM5egURbN4nYZ/pHb9J0YLzPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@google.com>
Subject: [PATCH 6.1 0938/1067] perf/x86/amd/brs: Fix kernel address leakage
Date: Tue, 21 Jul 2026 17:25:39 +0200
Message-ID: <20260721152445.515585978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

commit 47915e855fb38b42133e31ba917d99565f862154 upstream.

A user-only branch stack can contain branches that originate from
the kernel. As a result, kernel addresses are exposed to user space
even when PERF_SAMPLE_BRANCH_USER is requested. On AMD processors
supporting X86_FEATURE_BRS (Zen 3 only), perf can still report entries
such as SYSRET/interrupt returns for which the branch-from addresses
are in the kernel.

E.g.

  $ perf record -j any,u -c 4000 -e branch-brs -o - -- \
        perf bench syscall basic --loop 1000 | \
        perf script -i - -F brstack|tr ' ' '\n'| \
        grep -E '0x[89a-f][0-9a-f]{15}'

  ...
  0xffffffff810001c4/0x72e2e32955eb/-/-/-/0//-
  0xffffffff810001c4/0x72e2d94a9821/-/-/-/0//-
  0xffffffff810001c4/0x72e2d94ffa1b/-/-/-/0//-
  ...

BRS provides no hardware branch filtering, so privilege level
filtering is performed entirely in software. However, amd_brs_match_plm()
only validates the branch-to address against the requested privilege
levels. For branches from the kernel to user space, the branch-from
address is left unchecked and is leaked. Extend the software filter to
also validate the branch-from address, so that any branch record whose
branch-from address is in the kernel is dropped when
PERF_SAMPLE_BRANCH_USER is requested.

Fixes: 8910075d61a3 ("perf/x86/amd: Enable branch sampling priv level filtering")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://patch.msgid.link/f05931c4f89a146c364bd5dc6b8170b1ac611c65.1783701239.git.sandipan.das@amd.com
Closes: https://lore.kernel.org/all/20260710110235.F3FD81F000E9@smtp.kernel.org/
[sandipan: backport to linux-6.1.y]
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/amd/brs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/events/amd/brs.c
+++ b/arch/x86/events/amd/brs.c
@@ -262,13 +262,13 @@ void amd_brs_disable_all(void)
 		amd_brs_disable();
 }
 
-static bool amd_brs_match_plm(struct perf_event *event, u64 to)
+static bool amd_brs_match_plm(struct perf_event *event, u64 from, u64 to)
 {
 	int type = event->attr.branch_sample_type;
 	int plm_k = PERF_SAMPLE_BRANCH_KERNEL | PERF_SAMPLE_BRANCH_HV;
 	int plm_u = PERF_SAMPLE_BRANCH_USER;
 
-	if (!(type & plm_k) && kernel_ip(to))
+	if (!(type & plm_k) && (kernel_ip(to) || kernel_ip(from)))
 		return 0;
 
 	if (!(type & plm_u) && !kernel_ip(to))
@@ -341,11 +341,11 @@ void amd_brs_drain(void)
 		 */
 		to = (u64)(((s64)to << shift) >> shift);
 
-		if (!amd_brs_match_plm(event, to))
-			continue;
-
 		rdmsrl(brs_from(brs_idx), from);
 
+		if (!amd_brs_match_plm(event, from, to))
+			continue;
+
 		perf_clear_branch_entry_bitfields(br+nr);
 
 		br[nr].from = from;


