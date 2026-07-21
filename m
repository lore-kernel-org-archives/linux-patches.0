Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25DE46D2A4;
	Tue, 21 Jul 2026 17:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654050; cv=none; b=aaqTvCqnHG6b7yjz3gJP7MJSfDZt2or5xhjDqSv2idhXQRXLi91K54v0mrfYQPV/Ht+GgZCKnwKj/TdAW7Zp6MjPf6RaU0MLqBZtiPm8i3a8KBR4tx1fKbCgM4bcgZQb3dCIpWD1qgUOujBf0lVx6ZyI2ChtEm3m6l6ZR7j7EV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654050; c=relaxed/simple;
	bh=05xHX1PBL2Qzz8+g3VYUG7F9yilJH7KbR1Des/EAens=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3Skte62XN1RGgytL/WidUwHh+dHk18xyk+4NClQkNn2YO5a/hDGyrZABmJy/AXpx6GL6lcTZ/yRZx/IoCaiZeNPim/5adnsHc+WJID7PGJfq1D2loMju+Sf2Jn1zTGCJpm/9zDknAmWbXtkAujdbpIZvEoF053Yaidgx+xgiJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4n1EaCw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4n1EaCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347121F000E9;
	Tue, 21 Jul 2026 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654049;
	bh=vC5vDrPL+bmUq0X61WQ7z4n822cNHgM8J8/sIL6px+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4n1EaCwwJw90G2qxz0jd6PnWWyXkuHmiBCL1PNO0xb68PKZEs/nGLPXMLDNPzCh7
	 42S4PuKxvoEZ/akxWNKRgpmP2vhLjZJi3kTfg04hA2cFQjYVzb13CZxX7z/mcl9LHA
	 Bqwgxz3Z4lbWFUVag6bJpcU6oK3AUDU8ETvePnZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.1 1557/2077] KVM: s390: Fix unlikely race in try_get_locked_pte()
Date: Tue, 21 Jul 2026 17:20:30 +0200
Message-ID: <20260721152629.505622699@linuxfoundation.org>
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

commit 5670b7f927f8d98685f3f5873dbf9f8d7a5a63f3 upstream.

Fix an unlikely race in try_get_locked_pte(), which could have happened
if puds or pmds get unmapped between the p?dp_get() and p?d_offset()
functions.

Fixes: 89fa757931dc ("KVM: s390: Avoid potentially sleeping while atomic when zapping pages")
CC: stable@vger.kernel.org # 7.1
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260611104850.110313-3-imbrenda@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/gmap_helpers.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index 1cfe4724fbe2..ee3f37af8aee 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -51,15 +51,15 @@ pte_t *try_get_locked_pte(struct mm_struct *mm, unsigned long vmaddr, spinlock_t
 	pgd = pgdp_get(pgdp);
 	if (pgd_none(pgd) || !pgd_present(pgd))
 		return NULL;
-	p4dp = p4d_offset(pgdp, vmaddr);
+	p4dp = p4d_offset_lockless(pgdp, pgd, vmaddr);
 	p4d = p4dp_get(p4dp);
 	if (p4d_none(p4d) || !p4d_present(p4d))
 		return NULL;
-	pudp = pud_offset(p4dp, vmaddr);
+	pudp = pud_offset_lockless(p4dp, p4d, vmaddr);
 	pud = pudp_get(pudp);
 	if (pud_none(pud) || pud_leaf(pud) || !pud_present(pud))
 		return NULL;
-	pmdp = pmd_offset(pudp, vmaddr);
+	pmdp = pmd_offset_lockless(pudp, pud, vmaddr);
 	pmd = pmdp_get_lockless(pmdp);
 	if (pmd_none(pmd) || pmd_leaf(pmd) || !pmd_present(pmd))
 		return NULL;
-- 
2.55.0



