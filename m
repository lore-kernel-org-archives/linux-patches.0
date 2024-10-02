Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655221D07BC;
	Wed,  2 Oct 2024 14:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878920; cv=none; b=T/msyUKxmi3DfLKqYGcqPGj9xwC9W+w5sLnKy/JR9r0UCDL22IGE99kGY0085gVx2gN4OP/+xtkn0a3czG3U1UWG5kgEfNkeSdnam6NlOYAgjM+WY2VkS5hGqJZ6z2XRGXujrfGHFPsr5KRayI8OvyqJT4BymmWoTwn0HOzQGqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878920; c=relaxed/simple;
	bh=ZnC0FZdV4D3lhkQ9UGLL+f+2wWnxN16No//GhLXgpZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piInBXyQa/NZCHgnXEHgo3L8esKzMmQVrDpf4imnHFgw1YNDQ8NjDl4sJgMZFvVS/euajwYKfDla5VHK8l0t7Wobzi48bjM7WhEDlAGDa0cBXmt65TvIAo3fmUVHDKLJgsb2O30ppBVhlxTccic8u4NvQ7ozM7fcGV2wWNXpDsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZQHa6Cf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZQHa6Cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE75DC4CEC2;
	Wed,  2 Oct 2024 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878920;
	bh=ZnC0FZdV4D3lhkQ9UGLL+f+2wWnxN16No//GhLXgpZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZQHa6Cf3oVZgH4T7/RRnyhoBAeOh2+sKtDUJfy8fL0oG1VNiunV3v4VhJNZPY1As
	 MKY/sjJujTti2iijGV79jFn1qJEWtMEPD7tzIhUtYiYeD9HrcsQyr7SNFUNs1iuuTZ
	 i9xHD3nLuYNs0/2nmf0/LqQcywBHZUcX5rcF6gn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.10 546/634] perf/x86/intel/pt: Fix sampling synchronization
Date: Wed,  2 Oct 2024 15:00:46 +0200
Message-ID: <20241002125832.660370535@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1606,6 +1606,7 @@ static void pt_event_stop(struct perf_ev
 	 * see comment in intel_pt_interrupt().
 	 */
 	WRITE_ONCE(pt->handle_nmi, 0);
+	barrier();
 
 	pt_config_stop(event);
 
@@ -1657,11 +1658,10 @@ static long pt_event_snapshot_aux(struct
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
 
@@ -1673,11 +1673,10 @@ static long pt_event_snapshot_aux(struct
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


