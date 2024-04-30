Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C1812C549;
	Tue, 30 Apr 2024 10:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473898; cv=none; b=Fnqk+IDYUiJpEzq87qSKe9XwHWKj1SKEi8UjtmIcqC4P0y4uA0tbddSXTOAS4O8om3lqJ3SWY8DTPaon6g3h8B9SfVUEi/oj0Nt7C14qJoHmjfqii2zTWLmCDC6S2scDDlAVrtAbCn3QHxNRFKncpaRnQTRq1D/PMojBvCBw3sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473898; c=relaxed/simple;
	bh=hnas+ZstbNahs8HdyFO/EB27rb8elio4BYwVhVr93yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYDKOFVdm/bn0y5F+thGFa2X6XVT3xNBtS5u9RwwPAXKGu2cjOi7aUu6Pl+eNiM2Ybm3hoJcrc+I3B9bEOl/U+HyK05RynjZdjmGBqqFOsVAZ0cq8/r1atDXfOTt3PEtHsmgQRWDK5Eq5GjN0XnVOQJ/8sjZM7nLqM0sgZiP5go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpqDb65l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpqDb65l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3271BC2BBFC;
	Tue, 30 Apr 2024 10:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473898;
	bh=hnas+ZstbNahs8HdyFO/EB27rb8elio4BYwVhVr93yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpqDb65lEkN8lnpPPCwCSJPUPEjCoxuuC6qzZ/v5XaT5Uy3UALwCSLMD1ZuozvZrP
	 IKM7776bAnRFitxp73UTnYHskEnacNAP/KtJsFqGCVxo5qe9s372x5ldSaOA0Nrtkc
	 lCrN64pdJTt207/RNYuVi3E5oUhvBzJkpanEZqtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.19 75/77] Revert "y2038: rusage: use __kernel_old_timeval"
Date: Tue, 30 Apr 2024 12:39:54 +0200
Message-ID: <20240430103043.355059455@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit d5e38d6b84d6d21a4f8a4f555a0908b6d9ffe224, which
was commit bdd565f817a74b9e30edec108f7cb1dbc762b8a6 upstream.  It
broke the build for alpha and that can't be fixed without backporting
other more intrusive y2038 changes.

This was not a completely clean revert as the affected code in
getrusage() was moved by subsequent changes.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/osf_sys.c   |    2 +-
 include/uapi/linux/resource.h |    4 ++--
 kernel/sys.c                  |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -964,7 +964,7 @@ put_tv32(struct timeval32 __user *o, str
 }
 
 static inline long
-put_tv_to_tv32(struct timeval32 __user *o, struct __kernel_old_timeval *i)
+put_tv_to_tv32(struct timeval32 __user *o, struct timeval *i)
 {
 	return copy_to_user(o, &(struct timeval32){
 				.tv_sec = i->tv_sec,
--- a/include/uapi/linux/resource.h
+++ b/include/uapi/linux/resource.h
@@ -22,8 +22,8 @@
 #define	RUSAGE_THREAD	1		/* only the calling thread */
 
 struct	rusage {
-	struct __kernel_old_timeval ru_utime;	/* user time used */
-	struct __kernel_old_timeval ru_stime;	/* system time used */
+	struct timeval ru_utime;	/* user time used */
+	struct timeval ru_stime;	/* system time used */
 	__kernel_long_t	ru_maxrss;	/* maximum resident set size */
 	__kernel_long_t	ru_ixrss;	/* integral shared memory size */
 	__kernel_long_t	ru_idrss;	/* integral unshared data size */
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1795,8 +1795,8 @@ out_thread:
 
 out_children:
 	r->ru_maxrss = maxrss * (PAGE_SIZE / 1024); /* convert pages to KBs */
-	r->ru_utime = ns_to_kernel_old_timeval(utime);
-	r->ru_stime = ns_to_kernel_old_timeval(stime);
+	r->ru_utime = ns_to_timeval(utime);
+	r->ru_stime = ns_to_timeval(stime);
 }
 
 SYSCALL_DEFINE2(getrusage, int, who, struct rusage __user *, ru)


