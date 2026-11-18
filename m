Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026659;
	b=Pz8r85vrvHp0XtK45h7nepmGechN0GYo0RAz3ICcQTff6928fMLPFmYyg0e80Pe58uq3
	 1x0KGpV17xBa9SQyleotRIQ9qmM7cPLxP/C9XVwDTrcYXOq7y4EkxCksUCaZ+B4ldTnap
	 yI1T0QJzbGi9wmBBJQjgfTR9u1xyAezvPpNPeRsHskmSjpeUmJRzSmiG+nhbxCBVYEzT/
	 LiGKk3MKc3DBN2JkJsPqA5hdOwTotbzug0lHJLVvr25xsgxH6X65YQW31ghIlK7coJUSD
	 jzkBCSRmpJvTGwl0X7eabCgI+pZyKOdRqoN49toGwGPk76eiPwlzgTdtyARxUvQ+g/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sDr/Ab7Pv1CYWQH534vvTYLea4i1O1s/kUDNtY8/cNY=;
	b=SE5SGEO1QV5FFkOmg3K85JDXGHmBKkgPZ/LueN4r4pIDnSQomkNtVyT3YcL32vJgS/yu
	 h1eyGStyS0WeKHjCOYWCV/DlPxHPYsRzJX71dCpv51Ax42kzNDCj2MKASxAmbE/ifzsFl
	 S6m6vtMtU3uybLUNgfMzW86B4If4NoihBXsqjRW9K18I+/Y8B80ly5EypvGe++64j1Xjc
	 hX2M4ElisdthkUXxXmQurZpD6LceFU+NOzv5RzCBOQVrfhQ4OOMzwwFqsrLTt/0nhOM9v
	 JIXT2YYbBG2v08iKVAT3r1IoKPcvfl2kvNAsUcVik4Mrj2EPoEBycAB2MDN9tdYtmkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZgyNRK/d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCACA606A31C;
	Wed, 18 Nov 2026 18:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZgyNRK/d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D687E1F000C5;
	Wed, 18 Nov 2026 18:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026659;
	bh=sDr/Ab7Pv1CYWQH534vvTYLea4i1O1s/kUDNtY8/cNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgyNRK/dFwVr01R8iYI0Q+laegJEwNxW4A1uwiwvidpVCWBhMrrxnmIo0iu9s8dmj
	 r9C/rIT1VHdGAtXuhLMJFjCAXYX+cZ453WYZwG3XY+RebA2pQjMcwxn0Fw5yxF1Rhz
	 rXAXF6LjJXMRfg8q76zQWo+I0IvBUf2otlttfan4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.garry@linux.dev>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1471/2151] scsi: scsi_debug: Fix a locking bug in resp_write_same()
Date: Wed, 18 Nov 2026 15:53:26 +0100
Message-ID: <20261118150215.475371558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 2f50ca3d46b4d5916874ba19612498c0a9c1f5f9 ]

If fetch_to_dev_buffer() fails in resp_write_same(), the function jumps
to 'out' without releasing the data write lock acquired earlier via
sdeb_data_write_lock(). Jump to 'unlock' instead so that
sdeb_data_write_unlock() is called on the error path. This bug has been
discovered by building the scsi_debug driver with Clang and modified
lock context annotations. The modified lock context annotations are
available in patch "scsi: scsi_debug: Improve lock context annotations".

Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/271ea11d3bc147d950a89419181f0c3f5a1ebf3b.1791924924.git.bvanassche@acm.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5acf24391ae67..bc0fe470f66fd 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5286,7 +5286,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 
 	if (-1 == ret) {
 		ret = DID_ERROR << 16;
-		goto out;
+		goto unlock;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: %s: lb size=%u, IO sent=%d bytes\n",
@@ -5303,8 +5303,9 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	/* If ZBC zone then bump its write pointer */
 	if (sdebug_dev_is_zoned(devip))
 		zbc_inc_wp(devip, lba, num);
-	sdeb_data_write_unlock(sip);
 	ret = 0;
+unlock:
+	sdeb_data_write_unlock(sip);
 out:
 	if (meta_data_locked)
 		sdeb_meta_write_unlock(sip);
-- 
2.53.0



