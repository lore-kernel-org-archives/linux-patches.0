Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ACE44AB60;
	Tue, 21 Jul 2026 21:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669133; cv=none; b=hDzltjuIgkBNMZsN/ZA54in7yPX+7+MLo0mWzHzmz5i9g8h7f2LsmlWsw5Ue9emPM6rgO66q/k32t6gIts6uCJBDaV6Ff5yZSXzm5QZtsb/atuOKP8UXqRwY37Hao0fIfUS4XhFKiNzbm3tMHJrbVVIhm4KrqW+O++NRG5ZIDNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669133; c=relaxed/simple;
	bh=JXBsvM8if4u0mJx4Ek1BqP62ZNfTFojPvSFxU+QipIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYuMjn/t7/nnDpqUUH2XCvW90RmNDWwsZyNJiHMblvhsKxFp95dTJ56/7bVSvk6nVuZLCFo6xgaICDwDQWUdSsbf8jb07szXjwNHKcgTTxAyj6qeQgxk+MbckvHbAlo8fYyFm1k0kptlGIxY44sQ9dHpz8M+0n6dFv/77JPGBCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRWmUtdB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRWmUtdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804911F000E9;
	Tue, 21 Jul 2026 21:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669132;
	bh=s0iDlFBhNl+41Zf6hQ/lzI6Yt0XWvGZTN2NJMemEPSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRWmUtdBRKjlJUKz8RQh6qjZsXldlq3nXLykFXroigBIZ6es1AbHh+JJzy3SuJAs1
	 CPbQ4fnKHUAFGl8Z2uk+IDiJCqwFZEEHhY1lHzg57T7kC/bwZGBeEG3n3vqrzM5XiR
	 Ndu5M6EOtEh2ZJUW98Q+wtSpl5QU3jUxU1b0BgPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0440/1067] cxl/test: Add check after kzalloc() memory in alloc_mock_res()
Date: Tue, 21 Jul 2026 17:17:21 +0200
Message-ID: <20260721152434.459262986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit dfe28c8592538152e9611341dae6f7be1735b3f1 ]

alloc_mock_res() calls kzalloc() without checking the return value.
Add scope based resource management to deal with the allocated memory
cleanly.

Reported-by: sashiko-bot
Fixes: 67dcdd4d3b83 ("tools/testing/cxl: Introduce a mocked-up CXL port hierarchy")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260611230305.197390-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 339b31a3319bfe..7be8bc4e4500ec 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -264,12 +264,16 @@ static void depopulate_all_mock_resources(void)
 
 static struct cxl_mock_res *alloc_mock_res(resource_size_t size)
 {
-	struct cxl_mock_res *res = kzalloc(sizeof(*res), GFP_KERNEL);
 	struct genpool_data_align data = {
 		.align = SZ_256M,
 	};
 	unsigned long phys;
 
+	struct cxl_mock_res *res __free(kfree) = kzalloc(sizeof(*res),
+							 GFP_KERNEL);
+	if (!res)
+		return NULL;
+
 	INIT_LIST_HEAD(&res->list);
 	phys = gen_pool_alloc_algo(cxl_mock_pool, size,
 				   gen_pool_first_fit_align, &data);
@@ -284,7 +288,7 @@ static struct cxl_mock_res *alloc_mock_res(resource_size_t size)
 	list_add(&res->list, &mock_res);
 	mutex_unlock(&mock_res_lock);
 
-	return res;
+	return no_free_ptr(res);
 }
 
 static int populate_cedt(void)
-- 
2.53.0



