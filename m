Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7963B3BE7;
	Thu, 17 Sep 2026 17:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665447; cv=none; b=o0cNdklW99DczmAUTbQFFLyRrV2MCORIUoJtcb34l8WUALxQx7Ep7Y8+Kxy8C9nsPwd05+oprHdVwkmLf8DIx3pEOFIlqXKO/7SLrs0rWvJYyMdqWs9Ph3gpesQfplOWPUI0en3PdmNouv0Os/MT565z5xrC+dkoWjS90aSfA+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665447; c=relaxed/simple;
	bh=VpBlTVutulHVumXLvRBuvzTxPj7vQ0lwxKXH73u40hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4JB8V7flhnoIKJIwf2ZWrOXTim2koyGri1MVvZTDQVPZITZCZWcwFCelh1wFEsnX/tyATkVs5rncKsM4zH++810zHzae6pjjkZCeFPczfZsLB52haAYwMEty7iYuv6K4z+gTMLdzNjEqhGYf45r38z2VaPRwt3I138NkiSkux4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6uEpNzq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6uEpNzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECF01F00893;
	Thu, 17 Sep 2026 17:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665445;
	bh=SLhaJaO6DIYdl/gW2JxgJjLtMj/0ih83rk/Mgbctig8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6uEpNzqR5pmlvypcTZGTxOXiXOsVpKvv/EHODEAC3duEriAACJM6cQ11ZGapozbL
	 AfpH8bsOtS3J1Exc6zzA5mKy8dJIA0kPghD9nTTmcCrmgOjskaRmw2OZimaLZfLMOJ
	 1sQbkpZUqqXsMor4Dz/DQI37yijteigUVe87XziA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamas Petz <tamas.petz@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0708/1250] perf/core: Skip empty AUX records with only format flags
Date: Thu, 17 Sep 2026 16:08:23 +0100
Message-ID: <20260917151611.089177725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 8a7f5b5e860b5c113ca99acd5b1e9074f5c5af3c ]

perf_aux_output_end() emits a PERF_RECORD_AUX when the recorded size is
nonzero or when any flag other than PERF_AUX_FLAG_OVERWRITE is set.

PMU format flags describe how an AUX payload is encoded. TRBE driver
sets PERF_AUX_FLAG_CORESIGHT_FORMAT_RAW for raw trace buffers, causing
an AUX record to be emitted even when no trace data.

This is noticeable when tracing a task with strace. Ptrace stops
repeatedly end empty AUX transactions, producing many zero-sized
PERF_RECORD_AUX records. For example:

  perf record -e cs_etm//u -m,128M -- strace ls

  perf script -D 2>&1 |
     awk '/PERF_RECORD_AUX offset/ {
        for (i = 1; i <= NF; i++)
                if ($i == "size:" && $(i + 1) == "0")
                        count++
     }
     END { print count }'
  165

This recording contains 165 zero-sized AUX records which provide no
useful information to userspace.

Ignore PERF_AUX_FLAG_PMU_FORMAT_TYPE_MASK, together with
PERF_AUX_FLAG_OVERWRITE, when deciding whether an empty AUX record is
useful. Zero-sized records carrying TRUNCATED, PARTIAL or COLLISION
are still emitted.

Fixes: 547b60988e63 ("perf: aux: Add flags for the buffer format")
Reported-by: Tamas Petz <tamas.petz@arm.com>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260825-perf_core_fix_zero_aux_records-v1-1-23b95e8d5df3@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/ring_buffer.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index dc2aa2a7109ef..6d805a7168be6 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -509,7 +509,10 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size)
 	/*
 	 * Only send RECORD_AUX if we have something useful to communicate
 	 *
-	 * Note: the OVERWRITE records by themselves are not considered
+	 * PMU_FORMAT bits identify the PMU type rather than an AUX event
+	 * has occurred, so ignore them for zero-sized records.
+	 *
+	 * The OVERWRITE records by themselves are not considered
 	 * useful, as they don't communicate any *new* information,
 	 * aside from the short-lived offset, that becomes history at
 	 * the next event sched-in and therefore isn't useful.
@@ -518,7 +521,9 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size)
 	 * offset. So, from now on we don't output AUX records that
 	 * have *only* OVERWRITE flag set.
 	 */
-	if (size || (handle->aux_flags & ~(u64)PERF_AUX_FLAG_OVERWRITE))
+	if (size ||
+	    (handle->aux_flags & ~(u64)(PERF_AUX_FLAG_PMU_FORMAT_TYPE_MASK |
+					PERF_AUX_FLAG_OVERWRITE)))
 		perf_event_aux_event(handle->event, aux_head, size,
 				     handle->aux_flags);
 
-- 
2.53.0



