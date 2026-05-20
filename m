Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95C83F2115;
	Wed, 20 May 2026 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294475; cv=none; b=kpFZtD6vAMpxCfl1D0XpVAgnpW199J5lpzKTOAXUHBo9OQKYbvzoouPZxqHxq3yxmgRa/eNdOuo2qgEZudjDt7slb3dne+Yn8pz70kdSfvIp8GAuV6wV9l5UJtxS9mWSP2qqkVgE2y+wkQc6eb9lI/OHKyH+QVMHMLnpO+LWTPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294475; c=relaxed/simple;
	bh=134dxTFODI+rmzVtUNCAn2WE84IJqQPkOjBUzZL91WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzxOrTojMnGkDv69L4Ft5VEt1/fAfCXZRYvvPbSkGaSTShyOMxIsDGhsD6wy6ZqWLy1ZwDgZMVTbBC7LF1JLi0aPFSVh3XqGdsX2q9Xh28Bh/kryY3y/9f77sAwEx9TH8QOrp8wyWD9EsKsl6iJhnjw1Zd0A4Fjv8juX5POF85Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VuIQr+qw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VuIQr+qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B2E1F00893;
	Wed, 20 May 2026 16:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294471;
	bh=YHxmJWVKtPikMlOdiT/EorBKJQBf2s3JiLlOjkvXi8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VuIQr+qwFlvOI6h/lOQp1KJVo+KphrzYY6nqnADtfTM7NkZR6EmoDrZ86ZZ4xJp5H
	 f7B4o/NCJJRpBM0gb2IqKaQmZxG8nRqwad4dkeSl4a+zG4K6GNJr6e3Jz8XRZ+jGR/
	 jPOUnsetzXmnKJKW2ThqxQNpH35jW343Fwg+m5eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sadasivan Shaiju <sadasivan.shaiju2@amd.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0053/1146] perf/amd/ibs: Avoid calling perf_allow_kernel() from the IBS NMI handler
Date: Wed, 20 May 2026 18:05:03 +0200
Message-ID: <20260520162149.572076201@linuxfoundation.org>
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

[ Upstream commit b0a09142622a994c4f4088c3f61db5da87cfc711 ]

Calling perf_allow_kernel() from the NMI context is unsafe and could be
fatal. Capture the permission at event-initialization time by storing it
in event->hw.flags, and have the NMI handler rely on that cached flag
instead of making the call directly.

Fixes: 50a53b60e141d ("perf/amd/ibs: Prevent leaking sensitive data to userspace")
Reported-by: Sadasivan Shaiju <sadasivan.shaiju2@amd.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://patch.msgid.link/20260216042216.1440-5-ravi.bangoria@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c          | 5 ++++-
 arch/x86/events/perf_event_flags.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index ddd74eff3faef..7b8eea1d75c10 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -313,6 +313,9 @@ static int perf_ibs_init(struct perf_event *event)
 	if (ret)
 		return ret;
 
+	if (perf_allow_kernel())
+		hwc->flags |= PERF_X86_EVENT_UNPRIVILEGED;
+
 	if (hwc->sample_period) {
 		if (config & perf_ibs->cnt_mask)
 			/* raw max_cnt may not be set */
@@ -1346,7 +1349,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	 * unprivileged users.
 	 */
 	if ((event->attr.sample_type & PERF_SAMPLE_RAW) &&
-	    perf_allow_kernel()) {
+	    (hwc->flags & PERF_X86_EVENT_UNPRIVILEGED)) {
 		perf_ibs_phyaddr_clear(perf_ibs, &ibs_data);
 	}
 
diff --git a/arch/x86/events/perf_event_flags.h b/arch/x86/events/perf_event_flags.h
index 70078334e4a33..47f84ee8f5409 100644
--- a/arch/x86/events/perf_event_flags.h
+++ b/arch/x86/events/perf_event_flags.h
@@ -23,3 +23,4 @@ PERF_ARCH(PEBS_LAT_HYBRID,	0x0020000) /* ld and st lat for hybrid */
 PERF_ARCH(NEEDS_BRANCH_STACK,	0x0040000) /* require branch stack setup */
 PERF_ARCH(BRANCH_COUNTERS,	0x0080000) /* logs the counters in the extra space of each branch */
 PERF_ARCH(ACR,			0x0100000) /* Auto counter reload */
+PERF_ARCH(UNPRIVILEGED,		0x0200000) /* Unprivileged event (wrt perf_allow_kernel()) */
-- 
2.53.0



