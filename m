Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D0D1CAA6D;
	Tue, 21 Jul 2026 18:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657547; cv=none; b=TOK2Ikigc0grdaZ2NnSm8a32ac3hExmB2IfhiHy90Y6Ff00BL3IRL5NsDZNsaCJcMOS/PM1lj5HhbcgmXi5dshbmwmlbPapeawoWdKIENMEkqqxNH634nWlR9K49mV7tg17rfQw63FovbmtM7G7zwnlX6bkxsYO1AvWltL2i2ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657547; c=relaxed/simple;
	bh=iszixJkO/ujMwrB1MW0Zk2Yg3IowDRvGWh7aisYKgsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMHiZEo2RpSN2A9ofYY0YDWECnLKlAjsAwTXIbPOd7Ej6dpaoO18edCP+yPHc16By2jPT536KnFXmPFrFi0ROQtfyuObvvkF5j66p8B9DHyzdavuNiaa/BEsrR3cDeU0PUASZ0Gbm/5mMz1z3hY8vwxO9KkTkD2j510LwvRun9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZPui5Y1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZPui5Y1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655AC1F000E9;
	Tue, 21 Jul 2026 18:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657544;
	bh=hcRLjdKGOCAejPi18vmowJtr/1OvrZNQ9bab+paoK7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZPui5Y1jHKuZ38gCg6fQPQZKEw5QiGC0T2Ie6ehtWoRByExXwwkFMIfhwOZkq164
	 x6/mHMgkWcYGO23KPBg2V55fFkap+9F5FBQ8F76Iv/I3DFTG68fkkehvi/Dz3cOtSE
	 TKTQM2ZecKKtOPkVEqLJT348/sowRGlYgwO54mZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksey Makarov <amakarov@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0806/1611] octeontx2-pf: Fix leak of SQ timestamp buffer on teardown
Date: Tue, 21 Jul 2026 17:15:22 +0200
Message-ID: <20260721152533.515585933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index fa23d42d1318b4..e0369466c9fd4d 100644
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



