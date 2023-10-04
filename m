Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E611D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAs4yLoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34095C433C8;
	Wed,  4 Oct 2023 18:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443930;
	bh=AwvV22U3Z3aWMKb/qq5jNTioHF6Xqws2wkVflEMRNeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAs4yLoehRiVEaHje/ydlaT0NTuvoruHgvFsLERuy1HE3uEcO5pA1Kj/jk1Y+DFTu
	 qOZVz/bEDqzSnUcCv5no+gRqIu8SQHNDIMMH6ysJTAFoyuc1/Un+Jhto4INa4+F7si
	 EpX730O1X9K4qimCk3Mn6HMgS2OkCeflxWHlO7Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Rappoport <rppt@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 071/321] x86/mm, kexec, ima: Use memblock_free_late() from ima_free_kexec_buffer()
Date: Wed,  4 Oct 2023 19:53:36 +0200
Message-ID: <20231004175232.497291581@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

From: Rik van Riel <riel@surriel.com>

[ Upstream commit 34cf99c250d5cd2530b93a57b0de31d3aaf8685b ]

The code calling ima_free_kexec_buffer() runs long after the memblock
allocator has already been torn down, potentially resulting in a use
after free in memblock_isolate_range().

With KASAN or KFENCE, this use after free will result in a BUG
from the idle task, and a subsequent kernel panic.

Switch ima_free_kexec_buffer() over to memblock_free_late() to avoid
that bug.

Fixes: fee3ff99bc67 ("powerpc: Move arch independent ima kexec functions to drivers/of/kexec.c")
Suggested-by: Mike Rappoport <rppt@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230817135558.67274c83@imladris.surriel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/setup.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index fd975a4a52006..aa0df37c1fe72 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -359,15 +359,11 @@ static void __init add_early_ima_buffer(u64 phys_addr)
 #if defined(CONFIG_HAVE_IMA_KEXEC) && !defined(CONFIG_OF_FLATTREE)
 int __init ima_free_kexec_buffer(void)
 {
-	int rc;
-
 	if (!ima_kexec_buffer_size)
 		return -ENOENT;
 
-	rc = memblock_phys_free(ima_kexec_buffer_phys,
-				ima_kexec_buffer_size);
-	if (rc)
-		return rc;
+	memblock_free_late(ima_kexec_buffer_phys,
+			   ima_kexec_buffer_size);
 
 	ima_kexec_buffer_phys = 0;
 	ima_kexec_buffer_size = 0;
-- 
2.40.1



