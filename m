Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031964;
	b=cjgDcJFpg52Rwdc8zsl5YzMllsyl8eaQmLHSFWuz8Y5R/5EvFCasLgkmbWGyU6oYHrro
	 FntWBMIG5btSHYR5f8PXjzsBO1oSvVMN2xGZ5xGFZ6rh/J98b/fAfp4X6rfV4f6BMe10z
	 puSpDFsMCKwfkldTkJNi9G7I+B2z2ftF+sv9WNQA5WSLCTk8NUQYCnk8TmnbF9SvifqQW
	 +r0Tm76yp7pFczcRQPguSTEP6EexGbawOpUwbpFw3RTp5u+fUWgQclNcCJJPlGtc/CAob
	 0MFpEWXpj1FjcPfNz6ehMJoUGD6ItmfNaax3I58Mc+aaWUTHdkqwNO/NmkqcxlAa6Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XHzczubJ30a/uQcFkoBc8mYjNV1zp0R2feGnNjMseaY=;
	b=5m2DFgXT1AwM/qf2Ov8lS2N+6rY+/sbAQF6LLTdtz7eXuPosmP/P6wy1/20/ymeobPDN
	 Dl7EWP8VKaUNZbRWq3fUdTDO8xI5R+G4UBEd3ngJuxssOEqWqM5zxydx3g70Es9wzZLv9
	 hhcXn0tEA4gRea8S8Zqfh4aa13C/NoYSH61kecMb6pnrqqUkIjbSwRW1KcyWU//HTV9RA
	 hdEojpolg0Gr4ypBTDvx7TAdPGrqo1X8KdmsU2/gqt2QN0aiXRpyVyPmkRn4oUJ9Id9up
	 Py9tDUroATwxmOocOMNQrIykwBIHpj5rRfP/wN/8QYsZR7SimgkjVUqYODm0b0W9rLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKI4gk9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAE8606A320;
	Wed, 18 Nov 2026 19:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKI4gk9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87EA1F000C5;
	Wed, 18 Nov 2026 19:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031964;
	bh=XHzczubJ30a/uQcFkoBc8mYjNV1zp0R2feGnNjMseaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKI4gk9EE7H6vk0ZIRusLBXgNEinDguxNZnsRg3s4gYD1yIeMSvOi13aDisfO/7s3
	 Le6fHPkoqTHORq5HHPsc43Xov6JLVHaPXW8spG/avRn80BCTap206nk3q46r/eusnn
	 xpLWSb93yzz4PFJOVq1bZDhhZ4ZP5ZfL/WvygOns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1245/1756] scsi: libsas: Fix out-of-bounds memcpy() in sas_ssp_task_response()
Date: Wed, 18 Nov 2026 15:56:12 +0100
Message-ID: <20261118150059.300724821@linuxfoundation.org>
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



