Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022289;
	b=TzJG1Km5NwwunNEW15Ald/hx6Iox64SeYrvvukCMv3sYMQXD+87iqey5W8ffjPNRwwUJ
	 rmqiOt22LC6Glf1dsx2M9RRNem/Wcf2ksW2nd7OcZePk1UahKicCCAUrKDcBSR+UI3Rm7
	 O4kRnD/wHE0zyMpy2e6RQFDNAt6xOOr1qP1zJGjpm/WJrnKhtEXUYblWFleFNMl2vo+Sr
	 guvRBqzD0H6WDk4zXNvueIf0RdQfXucz5BbSZ10k5lJEG6sAEPhI33y+0heX29dF+mYUA
	 yzT8gOaRT9ddTA1g8wO9VavmI5Rtl5Jq9YIf//wP0yod73OcFkIs8/uQpEXZilTXw3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WhgZbs3o+IqqrVSRqPCZd62CSz0rvt6QuitJK5sdjLY=;
	b=dXnU7v/4bFDsiInjZKO6rsCOEsn4Hy4YP0hmaeStkvvojlpGDVg1WkLyp5LV1LpD2IDO
	 LCbx3+oEbAcFT3Klv7lHMS57e/jD/ZCxmv76gXO1+X1bmW51vziU9L/ITM3EejONGLOcl
	 +vbB3UglvKViSxbzU53217k1IIjgK9L3iLeLs4OZ4x4qNzaJ0cHM+m9q2kCb96AA5vKHO
	 Hd/RuzpGT6Ac1ULAlZnvr9ePOMdnA9a6jEwVrFyY4syU1hYUk1MvZV6dcuvpB5JbXgfoZ
	 js3bknNlQXrf115F53x+oAvvrPR8lZ0A77Y2WavBTot4a6ebL35kUNAsiJboM4BNfTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ic9CsFhO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144BB606A31C;
	Wed, 18 Nov 2026 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ic9CsFhO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6674C1F000C7;
	Wed, 18 Nov 2026 17:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022288;
	bh=WhgZbs3o+IqqrVSRqPCZd62CSz0rvt6QuitJK5sdjLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ic9CsFhOS0FKcQNVZqad3s4SkmlhJWV1UsQ3eDq9ypIvVZZRFbb6GIGpcQfj3a30D
	 CzaWmYWufBmmotOeSLAHOPmIHbjKS1DTsdgotML0HHq1PZvOEgQganzgpfqzu9fPdL
	 cbrm2tfVRjSX/16bve0aZZxfcOLaxvOQN/vn+jnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2608/2651] zloop: check that the zone backing file support ->{read,write}_iter
Date: Wed, 18 Nov 2026 16:04:08 +0100
Message-ID: <20261118150418.147057671@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0c10f8a1a7ae1502ea4ea7e13f222df89c28adf4 ]

I/O to backing files requires support for iter based read/write, so check
for that upfront instead of dereferencing a NULL pointer later.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261029150353.2503201-5-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index d41c0d54ae4e5..2933f6db4fd0b 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1122,6 +1122,11 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 		return PTR_ERR(zone->file);
 	}
 
+	if (!zone->file->f_op->read_iter || !zone->file->f_op->write_iter) {
+		ret = -EINVAL;
+		goto out_fput;
+	}
+
 	if (zlo->block_size) {
 		ret = zloop_get_block_size(zlo, zone);
 		if (ret)
-- 
2.53.0



