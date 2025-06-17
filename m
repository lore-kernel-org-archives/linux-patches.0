Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBB82ECE84;
	Tue, 17 Jun 2025 16:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176068; cv=none; b=sZDANeiM9m+7GMSLSLXsGW8yQc3RAuUG410IHCZZSH0EP8OKIE9JpB9gpFUyMYiWOfpymuQQSYUGoQMnjoZDDWc25MtqsV+RT3fmaC5vsiTHDk+ChV9RHZZzvECsBZ5d2JO8z49vXL8kzr9LvFp2hxED+K83QSN8yyg/VwR8EqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176068; c=relaxed/simple;
	bh=/vyygnGhApH+qkvvbLp8F0CSkHf8/kdPxb72McteHZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oA3C7dGtYEYn8E/JkgZcZud54J+poZ2+M06KKwidjEjpTZExIAZv4jI7Zn06WoLKg9+b/BWGryCWeeAJ7TUyThPzVMnDb65RDyK8PV1QQCiKWs7k/RI+Gi83SSmboIBJk7cMtMrI4vqAygk8+26jvb2nt36ZjJRQwL39wk7Cm+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpILxzKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpILxzKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5694AC4CEE3;
	Tue, 17 Jun 2025 16:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176068;
	bh=/vyygnGhApH+qkvvbLp8F0CSkHf8/kdPxb72McteHZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpILxzKRL0+n3xPjLIOnrxVvUMnYPwlj2aAMDauSB0QznP+mh3WQH8JXK1MZLfGPT
	 5Aqbj3+I6bQqzq+nXRBNrPUOpnM/BjvlRdNrLLUQjMQwMvhzeUs4w5oKrl6mkEjQDU
	 mn884k5DqEQj9+NhFGIabq28f8N/0G9pHGtImIwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Pagani <marco.pagani@linux.dev>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/356] fpga: fix potential null pointer deref in fpga_mgr_test_img_load_sgt()
Date: Tue, 17 Jun 2025 17:25:55 +0200
Message-ID: <20250617152347.871667217@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

[ Upstream commit 6ebf1982038af12f3588417e4fd0417d2551da28 ]

fpga_mgr_test_img_load_sgt() allocates memory for sgt using
kunit_kzalloc() however it does not check if the allocation failed.
It then passes sgt to sg_alloc_table(), which passes it to
__sg_alloc_table(). This function calls memset() on sgt in an attempt to
zero it out. If the allocation fails then sgt will be NULL and the
memset will trigger a NULL pointer dereference.

Fix this by checking the allocation with KUNIT_ASSERT_NOT_ERR_OR_NULL().

Reviewed-by: Marco Pagani <marco.pagani@linux.dev>
Fixes: ccbc1c302115 ("fpga: add an initial KUnit suite for the FPGA Manager")
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20250422153737.5264-1-qasdev00@gmail.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/tests/fpga-mgr-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/fpga/tests/fpga-mgr-test.c b/drivers/fpga/tests/fpga-mgr-test.c
index 6acec55b60ce9..bfe25c0c0c1c3 100644
--- a/drivers/fpga/tests/fpga-mgr-test.c
+++ b/drivers/fpga/tests/fpga-mgr-test.c
@@ -253,6 +253,7 @@ static void fpga_mgr_test_img_load_sgt(struct kunit *test)
 	img_buf = init_test_buffer(test, IMAGE_SIZE);
 
 	sgt = kunit_kzalloc(test, sizeof(*sgt), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sgt);
 	ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 	sg_init_one(sgt->sgl, img_buf, IMAGE_SIZE);
-- 
2.39.5



