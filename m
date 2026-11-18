Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016039;
	b=aFSjAArZIIWNanHdr4LLcIpg6m8I3pf9PFtwIAKdm7WbxW0S+xGz0whXA/R0GA2sGHfm
	 hkfIXS9Imk2ILDPreEHjZ9IgtZgKz/RY7pDWIwoe2xbqVn7fBVSgYqieDSwLc65v+R2+D
	 sHTj9vMYUh38pPxat4HINtqetpdheqFV8JPwbSWDODN39xu5tkVlSHcOdUzng1acd5HM6
	 q4tA5jotiRqVz7Hh9iSoMnGthzKlO3RZjiiFL4NR+kppm9Q+YqDBR/TKxP877KVsKKGhm
	 uvZdUfXLQMq121Jtzh1sk9YPvLKbUb1fGiRHoZB17LtEJG1Ypxsqpw4h0SiKR86FTuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=83RbDNNmO32XZERPIlMDk6VZPYvr6FvOnzp9mV3LBpE=;
	b=N3kyilVrdJaRdL670iRDNIO3kiaA+T62J1SeXdb1NZzasu5LmHpKcU9r87xKWa0geq8e
	 gbV96pCJO4ORgR80PVJFBzizAlRLEfioaZoRERlwINYbZ4o9fcP4YvP0QqXHyTKivqsBk
	 PWJGr4VoO0agujKy1Tmll6A0nUkJRzAqYMH0YXOHRUTJf7nA5sFlMJX44txOS25KP/swE
	 DJeNyxMDNWZdu/C11zsIyq42vpuEriSMATpOcDQNRY7xdbdf92RZXsrJzbK/Ra+9G9TlZ
	 L5Dy3uIn3iGriBjTM8XKLT8fUORV6pS2753NNYCLdU+6rLvEVctxYcbteGw05APa9Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CX1k86vh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3438B606A320;
	Wed, 18 Nov 2026 15:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CX1k86vh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848651F000C4;
	Wed, 18 Nov 2026 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016039;
	bh=83RbDNNmO32XZERPIlMDk6VZPYvr6FvOnzp9mV3LBpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CX1k86vh8lpyVR3zmXGE56DsOpzXnn23SiKpYQ4XPHBXjuPJ7sJ5KtAgM4E7oMen3
	 5OSWi63iTnlvOL3P8dKSEbyB5ZRwepyYgQViozrI8hMJQTQFWHcZbluAuv+flX+5q1
	 /oxF+/+FodqFgWpRtXa1LGm5+HTWhTtAJchOxOtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0336/2651] scsi: mpi3mr: Fix out-of-bounds sense buffer access
Date: Wed, 18 Nov 2026 15:26:16 +0100
Message-ID: <20261118150259.952376160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 82fadb4d2b21f..5c2547bb67a52 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -142,9 +142,19 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
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



