Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEECA2F12A4;
	Fri, 21 Nov 2025 13:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730894; cv=none; b=GwcLnbhOC8VkpdDHFeqKRwi5CUxuAw99hHI+dvhFMHQhwsjSAcy8PB2g3XWmGMMnX3hSxVKgx+1mwgUruJaTfBB6Cy39Ne6EgM6tqu6QhdDzi6wcKwy8aVL8WS3QliZfHs46FDxZUsa0KIvjF20gPjkwiXHYTwh9KAi6ynGD1Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730894; c=relaxed/simple;
	bh=WkBbdcbQ6vIKatlEJtkMR4j4sA5sPAJSx3ATtePqUM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VISeYQ3rTkTksVFODP12lenbVwc8CKnx1TVYqvHB7B2FQjtfivZPOdE/JGrJXvH2YsQvG642GzkXCBSQAVCVyT58FY/3yjejf1KFXI3VCblBpyZclMN3lHbmCn1aSzb1GknbC2BP6A6ClpseoLVxJsc+S1lHpRFD8vitqpKBVFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWLAA+FW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWLAA+FW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581D4C116C6;
	Fri, 21 Nov 2025 13:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730892;
	bh=WkBbdcbQ6vIKatlEJtkMR4j4sA5sPAJSx3ATtePqUM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWLAA+FWVnrlquftBJ3I8/oTC7FvFlQVD12cpSKnqDBP/BQrV1UUzGXHpmlMrgVIt
	 zT30z3LJpsm0vvmAsKxNzmGfrMN02uEnJeFRcqucIQZ+JG4OhlBisarH5LBQS01t6h
	 UJHMAGkUGC5+Wfqu8quoWGBDltX0vcIhZtrNf+cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 019/247] arm64: kprobes: check the return value of set_memory_rox()
Date: Fri, 21 Nov 2025 14:09:26 +0100
Message-ID: <20251121130155.290725985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Shi <yang@os.amperecomputing.com>

[ Upstream commit 0ec364c0c95fc85bcbc88f1a9a06ebe83c88e18c ]

Since commit a166563e7ec3 ("arm64: mm: support large block mapping when
rodata=full"), __change_memory_common has more chance to fail due to
memory allocation failure when splitting page table. So check the return
value of set_memory_rox(), then bail out if it fails otherwise we may have
RW memory mapping for kprobes insn page.

Fixes: 195a1b7d8388 ("arm64: kprobes: call set_memory_rox() for kprobe page")
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/probes/kprobes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 8ab6104a4883d..43a0361a8bf04 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -49,7 +49,10 @@ void *alloc_insn_page(void)
 	addr = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
 	if (!addr)
 		return NULL;
-	set_memory_rox((unsigned long)addr, 1);
+	if (set_memory_rox((unsigned long)addr, 1)) {
+		execmem_free(addr);
+		return NULL;
+	}
 	return addr;
 }
 
-- 
2.51.0



