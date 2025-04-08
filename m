Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84432673B7;
	Tue,  8 Apr 2025 11:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110685; cv=none; b=cVPtDgyKV/xTEIx5bvmBT8pUADOYIUUC11zFQTnTcaNqFKdnGGex18bADcfm2l6W6WY3H9nMZ6m63yX9ET3+UBy23WBgIbIFk6h6eUiYYFT3mq80CxrDqjZNfq4a5MCjtPd9OKbcQg5t3RQ8y9oW9ifa99g0p0vWHk0e/h/dn9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110685; c=relaxed/simple;
	bh=FngCrHle8/utvD31odbAYD1RmqIVAP8wLsiUtlasIPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bO2W+e1yVOnd4DMu5NdlGm2X5yjs7O9pnehDW1K5fXsyt4TcuYwxVcYzW6kG1lan3qP64mUkvk1Tt4YeFH4knmsdP31G6sAqsNRZB8uhTeQmyKwNWaddR2vbRw5YnGmc4wYpXVbdsROc1UB0DF1fCDaV6PbcbJTCGLoyYjLOlng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lza1jTSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lza1jTSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C64C4CEE5;
	Tue,  8 Apr 2025 11:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110684;
	bh=FngCrHle8/utvD31odbAYD1RmqIVAP8wLsiUtlasIPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lza1jTSauz6TeuzK2eAvaS0vNqTWTIFtBuJ9C531zZVT/WWr7jMfd5Q93smVkRYjr
	 IFQoTHzAmP0dzlXP6DZ+fKsPrjKEkdYuKi/Rv/OsMhGpW65M40e6T+SKDNbxT7GMAt
	 WI3lYrrTpf85lI6eyj0P4KUuIc04QeOjA6BAw5Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Yu Kuai <yukuai3@huawei.com>,
	Coly Li <colyli@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 154/731] badblocks: fix the using of MAX_BADBLOCKS
Date: Tue,  8 Apr 2025 12:40:51 +0200
Message-ID: <20250408104917.857989449@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 37446680dfbfbba7cbedd680047182f70a0b857b ]

The number of badblocks cannot exceed MAX_BADBLOCKS, but it should be
allowed to equal MAX_BADBLOCKS.

Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
Fixes: c3c6a86e9efc ("badblocks: add helper routines for badblock ranges handling")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Coly Li <colyli@kernel.org>
Link: https://lore.kernel.org/r/20250227075507.151331-7-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/badblocks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 88f27d4f38563..43430bd3efa7d 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -700,7 +700,7 @@ static bool can_front_overwrite(struct badblocks *bb, int prev,
 			*extra = 2;
 	}
 
-	if ((bb->count + (*extra)) >= MAX_BADBLOCKS)
+	if ((bb->count + (*extra)) > MAX_BADBLOCKS)
 		return false;
 
 	return true;
@@ -1135,7 +1135,7 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 		if ((BB_OFFSET(p[prev]) < bad.start) &&
 		    (BB_END(p[prev]) > (bad.start + bad.len))) {
 			/* Splitting */
-			if ((bb->count + 1) < MAX_BADBLOCKS) {
+			if ((bb->count + 1) <= MAX_BADBLOCKS) {
 				len = front_splitting_clear(bb, prev, &bad);
 				bb->count += 1;
 				cleared++;
-- 
2.39.5



