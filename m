Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9AE376EC;
	Sun,  1 Sep 2024 17:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210335; cv=none; b=naS0GgWxdd+xs4Vu1bm8v884FVzksJzBlLS78MxjI8a4wvNJmrGDyOQDx9eblJNUrhti3yQWtYjmacJ2z8lmgHS4W/t6s1sPHcFeUXg1kGA7nwiOXpabPvgmEqP4EOhal2qSvqoRcPSYIEeBRQK4ZrxjcXXC6zANbBthzP/kpCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210335; c=relaxed/simple;
	bh=stS/028XzAIZYMkH60r9tHgbyVWDXXyJpju+I/3JDh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbtRvpjSshir+/E4csYQlwhh/njM0ithn9FFcULsBDVSEq4ZueZd5pgZ/IxuiVNzsJYtIzN/EfdcORewSWH0M/qYjo8fQ2wDH0levHOooV9pVLfEm3XZfimhw0w1anBcPXLQKPU5Fov40nNtXSBbiPBRDGtASgVuMcGhV0n9d4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtlVhHGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtlVhHGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624E2C4CEC3;
	Sun,  1 Sep 2024 17:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210334;
	bh=stS/028XzAIZYMkH60r9tHgbyVWDXXyJpju+I/3JDh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtlVhHGXL06oTxHqlApDDmvezG+diBDWGNYs2I7sk5PrbTj7k2ZNF7gIrnTV0GX6F
	 f9Ny6c+rOvHtcOEiPMAVrxnl/CXIX2BaaRgh7wQOzwjNXZR8bv/HgbnC7E6gQP6CcQ
	 AWlwff3CH+fUGqNOkESug599qY7gr4zCIYOPEY2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/215] mmc: mmc_test: Fix NULL dereference on allocation failure
Date: Sun,  1 Sep 2024 18:17:50 +0200
Message-ID: <20240901160829.334172896@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4052f828f75e7..e03d4405cda36 100644
--- a/drivers/mmc/core/mmc_test.c
+++ b/drivers/mmc/core/mmc_test.c
@@ -3111,13 +3111,13 @@ static ssize_t mtf_test_write(struct file *file, const char __user *buf,
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
@@ -3125,6 +3125,7 @@ static ssize_t mtf_test_write(struct file *file, const char __user *buf,
 
 #ifdef CONFIG_HIGHMEM
 	__free_pages(test->highmem, BUFFER_ORDER);
+free_test_buffer:
 #endif
 	kfree(test->buffer);
 	kfree(test);
-- 
2.43.0



