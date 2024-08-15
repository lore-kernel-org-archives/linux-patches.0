Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5731AC893;
	Thu, 15 Aug 2024 14:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732779; cv=none; b=Bg/HB35jeoRCRk+ZBG/us77Cli2Vo+nFiDHH1ZMQo8Y5Ef2HZOw0a8NNvbJ6cBwVMW1Rs6OG8J5N3bpVkZWxkjaJscN+FDOMRZPagzFDwDr0n7m9wJYF8gmYqmQa63X9qvn0NTpNnVZf8jB928NDSN2emjgtS92DBLKa4TNn+yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732779; c=relaxed/simple;
	bh=OqubQMwMyWFJUYiWSMe6NtjwHvi/oPUwA6gnypFFhJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNohhnWQBvd7vXLbaLbnpw1aviZUum4zJVZqldosTfTWYE/Irhy0xFx4RxmieQSU++a7VcVVlvHCSlzDVjj/HTmB2DBb8mN0DI8xwqBq9Sfsv5R/5x445tgVkNYiV5YIIJ1PAYsek8hmWty4hM40rYzLS0mwO7k1gQfD5Mqo/uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJmmKFrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJmmKFrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95784C32786;
	Thu, 15 Aug 2024 14:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732779;
	bh=OqubQMwMyWFJUYiWSMe6NtjwHvi/oPUwA6gnypFFhJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJmmKFrLiSYPHBVEkSFYlahY6KRggH0vfZ61/8DMTawSNuAYpoer6F9nhxiw0BbpB
	 or6cepiZh024Bp3Yu53kVbdemnL4CJNfSWZ0BefUaSN0CZmPucZ5nVTYGmeyXF8tPp
	 pesktU/qqWKuf9YWbFbMsR6QJ2JVm3d9psRyWsKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/352] x86/mm: Fix pti_clone_entry_text() for i386
Date: Thu, 15 Aug 2024 15:25:18 +0200
Message-ID: <20240815131929.179037145@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 3db03fb4995ef85fc41e86262ead7b4852f4bcf0 ]

While x86_64 has PMD aligned text sections, i386 does not have this
luxery. Notably ALIGN_ENTRY_TEXT_END is empty and _etext has PAGE
alignment.

This means that text on i386 can be page granular at the tail end,
which in turn means that the PTI text clones should consistently
account for this.

Make pti_clone_entry_text() consistent with pti_clone_kernel_text().

Fixes: 16a3fe634f6a ("x86/mm/pti: Clone kernel-image on PTE level for 32 bit")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index 59c13fdb8da0f..50e31d14351bf 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -497,7 +497,7 @@ static void pti_clone_entry_text(void)
 {
 	pti_clone_pgtable((unsigned long) __entry_text_start,
 			  (unsigned long) __entry_text_end,
-			  PTI_CLONE_PMD);
+			  PTI_LEVEL_KERNEL_IMAGE);
 }
 
 /*
-- 
2.43.0



