Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30FF2288CB;
	Tue,  8 Apr 2025 11:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112607; cv=none; b=lIfaeyk9PVt5IMWnlHQU9ysBva0bw/SyaUujrJO87y8O3YL67Q5DxBwOLhtQfMf/tCF8Q5ue3cPbGlOVp61ES7h4dfwjd3jt75GePPBBwIHHqaImhSFUUUgkJfFNyJLgKDQ2E6MB4Mn5pIRCFeLn+bwmazCEDRvZz7hKYJje9Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112607; c=relaxed/simple;
	bh=Inlbhi8zwSm8FKjo3+xj7tlh8IGbgYizVwlpEvi8hQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBqWGXk/pAdezymcbyHhPnH6epPlHsDKnZ0iTXspahNDUWgsh+w1dk/FYsZYYvWB1wbbrwW9kUqwHSznoK69wqwgITBY0sBhs2+tME6KzYI2tMi+veyBmKaqknn83OLqOvn74pWGzLFska2NeoF74Y/edcGNXuYcblKCXxxTdLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gHxq8f7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gHxq8f7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F8BC4CEE5;
	Tue,  8 Apr 2025 11:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112607;
	bh=Inlbhi8zwSm8FKjo3+xj7tlh8IGbgYizVwlpEvi8hQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gHxq8f7iOGIpK44c96kSjjDTiyakl6MdKxPg9CmHisaGtEjWF1bn92sckBKgYgV/
	 16ZcEpoCDD5OOsXpgy96UzJW8PTM/83YtIyo1ewHiMk7UldWmqzHXNdFSxuLlY4HEd
	 trJP05QjkOKLI+mj9pVSxr0Maj3Q0K7mEUEg3jig=
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
Subject: [PATCH 5.15 132/279] x86/fpu: Avoid copying dynamic FP state from init_task in arch_dup_task_struct()
Date: Tue,  8 Apr 2025 12:48:35 +0200
Message-ID: <20250408104829.904216192@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 720d99520316a..72eb0df1a1a5f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -83,7 +83,12 @@ EXPORT_PER_CPU_SYMBOL_GPL(__tss_limit_invalid);
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



