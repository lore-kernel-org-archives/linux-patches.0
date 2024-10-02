Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275A81EF1D;
	Wed,  2 Oct 2024 14:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879437; cv=none; b=GsdkGfkshEMc0N0Dqmga9ANjPjIHS+czP979MrWdijDMzvRLXh9ueMs2RusHmuzGmpTEfX7wJGcMcgtdM/gEyNKgwJpMlJJ1pwMawTKH9Q1YJWpoUTfZ09/o72UNnAmKYebsN1X3QdiqDxM8Y7hMbph3qCuFtlwfKyiKabPlYE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879437; c=relaxed/simple;
	bh=331obl3SGmZ6yTQR3efyzU1gPrVhevagsQ2cwGOpEf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFOc+upK2IEVzUQMqqAqH1OjK7PpLt0M1ydt2Sc+tM33zsEqoEiWw2RGU3W5IGTMC/NwPuuSqGs6GULCI4iMpWNF0F2DVKuzdbSnmQ9iyoflHGCuQFawLkY37GQuQNfHECdN4By/gD39fkSRChDRrP7RX5osFFyYQSLe1IO63iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xILnd4Bd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xILnd4Bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F03C4CEC2;
	Wed,  2 Oct 2024 14:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879436;
	bh=331obl3SGmZ6yTQR3efyzU1gPrVhevagsQ2cwGOpEf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xILnd4BdO9IQNzSoZGqix4HsyQXl+AepB5oGS67eeax08jD3Q7PLfwD/Rnm6u3Fcc
	 K/GwsJLv83fp/SMX/06STfq9gLoOmGicMre9XpoCPXx7FfJLRMiJ6eM/vT1Rrtoj8a
	 0Pc8TwNAAQ1mKfY5FYJ1rf9WNNM1B/yOzAxLKhJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/538] m68k: Fix kernel_clone_args.flags in m68k_clone()
Date: Wed,  2 Oct 2024 14:55:57 +0200
Message-ID: <20241002125756.904029032@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 09b3d870faa7bc3e96c0978ab3cf4e96e4b15571 ]

Stan Johnson recently reported a failure from the 'dump' command:

  DUMP: Date of this level 0 dump: Fri Aug  9 23:37:15 2024
  DUMP: Dumping /dev/sda (an unlisted file system) to /dev/null
  DUMP: Label: none
  DUMP: Writing 10 Kilobyte records
  DUMP: mapping (Pass I) [regular files]
  DUMP: mapping (Pass II) [directories]
  DUMP: estimated 3595695 blocks.
  DUMP: Context save fork fails in parent 671

The dump program uses the clone syscall with the CLONE_IO flag, that is,
flags == 0x80000000. When that value is promoted from long int to u64 by
m68k_clone(), it undergoes sign-extension. The new value includes
CLONE_INTO_CGROUP so the validation in cgroup_css_set_fork() fails and
the syscall returns -EBADF. Avoid sign-extension by casting to u32.

Reported-by: Stan Johnson <userm57@yahoo.com>
Closes: https://lists.debian.org/debian-68k/2024/08/msg00000.html
Fixes: 6aabc1facdb2 ("m68k: Implement copy_thread_tls()")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/3463f1e5d4e95468dc9f3368f2b78ffa7b72199b.1723335149.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index e06ce147c0b7f..fb87219fc3b46 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -116,7 +116,7 @@ asmlinkage int m68k_clone(struct pt_regs *regs)
 {
 	/* regs will be equal to current_pt_regs() */
 	struct kernel_clone_args args = {
-		.flags		= regs->d1 & ~CSIGNAL,
+		.flags		= (u32)(regs->d1) & ~CSIGNAL,
 		.pidfd		= (int __user *)regs->d3,
 		.child_tid	= (int __user *)regs->d4,
 		.parent_tid	= (int __user *)regs->d3,
-- 
2.43.0



