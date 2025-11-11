Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CF92857F0;
	Tue, 11 Nov 2025 01:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825559; cv=none; b=sH93xnskMLdkVSt7w7btEjjQr7zTjuVe29f2GIktD2Hw/H4nhlE0Q16xDE3saFoMWM2drMG6r55QuUfw6qDCUeBvbL/eMa6XcthQiwN7L3f0qmDrciG3XFX7TUaHw3qIKPDNTBlWYiX4OEmycvsEuW43qgfnMzIQC5qJx7aEjhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825559; c=relaxed/simple;
	bh=lZ/za5f0N8LyTuWt0OnB7vYZog6I27hI1Bybw+rh+rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rr8A0689Ba7ztPvWloxJoPuOvaxZ2bLZIG/Tx/Tx+/BCapYZNth25Ob4Or4dkfGSb8Z14VgFZduNa4YT6ZCjqqAysKSRD9sDl/DhWOwFBxOlGeO6zhlUB3edrELkNb7qfHgrLLnL4lXJ37C84yLXt1xqk0htkPobM8im2xXo2uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtQGYrFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtQGYrFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36213C116D0;
	Tue, 11 Nov 2025 01:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825559;
	bh=lZ/za5f0N8LyTuWt0OnB7vYZog6I27hI1Bybw+rh+rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtQGYrFwvpbkWWMiQEZK9A6fcurLFHz9YLBgeiUiK4lMipoXLXpEjru3qYwpYtL47
	 Ch/pgAWL82pQX6owwtIsl7KPTvDNNwfDz3hcYbKd8nVuGAn2ArNeCrnpId3JstYK2X
	 BtpEedfdeS3U4yQihVf1uceZQPCwLRjaNcRCPEco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.17 811/849] riscv: Fix memory leak in module_frob_arch_sections()
Date: Tue, 11 Nov 2025 09:46:21 +0900
Message-ID: <20251111004556.033235633@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit c42458fcf54b3d0bc2ac06667c98dceb43831889 upstream.

The current code directly overwrites the scratch pointer with the
return value of kvrealloc(). If kvrealloc() fails and returns NULL,
the original buffer becomes unreachable, causing a memory leak.

Fix this by using a temporary variable to store kvrealloc()'s return
value and only update the scratch pointer on success.

Found via static anlaysis and this is similar to commit 42378a9ca553
("bpf, verifier: Fix memory leak in array reallocation for stack state")

Fixes: be17c0df6795 ("riscv: module: Optimize PLT/GOT entry counting")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20251026091912.39727-1-linmq006@gmail.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/module-sections.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/module-sections.c b/arch/riscv/kernel/module-sections.c
index 75551ac6504c..1675cbad8619 100644
--- a/arch/riscv/kernel/module-sections.c
+++ b/arch/riscv/kernel/module-sections.c
@@ -119,6 +119,7 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 	unsigned int num_plts = 0;
 	unsigned int num_gots = 0;
 	Elf_Rela *scratch = NULL;
+	Elf_Rela *new_scratch;
 	size_t scratch_size = 0;
 	int i;
 
@@ -168,9 +169,12 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 		scratch_size_needed = (num_scratch_relas + num_relas) * sizeof(*scratch);
 		if (scratch_size_needed > scratch_size) {
 			scratch_size = scratch_size_needed;
-			scratch = kvrealloc(scratch, scratch_size, GFP_KERNEL);
-			if (!scratch)
+			new_scratch = kvrealloc(scratch, scratch_size, GFP_KERNEL);
+			if (!new_scratch) {
+				kvfree(scratch);
 				return -ENOMEM;
+			}
+			scratch = new_scratch;
 		}
 
 		for (size_t j = 0; j < num_relas; j++)
-- 
2.51.2



