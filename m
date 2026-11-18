Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056460;
	b=VKvCPe8HmNeVwqOBrfXv/3ql2gXpX7k46btctwOvb7jJBMtV2KnQ4w+k2XioKhUNLhiw
	 ctZD/NyyI6KfFiy+wUys5mGYmjPIatQV3ukCF+cnADY8KDSr6V5jXVB9kTHUfNYWybzlS
	 S8ZfG+8/uEu3nG4v4ADZNzE4hc4IJBpTRI5tYhRlcYNeFHpArgAIspjVvqBenJYyrjYGn
	 aXSoWwa4C2Z/QpUPJO2jlwI2+cWqGFitk1H9G+DpjyqdpvbOAzOFi4n6ReQ4KqTasWNBC
	 J5V0qlK1s23IYy6uudHLzKrtMUJxToWuaqTJ+sVM7KdlUKstxWMqtez8hkbyykggR5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AIlJoZgIB6VJ1Meu8g0BcdOQn90kZeERl/Ax/8RN7jQ=;
	b=MIyo+AXOxgUmFyl9f16P53HaMnpnomi4/ouee1jAisF0N8+E/Njzk12hq01Opq79pLND
	 ncCe1ggnc95SSAX2A/xmCSNf3tkLZ2aMWEvXYtUddKrXCSkCMeCigKFP3cT1VWMLz9TD5
	 zobnXucqx7D6yzbQG0Gq2Y/YoiiXT9SykhwosHoZRcnGDZ2YBMqciAhDCfhYsKLXkaQRS
	 M7XhSq6susmDRQH/Tg5Wsjjt67v8dzNlOhkYD/iTPYmC1TN5d/6/JoztRkA1v90FY/2pW
	 nUPTGDiqvw8vmygoLJ+TKMdOuicZHPdnc31kmT6EJoiZaguE/Ky913y/18aE7dXSAzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofKvW54a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA53C606A31C;
	Thu, 19 Nov 2026 02:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofKvW54a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA9D1F000C4;
	Thu, 19 Nov 2026 02:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056460;
	bh=AIlJoZgIB6VJ1Meu8g0BcdOQn90kZeERl/Ax/8RN7jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofKvW54aY9RaP/3DcRUTKnFGWHkech3wN4tvt9rjpVb3fZKpoICV5U5BYA6yyp3WK
	 pjvxZr+PYwsObkOTpUiSSxfE01JIT9sWpQnSGRyY8cUcBGGk+dc9hw0ZJxyMFIMZgQ
	 mVDeoUDOJBvuAxnAt1blCzgb3bZSpUVPFf7FNW+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1945/2214] scsi: libsas: Fix out-of-bounds memcpy() in sas_ssp_task_response()
Date: Wed, 18 Nov 2026 16:00:21 +0100
Message-ID: <20261118150128.811666620@linuxfoundation.org>
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



