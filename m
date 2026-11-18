Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045865;
	b=RtE4YbBc55OOBKty5RzpYn+dv0HcW1VSEZJ6XIHdHWXqNVGVQwQpagUM+jTeCnD9Kg2J
	 pY+Hk7x/p8MmCYlAltN8Z/8H51dDmUJ9MyBTEczn51jI1Tnf0phSetPYKG/m1NRmx+jf/
	 y7VkzyH0jF8XkkZFgRMgFn8hz+QrNQy1y9uxofnDhwxCSOUeYk9kKXUwyPX5IVyMHOZYS
	 qYeQQrq1wB2gAKRtWp3lT6HvJA+9IdkvAEq396QfLJOHdWJH4E6i4kDCrnevkENPzxV+i
	 v7UIA844hibCTMS7DTJMn8ZQT5KNveyN0/e6DVN60/5ZBHuAp3P5K10MDTdcY6qPyGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wPRkBlz6ltylHG0+hrLw5s5E7XsUzQjU/WPvzUh9ZEc=;
	b=T27ZkatV00ooIFNfT/GMUE7btIzHtFU0rXgyv9gYzgTQJNxCoiCoVu3m4sUi8loLfrnY
	 LC6Az74EoFcXc0eVDtNgBv37b8x6Q9V8bLuUdMSb6uOIOLlNU+lHuON3w/YFhekxvLQ1D
	 6MQVvotDoDafFbEQQMYW+bjJxVF+UOXXPoN/ODYYwfyjxUIns5bz4RhlUYaBn/3VjDc6l
	 RwviWmmsBcZPpfs4psJhtodQr1Zp9Z9jMUjSGHHPPgy7r/OrkKSNYsasBnWyfzUpQ9C7x
	 fKewt6jOcyn1TLV0Vb+uZuWIr0qVPiwjiDrHqICmpVmvs+rwoQbq3XWl9LICWOppeiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n9QGnLmh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BAA606A325;
	Wed, 18 Nov 2026 23:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n9QGnLmh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA82F1F000C4;
	Wed, 18 Nov 2026 23:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045865;
	bh=wPRkBlz6ltylHG0+hrLw5s5E7XsUzQjU/WPvzUh9ZEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9QGnLmhV7ESTVI8Bi81hqGcGqgSpmqVRnb76D7gy9cOsn0KlQLzt4Rb8wfXeBeUq
	 haJMfNDwJhVStca74LEEFW1JpBn2tfzNitr+qGg3ALrpxwRAwQRJiOgicJAKru5w8I
	 x7x9sEN80heYmLnCBxLuQ0WnqJmay8Sbzzs8tfXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1036/2857] scsi: libiscsi_tcp: Prevent R2T range check overflow
Date: Wed, 18 Nov 2026 15:34:30 +0100
Message-ID: <20261118150238.897696261@linuxfoundation.org>
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
index 646a2142ed666..4cce6bfb55c57 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -612,7 +612,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
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



