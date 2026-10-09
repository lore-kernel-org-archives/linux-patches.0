Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A50D4E36D6;
	Fri,  9 Oct 2026 14:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557330; cv=none; b=dkY7+YpaBIUkKYxR1zDGYZnP+sV/h07yGb6Xb6zVZ+rAjYa6N7fXJUkk5I/g7oqrqhWNoaNcGHWtHE2Il2Yr07VJQUi+8HE6OyYkngOj/y53RrRuuqeJydRnHXT4ZK50OtFhk5eTdVdUSg/nJXJlyAENNekR/c6zdEm5QHo/m2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557330; c=relaxed/simple;
	bh=DRY8Zwtd5OWw3z+02dBAtDkQVTbBdqKc4VfREU7HUpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsKpGleIp9JCif9xAUG7cJ86aTtoymBhcfk1VBrt6CL+ewKY6wsES36cKqwMT4m9OXZ+ABymPnPIUJKRFPyoNx+2DqsvN+3NsHgbCjoUw3y6Lw2gSw5Z2JflQqtzzkUrl7t024b23MpwANJdvadvxTp3mHDR1Bk1AZdMdmQ9mJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVZel7kG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVZel7kG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5F01F00893;
	Fri,  9 Oct 2026 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557329;
	bh=U2ZIGGSDhJOD2vhmAKE48rSCb9U51HThuSF3Vfrq4V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVZel7kGugxWYFochafqHJd0J8bwtvkaTIIl9vWeYYWscwzD7ihkQzOeoYmdkV/AI
	 e4WiyfCSYWvDgAXsXvBucSxAN5gyp5qArR6yYP5RYKIWJfqdneRegRFiwxzMNv5WlW
	 gtJRkikbantB0nrLqwj44afLMLQDGs8qsgbM+qU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 383/403] perf/core: Check kernel access when kernel callchains are requested
Date: Fri,  9 Oct 2026 16:12:24 +0200
Message-ID: <20261009141001.287090000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -13490,7 +13490,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (err)
 		return err;
 
-	if (!attr.exclude_kernel) {
+	if (!attr.exclude_kernel ||
+	    ((attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
+	     !attr.exclude_callchain_kernel)) {
 		err = perf_allow_kernel();
 		if (err)
 			return err;


