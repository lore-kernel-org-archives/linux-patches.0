Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6691947044D;
	Tue, 21 Jul 2026 20:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664180; cv=none; b=lb4Bezx60sfwVlw2N4ZM9SDnoykG2OYm+r7SbEW/LsfCE2zHwxdbn5OxIke9fBB9tBLeGYDoEItti1/SNPpuup1OfXvHpud50tI1j5mcXqmvuwSZNX6ZIsGHyHI7NcasruWS1CIydjm9wowZYSss7rx3by9dQSO4pBbFxrg39Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664180; c=relaxed/simple;
	bh=vYUXMjKP/dsB9azFh7vIXLq4hDfX9hYtm0EhdbwM4+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUAySEedcLoeQMZMrZZqaxGsaODzH8ZjHMAfA4+KBOTZKcKLT8YpjI3Fwcv2bNxwf4csIXepL6InujfccOS9D7h+u/B4iJwHkwAHFjhzhYM3vx25AsKMXLKW3soBTi1309X7SmWZSnDsodNsjL0hfIgwFvY6g2OTH5Bee88E+xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1K9Yhny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1K9Yhny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5CB1F000E9;
	Tue, 21 Jul 2026 20:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664178;
	bh=qWE/hmQlzteqwfZaEPNufR0Uh+jpCX5HFEviifx5ouQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1K9YhnycWDZdg2E7KtRHm5tuUD6nVnc19JMGOoWiAxiZjALomPLi+CidY108MZpB
	 HAabtJ6ARxaTB9uUeoUNoLK+WsO/scRUalP5ifM8kvTP1QgKHBrsSUXV0A/M3kmiMC
	 uZUXRi3YO+X1mUzkgluwOtqBzLiKyB/2epuSmRPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 1100/1276] s390/mm: Fix type mismatch in get_align_mask().
Date: Tue, 21 Jul 2026 17:25:43 +0200
Message-ID: <20260721152510.604343865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit ec84aad4c3594307d103af563991b4415ac5c8ab upstream.

Commit 86f48f922ba79 ("s390/mmap: disable mmap alignment when
randomize_va_space = 0") introduced get_align_mask() with return type of
'int', while the target field 'info.align_mask' in struct
vm_unmapped_area_info is 'unsigned long'.

With currently used masks, this should not cause truncation issues, but
fix it and return 'unsigned long' to avoid future problems.

Fixes: 86f48f922ba79 ("s390/mmap: disable mmap alignment when randomize_va_space = 0")
Cc: stable@vger.kernel.org # v6.9+
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -71,7 +71,7 @@ static inline unsigned long mmap_base(un
 	return PAGE_ALIGN(STACK_TOP - gap - rnd);
 }
 
-static int get_align_mask(struct file *filp, unsigned long flags)
+static unsigned long get_align_mask(struct file *filp, unsigned long flags)
 {
 	if (!(current->flags & PF_RANDOMIZE))
 		return 0;


