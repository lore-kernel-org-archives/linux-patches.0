Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF0C3B52FF;
	Tue, 21 Jul 2026 22:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671958; cv=none; b=YT6/0umOxHhVzMFqdtpKZCnativ4F1FYl+/MrTNekdjDwchsliaTLN+X1Q5t71CoP6VY3IJZaiUg0N8ljKJQK6Oo7v+VYI0Bba4e45Erf9rAgJeBGxWX1pPSrPTDMgVDVUcCgMMSBB69BA5i5dBjftRab68RUx1u6xtgLZLwON0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671958; c=relaxed/simple;
	bh=XUiwxKd9uwSeN6FiGAQfHPY0RTFRJD2MxcGAEKzJvps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5ycPggJvl4paMtw7WlRflweX+79fnMjYluRhd8TMfu/k+U99ASuBNbkO+XqUFwhYSebr0/fbNZRgpZ6rwS16rV/94/0u0wjXFVycY+p5jecpOox1nk3xmPZiXp2VymlfCgaQbYMF6PxQSesmOs+xgT+mueL00L4bkv7OEDM5Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5eq3yHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5eq3yHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014501F000E9;
	Tue, 21 Jul 2026 22:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671957;
	bh=luKE7PQOMUQsmTYKYKfqp/M8eB37K+gfMHJT2or/wYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5eq3yHNBcBYxEQtdDvetk+BJm13zDWkOjPvOc9ZAGe+r8oLUYVvseITCO/1fx024
	 Z2ZR0XXrYPygoWIV+IRYnuTTY4C388jEQ8XYGmqEGkpiYiKGq7bTuJWtl4COjZxach
	 Nu4rRP7KwdI6qZehh5nXTsJeLxqCtyeuAkbCmF7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksey Makarov <amakarov@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/843] octeontx2-pf: Fix leak of SQ timestamp buffer on teardown
Date: Tue, 21 Jul 2026 17:21:16 +0200
Message-ID: <20260721152415.950181195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 803f40a2bdc19b..dfd85b0088e007 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1382,6 +1382,7 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
 		sq = &qset->sq[qidx];
 		qmem_free(pf->dev, sq->sqe);
 		qmem_free(pf->dev, sq->tso_hdrs);
+		qmem_free(pf->dev, sq->timestamps);
 		kfree(sq->sg);
 		kfree(sq->sqb_ptrs);
 	}
-- 
2.53.0



