Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA768511E90;
	Thu, 17 Sep 2026 15:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659336; cv=none; b=FrdVyPdyBgngsKoOqRr8B3h4NtrOh85WKZT1O54xwH4lXN9abL0kthm8hT5ZCOZrMfF4V7cL2nd/QNKWDSmC/AQCPSxG3UZeGG0yL+2w3WZskVKD1r+w41nxgysO0W14+XAl1mp0Iuw7PdAQ8RXHglueRGQC2IB7+yfWhETmGqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659336; c=relaxed/simple;
	bh=qWkRAC+kZ7WVf/ugzeI57+jBOFbddlISw+SOCLwUBPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFHhfJoKFCpy5SyTBHijQo19MaJ1BE7B0tq4zc3j8pyRkfAyAkyQnLpLBo0broaV/0Jhj7ZozN1j78rPzkYQEpqr5D4O7MHAXywnFyZvDubGzLKAhorjr4tEBNfY1xAupSW52pLxCc3iNOZfL4h11g2eleiN4DZKpMAUeYvbXfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfcMA9qK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfcMA9qK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BB91F00893;
	Thu, 17 Sep 2026 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659326;
	bh=s43cNHyQ+EY2JzB0SgaQTxueJGIL/bZiWO8yTVSHOis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YfcMA9qK2PDSww32F8llcNOOxUrJEejozzGFMEIxLe2qPOsz/U/Gv/VKmM98w23xa
	 1cXX4W2KxestVwdFavHGLO1CHKjZoapfoWCoy512kleYaM7k+i3kCL11jDH1qZpApF
	 TdUX53ZJP8NfEKei1/+PTTP4hQrZhx45xv2dz/yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Yury Smirnov <yurymonzon@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 220/733] arm64: trans_pgd: clone only the linear map that exists at runtime
Date: Thu, 17 Sep 2026 16:08:48 +0100
Message-ID: <20260917151356.686911500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index c5693a32e49b0..8f9bc2327dc85 100644
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



