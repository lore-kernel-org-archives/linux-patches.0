Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFF42676CA;
	Tue,  8 Apr 2025 12:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113951; cv=none; b=jQoJO98G1JI48JWghQ7sjC9zWvEfLgpTt7XyfaUeTcW9+RgQUWP1nhgSYnCieFw31OSQtVMCckKlO9hqCaQx0+tvKgutn7r9HO6+TxhFZYMytVj0rp5qmD4Xg+ovqAQSRk/IPqg/43NseP+BxM57Zl3bpL6ymkau732R2QiV164=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113951; c=relaxed/simple;
	bh=uVtzqJAjH00HcvxTJ+34XSAqIYUDIzIQTd9WS612Fhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cg0hr66SHKg1Baj198P2G4Y+CVIyt8XksBNeoekoO9nkHk4/Ow2e4Pg2AK5FKmYn5iYbNqWI7NWzx8e0rUl50J/rH/fQtKOLhLudxL/QBGZ1OAARlHF1CHN/nZT5B2JlwaKM6l6g3XqCRtLsGp6h5EPO0176th/ZML3lk6tvs0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJ3oCB2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJ3oCB2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C806C4CEE5;
	Tue,  8 Apr 2025 12:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113951;
	bh=uVtzqJAjH00HcvxTJ+34XSAqIYUDIzIQTd9WS612Fhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJ3oCB2V9OVYCVaD8WM4C8loj882JCk5UM9P2tbOaNEtmPgzWIub6PZA9TriE/7nR
	 yu/X93megmEKSQYlIQxN4km61aVgzm2Vj9bsT4M74kxp0xYnuiwae68byIFpk4hI57
	 SDsZaN/z9G0RA6gVr/fXrDcJAIRCbAjK9619z72I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/154] x86/fpu: Avoid copying dynamic FP state from init_task in arch_dup_task_struct()
Date: Tue,  8 Apr 2025 12:50:23 +0200
Message-ID: <20250408104817.942073399@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 5d3b81d4d8520efe888536b6906dc10fd1a228a8 ]

The init_task instance of struct task_struct is statically allocated and
may not contain the full FP state for userspace. As such, limit the copy
to the valid area of both init_task and 'dst' and ensure all memory is
initialized.

Note that the FP state is only needed for userspace, and as such it is
entirely reasonable for init_task to not contain parts of it.

Fixes: 5aaeb5c01c5b ("x86/fpu, sched: Introduce CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT and use it on x86")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/20250226133136.816901-1-benjamin@sipsolutions.net
----

v2:
- Fix code if arch_task_struct_size < sizeof(init_task) by using
  memcpy_and_pad.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/process.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c402b079b74e8..cc9d682a98a13 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -96,7 +96,12 @@ EXPORT_PER_CPU_SYMBOL_GPL(__tss_limit_invalid);
  */
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
-	memcpy(dst, src, arch_task_struct_size);
+	/* init_task is not dynamically sized (incomplete FPU state) */
+	if (unlikely(src == &init_task))
+		memcpy_and_pad(dst, arch_task_struct_size, src, sizeof(init_task), 0);
+	else
+		memcpy(dst, src, arch_task_struct_size);
+
 #ifdef CONFIG_VM86
 	dst->thread.vm86 = NULL;
 #endif
-- 
2.39.5



