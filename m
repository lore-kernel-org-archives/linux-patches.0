Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052830;
	b=y7J+uqZ2kU5opdflC/Y6/2y508p9DdqIjeqLRoJ2m/dCnEyKgZESyBuN5RIEpjG8Tgtk
	 /jwUR5bqp2+8ZFzZIoaw76XGhmsnlVZvVg40bhfnYBGwizWZDM1hWjxpEDdpROn0wQtOs
	 qIsL3fzD/i28Dq52HNevXGxZMz/pAxHUD3rfsKhuQNMWm0DR7GZrkjF467NZIuYd/hcKi
	 cGfdosJUL7YXpruV5riiM5vDDVOnXQfwMOljKsxbgcDN/alV7jKohDV5+UgXfl5ErjIYM
	 uPsHFbk+1Yt9NRpg+pvpLI3ojQj0OhFImAGKAlddCmlZnWe0vW7qqggPMDk0QpDc/eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i7QVoE3No4SOGcpassFHRxi3gcyQFYM8GfP8bBT5Ibc=;
	b=LuLCaar6zOksiR00n1LJmg1Nnp/JzLXOrD7VbXTIXTHWfp55O1XcnRGLMbB8tTfEEpAk
	 aBekQw4BMHIPzmpuCRpMMpnsqsKUU66i8Ayuq2sZH0ZrYL9djrtoHqAND57gj4stqNSVQ
	 XeUgUtajDL736h9pbXwES0QskAn1+LQUfiNuJHlQOPZ13jTc3hIMb/SR55Z26XFaOtsJW
	 K8SZ3k44I7v1+3kVuLx3PzEpwiLVXLCDah45wxycFFQP9/hprZI5K0Pp4Ii9yLRdYSLH1
	 NxHFsa0asm6DawJJ5jVF1qNgpNP/V/1tLPKUEKgk53zSnowIeH7wfHKATlVmdDI/WKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idgn2juH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA999606A32C;
	Thu, 19 Nov 2026 01:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idgn2juH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA5F1F000C4;
	Thu, 19 Nov 2026 01:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052830;
	bh=i7QVoE3No4SOGcpassFHRxi3gcyQFYM8GfP8bBT5Ibc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idgn2juHwJYTjqUXuw5rtWn6FDmMKMk91Uz05e18rb5romsSrkavCRRHhwbBVx+kW
	 Uz2vM9IsKyMRoZUFYW1sa4XW+Sh/4Y0aRmwhRLGSyjEru/IpHjDllZBlu8W9lIhQEE
	 uH/eh4++toaN2N5DAClDSi9cvRkkmuOA2/OH6w08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0703/2214] scsi: libiscsi_tcp: Prevent R2T range check overflow
Date: Wed, 18 Nov 2026 15:39:39 +0100
Message-ID: <20261118150039.933363336@linuxfoundation.org>
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

From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>

[ Upstream commit eb7aa7fd673fdc1582223cd133bcc5f54e7af19f ]

An iSCSI target controls the R2T data offset and length as 32-bit
values. Adding them before comparing the result with the SCSI data buffer
length can wrap. An R2T with offset 1 and length U32_MAX then passes the
check for a 4096-byte write.

The transmit path treats the wrapped range as valid, exhausts the command
scatterlist, and dereferences the NULL next entry in
iscsi_tcp_segment_done().

Check the offset first, then compare the length with the remaining bytes in
the data buffer.

Fixes: a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld")
Cc: stable@vger.kernel.org
Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Acked-by: Chris Leech <cleech@redhat.com>
Link: https://patch.msgid.link/DB5PR08MB100629CD3750FBF71475B5224FD982@DB5PR08MB10062.eurprd08.prod.outlook.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi_tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 671d86902ff92..fb481944c7b52 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -608,7 +608,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			      data_length, session->max_burst);
 
 	data_offset = be32_to_cpu(rhdr->data_offset);
-	if (data_offset + data_length > task->sc->sdb.length) {
+	if (data_offset > task->sc->sdb.length ||
+	    data_length > task->sc->sdb.length - data_offset) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", data_length,
-- 
2.53.0



