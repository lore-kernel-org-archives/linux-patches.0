Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023333;
	b=ym+7Co3Qye4MYheGCIV/mUpb4fG9/zDiURTjI22opBqu0LTcsQ3U3j/u5eCdWxPsgd2u
	 y+B+mbn8zH7rUBpDtQ56qH77DG60XrmwCHRqMP/TGVAfAsSSt2QP3B2OXJ3nYOBVSPC4D
	 fW3VioJ7HDZZS9UFkmW7CGtmp5WWvq6gdQg6VqYHkk2j9n9BzjvvelyPP0XQ4kpZaup5R
	 GI00VEEDCUx1hBwwm2C2EQUWNxVCsvwJOk20Bd9gogcXF0RrxdbIkV9Z5dbpWEYUN14yC
	 a9fMxePk/fLbZPWEfjxaKSgmPFoQW+HO+0qp2pf5Ntgm2D0wZAzCBNFYpMfftT8rZnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mp83WCIBoLAmDjr1hZIGrgk4mv7bhub/M6tZX4YRVUo=;
	b=dkAkQYntp6yYd1i14h2+4VFdFfSXI/Eyw2IRvobeapwkKObTIktbVgld2bxyKzjz8yaM
	 t5BJAGsQ2n5M6M69i+hm6lvutU9NAHUgtYErHJoo1I9OcFrA9zPIHdmDr8jsuOmU4Sk4H
	 nq0VMOYpDUIC36HsqROrBFId8Ew+DNSaNiQkz0Bc2OG7+/D9hAnRuD/UFkxKoOvmtwMPT
	 eYDL+GDqgwx5NIsVkF7YRKjbOGK3fg6Bng4V/59cJ03SL7A+RjSDOvJeWKCwW3gzUqISm
	 kvHbqUVeF0RlXCvChAHdCvpVt4abqt9xgvasHv7kV2OZ0f5x0/O3RuyLJ4qmy2dAysQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MIiG/op5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98185606A320;
	Wed, 18 Nov 2026 17:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MIiG/op5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9601F000C6;
	Wed, 18 Nov 2026 17:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023333;
	bh=mp83WCIBoLAmDjr1hZIGrgk4mv7bhub/M6tZX4YRVUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIiG/op5qC+bCeOOlMBJxiaMmISQzffNtn47epAj7FtpQ0mH83Xanofnn28TUJCrI
	 K8hFXsR5X8ER9TNwdVvMvUKMUpE1UEOExol/vTIy8tfFFZ4cdbfF5DWza5nam+9tst
	 pQBnZ04x8Iq7ts7gdHxxrFkSmVnwX0+FhKmFtQzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0331/2151] scsi: mpi3mr: Fix out-of-bounds reply frame access
Date: Wed, 18 Nov 2026 15:34:26 +0100
Message-ID: <20261118150134.051720517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit bcf0a5bed59acd5ae19d80e1f617c1a5b355af0b ]

The reply frame address reported on completion is only checked against the
start and the end of the pool. An address near the top can pass the check
while leaving less than a full frame, and an unaligned one resolves into
the middle of a frame instead of the start of one.

Require a whole frame to fit and the address to be frame aligned.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-7-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 4c8d78b840fc9..b83bb6027d578 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -119,11 +119,16 @@ void mpi3mr_build_zero_len_sge(void *paddr)
 void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
 	dma_addr_t phys_addr)
 {
+	u64 offset;
+
 	if (!phys_addr)
 		return NULL;
 
+	offset = phys_addr - mrioc->reply_buf_dma;
+
 	if ((phys_addr < mrioc->reply_buf_dma) ||
-	    (phys_addr > mrioc->reply_buf_dma_max_address))
+	    (phys_addr > mrioc->reply_buf_dma_max_address - mrioc->reply_sz) ||
+	    do_div(offset, mrioc->reply_sz))
 		return NULL;
 
 	return mrioc->reply_buf + (phys_addr - mrioc->reply_buf_dma);
-- 
2.53.0



