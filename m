Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F8E2F6186;
	Tue, 11 Nov 2025 01:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825407; cv=none; b=fUVbR4b/w+JOUacgxakEvWr6/sih7Ci+9E3132J3iNYQqn+1sEi19PmnywLEcnYOxGLC4rDPP7mKVxteHuWtZEsRJt7IrmkqoMBU0vQoVFk4iloXFzrsdSTcKeDxjV3QChxU0C4CnKjRuOMN0INfVssAf0MRym998uGdZF5zlRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825407; c=relaxed/simple;
	bh=O2dAIEDJLOjWl+LLwlxLWZXm6n8nBztS2nlgVYu4QQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+37zAWzTjRBwag2+n6sI7FuIzIOxd4P64JgNBbFjQpGAMqyaFhA3y5vG7nUKZXLhBn0J+vn3V+c7RetZovwVGFptsQPPj7q/ca5MSV8yd+i+Umw8QDK06q73OsWzWqLJhzAHD04Rfbt9783k6l5hn9++hOhe4e2zV4aKZRS5zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6hSGMUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6hSGMUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CA7C116B1;
	Tue, 11 Nov 2025 01:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825407;
	bh=O2dAIEDJLOjWl+LLwlxLWZXm6n8nBztS2nlgVYu4QQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6hSGMUqIuwG4XNcykxo2FFPkLTlEqtIhJ/tswVmT6xec3IIuD7yrqEpXT7RD+euu
	 PQTryqyXSuhgtHuENGFqBvbGkVzCH5mmbZT//y3nrdMiGvY9Q1NO9H7Eo4eS0mOkux
	 R8EfuhNrnkr/j2LOpamIbwZPg/lhtldGjdF3IY64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 788/849] io_uring: fix types for region size calulation
Date: Tue, 11 Nov 2025 09:45:58 +0900
Message-ID: <20251111004555.487358589@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 1fd5367391bf0eeb09e624c4ab45121b54eaab96 ]

->nr_pages is int, it needs type extension before calculating the region
size.

Fixes: a90558b36ccee ("io_uring/memmap: helper for pinning region pages")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
[axboe: style fixup]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/memmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 2e99dffddfc5c..add03ca75cb90 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -135,7 +135,7 @@ static int io_region_pin_pages(struct io_ring_ctx *ctx,
 				struct io_mapped_region *mr,
 				struct io_uring_region_desc *reg)
 {
-	unsigned long size = mr->nr_pages << PAGE_SHIFT;
+	unsigned long size = (size_t) mr->nr_pages << PAGE_SHIFT;
 	struct page **pages;
 	int nr_pages;
 
-- 
2.51.0



