Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CD03B4E9B;
	Tue, 21 Jul 2026 20:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666550; cv=none; b=VkAuAJ5NUFkqTl9V4VDOCmlwHAcKjwNfMEUPR5QYd4UU4BGDJsKj1+1/tcAorxii/xIck0vGmtTMIHr6BxS1Dqhc/mxUPGxtAT5VRtft3aBGUBfV7jsJt/i4nEtFFDic51D/PVRwIRhzoEYKZegWsvjkswLxz+jfIS5tLMMGcmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666550; c=relaxed/simple;
	bh=jhc28Z6tAcJ0E9H5R+f6azj6lIV/CHNWmdFb5lMJNQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sp3pVOGqDvWICa6KSQgY6i2L4exRPh8IqK2E0YfFmJLMDB9YJw68RismQyht7jJJQFURLdzpjkmj7BjS1fSuvEkliRqHmyHRCQMQ2ydqkXVs3zZ2bCzl+vL9EHxRZE7ZnsKIaXqdSuslmBcSWEeb5uT5S26L82XBc8Gl062CucE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bs9vpjKD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bs9vpjKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4261F000E9;
	Tue, 21 Jul 2026 20:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666549;
	bh=iR4hXXkyWrT6pNkk5NKZuFbJ2iCbGsLgT+MgKQaFdTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bs9vpjKDFiOnCAsIQcsxtkbtlumq1xI4ehNePyPPufmuwTPcsQPwKw7puCBoClcsS
	 anLND6FwNJ4rhnKw0N9T0Rlq9LgKSRq70XztNm7+4DQCuIVJyOu/TzClaxbgzTc36A
	 BbY1P1c+o0KaLxd1gdOElTnzVbLyRJQCATNMiXJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksey Makarov <amakarov@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0724/1266] octeontx2-pf: Fix leak of SQ timestamp buffer on teardown
Date: Tue, 21 Jul 2026 17:19:21 +0200
Message-ID: <20260721152458.070866789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 784130b4b08655..a41ca759ce77fb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1448,6 +1448,7 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
 			continue;
 		qmem_free(pf->dev, sq->sqe);
 		qmem_free(pf->dev, sq->tso_hdrs);
+		qmem_free(pf->dev, sq->timestamps);
 		kfree(sq->sg);
 		kfree(sq->sqb_ptrs);
 	}
-- 
2.53.0



