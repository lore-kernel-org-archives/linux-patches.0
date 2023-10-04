Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37BB1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005F5C433C7;
	Wed,  4 Oct 2023 18:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443278;
	bh=cBVKFjnUKC09UEBclA+WGL27oZHQDcKsnVPRsRU7Y78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6gOxZG8soKoDzUmxr8P2tTRK4IuMvEF+dHYYRoIRB1aNsujebZ+LoZeKw/z5h2oP
	 4h87CQXAKj3pofXEAHvf56hj8/fUn5s5sP4ZBQl9GlYrUvC3oWTkBlsulL/EC3RSh7
	 Wzxo2SCjZD5rJje4YGBOSxsby1nJfrGhd9chUIac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Rappoport <rppt@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/259] x86/mm, kexec, ima: Use memblock_free_late() from ima_free_kexec_buffer()
Date: Wed,  4 Oct 2023 19:53:54 +0200
Message-ID: <20231004175220.221224682@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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
index 892609cde4a20..804a252382da7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -363,15 +363,11 @@ static void __init add_early_ima_buffer(u64 phys_addr)
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



