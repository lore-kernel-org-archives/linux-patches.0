Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473C140FDB9;
	Mon, 17 Aug 2026 14:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977052; cv=none; b=pcNIIbw6jfCiHkcXz95HStc/nd8C+LeccsOE3VSWhH0fMhWgpYS4Hn/MuRJ+btrpXdgzR9Mt1o1PdkLIuoSA57TpRMpm+mTj7kun3xtLOAgm6I1nYmfD47xop/7CjNkZfDWwr8DVB4sCuRYWTdjzw0yVDEQCKDnmONl8c5E8RDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977052; c=relaxed/simple;
	bh=g1MK5qfOIuSzKKIXz673ynmNJaQLQilEo4gNspIoTsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bu7pIAPep5oCDPIPPfOFE0VVdlabY9tbvDYDkEF6JGL5iztBKSoqCoBNSwuuj6JOmIULoq+6B6C4gnQuc+vSdSEmw89r0i71qdHMln3M3SzCoCbEH5kD4mT7HaE+8o/IL+wwCvV0vXf7iOa4tIIwZBbT5Kb1lspsxCMdwUOoRGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsxLsPet; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsxLsPet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B841F000E9;
	Mon, 17 Aug 2026 14:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977051;
	bh=aBsqBey+Lw4QK2gNaQMZq2+Bm1EnMRzGl5H899AlBfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CsxLsPet6EZDvPg/aqkwQSSlVEaEOQdW0TF1qPtBDF8qaxV1rNU5wye5WGX2113xy
	 LdPDazZW376hH2/KgI3yrEbxE6o5sKejZGq73eN2CbZeXFDVjSJaS7lAwEEpvsdFK8
	 X/Sc8IRWyYyW8R8DF2aTa+GqUkBy9TgzPttJpnbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 196/456] tracing/probes: Prevent out-of-bounds write in __trace_probe_log_err()
Date: Mon, 17 Aug 2026 15:29:46 +0200
Message-ID: <20260817132547.781987483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit a9d6fb284039a5d3858a1d9f9a0d7e46cfb7c2d4 upstream.

If trace_probe_log.argc is 0 in __trace_probe_log_err(), the loop
constructing the command string will not execute and p will remain equal to
command. Writing to *(p - 1) will cause an out-of-bounds access before
command. This should not happen, but better to be treated.

Reject if trace_probe_log.argc is 0.

Link: https://lore.kernel.org/all/178454233992.290363.18323091580600697731.stgit@devnote2/

Fixes: ab105a4fb894 ("tracing: Use tracing error_log with probe events")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -176,7 +176,7 @@ void __trace_probe_log_err(int offset, i
 
 	lockdep_assert_held(&dyn_event_ops_mutex);
 
-	if (!trace_probe_log.argv)
+	if (!trace_probe_log.argv || !trace_probe_log.argc)
 		return;
 
 	/* Recalculate the length and allocate buffer */


