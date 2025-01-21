Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A5EE571;
	Tue, 21 Jan 2025 18:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482531; cv=none; b=GZ7fNBcN9vfik73u5tUHr8qDQL+Fj5an2hWy3Sghfvh0DOchQyCyeTTyglJS3Oma6TBpmg/3HgVxbfeuFrOpf3s3urK+bzBf8A2pezVxX14JxsGKmdhAEh9sAEyvKr4VTWOVi6SWjIViv3D6nQ7SZs0BPrXmrRXz+n0J1SnhEFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482531; c=relaxed/simple;
	bh=aKQc8Sjf54HF1sgfm82JFlv1B4SWswt0x9rlLLIUIqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rf42CzmQQ6bZ0Yb83UamIok62qlYwMyk+ca7NzN2EitLHWNBwQtzzg4Gfle0HxaeFWCSx8NWWfDGnChdfZBMjaFbMJax0h+kDg0Eyd6gbAEhu5qZQJPP0acVpDqlef4npZocGa6wEd2DOfhAnXPc2A2VLB+J49MDdxw6X60ra3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9exXBvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9exXBvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0D1C4CEDF;
	Tue, 21 Jan 2025 18:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482531;
	bh=aKQc8Sjf54HF1sgfm82JFlv1B4SWswt0x9rlLLIUIqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9exXBvlxOIAPrpt4SoTc8Ajvgc1pq0+CrQCe1ntvIpUDMH8RCOezlKBRZBUlixiS
	 dG7xojUWoUBKni9wkeLu2qGqt5MbtNUHqLOtaHmzkwOhwJrOZLAnZUW06HSgQrHZ0s
	 2zEn/8qiSXLhXPOCLyNwGjeDwlHMXS3WdWhtn8uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xin Li (Intel)" <xin@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.12 109/122] x86/fred: Fix the FRED RSP0 MSR out of sync with its per-CPU cache
Date: Tue, 21 Jan 2025 18:52:37 +0100
Message-ID: <20250121174537.246196339@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xin Li (Intel) <xin@zytor.com>

commit de31b3cd706347044e1a57d68c3a683d58e8cca4 upstream.

The FRED RSP0 MSR is only used for delivering events when running
userspace.  Linux leverages this property to reduce expensive MSR
writes and optimize context switches.  The kernel only writes the
MSR when about to run userspace *and* when the MSR has actually
changed since the last time userspace ran.

This optimization is implemented by maintaining a per-CPU cache of
FRED RSP0 and then checking that against the value for the top of
current task stack before running userspace.

However cpu_init_fred_exceptions() writes the MSR without updating
the per-CPU cache.  This means that the kernel might return to
userspace with MSR_IA32_FRED_RSP0==0 when it needed to point to the
top of current task stack.  This would induce a double fault (#DF),
which is bad.

A context switch after cpu_init_fred_exceptions() can paper over
the issue since it updates the cached value.  That evidently
happens most of the time explaining how this bug got through.

Fix the bug through resynchronizing the FRED RSP0 MSR with its
per-CPU cache in cpu_init_fred_exceptions().

Fixes: fe85ee391966 ("x86/entry: Set FRED RSP0 on return to userspace instead of context switch")
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250110174639.1250829-1-xin%40zytor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fred.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fred.c b/arch/x86/kernel/fred.c
index 8d32c3f48abc..5e2cd1004980 100644
--- a/arch/x86/kernel/fred.c
+++ b/arch/x86/kernel/fred.c
@@ -50,7 +50,13 @@ void cpu_init_fred_exceptions(void)
 	       FRED_CONFIG_ENTRYPOINT(asm_fred_entrypoint_user));
 
 	wrmsrl(MSR_IA32_FRED_STKLVLS, 0);
-	wrmsrl(MSR_IA32_FRED_RSP0, 0);
+
+	/*
+	 * Ater a CPU offline/online cycle, the FRED RSP0 MSR should be
+	 * resynchronized with its per-CPU cache.
+	 */
+	wrmsrl(MSR_IA32_FRED_RSP0, __this_cpu_read(fred_rsp0));
+
 	wrmsrl(MSR_IA32_FRED_RSP1, 0);
 	wrmsrl(MSR_IA32_FRED_RSP2, 0);
 	wrmsrl(MSR_IA32_FRED_RSP3, 0);
-- 
2.48.1



