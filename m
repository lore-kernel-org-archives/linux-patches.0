Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E8440710B;
	Tue, 31 Mar 2026 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976262; cv=none; b=gihIfdOHwwhDm0mxDyKAIOxnWWUqYMt1elOli8IWPVUc+BKrxZqtuMQeA2MMIKy+Oy1tmiQZoScNRrxM0Zd9Rfh6JAM1ehcEUIvgWUkNsq1oq8URObEfeVhivdxZLyhBqBQ9rCbqMF3gE1v/AO16nBHvLVAEn6+ysP6aceceS/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976262; c=relaxed/simple;
	bh=qTXGmUe7Gc8aioYk/wGSGKgQPe/2J2dy4krgts7H4BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQp9pJfqGCrL5j1Pah+AOru952MTS6UDQcV1Un9QKe+WWoE0b+HD5JGxg7vmW3Eae0fFFYXy6ObHcU27tAnqFSf3vl3hxEUeR+VrZijiVxxD4YfAdV5Y+lTwKK9DiJQCUo5l/nUUW+39ceS6f1UhtjNHU7PpDYEN8LPpYlx4e80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nm8GCxdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nm8GCxdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC8DC19423;
	Tue, 31 Mar 2026 16:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976261;
	bh=qTXGmUe7Gc8aioYk/wGSGKgQPe/2J2dy4krgts7H4BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nm8GCxdR74+t+oAsUAx+n6G25BQlyZh0AX2K8QgEvA0eYNVNSsZSUlvMmoKiGYQ0g
	 gOYEkz6F91VGSD9w/NjVrcRovXEW5mlyVouCidYTG7oNkAIHBgkHw5jOIASsGyzXOp
	 cJE9GyOa7VKUQ244U7Up4MthIJlsGI3JQRSFFDgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/309] s390/mm: Add missing secure storage access fixups for donated memory
Date: Tue, 31 Mar 2026 18:18:29 +0200
Message-ID: <20260331161753.710840205@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
index e1ad05bfd28ad..d1f165048055b 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -436,10 +436,17 @@ void do_secure_storage_access(struct pt_regs *regs)
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
2.51.0



