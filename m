Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E862B269D17;
	Tue,  8 Apr 2025 12:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114189; cv=none; b=SWFRXRYuyIsnnUe5fO/jNfj2JyEFA8S2zpY6b/0DpaFPyr9LffZpltgTsleZai+Uun1bkx+ZWv+UrIZsCsmCea1ZZdBz3rv3HWGlhyrCoGqWKut0XiDpLJdvZu+I/HTxLxaddYYVL+qkT+q9wziRHU6mGZ1rAu+ED+rrILw39pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114189; c=relaxed/simple;
	bh=mgUnHww7ZvLznn9MjZLmvMra9RwefFoDAvKxJLc08/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c21r2zB48+mV+ribjx6R/lu24tnrsizf3BoV3/XSNV6/wlKgKbh5MudfyTk/GUrjoMbpLAkLhn4gTi3CXqH79Uxmivn2RdYM2LRZv0vE8Iqy7EdndXxHyFAcV9Q82kYdBTHIeh5Sk04BytV5Vcxs4nbX4TEFEF2vEP/f41iOuxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/tFGZeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/tFGZeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE97C4CEE7;
	Tue,  8 Apr 2025 12:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114188;
	bh=mgUnHww7ZvLznn9MjZLmvMra9RwefFoDAvKxJLc08/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/tFGZeKTuJ7jHAHg/GGlYX5itQ7KZgxB9vcwzRPglom7oY0SjVqV4z4BVyHoI/YW
	 /jIYJi57nHnELGp3/62f++DeDt7JG5m28idvV9kjkzZ87iu3j6j71QmnK6RU3ANZ5g
	 gKv4TePTis0lquYwf20w+hhI8+v3SEUsK/rHYhTs=
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
Subject: [PATCH 6.13 015/499] x86/fpu: Avoid copying dynamic FP state from init_task in arch_dup_task_struct()
Date: Tue,  8 Apr 2025 12:43:47 +0200
Message-ID: <20250408104851.632844837@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 15507e739c255..e42db0de02920 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -92,7 +92,12 @@ EXPORT_PER_CPU_SYMBOL_GPL(__tss_limit_invalid);
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



