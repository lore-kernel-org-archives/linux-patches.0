Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8BA1D0438;
	Wed,  2 Oct 2024 14:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880416; cv=none; b=ZDg10zJCss9/brPGdoNdkO8Ihpbmz1GJYqm4UCFu2/4q2wdvwXWTh/BReD1ILB1/NZKceehjIpbVm97i259hXef0ar+27C3SSVBMOgl9JepRfPRJ/6vu7bGToTLp7dlbbqyBFc5tcJU8HY6VTtOiDCeWV88Us7ozoFCJhtal7YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880416; c=relaxed/simple;
	bh=MCtMhi/DWxFrGB5vWb2C8bIiG4sxKzeip+R2wrnXD6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyQ9JEGmpmO6rfMEnE48HWGoKEn1mc/enOrC3Sc+QrREKlg2Z378cEq1+CxO6OgJjBT3Z8o7sW6YGeN6c6GVTR5wtGRZ8QXdmvmOLd9dsukag7Q6x7i9DXBboV6kniMK+j1hCJYTlEEtOPSnio9IfOdQ2i+m4QzfZg3XnQQGPzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZT2ncq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZT2ncq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB96C4CEC2;
	Wed,  2 Oct 2024 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880416;
	bh=MCtMhi/DWxFrGB5vWb2C8bIiG4sxKzeip+R2wrnXD6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZT2ncq5lOT9oIC2gHLFQgfssCmbc9njIg/W2sM9YVm8XYif09FzCGq1S4lPevcPX
	 jDH3o1KorLFTigxaHNv3MP7wYBJQONV+yPktyJTo7jD0QLynXnHMp9nxbwdXMrxgcl
	 2Sv1fgY9tpDl+aHDwwExJ9/YRTL6aidmLpNyejvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 451/538] perf/x86/intel/pt: Fix sampling synchronization
Date: Wed,  2 Oct 2024 15:01:30 +0200
Message-ID: <20241002125810.243575764@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
@@ -1602,6 +1602,7 @@ static void pt_event_stop(struct perf_ev
 	 * see comment in intel_pt_interrupt().
 	 */
 	WRITE_ONCE(pt->handle_nmi, 0);
+	barrier();
 
 	pt_config_stop(event);
 
@@ -1653,11 +1654,10 @@ static long pt_event_snapshot_aux(struct
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
 
@@ -1669,11 +1669,10 @@ static long pt_event_snapshot_aux(struct
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


