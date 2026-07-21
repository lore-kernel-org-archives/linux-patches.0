Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2BD42D76B;
	Tue, 21 Jul 2026 19:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660902; cv=none; b=DGFRYN747aG9jxW60RxveUxL8W3BM49Oqn2CquJKTusGM/deQZ/9f/ednWD8SFYs7mYoaczbFWi9Y5OEpdYFO/PJUhzKdgVUH1yHfe/IuO/Vs1f6uNHfnDFHj/PCl0O41XC6ashfxlwgXZQgsLpWhl2w3ad8f5Qs84QCpcK6GBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660902; c=relaxed/simple;
	bh=TGOndpyuKVbcotlCeRt04EQp8N/Y4k16axbyDwlTV4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSCaSICrarmZtmeB6ZTWvYRI15/rHp7wLJpeoCuTWwNjv+G4ee7hNb6AdMX2eUnOqilXti91mDna6DCGu0TpHYyJjcLUD9W5nJxXBtDVRqcZgsSVUKV3uTWuH/IYs8L0ZEneuZB6tWG7KwGzPB4mxz1pX9aB+OreAeCJlNWtsIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQdE7vHX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQdE7vHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39BA1F000E9;
	Tue, 21 Jul 2026 19:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660901;
	bh=ATOcxXfKFSjoRQmvwrCbcHBsGgb1ip+d8ik0O79xins=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQdE7vHXgj6HDEku4BBmfwl1pQ8vYcPYO39HOE9elw/JTRU9rF8QZZoBjKaoWk67E
	 LwSEtT3ZTyMP+ZlxhpWKFOq7B4QC8CCItcKRSZYZOF7nRqMPwbQhvhFkE0gJlyWQT1
	 7rnWA+htqaPutOAji0Ioz6h1iJAvqfJGq1LJ3VmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksey Makarov <amakarov@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1111/2077] octeontx2-pf: Fix leak of SQ timestamp buffer on teardown
Date: Tue, 21 Jul 2026 17:13:04 +0200
Message-ID: <20260721152619.026486242@linuxfoundation.org>
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

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit a056db30de92945ff8ee6033096678bfbae878e3 ]

The send-queue timestamp ring is allocated with qmem_alloc() when
timestamping is used, but otx2_free_sq_res() never freed sq->timestamps,
leaking that memory across ifdown and device removal.  Add the missing
qmem_free() alongside the other SQ companion buffers.

Fixes: c9c12d339d93 ("octeontx2-pf: Add support for PTP clock")
Cc: Aleksey Makarov <amakarov@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260615030704.504536-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index f9fbf0c1764825..0c2da974ac6d52 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1578,6 +1578,7 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
 		qmem_free(pf->dev, sq->sqe_ring);
 		qmem_free(pf->dev, sq->cpt_resp);
 		qmem_free(pf->dev, sq->tso_hdrs);
+		qmem_free(pf->dev, sq->timestamps);
 		kfree(sq->sg);
 		kfree(sq->sqb_ptrs);
 	}
-- 
2.53.0



