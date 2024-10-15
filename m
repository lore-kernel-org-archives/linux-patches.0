Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCADB1D0492;
	Tue, 15 Oct 2024 11:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993178; cv=none; b=RtWf8mWq894347hAi/NI5SCvUqUOI7eCsv6N3B27qJK6f0+VF0zqVaCrEyAH2rqk98GJkGzVt6aN5RCpVSq99STox85K5uxcsEUzn1JkbPvDmHOWNNRUh+lKD/GTGqMV02KiVN70jdliz+CIyqinc34MWIOJde81U1tyI9o3fBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993178; c=relaxed/simple;
	bh=ON18hNAHUfmsHnnhQ5CQe9S6DbsQHM+0rV5n0DzjZTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpLa6mUhPCC7goD8TzjvnjQpbAs/a5a7BoojK0lyX5SyqJF/MQ5+ZJw+177J+b2pYhu0H3SDMAG8Dmc2aMkNozyDIK0E6U3ADWidYwb0akbyMbKuYkdjsEKftqjfYqvKp1i33/hu2DrVYmxZDAGRFj+X8SsYi4D5jnprtVAAMHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZJoTOt3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZJoTOt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD94C4CEC6;
	Tue, 15 Oct 2024 11:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993178;
	bh=ON18hNAHUfmsHnnhQ5CQe9S6DbsQHM+0rV5n0DzjZTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZJoTOt3Z5b+scmLq6F0ce1MhqRkqSB0Iz8/Vpk8NFmm3Z2mCztIHHhgsTX8WTKf7
	 eVwBDEE6Pc1YltVvoTJjEvcn7M3sEMuL1VbitZetA/nXnBwAsK+Lcm0fZ3EJX0CBcR
	 bntGMxa+Fis1paqkEunEdLK3rlbzta+j3p7+ZZaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 334/691] perf/x86/intel/pt: Fix sampling synchronization
Date: Tue, 15 Oct 2024 13:24:42 +0200
Message-ID: <20241015112453.590731450@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


