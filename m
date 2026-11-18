Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054896;
	b=Vz/r5TMkwzjrlcNP88P0ATjUX8UGcOF0OiuK9UpcuUeQfqGocxp7jijjJxEtnRegvnrg
	 Z2jWQzXpprrNYbPOt90qgAa12aHDwL8Jzg+LXYL6DrLMjpsew2kj+eZZAYa/4SBp5kqcA
	 rOD7VZUcwzZMpGcHC9TNY6nqOe55jBz/jMVWVk+k1dw+Uh55icNIQXu/Ic104+R4+NSNJ
	 psvnVGx7pQ4pwADjpilk/RnUVG2yyN0dKLUoPf0LIC5bgjLwfXaWtuCYrIO0nu4M2DAeN
	 igOPqaSwQqKlOSwh4sowXT5tYsRVp4po/qaTvkVE22H3g8oNABfgIikq2bzgMJtdccg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kvimj5ZYQFYgGa7qe4WV0Ewh7cxNwQXd63d0UDLIJCQ=;
	b=e8WESePQtvir/2YY0V18cb7TB4Viuyn+UntBiVa/KwaUNY0W0bZ+vY4eFssIvhSnah/2
	 TMuf6ISJy/vxEVpOx/NjMxD40RMZmMiqfozTdhADpBwluYEECjTz18sNCUBeoX/KjxOkY
	 UnTBdyqcPqrvCiuqrAvEaH9WasN4PzMFBmctZuJzbU92R8diDB7p/8gLu/87naJ0vwVdG
	 DGzSYd1jAZ0cC18bpO4w+/ebIa8gkyChalS1nMXCe1olcvh+GP0A8fZa0bpF557oCHOLu
	 CZ7iP4k5odsIIRCFvcL8lC0BEUeLuHL3gFC7GapPB/ABfDZQMMgv27sHTA3GpjIz1og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w6KrG0Ou;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EC1606A331;
	Thu, 19 Nov 2026 02:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w6KrG0Ou
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625DF1F000C5;
	Thu, 19 Nov 2026 02:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054895;
	bh=kvimj5ZYQFYgGa7qe4WV0Ewh7cxNwQXd63d0UDLIJCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w6KrG0OuQDbdVepwAHY7t/p2ongOWgwPBDkUniPiMxBiGzwHmDAtCVKFPAccabnai
	 3HEveBYQzDZLkn1dzKTrNYTnEU+FrHndY4nTOyf899TydsuIo4qt9ICVxXZDwfH6Uo
	 BYJlx/iCqLhD0nVsrn12VAR7WSecxGIBDxdy0NbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1438/2214] scsi: mpi3mr: Fix out-of-bounds sense buffer access
Date: Wed, 18 Nov 2026 15:51:54 +0100
Message-ID: <20261118150108.682465312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 7fea128f6b829ad834f21834d2605d28a45b903d ]

The sense buffer address reported on completion is turned into a virtual
address with no range check, so an address outside the pool resolves to
memory that does not belong to it.

Check that it lies within the pool and is correctly aligned.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-8-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 06135b4d96559..3d6d6b9b71276 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -131,9 +131,19 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
 void *mpi3mr_get_sensebuf_virt_addr(struct mpi3mr_ioc *mrioc,
 	dma_addr_t phys_addr)
 {
+	u64 offset;
+
 	if (!phys_addr)
 		return NULL;
 
+	offset = phys_addr - mrioc->sense_buf_dma;
+
+	if (phys_addr < mrioc->sense_buf_dma ||
+	    (phys_addr > mrioc->sense_buf_dma +
+	     (mrioc->num_sense_bufs * MPI3MR_SENSE_BUF_SZ) - MPI3MR_SENSE_BUF_SZ) ||
+	    do_div(offset, MPI3MR_SENSE_BUF_SZ))
+		return NULL;
+
 	return mrioc->sense_buf + (phys_addr - mrioc->sense_buf_dma);
 }
 
-- 
2.53.0



