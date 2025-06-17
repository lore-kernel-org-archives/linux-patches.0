Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D31CA4B;
	Tue, 17 Jun 2025 16:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178709; cv=none; b=UG8sJzpqrLY6NsAjnf+QwNVaulv5GCi25V5Dt6AitpXwlzM1RVNQW5Z9n6m9vYGqrF8WePhl8v0xP/wlJg/rjugU/rFWQO7q5iFmpKLHEnjUBiR1S8uN0PAxSaskCG0outH5q/slpx9zBJGNAtfYSEB7koeOQhxd1GnDH46B6yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178709; c=relaxed/simple;
	bh=1LwVH69YWwcI+qNpVeZndaTKGieMwfu9ajCOjOB9ltE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYzj1tpaYtrPQrN2Gq7oZeTIP46fGzBroCNTXsGMJ+/wlgJ5KkZI2svh7CJCNt/LytTIzMtIUPK5Csrtbv1IBrQQZyN4k2GYUcE52ewdPDoHywZJFQFGouzugcEganaC0qZbffoYtYO6b4AbwvoHS4fjPbZ/k4JxD5q724kEmXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwTWEOWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwTWEOWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E25C4CEE3;
	Tue, 17 Jun 2025 16:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178708;
	bh=1LwVH69YWwcI+qNpVeZndaTKGieMwfu9ajCOjOB9ltE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwTWEOWgdv4TVdW878Z+N3bW6VxJ+drLJEeb55ymZ1ndCjdMVgUM0v+HFc+RUbT28
	 1zxCMezR23RFjLLzbXEB2T5NRs19Hu/fENTWOcOS3/ZsYDIJVbv3zJ9lhNb7ZYgv82
	 VVZYV8JmndJdC+4OubP399891mN8pLWgx3A7YkkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Pagani <marco.pagani@linux.dev>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 529/780] fpga: fix potential null pointer deref in fpga_mgr_test_img_load_sgt()
Date: Tue, 17 Jun 2025 17:23:57 +0200
Message-ID: <20250617152513.057683348@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8748babb05045..62975a39ee14e 100644
--- a/drivers/fpga/tests/fpga-mgr-test.c
+++ b/drivers/fpga/tests/fpga-mgr-test.c
@@ -263,6 +263,7 @@ static void fpga_mgr_test_img_load_sgt(struct kunit *test)
 	img_buf = init_test_buffer(test, IMAGE_SIZE);
 
 	sgt = kunit_kzalloc(test, sizeof(*sgt), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sgt);
 	ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 	sg_init_one(sgt->sgl, img_buf, IMAGE_SIZE);
-- 
2.39.5



