Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613715B5AB;
	Sat, 17 Oct 2026 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253666; cv=none; b=cnZkfAgwhe6aFyZU5lCNtUUXxj8UCOF0AWpECXlpenjBDdKHwCr4lWTPE44HiDai1gMTTFp3EmbP6yC5sooWrsx7Li+yL+vSmhUMDoC3jcUdb2rXZasL+3dkL3yeLWFH/poPcJJoteu+OMv7HXQ2R0hrm/Rl9DCY7ghIQlXKywg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253666; c=relaxed/simple;
	bh=anbLRRsr6sy+oS8+dW3XfO/vpnvfdWtQYfLFsgN8mIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIfqIglJtdKxIIZq4gk7DBz4JKZFd/EYnkdEirOUsQGf1zasShmJ87uz/iYDq39HmASCW9Aikm1iNBCPa77mQvrrPBV9O6oDPIivDW6QftnsdBkS6JwZ4IllF+iHRFaeSx04MAO4ogBmfnhGoF6SV182cQ5PTiaCDPaMkcYZAhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Byp81zCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Byp81zCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD071F000C4;
	Sat, 17 Oct 2026 16:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253665;
	bh=1OdkvEDdNGvcRTC9ecz6Q+N6VumQXlKS3w5htmYgFVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Byp81zCRykjtM9eEs1EcI0sbHFd5tESXRgh4DQEkavH/2t3MJiIsMOd12/utDGMXZ
	 uUVgnrscK9V4614ZERE0eLe/kkz/26uotKGBWA8ec9691Fj5qoUDEZP83SCmVimzsZ
	 dplFUA6s+SWkwM3yAEI4i4e+LvZAwX2aMimS7kQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/869] s390/mm: Add missing secure storage access fixups for donated memory
Date: Sat, 17 Oct 2026 17:50:33 +0200
Message-ID: <20261017160041.977775533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janosch Frank <frankja@linux.ibm.com>

[ Upstream commit b00be77302d7ec4ad0367bb236494fce7172b730 ]

There are special cases where secure storage access exceptions happen
in a kernel context for pages that don't have the PG_arch_1 bit
set. That bit is set for non-exported guest secure storage (memory)
but is absent on storage donated to the Ultravisor since the kernel
isn't allowed to export donated pages.

Prior to this patch we would try to export the page by calling
arch_make_folio_accessible() which would instantly return since the
arch bit is absent signifying that the page was already exported and
no further action is necessary. This leads to secure storage access
exception loops which can never be resolved.

With this patch we unconditionally try to export and if that fails we
fixup.

Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index f907e916aa20d..2d03af60ed88f 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -443,10 +443,17 @@ void do_secure_storage_access(struct pt_regs *regs)
 		folio = phys_to_folio(addr);
 		if (unlikely(!folio_try_get(folio)))
 			return;
-		rc = arch_make_folio_accessible(folio);
+		rc = uv_convert_from_secure(folio_to_phys(folio));
+		if (!rc)
+			clear_bit(PG_arch_1, &folio->flags.f);
 		folio_put(folio);
+		/*
+		 * There are some valid fixup types for kernel
+		 * accesses to donated secure memory. zeropad is one
+		 * of them.
+		 */
 		if (rc)
-			BUG();
+			return handle_fault_error_nolock(regs, 0);
 	} else {
 		if (faulthandler_disabled())
 			return handle_fault_error_nolock(regs, 0);
-- 
2.53.0



