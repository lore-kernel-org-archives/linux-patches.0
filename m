Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6186268FCC;
	Tue,  8 Apr 2025 11:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110321; cv=none; b=OZoKiJbz74JUnF6kOPpp7ThrC50BYGzQem32zGZ2eYJWsF1KTbiZRZJ/nIlnMQ5wviNt8xFXf8oyx+5lC3c6mDTPNCf88tIU7idbVcA+gNSlWYnyPx2wfXNcOvrOFoRHjlkoou9h8P7ymfwQywrYmeiaozEoRavBFHgrvPkmOeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110321; c=relaxed/simple;
	bh=dD+lnyFgyjPWCOe5F8Dz7vGyEf4xKD7LfuT1yIm7MY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0hnOPEOWvYS0cfxqYj2hrIAeC6HhhIt0nt/4M1gzDvw58hHMwtmE8hZyhFD+yngrZoooOOyPwnA+rTqi5gnt7J5EzRJZicrNf0klEpehgDPw7SYmoWKcLYnqJ+BwIi1gFVTbZU1pEe824it09BCITGx7HEN9ojGuNCALcnh0/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZSrmqMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZSrmqMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF37C4CEE5;
	Tue,  8 Apr 2025 11:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110321;
	bh=dD+lnyFgyjPWCOe5F8Dz7vGyEf4xKD7LfuT1yIm7MY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZSrmqMvZlKgVzpb4MKwAKTe11p4cva00h84Jw2ii0/QvuFY/OHvTKmkQYg7n0DNm
	 RhdEO6rgdyS6zON6+e0JP5iaKqSXa/CIDqT9LIZKaL4WRWNTT0r+DLa9RXGSKjXeZQ
	 z8E69/yHRG5CVeRH1jDxumXMK8iQ9uYNIOOYNzAM=
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
Subject: [PATCH 6.14 021/731] x86/fpu: Avoid copying dynamic FP state from init_task in arch_dup_task_struct()
Date: Tue,  8 Apr 2025 12:38:38 +0200
Message-ID: <20250408104914.759412814@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 6da6769d7254a..7cb52f84cb0c2 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -93,7 +93,12 @@ EXPORT_PER_CPU_SYMBOL_GPL(__tss_limit_invalid);
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



