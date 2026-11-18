Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020347;
	b=E2KaWPE5fvnNpoNg7A6p+iv3bYxP9podzZt1LJOutHzU35W4un5xPOLSEYaPZo/Y0xmK
	 gX1fPMDMdudiWKVuW8dix6hSQ4zJAncKiO/F6qchymW6sd6eCbSwbsAlpFSlQEulg4Jzo
	 y7ArLrNp3ljQCH8hs0zVb/jaTWYMv5QLlBw4V3AszsndLUFSE+3OPR9CeHhUtCvpW/Z5L
	 DMQ8V0yoRAMVi10UIcl2yqLrlTvPhYzu3m8/k+uN1pTNcXHRwhNY7benjBCSZoeolZ40g
	 JgLIhrwtkyDyWCenrUUGc0Ciq6HnI5wS8pw3wTGiHVwfMSYQYcIxF7FdcJZhNnsaY7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0z4VI+2VtpDuJT5EEx1tS12wztHsLJzL+p4bZhXyyb0=;
	b=jMBW/MGPGCgVwisn4VDt0LOS8EHYlvFYBRvTBBOmdVVob64awcDSy7YIIFnOImZVf2Cu
	 0FY1IXR0nq68FVZB2IDkpZWAkSe0QFkZ8L0d34EovZvsMDhmOd3/oTsVJ2jZfvoLk0qZq
	 hSrpxoyGOBrqPktnGCh1gCFcR4MeGHmuMC5GE/i15JI4CCzkB+zU8MbBKVpjiQpu09m6x
	 m4atVgXISqga9K2CRYKPGHpjmg7/zHWAurofoevm6lFyXGyPNPDEh7ikqo3SnmE3VYElA
	 eir/UZ78Bk87zh4Zm4BW1rTZFGUeImGTC6I3U1ni4T680Xsr1IeN7cyWEQxnTgaTsyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YcMeq1Lm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675BB606A330;
	Wed, 18 Nov 2026 16:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YcMeq1Lm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B171F000C6;
	Wed, 18 Nov 2026 16:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020347;
	bh=0z4VI+2VtpDuJT5EEx1tS12wztHsLJzL+p4bZhXyyb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcMeq1Lmm2QzpBgI+OyOzHMYVSboi8aq/MOKSCHerco1O13PKn7aDA4Pcbc0uHAPl
	 67YQ5J7DkIRVejqWwBA4Kp2jQnws8YaeKz/opD9Xc+X7UxUKa2DnaaUPZ/VrMRgt7c
	 q8Gg3doGMMiUs6g6si9ZJMMxPpm4bcMDGuz2uDBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1917/2651] scsi: libsas: Fix out-of-bounds memcpy() in sas_ssp_task_response()
Date: Wed, 18 Nov 2026 15:52:37 +0100
Message-ID: <20261118150355.773576064@linuxfoundation.org>
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
index e9d291007817b..2080e5836179b 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -25,7 +25,7 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 	case SAS_DATAPRES_SENSE_DATA:
 		tstat->stat = SAS_SAM_STAT_CHECK_CONDITION;
 		tstat->buf_valid_size =
-			min_t(int, SAS_STATUS_BUF_SIZE,
+			min_t(u32, SAS_STATUS_BUF_SIZE,
 			      be32_to_cpu(iu->sense_data_len));
 		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);
 
-- 
2.53.0



