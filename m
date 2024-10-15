Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186AC1AF0B1;
	Tue, 15 Oct 2024 13:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997712; cv=none; b=rZghQC/61Ty6iadtU1xOLBXcv/W7iQ6JCoRIL9sX35jr/tvx2a4kftE/LyHQXbvvvnyWHkfXL97d58q6un7NJfaD3radF9rOXjL25CcASsJ5NsEkOzb91GAdjrZTtbkyYxb+HMm3qP1GF8uRiJipm8kelMi9gYVPec3YNkSeJrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997712; c=relaxed/simple;
	bh=Wv2b1rwKVwowNJfF8LveIrf4IcV8I41mR1op2ZW/MeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J11rJqI4ROoL9bK54J78JS8IEDEbhAdv8Pb9F3y+fccr7/pk7b46aAISSOZPXdaC/XSPf9guCjNF/Bq4vD/Bb++MiyE+yUi00qkoMSn+P0OlH/p8CVtnB8N6fKPN70wyID4e7ybbZqKUShwPsiRxAJ/I+V+mxf4L2ZhBqQNLBDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7eIhZ/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7eIhZ/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762EDC4CEC6;
	Tue, 15 Oct 2024 13:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997711;
	bh=Wv2b1rwKVwowNJfF8LveIrf4IcV8I41mR1op2ZW/MeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7eIhZ/FfEDYxOm0nAYFrySh7RqFNChkmXAVcjLvhHAw3xHeGBpBMJjud85y4nMhI
	 UMhPiNSCdnGnUtdidXiyC79qRJ2s9lSp+Dv7TGbuqJdSUTwNqvLKZlCvtTIN9LZ9JB
	 uQtXfqM9bVQQjKEz5dRPCMnd78Qp9QbKf4Up+xk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 236/518] perf/x86/intel/pt: Fix sampling synchronization
Date: Tue, 15 Oct 2024 14:42:20 +0200
Message-ID: <20241015123926.102344718@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit d92792a4b26e50b96ab734cbe203d8a4c932a7a9 upstream.

pt_event_snapshot_aux() uses pt->handle_nmi to determine if tracing
needs to be stopped, however tracing can still be going because
pt->handle_nmi is set to zero before tracing is stopped in pt_event_stop,
whereas pt_event_snapshot_aux() requires that tracing must be stopped in
order to copy a sample of trace from the buffer.

Instead call pt_config_stop() always, which anyway checks config for
RTIT_CTL_TRACEEN and does nothing if it is already clear.

Note pt_event_snapshot_aux() can continue to use pt->handle_nmi to
determine if the trace needs to be restarted afterwards.

Fixes: 25e8920b301c ("perf/x86/intel/pt: Add sampling support")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20240715160712.127117-2-adrian.hunter@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1586,6 +1586,7 @@ static void pt_event_stop(struct perf_ev
 	 * see comment in intel_pt_interrupt().
 	 */
 	WRITE_ONCE(pt->handle_nmi, 0);
+	barrier();
 
 	pt_config_stop(event);
 
@@ -1637,11 +1638,10 @@ static long pt_event_snapshot_aux(struct
 		return 0;
 
 	/*
-	 * Here, handle_nmi tells us if the tracing is on
+	 * There is no PT interrupt in this mode, so stop the trace and it will
+	 * remain stopped while the buffer is copied.
 	 */
-	if (READ_ONCE(pt->handle_nmi))
-		pt_config_stop(event);
-
+	pt_config_stop(event);
 	pt_read_offset(buf);
 	pt_update_head(pt);
 
@@ -1653,11 +1653,10 @@ static long pt_event_snapshot_aux(struct
 	ret = perf_output_copy_aux(&pt->handle, handle, from, to);
 
 	/*
-	 * If the tracing was on when we turned up, restart it.
-	 * Compiler barrier not needed as we couldn't have been
-	 * preempted by anything that touches pt->handle_nmi.
+	 * Here, handle_nmi tells us if the tracing was on.
+	 * If the tracing was on, restart it.
 	 */
-	if (pt->handle_nmi)
+	if (READ_ONCE(pt->handle_nmi))
 		pt_config_start(event);
 
 	return ret;


