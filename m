Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2B1268C42;
	Tue,  8 Apr 2025 11:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110674; cv=none; b=jBgpIebW9OgnMgQAX69ZIKu7UKIqqIr0nctTahD+2pKxST6NAEXt6oqA08EbE02Gv8xDL8mkK1KcGR1q6LC/ucwMjj0i9lJe2Qj2UFV4ahkOLdSbBhPPHkMWHxExDtV3erVitCZcC5GesCuqswnrAJ7r/L0yGCPlrr6is+31Evo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110674; c=relaxed/simple;
	bh=0ZEJkxOx/pHLwNuiJUDylthupUz6yHjSz6PufHWyV9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esvpkK01kh4gTgHPlbXlaHcdFOx1QTIWsCe6oaEbiR2dsEfoJqE4glxOd3ZPFjxK5OkJygizScnb1cMorWHPPscQ+OMYnJcu+vH9mQzHi2qw7QJCrMniit8j62A7Fp8778zpFAoqyjGTRMwxW2ZGmQG5H3N7yxqlt5XwPAOpScE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONQVkOmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONQVkOmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A424BC4CEE5;
	Tue,  8 Apr 2025 11:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110674;
	bh=0ZEJkxOx/pHLwNuiJUDylthupUz6yHjSz6PufHWyV9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONQVkOmYFCTMuKgo6AOjKwkqpw6mUVZiScQNNRFYmZV+XKmx7Bh03DtrusOLqeq6v
	 dSFR453ryGBIfFIbizSc42hPRWeFMPBVOttIQDN1wjwFsqdsJdOepkw4UXGrx1lMil
	 VS6IlHTMFMmduEzlRdWzCb+zokNAhWP9ZyiLVdS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Coly Li <colyli@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 151/731] badblocks: attempt to merge adjacent badblocks during ack_all_badblocks
Date: Tue,  8 Apr 2025 12:40:48 +0200
Message-ID: <20250408104917.787078728@linuxfoundation.org>
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

[ Upstream commit 32e9ad4d11f69949ff331e35a417871ee0d31d99 ]

If ack and unack badblocks are adjacent, they will not be merged and will
remain as two separate badblocks. Even after the bad blocks are written
to disk and both become ack, they will still remain as two independent
bad blocks. This is not ideal as it wastes the limited space for
badblocks. Therefore, during ack_all_badblocks(), attempt to merge
badblocks if they are adjacent.

Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Coly Li <colyli@kernel.org>
Link: https://lore.kernel.org/r/20250227075507.151331-4-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/badblocks.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/badblocks.c b/block/badblocks.c
index f069c93e986df..ad8652fbe1c8f 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -1491,6 +1491,11 @@ void ack_all_badblocks(struct badblocks *bb)
 				p[i] = BB_MAKE(start, len, 1);
 			}
 		}
+
+		for (i = 0; i < bb->count ; i++)
+			while (try_adjacent_combine(bb, i))
+				;
+
 		bb->unacked_exist = 0;
 	}
 	write_sequnlock_irq(&bb->lock);
-- 
2.39.5



