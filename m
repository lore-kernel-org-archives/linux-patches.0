Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B34035F8D9;
	Tue,  6 Jan 2026 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722241; cv=none; b=ZReSMADguYpe1phpRot44Fp3ZOsJT74B8Q/uCyj5p15e76hPmRT7itW5earoEZ9ODk4U3yHhxbrClC7Drbq8ss1o3gq5zPXd26NM/DDW9nPiUBmNvrVXgQ48M9IR3FZa7WN2vTv0NDkSqWdLHJMbOCVxe813gNk/QUKTqx+fW9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722241; c=relaxed/simple;
	bh=dV4Y937VyLo8Ul8lkWpsVzwsOQQ9psvZcxR1DaOcTTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jk4R9wQRfl+Uq4/ftzZTlJ0ZnrWRChaNFmfQBag8AWAqwwz3q91NcRLGRt3tcPSr29cmXLHXoYJSZ0EFiusjlQJzhrEWErxTUlC3N1r5P6Qs/wSTU6zftaZdmddkVG48/zvcyrp6Y/ZlWFOmMv2sQpAl7TZpCWQ98xCze5UjjcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2BkfcYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2BkfcYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8EEC116C6;
	Tue,  6 Jan 2026 17:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722241;
	bh=dV4Y937VyLo8Ul8lkWpsVzwsOQQ9psvZcxR1DaOcTTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2BkfcYce5m2KxEmwTt/RErcQTTazYkTNUsk3jI2eP7h+iVh27xIaPd77x2PMIUc0
	 VmfId/83Bn11WRuxrit0QDM+vUg1AEJPLyKJxTTeRiBumTsTMEhTMoUf9mTyJegwWL
	 RAEiB3C/9iQRMeyukgSfP9ZzbAP7n9vloG9PSZiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 206/312] mm/damon/tests/core-kunit: handle memory failure from damon_test_target()
Date: Tue,  6 Jan 2026 18:04:40 +0100
Message-ID: <20260106170555.286878282@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit fafe953de2c661907c94055a2497c6b8dbfd26f3 upstream.

damon_test_target() is assuming all dynamic memory allocation in it will
succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-4-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -58,7 +58,14 @@ static void damon_test_target(struct kun
 	struct damon_ctx *c = damon_new_ctx();
 	struct damon_target *t;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
 	KUNIT_EXPECT_EQ(test, 0u, nr_damon_targets(c));
 
 	damon_add_target(c, t);


