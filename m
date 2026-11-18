Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036874;
	b=x6TCEQ4kC9abFgJ5X3L7i4wSjqFN8ogmUEJjkmfDKuwzY9why++FEGFTRTb3ojUN+BgC
	 rwfB1/QRgKEctG98SpqbeEUVNVbFeFDVO/peG0A8tA1tsuPv1+gd44m5gbASCSklbSFt2
	 RXmKEEDDPQv1QtGXzQYKtoFca8aR3ObIKypBGjLMomM0mNCF34N7ZqVV3A7m+y0zAiWhk
	 reWuByOkwhsbs9Pt0NxeCdQhU/IMPyN6E6OXDsoiooUiWNAKlmWy56NZj+aRcjJBFHwpw
	 NR2CiuWWZkq1KNF/QDrFmDir9tZ1/UkgiW5kc555F88iKzUy1FY3dc8Q5KdXpcHPLzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uSL8LqMVmyW1pA88mX+CnyAjkOMUL6hJhmyPHAIKnB4=;
	b=K97K17cKikWFh9uOQuaiZ3voY9ExY2Q2gn0+lPxfzdZWWqy+VABn54yI43Ft42+cdjgZ
	 JJke0T5Zd1jU7wXXj5ClFl9YROBjl3lzJ/9NWFzLmBXc6/MES661o+5lOvB5Gv2Z/yY7I
	 lMSiyzv4IIYn9HGoV7r/rn7SLfWqPS40+nYKBEZOz1OntWBUn3AAe8ZQ7yvDiMx18z0Lj
	 A4H5S+++ROsOs+37NKorRgYPm/tdzoCdMkwjyx5aEwgdLR0Pn3NE6nXXvZP4mFRkati06
	 1ydNA7L+pUBu9MfnLKzVaAtK5Y766A4SeicJ9CKTLun8YZkyuiLflv5JqO8CzUaxPDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYPSC1Rk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CCA606A31C;
	Wed, 18 Nov 2026 21:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYPSC1Rk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58C21F000C4;
	Wed, 18 Nov 2026 21:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036874;
	bh=uSL8LqMVmyW1pA88mX+CnyAjkOMUL6hJhmyPHAIKnB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYPSC1RkQLPR56nJRnqVmAn1FcA3FAXVAoRhow/1cttFTYkkmyJ5pH+tvzi+FSNnl
	 uF7s7o5WQarNo6mJoky+ezIQKctgxVpjb9ClosRIG5Cmm7vc9jjFdUsyy+xscHPn8y
	 2AbzVXqJlb9NsFa1JciBgHMyiPMa78f6z6f4LtHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1215/3318] scsi: libiscsi_tcp: Prevent R2T range check overflow
Date: Wed, 18 Nov 2026 15:30:37 +0100
Message-ID: <20261118150356.626216471@linuxfoundation.org>
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



