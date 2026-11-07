Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062546;
	b=2uIPowwOmZk2JLVJsEVq0E69jBNds2pWo5N6657xXEDVL9R7SVJlrhSQxAqMAgQutltK
	 24r+HHm7Rk20EXN1CaziYYDOYZ/8uafhi1dQVLSboKcHa4XSmiZZC8jA+7ITRkr0ixYFZ
	 xMjbe5zYQt3OZf4Aqc14YZq/ReC1zjYv3YExTRym6b8MmTtVzZb8XOGSvt+ZaT/ijPs8W
	 WClo+MJuk31l4z4W0Z4YGkJmp3R4TU3CBxK26NQ8mqRVPw5cRPvnZ07P27yfmpso/jIuc
	 lWC+ee2wZDl8zYRe8fe4XsZ1E0nA9BmnwMmUrTvrQdztMVNqefjR4SYY746wsrBC32Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IA/T3f+2jL1CW7TAmUp6bcikM/RbWuJD3d2UvT/iy0E=;
	b=cgqz2M3YdXDlJ++4Uqi5f4yIa8hELT6HCM+iHBSV0mjmJqAT3G6F/ppHGAoa27DV8IEh
	 0ubSv5GObUiIDv+ekeIXWJhVdyh3tygiimLqqagf9WncsX2sPtr20Qce6SSbXffbX/Ciz
	 15MaZxzOZe3R8C56Iijevo+9eUJmfD4xg4Xp/aBK6Qrzplbx4tIhPqPHaDe15HCg54qDg
	 7ecGTyhqNTxnk/wDlJj9HDGaCKmSmGkV2xpPvMJvS9h3oA3B+YdqWTWYJka9aSfoFHGWl
	 QtZB29aJs5n8Z1HyF5yoo8v97THr0pdqJqCfikQESHFFXqUstOtg4Ugm7W4TMQZL5cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ky5t2VJY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638FB606A33C;
	Sat,  7 Nov 2026 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ky5t2VJY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1375B1F008A2;
	Sat,  7 Nov 2026 14:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062546;
	bh=IA/T3f+2jL1CW7TAmUp6bcikM/RbWuJD3d2UvT/iy0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ky5t2VJYS8hZydR3p759Vz12ZY42skQaAzsXA4YxIKKZxot83QgU65gTCHt8qwgMs
	 hm1Yo8Ac9BXvkYoAq/7i3KUYWX/ADbd6/YeB55hZARdHD4uvLy/4gBhJ9SspffUXyu
	 limOnTprIRSKEYpfF0i0u5XHYOEPyaTCaCrg9Sxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1434/1536] scsi: libiscsi_tcp: Prevent R2T range check overflow
Date: Sat,  7 Nov 2026 08:57:30 -0500
Message-ID: <20261107135038.111649907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



