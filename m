Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1EC21C9FD;
	Mon, 18 Aug 2025 13:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522176; cv=none; b=EUk1EQxQNz4E65qhjDM3PFvf7WnnvBj3kkPsA4hNyFzS2Tjxo/nsnciTr9uxzgUctr/gKsG/pdLtB3BQ9xP0DfHocyzEdPVhSPdRVK5Zo9EQA7TR5At6pfjqIHEXXlJFphEmOVZ7a5XdOJBMmtzA0SZnvpYx2dP7cITlCZf1e48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522176; c=relaxed/simple;
	bh=hC6gALGHFbnYEDMLE3Logo0BibtMbH/swzHWfUoZClU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZFgYvCm3T4ZduXAgNT0SVJy8jGSX0Fbk8KJ8I/jGY87S/49gQkKHuelGIqc2SYtaf8r6biE85eGH/24addXn1mfcOOGCpm4mqyBTrfKZLcwNLwnbkmP/4VTBnp5PeGJLHLbVyu6lZ+QjAa6TpfitBlSh6ghkKWbSlOrSgASrg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UKzzWIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UKzzWIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE16DC4CEEB;
	Mon, 18 Aug 2025 13:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522176;
	bh=hC6gALGHFbnYEDMLE3Logo0BibtMbH/swzHWfUoZClU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2UKzzWIN3j90p2q5jOnzBEkuXW9J1PZScmIrAxZgy7yjktvmRShhbwHooFGY3Bju+
	 SIjSWnacZFkjEC8Z0NeCRu0FEaiPA22ldouC89m7NKuQ7j4xloF2qKFncwTptnEmgg
	 ajVvY9v6U1tE6+bmTh7TMcZs8Iv8h1GAmsQZa7Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/444] powerpc: floppy: Add missing checks after DMA map
Date: Mon, 18 Aug 2025 14:44:24 +0200
Message-ID: <20250818124457.754192738@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit cf183c1730f2634245da35e9b5d53381b787d112 ]

The DMA map functions can fail and should be tested for errors.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250620075602.12575-1-fourier.thomas@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/floppy.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/floppy.h b/arch/powerpc/include/asm/floppy.h
index f8ce178b43b7..34abf8bea2cc 100644
--- a/arch/powerpc/include/asm/floppy.h
+++ b/arch/powerpc/include/asm/floppy.h
@@ -144,9 +144,12 @@ static int hard_dma_setup(char *addr, unsigned long size, int mode, int io)
 		bus_addr = 0;
 	}
 
-	if (!bus_addr)	/* need to map it */
+	if (!bus_addr) {	/* need to map it */
 		bus_addr = dma_map_single(&isa_bridge_pcidev->dev, addr, size,
 					  dir);
+		if (dma_mapping_error(&isa_bridge_pcidev->dev, bus_addr))
+			return -ENOMEM;
+	}
 
 	/* remember this one as prev */
 	prev_addr = addr;
-- 
2.39.5



