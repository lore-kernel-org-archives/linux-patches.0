Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC7446F4A7;
	Tue, 21 Jul 2026 17:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655305; cv=none; b=YqmvMY88m4bqAPfjBPEHVD98CaZ28NJ+J5ioDl0MVuAjwVhu0cpGyAezGnS3wjkeyc2qsqUcQQy6v5MBYSfU0QjZLu8bvIaAmuyUNZ8zZtzdsHHCy80DYVwKhkqFaD16v265aiosnVfV4uSMFA9PJjKb452sqdvErl3b+7n2k00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655305; c=relaxed/simple;
	bh=sGCRmCOISNR+jOvR3Nw/uUnw3tCzfYo+9Qis0WqCr4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhPmAe8C2NmbigFl5BxSypsWIKVGU/TQZ/T0pHlJKu7B+rC/oIrWxNlehS1klRIZiClMmUr5YL03IRadL+YvrNOz1kBtubF3bke+OOYLFgMc9zYhCm5+FaML5D5iscZC3587rRecdI39vP10UaEyoo2urOsfHl88uwuoSyUAjZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dU00tzF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dU00tzF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503481F000E9;
	Tue, 21 Jul 2026 17:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655303;
	bh=Ut/1LGAZ7zx7r/ism5izmWssiW8angZlVbPd6ZYaxq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dU00tzF6yzvCb5HhLwl7wJ+xuzU4O8hy2hk4DvsofUv50jwWmgl5UAWV4MUuUeCE8
	 OsBO3YQI/FlYv4/rxgc2IVwUwVasdzI4bYpQQi3xdUuJSs37BbZWknLICdwrSxxV0i
	 CZGQV8L7nNAwYNfkD9BeiJJvFVtttu9fQtjv3pDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.1 1991/2077] s390/mm: Fix type mismatch in get_align_mask().
Date: Tue, 21 Jul 2026 17:27:44 +0200
Message-ID: <20260721152639.671517051@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -64,7 +64,7 @@ static inline unsigned long mmap_base(un
 	return PAGE_ALIGN(STACK_TOP - gap - rnd);
 }
 
-static int get_align_mask(struct file *filp, unsigned long flags)
+static unsigned long get_align_mask(struct file *filp, unsigned long flags)
 {
 	if (filp && is_file_hugepages(filp))
 		return huge_page_mask_align(filp);


