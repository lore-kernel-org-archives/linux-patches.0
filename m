Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42A92E11A6;
	Tue, 31 Mar 2026 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976649; cv=none; b=J08VTVMUKsv1ydlLw2kpCK478k9qBr5tAUeyMRWY8xBBzpGqgzihlBEotResSjPNdjklTdgFGl7/g3yMt56a9vjvwPftFW79ao7zgejA6lBoZwsxDzYAq1ljPN8OjWTUz7PIr+AkGnFOf2VLW0ywms+/eXxwj8tMx5vuJ3JHGpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976649; c=relaxed/simple;
	bh=O8/rfsP95ejLYview66m3+DroH4WVTz29LC0re+XQno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1c7vfjGCP3lUh63cyJr0lJuUdpAjJFRSw13APrZ1bG9fmKADeZLxf5wT0DmWp+3OCm+cN26iGUxRvk7H0Kpujf/7lx4fo4Waft09aXf5Tn/3SIpxFKMA3aFRPVHMnyxH5VrkG1N8EzRu0XZXJ+L6B63ZPWj5OpWkCpMuykaVJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1SrkXgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1SrkXgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3515C19423;
	Tue, 31 Mar 2026 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976649;
	bh=O8/rfsP95ejLYview66m3+DroH4WVTz29LC0re+XQno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1SrkXgl6mPyJzuDQ2+PaYrdBacsgpml4xWTFEaJNWihFn33RIVtf7ZNYCAp2QwgO
	 9BuqLBThrXvi7GGqbD2fHvBuHcgPtqf+tIgjtxwJ1i9aZq4xajMrhM3IENRzns1HT3
	 OzUgHka8yfzeSWQRhZR89Erx9mfzwjJmbwOlW2tk=
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
Subject: [PATCH 6.18 175/309] s390/syscalls: Add spectre boundary for syscall dispatch table
Date: Tue, 31 Mar 2026 18:21:18 +0200
Message-ID: <20260331161759.908252873@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 arch/s390/kernel/syscall.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/s390/kernel/syscall.c
+++ b/arch/s390/kernel/syscall.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/cpufeature.h>
+#include <linux/nospec.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
@@ -121,8 +122,10 @@ void noinstr __do_syscall(struct pt_regs
 	if (unlikely(test_and_clear_pt_regs_flag(regs, PIF_SYSCALL_RET_SET)))
 		goto out;
 	regs->gprs[2] = -ENOSYS;
-	if (likely(nr < NR_syscalls))
+	if (likely(nr < NR_syscalls)) {
+		nr = array_index_nospec(nr, NR_syscalls);
 		regs->gprs[2] = current->thread.sys_call_table[nr](regs);
+	}
 out:
 	syscall_exit_to_user_mode(regs);
 }


