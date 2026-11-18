Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031750;
	b=uNm5ULsoQWCy17ssJKyaWrvHHg/rxA1SudQa2wcIzHeWfT9BUUI9EAdFrSIoniSozqFU
	 4qh2zOuOWU47ger6MCXD22zwhtWZeCDf4N66dKyvtryfGLM87y2TvRMVgE2bp5n0uhb/p
	 NdeOCcz/G/1PRWwc71y14D+t1XqIPLngY/hsnCo19IKjiMnHkyzAK2Ep3LzkztiEjO2Cy
	 NZOreky9AfGP+JVlzlCCIMGscQwI+/JIhTc7ASm13v/a3qrevSjo4+Q3zbfZDuBmHRW4w
	 SAGekfjFv0CJfHv8P2np2gxqQM73MX0qt82hK5aLZVB+8nWkznB9SY3hRdxwjohw4yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jXqFpW57VS1++fYBgxWuLMQ5mixQAUjtEAiC7ffKN20=;
	b=RBSwfm4BcLQDbWqHHIf8HweHyfYJo2gQRsbOsHfwdhgnsyiV5IhqDA76tZ0jR5wgXamw
	 wqMSW965WdXpitmaFoL1SxjdOfoPi7RpN5c+msCAp8OI/WkM0/SlG9djOMtQY3BMQN6el
	 nJtCoex6rDFbi4+Sf1OQ2m2vj41dzuGwEIjNXFalSxoSpkrxcIv2pD2tBs2maW4mHN8kh
	 VIkrjC8NUdv3rOLMcGSCgUDVOkpU6X4v1X2jrXaXYh+eqsC0ZgaJ/Z1fCI8Bfq1leMqjE
	 knUmij0vYH96VTXz11Y/Lsjbpws6NkdBvnOFC2DEuU5pWehSr1z26Ke/9RtTp6pqjOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b/NspnL5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1997606A31C;
	Wed, 18 Nov 2026 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b/NspnL5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FB51F000C4;
	Wed, 18 Nov 2026 19:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031749;
	bh=jXqFpW57VS1++fYBgxWuLMQ5mixQAUjtEAiC7ffKN20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/NspnL5asF19pAdIK9PywBXc96q6tFteSm9KoTaZrHBxpy8BMvXZdKGVsfErsmjT
	 eMFZ5Kuh8nzMUjGoNtoKNwvX0u1D74OAsWqX3rFzKr6atkMJSNK7wg5lZ1yVUah3zj
	 RGUPyNi92y1z1iqaW/napq6ShVcWr2q9A2hhVDcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.garry@linux.dev>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1168/1756] scsi: scsi_debug: Fix a locking bug in resp_write_same()
Date: Wed, 18 Nov 2026 15:54:55 +0100
Message-ID: <20261118150056.471681291@linuxfoundation.org>
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
index 0906ef5d7798e..c4e7b210183e9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4587,7 +4587,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 
 	if (-1 == ret) {
 		ret = DID_ERROR << 16;
-		goto out;
+		goto unlock;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: %s: lb size=%u, IO sent=%d bytes\n",
@@ -4604,8 +4604,9 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
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



