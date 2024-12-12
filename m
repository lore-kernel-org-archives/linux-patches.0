Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3383E225403;
	Thu, 12 Dec 2024 17:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025381; cv=none; b=c7K4wnMvVb10Z1mkk29D34hBLQ8AQj/avvzTaKMl44RdAmvTGf7r7TvitFJiriO5fdSu7en4TEzzoeFHIctoBBOK+bz05j8fH2xG/JTQi2rPTsjGFRKghR48240iqv4XDQEcHuNSviQYmDCtiLxHvBVJeMS9MIlrOnUbAMnBzdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025381; c=relaxed/simple;
	bh=LMDFzIc3VDFkxjw0Xno1bDl4SgK/ifJAxK1DqBiEago=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PD73ZdFqyTxV2Eg37p0BJ5MtY2ZxJRah38oxnXN8JniobMJAnoG+IVjWIDpG91++SdtFf+bMuT4GjXFx+ITnf8/s7zM8uF4f0XVAE+Euyco+S0SCB6rOuTINaDPlS03eh6V27AxClp/sGaYdE7zFdFUudJqFI0IW3mIsTgMJj/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9DuVT/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9DuVT/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E05C4AF15;
	Thu, 12 Dec 2024 17:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025379;
	bh=LMDFzIc3VDFkxjw0Xno1bDl4SgK/ifJAxK1DqBiEago=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9DuVT/K5oJCMc7UHeoGxO8ZQdggyxwkpvFIzMyEm9Ijsqpa5slI5qtg9huq/79pu
	 mNB2kqwqrI48nold/hto+/4Y1/+/oGDuiLo78g7TCbRfTrv+iRFTkrtMWMyTXaMh/T
	 /z8cbS9WdXxiA68qNLMgRdeSBP7o1UitCsdMTDMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>
Subject: [PATCH 5.4 151/321] comedi: Flush partial mappings in error case
Date: Thu, 12 Dec 2024 16:01:09 +0100
Message-ID: <20241212144235.943000157@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit ce8f9fb651fac95dd41f69afe54d935420b945bd upstream.

If some remap_pfn_range() calls succeeded before one failed, we still have
buffer pages mapped into the userspace page tables when we drop the buffer
reference with comedi_buf_map_put(bm). The userspace mappings are only
cleaned up later in the mmap error path.

Fix it by explicitly flushing all mappings in our VMA on the error path.

See commit 79a61cc3fc04 ("mm: avoid leaving partial pfn mappings around in
error case").

Cc: stable@vger.kernel.org
Fixes: ed9eccbe8970 ("Staging: add comedi core")
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20241017-comedi-tlb-v3-1-16b82f9372ce@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedi_fops.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2383,6 +2383,18 @@ static int comedi_mmap(struct file *file
 
 			start += PAGE_SIZE;
 		}
+
+#ifdef CONFIG_MMU
+		/*
+		 * Leaving behind a partial mapping of a buffer we're about to
+		 * drop is unsafe, see remap_pfn_range_notrack().
+		 * We need to zap the range here ourselves instead of relying
+		 * on the automatic zapping in remap_pfn_range() because we call
+		 * remap_pfn_range() in a loop.
+		 */
+		if (retval)
+			zap_vma_ptes(vma, vma->vm_start, size);
+#endif
 	}
 
 	if (retval == 0) {


