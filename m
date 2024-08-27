Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45361E520;
	Tue, 27 Aug 2024 15:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771072; cv=none; b=ColLBW40gloLq7BZXyC0weNbiS1sGJ8iUkAXLI4cRPPgBuVw7yf+jpge5251p4m4bXUEn6GqIZVi5ezrG0Ty+k3JKOEGj92IVzKlhconMJDI+DH0+nS0kHB7mpKECMDENMQj1MyOdeKNXHygL0CqihZyQ+NFF5WMC9hsxJT7Jho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771072; c=relaxed/simple;
	bh=iMGQXVFEEiYn8+82KeVxQdHaH/qdJ9TPaZex0taw/tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFoYJuQxiSWEZ5M3Ez6PhybVPvckTibM8FWTgKz+TDfQyVVfEGepcuVhRElTbVUrOlUl/leornCLk3KPeJKkTcaFdHC+QurEYutDdiv/N9m1fqHrVp3jByfdG0HklaDqGYBKAQ1lSb357B3G+qNNrg1GccFfe8q1zVHqmSflzD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYds05Oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYds05Oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA4FC6105B;
	Tue, 27 Aug 2024 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771072;
	bh=iMGQXVFEEiYn8+82KeVxQdHaH/qdJ9TPaZex0taw/tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYds05Oj/QjqA0r7aMVdwkocOPoZs+VqcG1PMeomZ8asRhcR0mnM5zKYs/y5WtQ+s
	 PG1AkOTjm8pLpJESEswB2/kcOMa+oM+wxSennqcvZCbgddfQgQ3lf+mt11jfRwWw7n
	 soGNhp+3ty2I1ElGC6c43aGP3X49XfHQUY5Vfxe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Sandoval <osandov@fb.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 079/273] filelock: fix name of file_lease slab cache
Date: Tue, 27 Aug 2024 16:36:43 +0200
Message-ID: <20240827143836.419542979@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit 3f65f3c099bcb27949e712f39ba836f21785924a ]

When struct file_lease was split out from struct file_lock, the name of
the file_lock slab cache was copied to the new slab cache for
file_lease. This name conflict causes confusion in /proc/slabinfo and
/sys/kernel/slab. In particular, it caused failures in drgn's test case
for slab cache merging.

Link: https://github.com/osandov/drgn/blob/9ad29fd86499eb32847473e928b6540872d3d59a/tests/linux_kernel/helpers/test_slab.py#L81
Fixes: c69ff4071935 ("filelock: split leases out of struct file_lock")
Signed-off-by: Omar Sandoval <osandov@fb.com>
Link: https://lore.kernel.org/r/2d1d053da1cafb3e7940c4f25952da4f0af34e38.1722293276.git.osandov@fb.com
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/locks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index 9afb16e0683ff..e45cad40f8b6b 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2984,7 +2984,7 @@ static int __init filelock_init(void)
 	filelock_cache = kmem_cache_create("file_lock_cache",
 			sizeof(struct file_lock), 0, SLAB_PANIC, NULL);
 
-	filelease_cache = kmem_cache_create("file_lock_cache",
+	filelease_cache = kmem_cache_create("file_lease_cache",
 			sizeof(struct file_lease), 0, SLAB_PANIC, NULL);
 
 	for_each_possible_cpu(i) {
-- 
2.43.0



