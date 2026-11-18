Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020038;
	b=cKWfy3BEpNrQKT+ZqcvRYfuYiwt5jBiSL2L2qvkrfffMaR+Sq2EpY4ENZd9bg8VyXeLT
	 QfmZvOMS7F6oyTXlXBkpTO8rScrbybAzWFOISaQ6z+gcM5HLjnb5pC4af0VixBu5++tzq
	 EZ+qDxLM1wBji0MZPPCZIvl1NZiRvloE4o0RxJslZGkTCyJdnEZam5YFKfBvUPnRzoRZX
	 yMKxT5ddx9umv/B77ASSeOKVKTfmWego25sQ2lBdkJqcPjsWzu9PQJLqsDqj6UWjuP9EM
	 safuYTz7+j1nWtKJ1GWib0elQ8+tGVHqBsVKeTl9vBL0tJQt/LMkkZu85UroA9oi58g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nFPp7ZYP4ck4INGy+1bdPX/qjgQvUHK85YBItWtdm+E=;
	b=hjRQNMn64GyIAP0Ue+mk54/hyUCctmRqOtsqSPhTpnyYv1Vqvv0A/zBOUziMtVfnC+pP
	 5U5p+gGoQS5IGISyDD9Ld0W2HkE8qjf4VZVhhe/uHRYeboFrJq2y1W7v95+Bz3hiy0exi
	 ZjOPpQcNpd+RNa9IcrOe2uhqDjJi37RTNO0FmTTmsYZRDao0XltbQaB/SX7Jf+C+d9zwa
	 O7xPVNgi7fXGsAEz315zMRZm7SZWw2NYP3yb5QypRKUQmJaAHkEFxnrnTk11Fu8zgwhrN
	 KuYnWVQgff58ZZffqzIAfyrm1ZdfLwPfYeMIvyBf5Ju5bVuKOgStJUVyOL3khjLVM+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zufYM5ev;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0868F606A339;
	Wed, 18 Nov 2026 16:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zufYM5ev
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5638D1F000C6;
	Wed, 18 Nov 2026 16:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020037;
	bh=nFPp7ZYP4ck4INGy+1bdPX/qjgQvUHK85YBItWtdm+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zufYM5evis6UajJSx1T9MNScxmpiu7rrSQPeOgbOsBoWkzmtTFMw/qV53zamlwFMe
	 /3kQM3G08W6s18t7RbwSjO/tp15EB6Dj3cfI9rRNNJCQ6EMrCm+NzJ8ED+gBJmf1my
	 H5uDMWip5MnLdHuUngkHAYsGCuMFLqDoilikErJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.garry@linux.dev>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1809/2651] scsi: scsi_debug: Fix a locking bug in resp_write_same()
Date: Wed, 18 Nov 2026 15:50:49 +0100
Message-ID: <20261118150352.369303880@linuxfoundation.org>
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
index 384f70afe3fc8..8290feadc212b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5255,7 +5255,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 
 	if (-1 == ret) {
 		ret = DID_ERROR << 16;
-		goto out;
+		goto unlock;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: %s: lb size=%u, IO sent=%d bytes\n",
@@ -5272,8 +5272,9 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
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



