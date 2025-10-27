Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732DC32548B;
	Mon, 27 Oct 2025 18:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591006; cv=none; b=eySzC7KPS7dYHG2I4CjofUeCavHXsKgYGW8M0YOmPW5a8+LkDZC23uVCm/aUXXnqSVMHmXtpbRHQbLi/aBKU11NcENhIwNZ3kQc6ujvVIDH3ZstNlPt8RBfb7l9alXBc8Ubo2W5SqmUR33Fe3D8sxiLN+Klp0mbFAjrFrDkIYSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591006; c=relaxed/simple;
	bh=2Z2k18Wxyzs1TS/x3JWsBQ7OrILcUHTJ4GPRpi4umz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSY/QZvH6O3OHrJcshzdvcdrMjTvHGw1yI4DptI/fwUkM4eQeRpgw6W1vCRPgC3TTDuCNOBrQR30yrEU1NNwmuceUKyUWWaW5qCLJL9f+8N82ZyNLnSoURPqJ9LNYlmRiHvl1T6j9c2KIP295a5hSBumgBxvyu0d9sIUFLyGdIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iX4GgcTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iX4GgcTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054E7C4CEFD;
	Mon, 27 Oct 2025 18:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591006;
	bh=2Z2k18Wxyzs1TS/x3JWsBQ7OrILcUHTJ4GPRpi4umz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iX4GgcTEXq8W/rvvYIdkeOKRVQlynsPq07Fi/wP+B8fn4jU4y94bDGupRfXDkTYih
	 1+yFZFFyzhKXhl+X5mX7KmH4c8deCCgmhDd0nh1gVgWToMlhycM9ygjNiqEHK2jvGy
	 aBtPrtMrg1YzisZOZKRK0H0SLom9xJgBHC5/Fv5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/332] block: use int to store blk_stack_limits() return value
Date: Mon, 27 Oct 2025 19:31:23 +0100
Message-ID: <20251027183525.416715434@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 18855d4bfda23..b2678e4dfa9e6 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -523,7 +523,8 @@ static unsigned int blk_round_down_sectors(unsigned int sectors, unsigned int lb
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



