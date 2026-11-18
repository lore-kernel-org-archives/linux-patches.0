Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055255;
	b=l3n8lxzy/IGvoytp3xxkQwlX+Tfae1smiBT5hdyWQs1LOlrtEX2RQMWpGeU39tXmScLg
	 3IDj59PJxndGocpbK/7RUEieWAcBk3Mq75cL8dJgkOeU7D0U+V3706oO3Gkk/D7azCM2v
	 buCWgb1/QgG3tQ752Hp7+pNCHHSaDzpxRol6umhZnP11QdrXrvemgWZv/KX6olaCZfodl
	 ZzfJpt20XtlZ7hP243lek1/cRCOU3pdHoBi7U/GTcp7UFPKHbUE4YFMWPyw/mnkG4oCqI
	 Wqwu6frLZi24FIi42KIBJeEB5a/Hvou1FF7BzpvreCE+MnD4h5qhDIYwNS0qMqJl69Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j+XsuXziXYopqPfiF0weKuy6/i7BN0wg2rmxM73/IyY=;
	b=DoS3j52eWnN4Vr1s6B6fCwYzPvfRT1f+4NEFjtYTaHGsLO9+yaLKGbg3cBnHSGxeOhr6
	 LP7su+Do4M/gaBPf4D28QTP34zN5IUvLK49mPU46gPCwH/oO3yUbqiw/F75/0Ud8bxJpD
	 3uFHm+4/x+vE7xL/cs+K0DzHjTA7LvCiPG2a0jO2XwLNM/JiswFk0bzOKNt+qF4NfBVvm
	 ef6tYKwIRkYjKENCFJQh8M/VUzRT8VyTfEkUCD2vl+wsYaccxxe8WVsq1bKOoPhrcv/uE
	 2wNjzqrA1c0DlrdIRC0kCovavKTCTm+NqK/JBzYCFh3gI8yWoM5p/A6nSS3kp3mQSuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8veEf7Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A7860A2637;
	Thu, 19 Nov 2026 02:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8veEf7Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804A31F000CE;
	Thu, 19 Nov 2026 02:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055255;
	bh=j+XsuXziXYopqPfiF0weKuy6/i7BN0wg2rmxM73/IyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8veEf7Qeb8Z+5yvIvxIp0B/gWtv7ZH8+0uMA8PNXyEM4dMQ7xtvNi03eI0KLULME
	 OPEQ6jT0U/KwmC7nhtJvs3LPT4bTNKWLabSFU9/S/wIOO/50KTxMiEBQtwSb+ujWJr
	 R+252WaKPj6LEFKhDVcUQIm/ENvDsOwcRCNw/zKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1567/2214] swim: simplify using blk_cleanup_disk() on swim_remove()
Date: Wed, 18 Nov 2026 15:54:03 +0100
Message-ID: <20261118150114.740455022@linuxfoundation.org>
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

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit b76a30c254d987b4ae7d47415081121d4c0a7423 ]

We can simplify swim_remove() by using one call instead of two,
just as other drivers do. Use that pattern.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20210927220302.1073499-8-mcgrof@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 994a778d9665 ("swim: Configure parameter memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index c9b7b8a0ad62d..2934b7dc02bb2 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -924,9 +924,8 @@ static int swim_remove(struct platform_device *dev)
 
 	for (drive = 0; drive < swd->floppy_count; drive++) {
 		del_gendisk(swd->unit[drive].disk);
-		blk_cleanup_queue(swd->unit[drive].disk->queue);
+		blk_cleanup_disk(swd->unit[drive].disk);
 		blk_mq_free_tag_set(&swd->unit[drive].tag_set);
-		put_disk(swd->unit[drive].disk);
 	}
 
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
-- 
2.53.0



