Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719A1471257;
	Tue, 21 Jul 2026 19:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662170; cv=none; b=ULGtHN4KOLUgc4vI964uipD3eOYhByyZvl49KJmZq57LNUh4LBAKju8H4pnzUwj0y/R9ax7M73mhwcXdFxUc23YKowE8ryBwfZIacO7K1wurYduGEHsBOYO/Zrw0vsqqd6g1FicOLXaq/fBJUURvyD1HDjMcKkaOo4Q8tYhF4/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662170; c=relaxed/simple;
	bh=T4zHhQcUVqMoIUNF0gBA5Vl98CSHz/XCP1blw++X57Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZBPa7uoA1Be4/ZCHHGL6nY5PnkoBpJT2rINflKQhpwYwG/2SruOaUs4D4wU9XKoV4ubjaW5pCb8FuGNIKGDTd+nXlDbJQvlpVxgVaubPVp0EfTYhehWQoZHIAzrpI6nkA8kZSc/AKJb6ZvVUrqXio5BMDvM3d27m4l9DOoHIR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWbw+ncU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWbw+ncU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73BF1F000E9;
	Tue, 21 Jul 2026 19:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662169;
	bh=ba6E+2ptNgjzxnsetEogTECWbKMTZrDMF+WkjzThFWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWbw+ncUHOv1WlnCGXa3yYuGYrG/+LKQrsTV00EhBHdq3oQ7XkvM42H9dY0k0sbA+
	 +J2OX+FbUBn3NlDQmNlJXJ4OJyX7IO6l6McG73FNqgbRyMj6xbI69QfFTBNFhNKI/o
	 e2oXC3oue5j07yOIRa9IRx+LYENZYv0YOWH8KaVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0343/1276] cxl/test: Add check after kzalloc() memory in alloc_mock_res()
Date: Tue, 21 Jul 2026 17:13:06 +0200
Message-ID: <20260721152453.780883814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ad583750e4429e..b9236c6d30d9d7 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -402,12 +402,16 @@ static void depopulate_all_mock_resources(void)
 
 static struct cxl_mock_res *alloc_mock_res(resource_size_t size, int align)
 {
-	struct cxl_mock_res *res = kzalloc(sizeof(*res), GFP_KERNEL);
 	struct genpool_data_align data = {
 		.align = align,
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
@@ -422,7 +426,7 @@ static struct cxl_mock_res *alloc_mock_res(resource_size_t size, int align)
 	list_add(&res->list, &mock_res);
 	mutex_unlock(&mock_res_lock);
 
-	return res;
+	return no_free_ptr(res);
 }
 
 static int populate_cedt(void)
-- 
2.53.0



