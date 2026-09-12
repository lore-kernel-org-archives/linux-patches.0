Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEB541A575;
	Sat, 12 Sep 2026 09:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203685; cv=none; b=VsW/olB85hvHkx1dpiBQ+DqYlqxE+Mhn2uLwih9facyRJMRedMM5XKQRvxBepPuc34xiCg0FiVH7VkT2ZOLQPxmIl3w5XOkZGSEKwDxxc1xNd/D1c0ENsrTO+HinXOuAlvG7OnF4QWWRSCIdDICCDF4bRoT5kAljyXmzRpZVhyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203685; c=relaxed/simple;
	bh=ma8lVRz5/2FyYvE4cMH3+0okuXjAsxkE9sZ7zHeCe4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRxVxvpMu9pG8JhkrQdBgcfkVDLFlaYFXj/Yd4UL2oIIAQU79ipIOzMRK2RJIWtZ4CRs2xrAHErTq6MYmj8LdUrQfIZ7CqDYhnPr9jhdf2PNL+yxWrFfTW4RgUSTyckFWsZUzYxV6rQMG7jfjAJmsjgasAUkQwsBGHq0wI4spuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4sNTI19; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4sNTI19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6891F00899;
	Sat, 12 Sep 2026 09:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203684;
	bh=cfhHH2XkZbv3HUd1LGLTcm9eqKvIjTM17NO97nIz6Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4sNTI19CmK9gIdXCZrUV5377mxKZYffZT3nFuf+4cX3FfN77icrGb5MbTMPQVHu5
	 l+vcNVq/mSPkkCqVSO1gU9ZyTM179gKJNH/wZdNGpLbulKhcUEDUJRPuzZ4pfFfr4Y
	 UEpWLbjP44yWHzrrsf/KElCfNsqlMJp0Pr2+vryU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1456/1815] bpf: Fix arm64 KASAN false positive after bpf_throw
Date: Sat, 12 Sep 2026 08:53:26 +0200
Message-ID: <20260912065723.195031484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit b0e872a31e157d48479507c2821ba8bf6323b7ad ]

arm64 passes zero as the stack pointer while walking BPF frames, so
bpf_throw() leaves stale KASAN stack poison after jumping to the
exception callback.

Use the frame pointer as the fallback stack watermark.

Fixes: e74cb1b42213 ("arm64: stacktrace: Implement arch_bpf_stack_walk() for the BPF JIT")
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/bpf/20260812-hello_world-v1-1-c3c2ddcb362d@meta.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 88b38db47de92..61805d8c95aef 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -3395,11 +3395,13 @@ __bpf_kfunc void bpf_throw(u64 cookie)
 		WARN_ON_ONCE(!ctx.aux->exception_boundary);
 	WARN_ON_ONCE(!ctx.bp);
 	WARN_ON_ONCE(!ctx.cnt);
-	/* Prevent KASAN false positives for CONFIG_KASAN_STACK by unpoisoning
+	/*
+	 * Prevent KASAN false positives for CONFIG_KASAN_STACK by unpoisoning
 	 * deeper stack depths than ctx.sp as we do not return from bpf_throw,
-	 * which skips compiler generated instrumentation to do the same.
+	 * which skips compiler generated instrumentation to do the same. Some
+	 * architectures cannot recover sp while unwinding, so fall back to bp.
 	 */
-	kasan_unpoison_task_stack_below((void *)(long)ctx.sp);
+	kasan_unpoison_task_stack_below((void *)(long)(ctx.sp ?: ctx.bp));
 	ctx.aux->bpf_exception_cb(cookie, ctx.sp + ctx.aux->stack_arg_sp_adjust, ctx.bp, 0, 0);
 	WARN(1, "A call to BPF exception callback should never return\n");
 }
-- 
2.53.0



