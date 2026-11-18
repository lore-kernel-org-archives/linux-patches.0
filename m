Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039505;
	b=OsOZr+oxox5Mao8VO7llrw6rkU24C9vveT+ObKqln8kY+kN0ruaRzXV0kbmiSWy8Y1CY
	 b9wyU4QvOzv2LvmzhprULm9l7GnueLCYqEwmHjK1PlQ1seDylBg7Vg5+muUHECKQxl/UW
	 epxhxvtXwAdJpsHhpvdWsvXo3y/+kuoXnvJ0LXy9dUIRo6VmUQdvX5uTcHlLUHtJxPtg5
	 hubGRa5azZ+qcM+Q5oIVILBBMEG9oDocNUaDOmIDsARHqSS+/wufgjHCAKFLNFx+PwW1s
	 QW3YzS/MIveWu3AhISPDcJnrj5ApP5f5QwTH29pS5gipCg6rd2U2CI9YYK8RYxOcYtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uN8rk7YaeY25R+XpRnfijxpqouFP8vaeSfvSBmoKbpY=;
	b=bmAty4WlxFU7u83KHngNi/2uyJL8LUyIErK++I9Uksx9ZmnP0d5uogMzrOa/92y2eO0t
	 DKrC0z8U0SH5PuLZxrzICRs6YTEer0TUAPw0Yamgz+UyzpGksa/U2WEToPcq9t8wtoLd2
	 28QsHOHymkPjEdh8AKVO7fKwvZ/77iDUizbuPwYrGVPOTa4DNiQRCgPYQWJPZLITrQZNs
	 BId8VIlyInEYBuXbGV79t0DjdnRjnSUsNcGa59PaifbWwIfR0ygKCrYxVjhCXivGCn3IM
	 Pj3FrqFbqghBR7MMtMuUBc/9UavIGNTU9haO9qb9zPZ8w233/q8MwlNo1p3lHOS/ShA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1+NhACqA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD0F606A320;
	Wed, 18 Nov 2026 22:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1+NhACqA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454BD1F000C4;
	Wed, 18 Nov 2026 22:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039504;
	bh=uN8rk7YaeY25R+XpRnfijxpqouFP8vaeSfvSBmoKbpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+NhACqAePd3qtVFmWvv8G6aPQt4oYpeZZz9hRBEsuAzdqL9XGmFZagrmbbIx+oNP
	 GEGE/DliX0yFVVR8X9gghLngLgSyfKdtNyvnChRvGh/dstCNWOFy244Qo/LdktAMPo
	 RUvQgpGNUtuToUjIfsyCFYHFSoK/2oJgEwRv98q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2123/3318] scsi: mpi3mr: Fix out-of-bounds reply frame access
Date: Wed, 18 Nov 2026 15:45:45 +0100
Message-ID: <20261118150425.750335107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 119e6db201010..8219d49435464 100644
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



