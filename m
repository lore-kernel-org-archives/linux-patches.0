Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029308;
	b=lrtP+ga2NeYCiTn20I0HHKm3N7GrBh5opGlJGlYnQh9Z2/g312d7Lqi579p53EbvouNu
	 Yeyr8T9Dhz3193vOR38FES+/TO+Fn/NO7QDqrNkmm80tMqDqgUI5LbzFQxzKQlzTAOe8C
	 Q7z5c2rY3PNW9br6VYmivXlehLHPpe/1p6YuJAZHz17rrB+mzgge8k68nJoEUC+9pXhJv
	 RY1iy2r+klNwpKIRPwtbFB8EOJPQuLstxDnpX3Y2Yngc0Emi0iuRQJIE/BkzNcwD6Ty5n
	 VnZ2Vcnhhnddzg/gBpzyH2Bxghli/mhQN/NUVfe09GYqvDlHCvDyIH0hHCc3Bqe+m7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AIi0Q+KhAHYipabgXl/HTAaIrokZCu00CjD2VSmxu8M=;
	b=lQ+JPrtCGS4qdH/iTfOajGp70qNopfFwnbqU1OOnz+VpVpJogubX32LuuNBWn8FrSMIX
	 HxmDuXhw/ncjXBq8zmeQfevsZHtm1FIOONb4eeTpRpqsdZWw9NHTX/IPRBTlqmiQ83bzT
	 tgiObtBAmv09hZhNOMPYXq5qBjKIE2kEjomzCxhvODbH4f/oX3Vh9N6fTvTAjQ4MBmVst
	 SYr14t3cLWfsGX5JBFwyHA3Nb9PZfbhuqGSmDrGcDBImgOFdIeXpf4akKDQamzNKv9ZEY
	 y7BcWORe4omHRJaHQpXXKPrxTWJMx+NVSqWjAHBvfgtCXL6o98HxGPUZscRcogK6byw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JgGvbVmz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E939606A320;
	Wed, 18 Nov 2026 19:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JgGvbVmz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09801F000C4;
	Wed, 18 Nov 2026 19:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029308;
	bh=AIi0Q+KhAHYipabgXl/HTAaIrokZCu00CjD2VSmxu8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgGvbVmziqtal15FXZ5+M396X3S5y2SjfD2ew7eeBvXxgQ2Y5UqD/ifec4VRGEcXz
	 Md5gds+uE7/HowrD/fT/Rx5SkUowAAAAztxvWqagrJpmWhTRjoEqk9kJG33yuo/QmT
	 ABqhHcIQHbCrmEmP3SGPBaljor7cZhwDwrirTJ9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0303/1756] scsi: mpi3mr: Fix out-of-bounds reply frame access
Date: Wed, 18 Nov 2026 15:40:30 +0100
Message-ID: <20261118150020.412224947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 25e8186f5df49..e651f2450e2fc 100644
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



