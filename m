Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308A146EC79;
	Tue, 21 Jul 2026 18:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659758; cv=none; b=LNQETNzWuXT43uP8pBtsgserfE7O7KOA8uDuEn0O9E+m9DMXxNNo7zIuglPyIgD+/u87nXK1m0SdM6tnhpdWDKJSbyKVWBf8MdT7ERQ35y+u1c0JX7qeiAMLIr8RGl55NrBkU6DzZs3BeboHQXSOx9idJjalIyNdrFQkkOS1yxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659758; c=relaxed/simple;
	bh=muHaQ8ibq33JUNyri3cSBpOYH9BdFFb5KyJ9t6mPWHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCaT60rOnxpAvyJXZvj6lf7kaVpPBAQvoIkh0xkwD3g0O874dvbD+s7+PGVyDuz6uAeXNo0VY+whgaf6pKEMkDlqmaTaF2X42RrfdHkDPO1Bpau2Qh6bFmyoH44DhU31pvx82/Q1u9e1+0mNHtDobuTYh420/XcBhYfe5pSXLGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vyuhnv5/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vyuhnv5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961881F00A3A;
	Tue, 21 Jul 2026 18:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659757;
	bh=DE+1Fs+bFGGMFdCiKmGJVJImAEgXgdEhUvPyBIBqTcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vyuhnv5/W1elqJGm6TQw4igGpv/7VNtAjS5HCg5gDiIxzL3XS/ynXMf65bToj6sSN
	 JGcZSLVZi0Phal4S7io2NrWzx6ES8sVVw+ErSzhgOZLNVbl3LXb87B5nNQnNjFEiQ/
	 hcPdMnbNcHir8v6wkNJg6XB28jwgEJBiqFSVXScw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0721/2077] cxl/test: Add check after kzalloc() memory in alloc_mock_res()
Date: Tue, 21 Jul 2026 17:06:34 +0200
Message-ID: <20260721152609.807276132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index fd6ff00541dced..5733a526f7dcb4 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -433,12 +433,16 @@ static void depopulate_all_mock_resources(void)
 
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
@@ -453,7 +457,7 @@ static struct cxl_mock_res *alloc_mock_res(resource_size_t size, int align)
 	list_add(&res->list, &mock_res);
 	mutex_unlock(&mock_res_lock);
 
-	return res;
+	return no_free_ptr(res);
 }
 
 /* Only update CFMWS0 as this is used by the auto region. */
-- 
2.53.0



