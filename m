Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31D443B6E1;
	Tue, 21 Jul 2026 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674566; cv=none; b=Yz0Ci4v7czlFXQD/WK7BxFbISgKl0QdTey56fMKlkV70YKZptxks+haYJL8dJmeF/hrF+7XXjOTPcedhCI4bjM+rzROunzqjAV56Q7c5jaqBerfOxWbBocUXyve6PRJam6D+UzCiOSCwTeuJlVGpS+3NhL4u5sl7tMo4/bZe/00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674566; c=relaxed/simple;
	bh=thSJakGvrx4ok0Zp+EkhkJwU7pzpd9QeGEjzROJp28U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWWtvaGN8g9s4dj/cKqNc0A+35vw3l94mZcwv+rtPF2T4hKx2FHMhb+RaS/3FfVMhCHe8enRQWiGzDMSH1iYbkjuk7t8kCoEx7PC57vtT0+89uNcrSRc3girjSfDY1W/ncj5rwnwMV8Fx38h+DvclOE/utqrVC0ABTWFyV2+nsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LN3/bOVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LN3/bOVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654F91F000E9;
	Tue, 21 Jul 2026 22:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674564;
	bh=nooJySrHn3O114KOahA8eee1I5+5J9qtoX5SefxpzUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LN3/bOVw41KP9w7ugx9lIKJHgGpD0XmCRPb4lHI8L0yjff5+ckSs02Q9wqJXks4hZ
	 d/RLTaasBpHbhBWZai0Lt3iGGbbZm2MejXEjCJ5WENDVX7sZrquycJ7C/UwAcuqTMR
	 j1OBV0PKvHinhVzRY/7vfLMOThLt0UVLkahyUqAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 546/699] fsl/fman: Free init resources on KeyGen failure in fman_init()
Date: Tue, 21 Jul 2026 17:25:05 +0200
Message-ID: <20260721152408.019590542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d288efa2b94abc2e45a061fceb156b4f4e5b37be upstream.

fman_muram_alloc() allocates initialization resources before
initializing the KeyGen block. If keygen_init() fails, the
function returns -EINVAL directly and leaves those resources
allocated. Free the initialization resources before returning
from the KeyGen failure path.

Fixes: 7472f4f281d0 ("fsl/fman: enable FMan Keygen")
Cc: stable@kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260625004834.3394389-1-haoxiang_li2024@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fman/fman.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -2022,8 +2022,10 @@ static int fman_init(struct fman *fman)
 
 	/* Init KeyGen */
 	fman->keygen = keygen_init(fman->kg_regs);
-	if (!fman->keygen)
+	if (!fman->keygen) {
+		free_init_resources(fman);
 		return -EINVAL;
+	}
 
 	err = enable(fman, cfg);
 	if (err != 0)


