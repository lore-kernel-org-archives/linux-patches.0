Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B23C2E06E4;
	Sat, 12 Sep 2026 12:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216935; cv=none; b=eC2NLfQBLV8MbSMAVr2Eh0Gq8p8t+X9UU84DlS+xKgHJoIe5li9ge71u/SSGqYHWfvPdYVVB21VwzzebZPNw4uA8c9WOQEWinWA4ulge51F1qanzI5EoGQh+qMUF/A8mFO65f5nhHC8zkWZS4msGYINE2EUxjYOgI1kvit+uslg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216935; c=relaxed/simple;
	bh=1ZAsIvrKQScluJnjiof8nj6a3JIKHol9oH35CWGMQr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bV4VWjOmCo+KMEBJ76ONYeKCn1P7k5hJFYf6Hn8Xz82qM+qAWoJp2qbowFPmsCU/SMvhSXRzTxLEZi55J3ceQZ/rdiYnh8pc43KvpkSD2muRSJWSpsxKWqVnbb/PL9Cmg2uu613IFW0OrEF33k0Q1CdHvrwwMhQYfxa9bVr04l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTaKwWJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTaKwWJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5D41F000FF;
	Sat, 12 Sep 2026 12:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216934;
	bh=3/WmjNMx5J/S8IkuZQwx/jZgVKrhdE0ebkZFqTaczcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTaKwWJp1/JNDz+fdTgjDDzNb1YRpY9o/oTEyrhBhubvw1JGcBaa+ZPSgr0Wsiw9O
	 Dyw+mzP/8KWdie9C82nBl+a1U21FMBHfurBdrIElIa3aj8Qy1g9nJwkLKbh1psEYoP
	 mudmyWRO63FrSnu3aH+Qr37vTGzNjPXvKGe9/GHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0795/1376] powerpc/crash: Fix possible memory leak in update_crash_elfcorehdr()
Date: Sat, 12 Sep 2026 08:53:41 +0200
Message-ID: <20260912065625.254862895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 4cc4b586007fbbf8edba4f1d0849e9a06b0cf6c3 ]

In get_crash_memory_ranges(), if crash_exclude_mem_range() failed
after realloc_mem_ranges() has successfully allocated the cmem
memory, it just returns an error but leaves cmem pointing to
the allocated memory, nor is it freed in the caller
update_crash_elfcorehdr(), which cause a memory leak, goto out
to free the cmem.

Fixes: 849599b702ef ("powerpc/crash: add crash memory hotplug support")
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260729012948.2797865-2-ruanjinjie@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/crash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/crash.c b/arch/powerpc/kexec/crash.c
index e6539f213b3d1..a520f851c3a6b 100644
--- a/arch/powerpc/kexec/crash.c
+++ b/arch/powerpc/kexec/crash.c
@@ -502,7 +502,7 @@ static void update_crash_elfcorehdr(struct kimage *image, struct memory_notify *
 	ret = get_crash_memory_ranges(&cmem);
 	if (ret) {
 		pr_err("Failed to get crash mem range\n");
-		return;
+		goto out;
 	}
 
 	/*
-- 
2.53.0



