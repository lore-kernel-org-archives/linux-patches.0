Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466893F20F9;
	Wed, 20 May 2026 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299520; cv=none; b=EpVFSp28b5SNmpAXpkUcOcR05pbS7IkBDfngSSFTVbsBzTIg8S421NMzCn9TYKl4Q0dWQkaPiT9ifsLJk7tdHSKBIk2c4d80rxwm0FnSF+2N/Tiy/MBmvZX/fO2ixoVGfKXLUME2wfFKdw6PqAH2xc/9mr/NdbCuiAVFUD700xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299520; c=relaxed/simple;
	bh=LcLIJ66I2ORGiE5+xL/Ci8EGerrn1ANbUTdig14MbyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQPZ3VQtLs8Wow87CVthpbFSy/auts4Fyn6XHNzPhEfW8EpJKUodBN13vAbtTCesFThvYIc02gSOgRIzl7nPmZ96yFrpTosuc4hA/6r9423/Yjs05nfk09tw4aYu4mpRMRMazpFdLHFdI/rvqGgJPz29So5S6LI8IUQwnVypNKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMnpeIXZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMnpeIXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647241F000E9;
	Wed, 20 May 2026 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299518;
	bh=97Cg3YdxLbzj2dJfBXuMkACRO/kWmDuiHUovQaLz+BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMnpeIXZJbAkvM31cSD2D5tJEoCMbAqh0aSNvHkcQapExlBzjb2elEZhUtiY5MXqL
	 5fHh/ld+b42QUcSSZLBS7b5OQzJGk6PTKb55MqDV8pA46Eveui115EHSQNxe92K4lF
	 2Z/UAsyV+yxKArbJuHDlTzWaecBcAUXXc/OZhTRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 796/957] s390/mm: Fix phys_to_folio() usage in do_secure_storage_access()
Date: Wed, 20 May 2026 18:21:19 +0200
Message-ID: <20260520162151.825492172@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit b95e0e792822bad8fc9eb33ea3a90005e29e75e9 ]

In case of a Secure-Storage-Access exception the effective aka virtual
address which caused the exception is contained within the TEID.

do_secure_storage_access() incorrectly uses phys_to_folio() instead of
virt_to_folio() to translate the virtual address to the corresponding
folio.

Fix this by using virt_to_folio() instead of phys_to_folio().

Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index d1f165048055b..069f72703a915 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -433,7 +433,7 @@ void do_secure_storage_access(struct pt_regs *regs)
 		panic("Unexpected PGM 0x3d with TEID bit 61=0");
 	}
 	if (is_kernel_fault(regs)) {
-		folio = phys_to_folio(addr);
+		folio = virt_to_folio((void *)addr);
 		if (unlikely(!folio_try_get(folio)))
 			return;
 		rc = uv_convert_from_secure(folio_to_phys(folio));
-- 
2.53.0



