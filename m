Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FB01BD514;
	Tue, 27 Aug 2024 15:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771509; cv=none; b=gtwyIiAVdI83qe9os3WrJZDD7q6eK2Kq9m+qdgKANPDrsLXHO9CTjR3wrmkhZhkvknXtg6Y5kezJVMlZ4bjHtf2TGTb6dnZwK38cQLgYllOEDNnp2NERPpK9yR2dIzP8A7iZvhcjeInSMOIUHgJbCtXO1cz3AB99boAerxI213U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771509; c=relaxed/simple;
	bh=yu2A8gX9B/Jx4T91PAEdCtuvrk/KpkXjpnV64czQDhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lv0u0QE14RdUURWrT4Skl2EceX4E8Hkfd3YBD78yRpkMUhLNGKXdQgEJpEwdkSJrecnH+AIBbT3AR8jv9TTZSUQzl8oR36FFOF3LMgtSOV+UPLZQTYbN8aLK2vx3XLfm+ledSv1p/tTM5J2nQKQFfI3nLHwodmP1My3k3JeyO0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMThWGvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMThWGvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56A3C4DDF2;
	Tue, 27 Aug 2024 15:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771509;
	bh=yu2A8gX9B/Jx4T91PAEdCtuvrk/KpkXjpnV64czQDhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMThWGvfm/4M+ybO+TXuSFE3OW/oWZm/hPzJLgAIaso9lIxY7mMyo+9pr51JtwJbR
	 mXvcIPnWOPiVnXMQiirlj5bP54zGnr2rVH97cB2cPl6LkaqTVpKYpK4Nha034gMcOb
	 zVHuNsrnat9f2NYKRaaEoXWbpLjdszDOG8HjhBls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 210/273] mmc: mmc_test: Fix NULL dereference on allocation failure
Date: Tue, 27 Aug 2024 16:38:54 +0200
Message-ID: <20240827143841.401908583@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8f7f587a0025b..b7f627a9fdeab 100644
--- a/drivers/mmc/core/mmc_test.c
+++ b/drivers/mmc/core/mmc_test.c
@@ -3125,13 +3125,13 @@ static ssize_t mtf_test_write(struct file *file, const char __user *buf,
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
@@ -3139,6 +3139,7 @@ static ssize_t mtf_test_write(struct file *file, const char __user *buf,
 
 #ifdef CONFIG_HIGHMEM
 	__free_pages(test->highmem, BUFFER_ORDER);
+free_test_buffer:
 #endif
 	kfree(test->buffer);
 	kfree(test);
-- 
2.43.0



