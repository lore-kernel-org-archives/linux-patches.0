Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D37340DA0;
	Mon, 18 Aug 2025 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523293; cv=none; b=oWEjw4ZC7Jb0SmsUWC/dvFeujsCk4hjmrIOrB5XGs7ZF9W0yXeRN86D5Jk0xjav3szECjlpn3Qe6EFDMptcgqgXK2Jvbz+T5Y95moXQm6vuQjysIsEexyMrlIpxK3y7gtsZlftOnA5nYdno3seMFfI0ZYJ6tmpPJoVsDswyQsCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523293; c=relaxed/simple;
	bh=7N5mlooCat4rAHy1oqWRWGvA0NxVi4WFnxP6Hx9VUzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3y7CD2GyjAbKAb/yLH4rWg5/TGjjPv0dDGylgqQy5S+JfgJejHolTyvTZ3ZsfZQcf6uPMj9DRq55dAan9gsduA/3/3Ea5/vk1wELmAWRVpg5VZX/ok9n/l9Zl6Ho8fk+lKyUe6qCWAa+Ms2cdWP7hQtYn9gUYSu+qHzphO4MC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbkQRAyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbkQRAyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAD0C4CEF1;
	Mon, 18 Aug 2025 13:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523292;
	bh=7N5mlooCat4rAHy1oqWRWGvA0NxVi4WFnxP6Hx9VUzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbkQRAyrj65TUezB4Y7c89jUkwLYln4VqEnByVn9kkw2FN7YrfGw4RGxWLYbzXfVG
	 qElmIG31hRfev7AlTVRI8Na8WNLUvNvrTVPYP2bpz70CRq304ExWNvJyiYd06VQgd4
	 Gr8fLb5WxZDP0DULiv4yyK/0+yDs9Z6xHmcqJVQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiffany Yang <ynaffit@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 127/515] binder: Fix selftest page indexing
Date: Mon, 18 Aug 2025 14:41:53 +0200
Message-ID: <20250818124503.289973063@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Tiffany Yang <ynaffit@google.com>

[ Upstream commit bea3e7bfa2957d986683543cbf57092715f9a91b ]

The binder allocator selftest was only checking the last page of buffers
that ended on a page boundary. Correct the page indexing to account for
buffers that are not page-aligned.

Signed-off-by: Tiffany Yang <ynaffit@google.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20250714185321.2417234-2-ynaffit@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/android/binder_alloc_selftest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/android/binder_alloc_selftest.c b/drivers/android/binder_alloc_selftest.c
index c88735c54848..486af3ec3c02 100644
--- a/drivers/android/binder_alloc_selftest.c
+++ b/drivers/android/binder_alloc_selftest.c
@@ -142,12 +142,12 @@ static void binder_selftest_free_buf(struct binder_alloc *alloc,
 	for (i = 0; i < BUFFER_NUM; i++)
 		binder_alloc_free_buf(alloc, buffers[seq[i]]);
 
-	for (i = 0; i < end / PAGE_SIZE; i++) {
 		/**
 		 * Error message on a free page can be false positive
 		 * if binder shrinker ran during binder_alloc_free_buf
 		 * calls above.
 		 */
+	for (i = 0; i <= (end - 1) / PAGE_SIZE; i++) {
 		if (list_empty(page_to_lru(alloc->pages[i]))) {
 			pr_err_size_seq(sizes, seq);
 			pr_err("expect lru but is %s at page index %d\n",
-- 
2.39.5



