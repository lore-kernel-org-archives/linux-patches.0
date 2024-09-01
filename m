Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7B21DFD1;
	Sun,  1 Sep 2024 16:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209661; cv=none; b=eq+q4p61Hwf/gXo2rulhuYX9CzgrTqR0oXe+NCpxODlwcOBtPZrF/vecevWYKQvXO/lojRMV0JP0Mi779n+B5ORqGz8Eb4CGt62JgifZ9NfASknTvCQXX7ZscOd57wu2UA3P1K0Vl6kDKa/oHADLzjCjmXvQm6YroVPhVaGr2Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209661; c=relaxed/simple;
	bh=4N43GypOoxl2yzewmonFwNwmamo1/q58lZHeUOgsTjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceR/Q+RE1C35RcCJSbufGXMGm/2TsBrEfBpUBPgI+YBUk/emjz7wb35WBtETxs5XUxgUMpiCwXFB1c9QGSf4+0EbZ8jgkI5raK74h2s8efouvW8d+vetbwrWUsDjV1u4xAJFGdh5KQ1t1yKtcp46bfX8Yq5j48of/W+7kGhrXhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5Othbht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5Othbht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190E5C4CEC3;
	Sun,  1 Sep 2024 16:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209660;
	bh=4N43GypOoxl2yzewmonFwNwmamo1/q58lZHeUOgsTjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5OthbhtY3R3t8vIbWKofxvkUS2moVxv79hjhhrMjrKhoYy07PmhHzSHDUnf/xoUc
	 3IryXfrz7kqGQJ7YBsp7OFDYRCjBYI4EFQNu9aNAHqO8ZO7iIMVb+SZvtKDoduXzEb
	 MAlhN29cXHPvF+M4mhg24XEJIBzoMiNlycNXoYbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/151] mmc: mmc_test: Fix NULL dereference on allocation failure
Date: Sun,  1 Sep 2024 18:17:46 +0200
Message-ID: <20240901160818.097823746@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b9b6f000154bb..9ebd5cebd4e13 100644
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



