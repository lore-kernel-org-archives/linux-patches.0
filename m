Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C26B253B42;
	Fri, 17 Oct 2025 15:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716524; cv=none; b=pX9DBKFna1lJH+BQPntYs2GoV7HGckAaNBbihswl1ZQOHOPRUfVz/S3J6EuONN7KVcuOGrJcxZ8igpikw7YclK8NFMvia1Xkmk2Fr8xLBoFg4GLr8IR9qRcU0T9hPLhZzrNJyltoKL3wnptEd/hMKn7nru9hCIb1KDmqPApns9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716524; c=relaxed/simple;
	bh=qdoW3kjwOJyQO6MoUpz9PBrIId2n2BnnzkI9MOb9Cf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f68nW1VUokCXY6ZgmWwNEa9ohSBquIKIA93ga9jmmvXOl4ex+nUFIzOUU7qIU5ctxvoys7VkRbgvvZ8vVBO0e7Qsm60GcZCu+GDgw9iLYPCpKzOTJvrUNb05WV78cSWJfajERQ6rGe4CD/HDkH2auBCxDlp97kvpVtqK+83l4oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kScnX6RP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kScnX6RP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96272C4CEE7;
	Fri, 17 Oct 2025 15:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716524;
	bh=qdoW3kjwOJyQO6MoUpz9PBrIId2n2BnnzkI9MOb9Cf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kScnX6RPsCJKZuGuJkqs25R0I9gAXE0Gag01nPysVphDpSyRSMZzCCpievVAICH/F
	 THxqYKBGtwXlWN34sDxBFmrLoLyj13dgFacndn1sUqfH9Leim5xgRTzdITTvfI5Pxf
	 eiFfNiYGeKu2F5DP/lWyxVxopMunNKZVeeXxSJbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 177/276] copy_sighand: Handle architectures where sizeof(unsigned long) < sizeof(u64)
Date: Fri, 17 Oct 2025 16:54:30 +0200
Message-ID: <20251017145148.936557421@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Schuster <schuster.simon@siemens-energy.com>

commit 04ff48239f46e8b493571e260bd0e6c3a6400371 upstream.

With the introduction of clone3 in commit 7f192e3cd316 ("fork: add
clone3") the effective bit width of clone_flags on all architectures was
increased from 32-bit to 64-bit. However, the signature of the copy_*
helper functions (e.g., copy_sighand) used by copy_process was not
adapted.

As such, they truncate the flags on any 32-bit architectures that
supports clone3 (arc, arm, csky, m68k, microblaze, mips32, openrisc,
parisc32, powerpc32, riscv32, x86-32 and xtensa).

For copy_sighand with CLONE_CLEAR_SIGHAND being an actual u64
constant, this triggers an observable bug in kernel selftest
clone3_clear_sighand:

        if (clone_flags & CLONE_CLEAR_SIGHAND)

in function copy_sighand within fork.c will always fail given:

        unsigned long /* == uint32_t */ clone_flags
        #define CLONE_CLEAR_SIGHAND 0x100000000ULL

This commit fixes the bug by always passing clone_flags to copy_sighand
via their declared u64 type, invariant of architecture-dependent integer
sizes.

Fixes: b612e5df4587 ("clone3: add CLONE_CLEAR_SIGHAND")
Cc: stable@vger.kernel.org # linux-5.5+
Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
Link: https://lore.kernel.org/20250901-nios2-implement-clone3-v2-1-53fcf5577d57@siemens-energy.com
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1595,7 +1595,7 @@ static int copy_io(unsigned long clone_f
 	return 0;
 }
 
-static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
+static int copy_sighand(u64 clone_flags, struct task_struct *tsk)
 {
 	struct sighand_struct *sig;
 


