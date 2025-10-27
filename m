Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8559B248898;
	Mon, 27 Oct 2025 19:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593455; cv=none; b=Zr/PFYGU1jNbMB5Wl3sa9shdFMH3ZXwvp0mKpXAP4pusw+AOZ3CiW5nEfrbG68op0OAXKO8o6zS2K5B2tPQqcruroW+LLahF2BFIiZIw9jeWagR5IKz4Qkzq7XV42/s0uOapoy8350u4y30mq9r6EDnQXM5+h+iB7asGeFFjWg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593455; c=relaxed/simple;
	bh=pLGstltQPsDnpGhTxRzL1WqX1YOjBF2bAnXT0FsuBMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbmENXGpiV1Xb4VJR1zp09jtneZ/aOpOzOPnuJayVFo0xF0vsNZrXRKUWmFN+M8j0B75GM9Pqntm8Ka25WGkvmPyqpzdReC/YofiCoji3k3XWzs0IjyWWE3cghHhxvh6WwA8vGjeur54xqF3gu0NUmavcxHm8iJi+uGCSfQHTEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1WgIWhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1WgIWhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076B6C4CEF1;
	Mon, 27 Oct 2025 19:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593455;
	bh=pLGstltQPsDnpGhTxRzL1WqX1YOjBF2bAnXT0FsuBMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1WgIWhZOMuuiTcOJXhkRNYM+N3fO1PAucs52wbYWqhVzWYPUEH4cJ/IRXpQv93Sw
	 T1v9QIWt0IBozutIvVK+XJMxZhcdxCb4x0vGaY7yjtul46/y6U3Jhyrr5ZdIhxoDIk
	 Sa7kq6iWK3oDzLXwYRQy9zI9SySzTFliVSKxQRqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 112/184] mm/damon/sysfs: catch commit test ctx alloc failure
Date: Mon, 27 Oct 2025 19:36:34 +0100
Message-ID: <20251027183517.944892024@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit f0c5118ebb0eb7e4fd6f0d2ace3315ca141b317f upstream.

Patch series "mm/damon/sysfs: fix commit test damon_ctx [de]allocation".

DAMON sysfs interface dynamically allocates and uses a damon_ctx object
for testing if given inputs for online DAMON parameters update is valid.
The object is being used without an allocation failure check, and leaked
when the test succeeds.  Fix the two bugs.


This patch (of 2):

The damon_ctx for testing online DAMON parameters commit inputs is used
without its allocation failure check.  This could result in an invalid
memory access.  Fix it by directly returning an error when the allocation
failed.

Link: https://lkml.kernel.org/r/20251003201455.41448-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251003201455.41448-2-sj@kernel.org
Fixes: 4c9ea539ad59 ("mm/damon/sysfs: validate user inputs from damon_sysfs_commit_input()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1435,6 +1435,8 @@ static int damon_sysfs_commit_input(void
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return -ENOMEM;
 	err = damon_commit_ctx(test_ctx, param_ctx);
 	if (err) {
 		damon_destroy_ctx(test_ctx);


