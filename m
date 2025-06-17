Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDDA2CCC5;
	Tue, 17 Jun 2025 16:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177373; cv=none; b=EglTlS7qEAzTDAvQF59w8qtYEoGC3JDonF276QgmNOOZMKCFYCIGyKrNQPm+gGoor/lVTCKkwZUYV4NtJtaVQGXD5RRuqhnBLCHGjhv1wsfk+R8w4cEpSL2E0p/hhpDmkaexBOk9aCVPgA3ZVmlCUMtRRDSv3RYTmgb3qeaWejg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177373; c=relaxed/simple;
	bh=7gQ/Fu0esoad02EsoVH9GvYkTTgK/3f96UGnXqAi7kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbl614jWvmkoLsVHFMDwdyPYFV59rD6e71+CWhQxHJjOxkhwROzPCkEH6yBmVj2tAdrLFZjsmhMbPdRKGdssN3rFadOW39JLma5am707xWc8+TzpnbEam+yZYU9GGX1kkZRwP0oGrXIOsrM5dJ7ONX+Ww8K+P8DQ55IZN8T/uGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRWDfVfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRWDfVfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826A3C4CEF0;
	Tue, 17 Jun 2025 16:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177373;
	bh=7gQ/Fu0esoad02EsoVH9GvYkTTgK/3f96UGnXqAi7kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRWDfVfrT5BSgpl+TrXNOEkSnXIaP0Y2iBx1STFaP+ChGDap15ZAEg9GQeoZJI8Vu
	 MGx+JjSH4P5akkXjazAplIe50rHdqaffrzefgNm2qkBZmTm1C1f1rZmEUqQO5Dw+uf
	 K478hMBJ5RaAmi/XWwpAvScabCQQCLp99Ret9t0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Pagani <marco.pagani@linux.dev>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 334/512] fpga: fix potential null pointer deref in fpga_mgr_test_img_load_sgt()
Date: Tue, 17 Jun 2025 17:25:00 +0200
Message-ID: <20250617152433.145129095@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9cb37aefbac4b..1902ebf5a298f 100644
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



