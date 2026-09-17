Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E624E73D1;
	Thu, 17 Sep 2026 17:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665567; cv=none; b=WzqWv3HOddNYMI6qy/bbzzycRFmpvuV1jZB+X9FtOW5ezxzKhcofOYcu6lZ7Pph9KbnPLS0TTR0qndjIerLRx/8tzzLNIdnBCmMwgUCZz3LAKmiPr2x3Ez3UjdRczsAyLLxVOCnW39w2yRwH8PNCH4iOsbIunmZ1Pf7oOBOo4Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665567; c=relaxed/simple;
	bh=kQZCoAdx5RkoQE3eZ/VW9S+KibinR93q2x5H/XUs5Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5zje8bYCtI8uofLoW9HrI1PBkdRqGB4+5fpuPxLwCf2U/RF8mEYsIOQJQilk93szsiXJe1Hgcmqpe6Q95Lq/Szyqs79bipgTo21c4YI8mvHH5ZAZJPidEjGPg5uaAf9Ba+DSJc5N0lBJz/rEU8h0b/aTCymElbzWX4kSPm+ZWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJ2Y/EEI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJ2Y/EEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13A81F000FF;
	Thu, 17 Sep 2026 17:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665566;
	bh=ai0YnVwI8pfoWJgP7cXUWhXvMg34Mo8fBTbbX7FJG3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJ2Y/EEI1yGqtkxfb8PLPcxUDAJ8CgWaAnk6FUBYaZ566RenSOt9irNmVQRGv7NzT
	 yccR7JoOU/589CGRD09oukcyk0y4mBGcL/u1qFtcAfSDPqZaeuYpGChQEHi5WbR7Tk
	 rEeeptgpLuiSdrfnZVwJtEZ99PlrkRmf0Y2FPiOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Yury Smirnov <yurymonzon@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0748/1250] arm64: trans_pgd: clone only the linear map that exists at runtime
Date: Thu, 17 Sep 2026 16:09:03 +0100
Message-ID: <20260917151612.158194635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 1537e55728ec2bc506c74ea69b93cd859da58fb8 ]

kexec_file_load() fails on arm64 if we have CONFIG_ARM64_VA_BITS_52 but
it runs on a !FEAT_LPA2 host (such as my loving Grace machine).

That is because trans_pgd_create_copy() uses the compile time
PAGE_OFFSET (VA 52) instead of the actual VA size (48 -- due to the lack
of LPA2). With the fifth level folded, pgd_none() is always false, so
the walk cannot skip the 15 extra PGDIR_SIZE slots, and they all alias
back to the same table: the whole kernel page table gets cloned 16
times, KASAN shadow included. Without KASAN it does not blow up, it just
wastes ~RAM/32 in page tables.

Fix it by copying the linear map that is the actual one, not the
compiled one.

Fixes: a6bbf5d4d9d1 ("arm64: mm: Add definitions to support 5 levels of paging")
Signed-off-by: Breno Leitao <leitao@debian.org>
Tested-by: Yury Smirnov <yurymonzon@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/machine_kexec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 28df62051cc97..e40db39bcb47b 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -129,7 +129,8 @@ int machine_kexec_post_load(struct kimage *kimage)
 	}
 
 	/* Create a copy of the linear map */
-	rc = trans_pgd_create_copy(&info, &trans_pgd, PAGE_OFFSET, PAGE_END);
+	rc = trans_pgd_create_copy(&info, &trans_pgd,
+				   _PAGE_OFFSET(vabits_actual), PAGE_END);
 	if (rc)
 		return rc;
 	kimage->arch.ttbr1 = __pa(trans_pgd);
-- 
2.53.0



