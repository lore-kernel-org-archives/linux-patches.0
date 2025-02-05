Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FEB149C53;
	Wed,  5 Feb 2025 13:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763161; cv=none; b=O/y2u/AEkumccGVEvPdA8cryf2/40HQSsluLv0Sks/5729AP0tHTOlertAj3DIBb2QLjohi0AF/cWJVDgBMKP70X5Q3p8FmGCR2pc5L+fuCrJ0iJtZJlYL2AExrk01KLJgrdmIlbIgkSNsxJElXnx4wNr69zgfyyigD8E2VYu+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763161; c=relaxed/simple;
	bh=ytPqZbm1jrGw+hOrSMZ1uWqmCMq8hX41pLCPuB443ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSUP1neQDpdZimpEyDUwkQbMEOiIWyFepJo/Tyk7b8wYHTU+LiruXvjuqD2GjBbqm/SHL1Z9vPCZDyIO3hc3uucCuMs4DxBBeCE6oKLQ2fDcFKP5Zkj90w4coerlevvXxtG5YxENxKY/XtDPsMithqTPDpRqghiRHUPT0b6e37k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Wuds5ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Wuds5ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566B9C4CEE2;
	Wed,  5 Feb 2025 13:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763160;
	bh=ytPqZbm1jrGw+hOrSMZ1uWqmCMq8hX41pLCPuB443ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Wuds5ubgspXQQ+TcKeIzkNVhSAJPq8OcjjN58tNlVGLHPYXMyo16uOGZ+ur98N4X
	 NzVk66/hUklMijQM7qN27eK04cjVKVR5dKEylo8WhjG/HgR0cSCgFujQXtL8ylxQXD
	 Tsgi1RxhWf8+DIpkQmz6pWSZpXbnMes4en/Tf7lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/590] coredump: Do not lock during comm reporting
Date: Wed,  5 Feb 2025 14:35:56 +0100
Message-ID: <20250205134455.285100586@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 200f091c95bbc4b8660636bd345805c45d6eced7 ]

The 'comm' member will always be NUL terminated, and this is not
fast-path, so we can just perform a direct memcpy during a coredump
instead of potentially deadlocking while holding the task struct lock.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Closes: https://lore.kernel.org/all/d122ece6-3606-49de-ae4d-8da88846bef2@oracle.com
Fixes: c114e9948c2b ("coredump: Standartize and fix logging")
Tested-by: Vegard Nossum <vegard.nossum@oracle.com>
Link: https://lore.kernel.org/r/20240928210830.work.307-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/coredump.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index 45e598fe34766..77e6e195d1d68 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -52,8 +52,8 @@ extern void do_coredump(const kernel_siginfo_t *siginfo);
 #define __COREDUMP_PRINTK(Level, Format, ...) \
 	do {	\
 		char comm[TASK_COMM_LEN];	\
-	\
-		get_task_comm(comm, current);	\
+		/* This will always be NUL terminated. */ \
+		memcpy(comm, current->comm, sizeof(comm)); \
 		printk_ratelimited(Level "coredump: %d(%*pE): " Format "\n",	\
 			task_tgid_vnr(current), (int)strlen(comm), comm, ##__VA_ARGS__);	\
 	} while (0)	\
-- 
2.39.5



