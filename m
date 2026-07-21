Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB3E3B95E7;
	Tue, 21 Jul 2026 21:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669495; cv=none; b=eGPBk7lF84GjclXYWkRBW5ZLGIie7qFRHw3Y30MvZ0fMIRKUkhrX4f0UmS2wNcxXCWt37oJy0peszNTCY8i6enEm7rCXxfuJ7czm/phVJbP5v4G4dLnr1lVrR8ZTfcjBjDzu594TyGubVZqKFRj4BXHbqfqmGVgOEFWPSQhU3A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669495; c=relaxed/simple;
	bh=a0UaGbPyXLhjuvumMas0mdlbLyKgv7lGA2MKVg7vN1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLPd0D4FesBEM+upOcJWhSK+alNUAhRNPSpp2nUtJi3BMkaPbAcTvkKi0ZIkk4HG5qGzKSMMFRmOshWpiamvqJME6vnVIRIWrfLwintyGFkygKbANJNX1qRX36L8Q/Wc2/5prj6D4/5WZYuvXBFHo79oCwzFf6gNZCRH78G0YjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJ4570+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJ4570+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E99B1F00A3A;
	Tue, 21 Jul 2026 21:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669494;
	bh=WeeP7wXxiOp6Q1b+XXdC5oKX5cFib38MvvMEq16j5iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJ4570+YKktHKl2VyxRjW0unUHQmPzcjoF2OdwpMlUwC0Ab/19fdd6CvjCYKSQ2bS
	 ZOnR2dxToDdUVVJTFBl6ukVLr6w4QKsIeRwyLnbQdK2s4KroFOphshHscYkEO0Pg0j
	 DvoXm6EWRm7azxpeJJTH/P7WIfG3joSac8sc9SFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksey Makarov <amakarov@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0577/1067] octeontx2-pf: Fix leak of SQ timestamp buffer on teardown
Date: Tue, 21 Jul 2026 17:19:38 +0200
Message-ID: <20260721152437.512280955@linuxfoundation.org>
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
index 6f1da4296ad5ef..6a18159851d47c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1427,6 +1427,7 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
 		sq = &qset->sq[qidx];
 		qmem_free(pf->dev, sq->sqe);
 		qmem_free(pf->dev, sq->tso_hdrs);
+		qmem_free(pf->dev, sq->timestamps);
 		kfree(sq->sg);
 		kfree(sq->sqb_ptrs);
 	}
-- 
2.53.0



