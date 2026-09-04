Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D82A3A961E;
	Fri,  4 Sep 2026 05:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499127; cv=none; b=B1wJQyTe//9xYTDKhglM6ut3jIbSHB6r4vS3Fzme9FMa7Wf66JGJ8Ku1CBgbNyL/zQWEN/xAEKm3ldLmUHRQjWt2i21jVGZDTEq5CBcscHV01ZDbHKklwfpr9V6xnzWPbxSEqx1cdtAPD1glB2ys9O4Z7/kkW/uLs9VUmUfDDVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499127; c=relaxed/simple;
	bh=Cm4ZPpndFyi/aTbbG1BiCED6CHdAEcjUzrHACddB3bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIdOzlaM/bibQdpupkYALdSqt5yQi9ZhQsgLs8MxU4CpzgbSTame7H2V3F+Lx29HyLMEL5aucfryxBG+u4+nJXd8OLmiOUO3ssZ9ve7PIInizCV/qjiAWdJ84R1q+4HUoTmRNtATLHVOd90k/CjlGVlCIr6Yau6OsJ+knyMEY3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ungcBb6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ungcBb6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D191F00A3E;
	Fri,  4 Sep 2026 05:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499126;
	bh=l78x32V13GOlopfLvK1NEA2DlzjHPPplyNlI21dgHw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ungcBb6kiRvkMXLbJaVWqhcl20ggo4pNELmNC5eCgWBxOgz8f/5JSC69Qli5u4TK8
	 2JNqH9KOgErImTMmBGREySQ8eOAKQfy6ypl+5ysalQ7Y06MP88dd9/rzwMr4mIs4EZ
	 GfkNFxRLva+pNAOZkHpwQtk2KvzFAD4N8ycmNVoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH 7.2 305/713] alpha: marvel: Fix irq_set_status_flags to use correct IRQ number
Date: Fri,  4 Sep 2026 06:54:33 +0200
Message-ID: <20260904045810.675577806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Matt Turner <mattst88@gmail.com>

commit 3a3ac1f6c6a67b3803f2643584310f78301e58a8 upstream.

Pass base + i to irq_set_status_flags() to match the IRQ number
used in irq_set_chip_and_handler(). Previously, IRQ_LEVEL was set
on the wrong (low-numbered) IRQ descriptors rather than the IO7
IRQs at base + i.

Cc: stable@vger.kernel.org
Fixes: 08876fe8519c ("alpha: marvel: Convert irq_chip functions")
Signed-off-by: Matt Turner <mattst88@gmail.com>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20260528230516.1839694-1-mattst88@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/sys_marvel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -275,7 +275,7 @@ init_io7_irqs(struct io7 *io7,
 	/* Set up the lsi irqs.  */
 	for (i = 0; i < 128; ++i) {
 		irq_set_chip_and_handler(base + i, lsi_ops, handle_level_irq);
-		irq_set_status_flags(i, IRQ_LEVEL);
+		irq_set_status_flags(base + i, IRQ_LEVEL);
 	}
 
 	/* Disable the implemented irqs in hardware.  */
@@ -289,7 +289,7 @@ init_io7_irqs(struct io7 *io7,
 	/* Set up the msi irqs.  */
 	for (i = 128; i < (128 + 512); ++i) {
 		irq_set_chip_and_handler(base + i, msi_ops, handle_level_irq);
-		irq_set_status_flags(i, IRQ_LEVEL);
+		irq_set_status_flags(base + i, IRQ_LEVEL);
 	}
 
 	for (i = 0; i < 16; ++i)


