Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434A71C68C;
	Sun,  1 Sep 2024 16:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208977; cv=none; b=el/ULFCIcN9nxVU/pQbEi0grKoRH7oaejqp+ejURaJQHgVkG04zbXSkghxnEuuN6PE6OJYzcNZEDYX1CkUQ8RswZa/Jzt3bnMeo/4YFNKkxYIHMJqzNX5NeUoxdjsXLdrZAuQkj49GycPW5LnF/9rqrQUfVlYAUCu7brd9RmI24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208977; c=relaxed/simple;
	bh=JNnPHHDiy6KORCZHWUOp6u8HBULngxrbS5Gzt/DnXrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqWuVc4XCU7tmHR5HZGzwMMhDjhIXb951avkC9jI0QugBjIRTPrEQJXlfsdI+kX1b37O6nzKeWZembGLXbEKgzH06iuy05FTZuANnUbDAI58TJqz/dEvi0BH/xMJzbdZjOlBzvrijnmTXkrVHmvNe6CFUvXkIxOOoWTZaw7ZFTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZbfipIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZbfipIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE4FC4CEC3;
	Sun,  1 Sep 2024 16:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208977;
	bh=JNnPHHDiy6KORCZHWUOp6u8HBULngxrbS5Gzt/DnXrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZbfipIHv3r/C0mufW8dKef+0KPcNbVTxC4P0+WaY5nyFg1SLmBZEmWCqbGJ3nNIL
	 DIXGDRQvij1iwQAiA+L5S6fQVd7ktsQujC/mLre1jKR4/28joAwE1plWWTazLGcd/y
	 2LmS/D1eTChAWX0cvb98Am9sueeS00RlnXriqeSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/134] mmc: mmc_test: Fix NULL dereference on allocation failure
Date: Sun,  1 Sep 2024 18:17:23 +0200
Message-ID: <20240901160813.743862093@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a1e627af32ed60713941cbfc8075d44cad07f6dd ]

If the "test->highmem = alloc_pages()" allocation fails then calling
__free_pages(test->highmem) will result in a NULL dereference.  Also
change the error code to -ENOMEM instead of returning success.

Fixes: 2661081f5ab9 ("mmc_test: highmem tests")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/8c90be28-67b4-4b0d-a105-034dc72a0b31@stanley.mountain
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/mmc_test.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/mmc_test.c b/drivers/mmc/core/mmc_test.c
index cd64e0f23ae54..8fcaec5544ff4 100644
--- a/drivers/mmc/core/mmc_test.c
+++ b/drivers/mmc/core/mmc_test.c
@@ -3097,13 +3097,13 @@ static ssize_t mtf_test_write(struct file *file, const char __user *buf,
 	test->buffer = kzalloc(BUFFER_SIZE, GFP_KERNEL);
 #ifdef CONFIG_HIGHMEM
 	test->highmem = alloc_pages(GFP_KERNEL | __GFP_HIGHMEM, BUFFER_ORDER);
+	if (!test->highmem) {
+		count = -ENOMEM;
+		goto free_test_buffer;
+	}
 #endif
 
-#ifdef CONFIG_HIGHMEM
-	if (test->buffer && test->highmem) {
-#else
 	if (test->buffer) {
-#endif
 		mutex_lock(&mmc_test_lock);
 		mmc_test_run(test, testcase);
 		mutex_unlock(&mmc_test_lock);
@@ -3111,6 +3111,7 @@ static ssize_t mtf_test_write(struct file *file, const char __user *buf,
 
 #ifdef CONFIG_HIGHMEM
 	__free_pages(test->highmem, BUFFER_ORDER);
+free_test_buffer:
 #endif
 	kfree(test->buffer);
 	kfree(test);
-- 
2.43.0



