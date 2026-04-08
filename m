Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C066E347503;
	Wed,  8 Apr 2026 18:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671925; cv=none; b=Sy3Hv17dcEevzGv/cVXFNxBBsYs48se6noYiUSfS5mfasvA3M1PI4M/abN3TDEjlbs0Hrw8/K4ZHynrA3y5desirAyXKlHKnbQrNWz7LBsWFzAjHsc57UpU4y9ioa5tE6CJktqxFBDgyncjh50/umkMdklKf4jKIzWB+tKL1e/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671925; c=relaxed/simple;
	bh=5RmhEhmBAnifK6wGhkpr6OpkMD07kNHVrTCSpKGdVSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kC0r6RSYewKwP5Oso6l2sdI94q93GBFMOAKdNoK728Hl6qg4nxlkdmcuDUkJhjxz5uRZvMbxLvqWDlJ7xW/45aMRJqeKXL34JwjJQhmRP7G9GznDg82l79THGA9wwJeP0SKYckrBNWkvLQwd7TaJa6E+UiOZ5S1Zz90Rs6LFbrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kA0ZmqxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kA0ZmqxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E9FC19421;
	Wed,  8 Apr 2026 18:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671925;
	bh=5RmhEhmBAnifK6wGhkpr6OpkMD07kNHVrTCSpKGdVSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kA0ZmqxUZrTjSCjyDgjQVM5/MZxVg+ib/7pOMhANbmcdJqX0KJq1pD4Cx09H4umH4
	 Uk1pccJkt73H4pjlRkO45beTCA7qd3v5jqZvmLl+bW27Hc48IN4TZy+v+6nAwFn9Tj
	 xr4GFeM04DjaVZYbjFYhVH0J6VYGneT3CEVJGA8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	stable@kernel.org
Subject: [PATCH 6.1 089/312] s390/syscalls: Add spectre boundary for syscall dispatch table
Date: Wed,  8 Apr 2026 20:00:06 +0200
Message-ID: <20260408175937.070950590@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 48b8814e25d073dd84daf990a879a820bad2bcbd upstream.

The s390 syscall number is directly controlled by userspace, but does
not have an array_index_nospec() boundary to prevent access past the
syscall function pointer tables.

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Fixes: 56e62a737028 ("s390: convert to generic entry")
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/2026032404-sterling-swoosh-43e6@gregkh
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/syscall.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/kernel/syscall.c
+++ b/arch/s390/kernel/syscall.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/nospec.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
@@ -141,6 +142,7 @@ static void do_syscall(struct pt_regs *r
 	if (likely(nr >= NR_syscalls))
 		goto out;
 	do {
+		nr = array_index_nospec(nr, NR_syscalls);
 		regs->gprs[2] = current->thread.sys_call_table[nr](regs);
 	} while (test_and_clear_pt_regs_flag(regs, PIF_EXECVE_PGSTE_RESTART));
 out:


