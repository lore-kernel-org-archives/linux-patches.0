Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061722;
	b=tsYpAgOq5g416AiVNucI5I7D3UY6BsGO/Ks+YHU/Qj5mzTc+joRKWwy2k25LlKCaOZgf
	 +s7MiHuK492A2+nkCQe8R0G3m51v0XYDNck7neEFjW0DgTTbcBijtfHx2KdskWYoiScCS
	 yhLAXAO9cgsjYM8EAE9fjNQ7qEZlN+HJ/HR76K9yYx+6AsTCFyqcEpih9JgGcveh/H5hu
	 pfp0bCp5Ox8lqhxMmdAcv5TYB6ljuLY5PR9CBj0BbRtiACh4mlVY6BmOwIMvdVESnhDHD
	 KiirH1DIEhokBhr7vbDfFfbuBTL1Vs1/kT44IxTuhoLxM8YaSPJWnrzOXhjWu0RV2Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IxtM9nd7VzSGCoMfNzrWW7zpYLAA6JmlEeTKK4+jjrw=;
	b=4Imm3SeeepSZ3XplNKqp88uEF7Z/5B+Qq+hx4h4YBsef/d1G5QbnLHtnN4yZSB6Rhg/F
	 yRhzM6FqCmGKmKQIEFeL9SV8RcwItJ1+C++gIoFNHu4wtVt6bzQince6t6o6sviKDz/Yt
	 f7dqHU0Lm6uvxwxwNUEb9vqtToLhDkEc8gAif4U3Yb+xJSsTD29/T3WgSY0xvyZL61U49
	 SQYaglx5glN9FMVFoFE/O+OpoDm+dNCBPLqedZucNktrWEBIP9MD8sOzxNMOdDmrcmDO5
	 olQBt7cg0gWM6v3+DHNxVqA3wOvf38zOnQh32fRuVmlXVzzoo8dX0JtlupUEnRLx3wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NAHBQ0r+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BE6606A320;
	Thu, 19 Nov 2026 04:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NAHBQ0r+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4514A1F000C4;
	Thu, 19 Nov 2026 04:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061721;
	bh=IxtM9nd7VzSGCoMfNzrWW7zpYLAA6JmlEeTKK4+jjrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NAHBQ0r+An+uEeLZCni9Z+1VoCJuKz9Qr0fPq03wBZOOqT3nQamgOlulIJ1FgV4wm
	 OPI73gitr3RnO1aTYPnnsuVJ4QG9ocl4D1QXcatmfMjEiU403PcwMUiOLLFADMKNIk
	 ViRcNE6Csp5dIedSiy4jMSN2LPqjKsVY3wu8yxw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1655/1848] scsi: libsas: Fix out-of-bounds memcpy() in sas_ssp_task_response()
Date: Wed, 18 Nov 2026 16:01:33 +0100
Message-ID: <20261118150028.994381226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 4d7f9c3fdce773f6c69d17c1d4a05bd5e17f4b99 ]

The min_t(int, ...) clamp of the device-provided sense_data_len turns
negative for values >= 0x80000000 and is then used as the memcpy()
length, reading and writing out of bounds. Compare as u32
instead. Well-formed responses are unaffected.

Fixes: 366ca51f30de ("[SCSI] libsas: abstract STP task status into a function")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://patch.msgid.link/20261009033238.1076098-2-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_task.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
index 2966ead1d4217..aca9332b66013 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -22,7 +22,7 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 	else if (iu->datapres == 2) {
 		tstat->stat = SAS_SAM_STAT_CHECK_CONDITION;
 		tstat->buf_valid_size =
-			min_t(int, SAS_STATUS_BUF_SIZE,
+			min_t(u32, SAS_STATUS_BUF_SIZE,
 			      be32_to_cpu(iu->sense_data_len));
 		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);
 
-- 
2.53.0



