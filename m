Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766F93ACEFE;
	Tue, 21 Jul 2026 21:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670350; cv=none; b=NSqus1K2bro6rXZ4MVXSaK0P/AtAc3QW1KIMzSBL2/jATx/Ty+G8DC2mOkL90YXw0yxe4fK4ve91pBofUhh/RhDTGMGtLXRE0XjHSrk1yakqandyCk+MW8Vq+/bWCGP1FMslgmZc9HWQWGDtQ7tG9yzcehFmwxolAoO8kMHEfE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670350; c=relaxed/simple;
	bh=dcMfH98pBM8m0gejjHYgZiI0zcqJs0KqmA2diYvHjjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxAg28PGHXn/pRyeqRse9CFXfE9DFwu+aE4jRGl8GdaXap8qGXfLvL0Z+jmnvJcNOJHT080lUxZOGNxvKDYO+yE9X13L08hc3XzAX1JPpkpa35ceCjP+vRDWA7iqu3Xg8hXmYtq7LUt8kkk1DB+1Xsz0ymtCa2sI44aR0DlQaf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFmPFM33; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFmPFM33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C561F000E9;
	Tue, 21 Jul 2026 21:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670349;
	bh=CzRhVWBb3tNEdYx6B3JTxhx/Pi3Jy+DuD64xo0WApBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFmPFM33DsRSKMsqxZr0UkMkllQ4SMzTQXxEKaDPsoCJfSwUmsB9G8FyJU15lZVfo
	 keE3JNv+2/gP4U6Psz0a7E0hPpowSD3BdmSldrixt2ZdmwIh+P9XO/7jwVMNllnyUT
	 b01VrFrgt7Qn2eK2C1ye33be7SZRlaplRfJBBgb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 0900/1067] fsl/fman: Free init resources on KeyGen failure in fman_init()
Date: Tue, 21 Jul 2026 17:25:01 +0200
Message-ID: <20260721152444.666704808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1995,8 +1995,10 @@ static int fman_init(struct fman *fman)
 
 	/* Init KeyGen */
 	fman->keygen = keygen_init(fman->kg_regs);
-	if (!fman->keygen)
+	if (!fman->keygen) {
+		free_init_resources(fman);
 		return -EINVAL;
+	}
 
 	err = enable(fman, cfg);
 	if (err != 0)


