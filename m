Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB54395D99;
	Tue, 21 Jul 2026 20:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666131; cv=none; b=Ux1Ppf3N0RDa4C4DyCRGQY1NynedZ5/Vr96KGpKas067GaCEwzakVZdKNrddN9DHbqjeZAIfBXNBVcRRDj9T9jp+2Z/sZPBSB6gFC+L00b4FqCfI9WS719kZXEnTpSU17ZsUsoueN94bJj6GPDpwsB0V3Ig59LbBzjtnCkNejBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666131; c=relaxed/simple;
	bh=d+m7bTC8g2jZsV/sZoDYaRZRq9ELM9wwWYE4Jh6S1MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyeVfU0DU7VJ1EDbWhV5BZj2wJUvQt84N/tVlHHSzJRkqoiquqa4gE9rYaFydifj91Rx1jpxX5YtcHPJefHiews1iZPZ6YnZ8pVSoQ4GZjqqMyLwnbjt6vYk+iSQeMIDwxLHKTUR4wOdea2OeH3zI4tjIvEPZnU9QBGZvNBMLHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fp9YyVXS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fp9YyVXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748CA1F000E9;
	Tue, 21 Jul 2026 20:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666130;
	bh=uHJpG/Uai01AOxFpIYl4F3Epv/spQBaB/Y8yVh4nnRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fp9YyVXSg/8Or5ZbHBzOTTTMDGMHNpninoR/iOJZU5qF+h7fnc0xcMlh674vCiUvf
	 pyPSD72hm2hG0wMElF8e5w1mhg/q2ByhrMeDaVUw08ZD7j6DkGjqNQjfWkfv5SN2yZ
	 2Fu7cK8sB51dXy0O/UF2jwZ594er+OvJ/ahsXmxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0567/1266] cxl/test: Add check after kzalloc() memory in alloc_mock_res()
Date: Tue, 21 Jul 2026 17:16:44 +0200
Message-ID: <20260721152454.553507470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ed1361c8b96c48..0bb93bff74be0f 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -396,12 +396,16 @@ static void depopulate_all_mock_resources(void)
 
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
@@ -416,7 +420,7 @@ static struct cxl_mock_res *alloc_mock_res(resource_size_t size, int align)
 	list_add(&res->list, &mock_res);
 	mutex_unlock(&mock_res_lock);
 
-	return res;
+	return no_free_ptr(res);
 }
 
 static int populate_cedt(void)
-- 
2.53.0



