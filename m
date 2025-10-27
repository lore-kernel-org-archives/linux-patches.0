Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FBD218EB1;
	Mon, 27 Oct 2025 18:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590386; cv=none; b=AVoM8CO7AaDfbgt8caB2BzJ0w+991njcnDbk4mPmRhJ6TsFPBQ4AeLugMjkCDWo9Qefg2ZTAU7aODCG9xPBFOyoWwet13Go7KaBDtXM1E4poaG8JrTqlLRq3qAzLHSnmAWTI0DvZw/NqwlHVVGzMfughgkMRRihg60b+4NqLFNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590386; c=relaxed/simple;
	bh=uYUBxInjEvs8zC5D+nm2QIO2quYjbJunDRpDRRtSY0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWoO4YkD3PchiGEXYJzh38p7LSl8rS5CIGzKm7HpQmOf55fZZX/2HrOUs5m2cLRZwZI7tQwNx4DYfIFArd1LfQqT5I6tyLye2cKqgdrPPkl8i76eO9ib1/Aj+0c1YXAG5pA/R4G8xCooUeK6+KKKi2mPdor6dFcEs6U1EVhAa90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Al3V/XvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Al3V/XvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF30C4CEF1;
	Mon, 27 Oct 2025 18:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590386;
	bh=uYUBxInjEvs8zC5D+nm2QIO2quYjbJunDRpDRRtSY0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Al3V/XvNraDRDME9wYNvHk4n3gyCPhgJXQs0NjOLzKrnfMLgvpskRly2jBtnOahOV
	 b8sp4GFKk1K1ckiquUlVsE+gpmty2M8KQT4SS9BHrTdKmhsYnDakYbGta3ia3lqnEi
	 hzAemDg1DHZ7b7uGPXAx/PlZWb3XJCfs3pZiaiic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/224] block: use int to store blk_stack_limits() return value
Date: Mon, 27 Oct 2025 19:32:51 +0100
Message-ID: <20251027183509.679051278@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 13be635300a85..d4870441a38ac 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -505,7 +505,8 @@ static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lb
 int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		     sector_t start)
 {
-	unsigned int top, bottom, alignment, ret = 0;
+	unsigned int top, bottom, alignment;
+	int ret = 0;
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
-- 
2.51.0



