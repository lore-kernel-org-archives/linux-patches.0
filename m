Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049888;
	b=brXaO9mhz9fwgg7BX1qJ6IJLA5pkunPuVYxbUkDo7hDpFF8iHkhqfHBQWj0pmoMXL/Dd
	 cbPNf/Bpp5FJAa+YNjRqLbiNzqCglloFc3mJ5yY7nR8GgarpTmO0zRLbN8CChj5DYxu3b
	 61LvEhtTUepU2hh3V225TPH4FmiN4QOAbulQ94Byaa6sVsjLKmSj33az+WX/tdc1xbQ11
	 UvMy39K/QRxiL3E39tiH4B8DEIPb2pwbXoJ5PjwdkEzc5ZJAW1V48nnZxKFjs9S/yxYi7
	 KUc19n+ZbFKnO0WjNiZzZCdfcJyqTxb8jZnt3O1slfZRhk1Nq7Omj85VL6/msu6DjGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MMbeJScdZIw5wNf3Xnecraxbru+GPOJ6RbUvHi+g4gw=;
	b=nZ5sm4NgYNu7ldzLD0IERYztmynczJGECEz7QMXoTP+/cwBqKGLqUy/lJRH4/lTlxkKt
	 +PzbWyzggPX5aFP4+CNSYs/vPxkqCxyquSf0Ow/5rhuu3FEUVDiC/x0HSWtyTLwKUsviq
	 LO4GDzwvtAfR1vvO45J1ZpHR7lINY9297FXkIacNAW+aTcorVW3q/VU8mj1wWmP6PVau4
	 log+w5krhkZDGIYJ9j7MxSxFhk6IzQqTSnbMazJ0o0irXTURFky6lj9xpxO+ql8e14AUG
	 ei8HYGXuyZOI4FgKeQi3ag2+Zzk81Bc+sJT/moCujFwjAQ25vp0dkK3qMjPnB6IwcmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qIYT7n23;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA47606A31C;
	Thu, 19 Nov 2026 00:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qIYT7n23
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999041F000C4;
	Thu, 19 Nov 2026 00:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049888;
	bh=MMbeJScdZIw5wNf3Xnecraxbru+GPOJ6RbUvHi+g4gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qIYT7n23mOcNQLxN3td3L9jUvEESTVzEPkRfu7sGpr4b623Dwu4bHyBf1r0yHxkD2
	 xF579vOEuJaiWgoc0ME8oMOXQgKt7/FkRbRhQ0PH1ilVQQk4PBYnx5Vo+32IJsWJ/c
	 alnPu2CN2vavKQaqvVACz/rZEXPF7UBZPV3Tn0rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2512/2857] scsi: libsas: Fix out-of-bounds memcpy() in sas_ssp_task_response()
Date: Wed, 18 Nov 2026 15:59:06 +0100
Message-ID: <20261118150331.985304432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



