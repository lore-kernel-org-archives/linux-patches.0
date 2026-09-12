Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9704B37AA97;
	Sat, 12 Sep 2026 08:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200755; cv=none; b=G2nJ7VUcNbP8/K+PsbsIK0JJiY8qkzSq/tTge/ow2JKwmspcC+c7q3vsV/5ZiMjLOjSoRYyGltTwzd7CYVeAsoAL8VxY1HYhF3pg1+/p+bl7ESlE7Yo2oM6ALVm++EeNdtTjAkE73QepgNXb5iA1ZZ8itxUEcyOFjnpmMMNKVqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200755; c=relaxed/simple;
	bh=Wq5i2QvuKOKJWA/oUV7KBXFGMJA83NX3rpK6nSgF89k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1wTzhJzQkGROgu3XOXqjAXnmLR2EY3vJyY4CTeYEgcIcoKBsR+QrxMamr3f5JXPSA7LG07v4V8R8Hba6PC94oMHlg7DctOas6ciQDrgVZkXXnu1Ng4DsVHybs2g7vxscV7hgJny/KODdDi/JpX4u5gGt5/zi05Vs74ivM3O2hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPI74A2Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPI74A2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B931F000FF;
	Sat, 12 Sep 2026 08:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200751;
	bh=GI1ImOawxI0ksRL2MGDYplKSfHW7czwsg3uB+oeyBdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPI74A2Q6ppat4fD+BEUHGqo1I0IGUXRZJ0N2zeInw353l1vAoSoRi132Irl5K5nw
	 btCdyL/i6s9qexin8y11fB26fcJtveSu2Zjee9FMDpAPEWl1g7h+H2n7qou3C870zt
	 Lmq/YCWPzKq3Zb8U0XWPUmekC9CmZD85POY3ypz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0854/1815] powerpc/crash: Fix possible memory leak in update_crash_elfcorehdr()
Date: Sat, 12 Sep 2026 08:43:24 +0200
Message-ID: <20260912065708.969226664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



