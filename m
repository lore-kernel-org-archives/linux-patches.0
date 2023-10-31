Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B40E208B8
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIMdKLO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24DEC433C9;
	Tue, 31 Oct 2023 17:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774392;
	bh=o7VNhG9Mv9712cfsEQbDs1sR3yHbJx+JciECrw8e+Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIMdKLO7lH4yXPJfDZl3tbscjG7/Idk9sMZDskg/OttIlvAcFAL0tSTNNLsQp5TVR
	 4qr5WpIK2oDMqfN5M+4BeEZaY6VwBde0ge8YmvTA2998bA2OLq9bYYMsDpJFbAVJqo
	 8tHOU4arWYj/QPtOLUXuap7QTp62pvRLkeiNuAHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.5 023/112] mm: fix vm_brk_flags() to not bail out while holding lock
Date: Tue, 31 Oct 2023 18:00:24 +0100
Message-ID: <20231031165902.048967020@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3136,13 +3136,13 @@ int vm_brk_flags(unsigned long addr, uns
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


