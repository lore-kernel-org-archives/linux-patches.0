Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38755361DDC;
	Tue, 13 Oct 2026 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895589; cv=none; b=tvNyYqihUjILlFMYPTdtqBgF5K6b4vBnPE7FiA5H5a154IAgr+hsq14DZZQIoFjWikCVe2C802M2BREh1xlXeiS0oWO/Natfhg7rIE7s2/XFuF/qtmiE4Bxd+bx5Mn6o9UgfKlRnK+ReLXZla58L1uJQHMxoaUBKlW4xnRXQDvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895589; c=relaxed/simple;
	bh=nDTI5toFnO9oyLxjOM/QqdtCT65uNJc43aQf7+Y7eTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYIUnFp/lNvSNDIQaCSiXPttTmehwrlnuTG1VenGLqJUanyk3NFxQ5sYxCfMSTASsAcgVP1p0s2XfJhCMwQyGxLFWI4+iVEDsL+orUvAq2DhiWndBOYfflZSsOlhNicGba/DuXhvAbAUQHqs3tBVmQ3j7Hd04R3CW8QPeHD21A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOyBNJJK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOyBNJJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B6B1F000FF;
	Tue, 13 Oct 2026 12:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895588;
	bh=LSa67Euv/BmUL8/VhBTr/Z68WUMvZ+B0YcE+x4lnFqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gOyBNJJKRbl+z4DS3MFZxlP1oyZRvnEu/bcpZ2/XssdUD6rjiSjxOggZRhbdFVpvt
	 GsmSUdy3pbmWhXf4sLB7hHeyGMOyTEbufCLQb8DntLAaQWSq2dbOUB4NN/kSCfYpI9
	 y+P9E78otirmvKXaqK62kWtb42CuRIgdIKRVSRio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 281/497] perf/core: Check kernel access when kernel callchains are requested
Date: Tue, 13 Oct 2026 13:37:28 +0200
Message-ID: <20261013112914.564250905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit a4573a3838ae4fc73b70019cfa1dac9aaea7cc2f ]

perf_event_open() currently gates perf_allow_kernel() only on
!attr.exclude_kernel.

However, users can still request kernel callchain collection with
attr.exclude_callchain_kernel == 0 even when attr.exclude_kernel == 1.
That still requires kernel profiling privilege, but the existing check
does not enforce it.

Update the permission check to call perf_allow_kernel() when either
kernel sampling is requested or kernel callchains are requested.

This keeps permission checks aligned with requested data and prevents
unprivileged use of kernel callchain capture.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260616044654.3468742-9-dapeng1.mi@linux.intel.com
Stable-dep-of: 357e8a77a501 ("perf: Require kernel access for text poke events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ddabdc16e3880..3791c84ffe2cf 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12893,7 +12893,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (err)
 		return err;
 
-	if (!attr.exclude_kernel) {
+	if (!attr.exclude_kernel ||
+	    ((attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
+	     !attr.exclude_callchain_kernel)) {
 		err = perf_allow_kernel();
 		if (err)
 			return err;
-- 
2.53.0



