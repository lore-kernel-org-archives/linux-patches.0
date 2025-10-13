Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910E3311957;
	Mon, 13 Oct 2025 15:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368185; cv=none; b=B0fdI1WkBA32s2wVXAxaOtQzyX+QBRDI/3t4awkavOnB1hktB7kEDcgc7Zq64Llarl9c9Ub9urpTss4hL9ApD5tpEeyREPltwsZ12N6NNsLfEgED0lRoxyotOQjX6iuKqDPpOXmh2Grm9TMJzKziePVsPKbfo0oh7SDhpYJfb5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368185; c=relaxed/simple;
	bh=E6sVjzEyPIlsgel+yw/ZpX95aE9+GntFdeJXt54CQR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DISlxPwjSIWIK5AHSJ9in0zYR+Jl0q3ryQBVCkbp0t+OvOPaS3t0V+ZkjpgGrtttFAAqKMJS9pOBsdmHQNC07f8K2tAp9YVaiazJHr4AWqHaEYV5ZFH+g5ObZvrzfP1206WYPdTl4soC56VYhNj2/RpHNt3ClEWQPw/p/o9mmSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+fm8zDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+fm8zDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12324C4CEFE;
	Mon, 13 Oct 2025 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368185;
	bh=E6sVjzEyPIlsgel+yw/ZpX95aE9+GntFdeJXt54CQR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+fm8zDMRMsZbr/wLqFE+oi4QtbzDwxi7D6dWdGl7pDXiZ9Z1sbGmZ8CYJhdtlrau
	 wpn2ZzcJxkVtMCDxHbQKSYb+5AD0eILs2D1k9au0SnZAUSUr2ttp5WC3yRmiP00qmB
	 4hvjh5ubTobyRtw0Yu0usViIJDXRXyoyCRq0CSbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/262] block: use int to store blk_stack_limits() return value
Date: Mon, 13 Oct 2025 16:43:02 +0200
Message-ID: <20251013144327.574922010@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit b0b4518c992eb5f316c6e40ff186cbb7a5009518 ]

Change the 'ret' variable in blk_stack_limits() from unsigned int to int,
as it needs to store negative value -1.

Storing the negative error codes in unsigned type, or performing equality
comparisons (e.g., ret == -1), doesn't cause an issue at runtime [1] but
can be confusing.  Additionally, assigning negative error codes to unsigned
type may trigger a GCC warning when the -Wsign-conversion flag is enabled.

No effect on runtime.

Link: https://lore.kernel.org/all/x3wogjf6vgpkisdhg3abzrx7v7zktmdnfmqeih5kosszmagqfs@oh3qxrgzkikf/ #1
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Fixes: fe0b393f2c0a ("block: Correct handling of bottom device misaligment")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20250902130930.68317-1-rongqianfeng@vivo.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index f24fffdb6c294..d72a283401c3a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -552,7 +552,8 @@ static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lb
 int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		     sector_t start)
 {
-	unsigned int top, bottom, alignment, ret = 0;
+	unsigned int top, bottom, alignment;
+	int ret = 0;
 
 	t->features |= (b->features & BLK_FEAT_INHERIT_MASK);
 
-- 
2.51.0



