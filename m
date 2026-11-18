Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039507;
	b=cx5U4Qvd7F6XKKnQgafSErikxM3EvJdrFfiTDm9z+RG9Xz6gxGyyTKulvRCdXd6u4gAF
	 u703EL2jw0GxPOVnxx7ZKz1vQc+qJ+aHexxuCa8h6cYy9aejOme5mqRx04IxuIR0FFgxk
	 Jcw5Vn3G0DCf12ZHBPITIuQ0JBVs9SHxr68rLisYFw5itbSF1znsOIFQHnhvup0GJdS31
	 Yqhb8D1Kt79tXrINbkYS7iSoZAWvBy2NAGBsgz3eN9nJzABkJ+Vw+ZRrRZJilQTqt4mQd
	 NSjfwGrtouzIJ39UQ13oMxJXPzlaPlr2k0oj9UB1POowOk4yK3DS8qYrBpa+Ig6a6XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/q1JgDrvAl3uS4lOMpGfKpWPN+BKvkhqNmA/t8atVXc=;
	b=F9ruKAdVTOdwtxFzDGeOo9vWB071nuUXd2Id519i7oymCb/+YiGiYhGV3Ij0oNl8YXs3
	 jJ64eyA3mmG868U1JfEm/85YCwSJp93DkJ7bjfq44b2BxgH4FCq8L3SxpSuDqPnjM7oWl
	 LW3h5WwXEQf8kHUwsRmvm9gaEvm2K0M0ZTbYe/+UY9mD0HN+aBIBYfob1IMWDmZR9Angr
	 HXOYfUWsnC2o9EJh0A+pFvH/t7YA+FgV4t/gLn7nZJyDA8bCh3FDwXJhXKLN42UA3Dhtd
	 vvgnKbvu2ePqHvQweX6U7AvUE/Z+m/CmO9qLJcP7+1t88/cZICc/F2U0/3pdx6j0AWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibAaMf5E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1D7606A31C;
	Wed, 18 Nov 2026 22:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibAaMf5E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4931F000C4;
	Wed, 18 Nov 2026 22:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039507;
	bh=/q1JgDrvAl3uS4lOMpGfKpWPN+BKvkhqNmA/t8atVXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibAaMf5ELEL6aefwcpr8iA2yOSy1AXOGRrhhJsQ+Xp1EHXWU7pn/Ij3PnHaq0kgrt
	 sWCeLqoQzqkJqvaGhzSiSEYm+a4esF6EuOXbiX3nH3jM5MJ0F3fQvKylXv1Ah8HEXG
	 mnQq0I2je05/ojfKR3/K3kShEbA48BqTZDmSrUpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2124/3318] scsi: mpi3mr: Fix out-of-bounds sense buffer access
Date: Wed, 18 Nov 2026 15:45:46 +0100
Message-ID: <20261118150425.781569616@linuxfoundation.org>
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
index 8219d49435464..92cc9891f63ae 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -137,9 +137,19 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
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



