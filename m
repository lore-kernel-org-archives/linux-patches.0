Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032224;
	b=wruBuYb/jXYx+9X7PFjJEbawSm8U6oIK2FzTrcFXK0rnVtTyvDlp/xc45qDNPT1GPIde
	 dRt1x6HkmLP3uwDwl73HYZI3nae/H2b+1dBdAJFmsr9Sagw2iZjv87O1fYOXn31v1zcM1
	 1Ywqql2nGH+K/98X+2reHloB1a6VBS33Uxg7egehI/8ZTqo6AtZEE8hl4llHTYrfj8B1O
	 Gk+h6rx8x65m6a1epw6fRz0hofOkM9MhTyoN0eLmsrNSpPnCctf0bkz6LsmFesGUrJItc
	 Pk1U/tIV/lZq8THaYN7869CJMzkHDAQu/6pRrGoVjBmFsbkOmbY+Fv4PCYvykkDXo/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KVlX3wjltiOcdO531BQLkF4Wr+EEIVfeDgbDaT83dDQ=;
	b=a8t5vnPaLUnoW8qUxsLeEBvjobr4Cnw+4hEQMrGsRP4aPD6YIBHpOInYf6ZCG5y4DxeC
	 TTm/rm1+FR58Kk6oXFdpf+jZIkKj69DdLIW/2rOLOHJFW6wwbHDXB7UOB9NAtQ6EZAtfH
	 djRYR8O7yiSJVlS62JBOtCaE0g+PlK0b2i2seSIPWNX//BeQCDmBcIAzahieposkfr7+q
	 1fiMhDD2a0bGdjWMPrXJhNV6pPIewgsmAnjaFheleoK4miIgm8snRvXSdDgTPbuU8fJkB
	 6VVHZbLVraNoxT34ezX9fA1+G8pjRuwIGZNu8Pd/aA2/XY71wB/P3Lo2iq1JEmscgwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=norogRrX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FB6606A320;
	Wed, 18 Nov 2026 20:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=norogRrX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0771F000C4;
	Wed, 18 Nov 2026 20:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032224;
	bh=KVlX3wjltiOcdO531BQLkF4Wr+EEIVfeDgbDaT83dDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=norogRrXFvL/XWhSKxfKpbc+UdHhF+d1B3Mvre/jJtd3jtIXsS2dCtW3XTJlswRRJ
	 avlhNbpEkN4PXNCE+f5WKLCle4A9V20PmJozbyBeNnqHLZLWfxAGAn+pYldd3v05U1
	 QI1Sh3DRcUt4Y0wI4bNEYvg0NEr5XATCu83Anosw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1337/1756] blk-iocost: charge zone appends as writes
Date: Wed, 18 Nov 2026 15:57:44 +0100
Message-ID: <20261118150102.582554351@linuxfoundation.org>
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

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit febdbf5682fa7e8f325b07a2c115e7632c4252bd ]

Zone append is a primary write operation for zoned devices; zoned xfs
and btrfs use it for data writes.  It is priced at zero, so the zone
append portion of zoned workloads runs outside the controller: a
1%-weight cgroup issued 16000 appends at zero cost on a zoned null_blk.

Treat REQ_OP_ZONE_APPEND the same as REQ_OP_WRITE so it goes through
the existing seq/rand classification and charging.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20260922043856.2020116-3-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index b33df932ea1b8..ce822834d5b90 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2548,6 +2548,7 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 		coef_randio	= ioc->params.lcoefs[LCOEF_RRANDIO];
 		coef_page	= ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		coef_seqio	= ioc->params.lcoefs[LCOEF_WSEQIO];
 		coef_randio	= ioc->params.lcoefs[LCOEF_WRANDIO];
-- 
2.53.0



