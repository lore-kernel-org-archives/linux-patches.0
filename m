Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28992031C
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLRwd0fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCE6C433C7;
	Tue, 31 Oct 2023 17:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771785;
	bh=uLaa1h3qaVwHW47fye1V818NdRA7WeZIN/Z5YQddxD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLRwd0fapItSSj4oZcaSjA18zWEo6vqxguCLiunJ02lDDHxq8fHav6nxPeDohD7M4
	 W2EhotulowoQ1MVHxU54pQjwdofdnftS2PA0W9tfQegQClpxaRbCx8/dgndaYZWSAy
	 dEcVyuegl078cgWfbdKxTX5Dk94G9JWmd/dfsY4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 20/86] mm: fix vm_brk_flags() to not bail out while holding lock
Date: Tue, 31 Oct 2023 18:00:45 +0100
Message-ID: <20231031165919.240148290@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ott <sebott@redhat.com>

commit e0f81ab1e4f42ffece6440dc78f583eb352b9a71 upstream.

Calling vm_brk_flags() with flags set other than VM_EXEC will exit the
function without releasing the mmap_write_lock.

Just do the sanity check before the lock is acquired.  This doesn't fix an
actual issue since no caller sets a flag other than VM_EXEC.

Link: https://lkml.kernel.org/r/20230929171937.work.697-kees@kernel.org
Fixes: 2e7ce7d354f2 ("mm/mmap: change do_brk_flags() to expand existing VMA and add do_brk_munmap()")
Signed-off-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3147,13 +3147,13 @@ int vm_brk_flags(unsigned long addr, uns
 	if (!len)
 		return 0;
 
-	if (mmap_write_lock_killable(mm))
-		return -EINTR;
-
 	/* Until we need other flags, refuse anything except VM_EXEC. */
 	if ((flags & (~VM_EXEC)) != 0)
 		return -EINVAL;
 
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+
 	ret = check_brk_limits(addr, len);
 	if (ret)
 		goto limits_failed;


