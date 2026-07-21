Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B7846A603;
	Tue, 21 Jul 2026 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649167; cv=none; b=EqIFqx7NC5l2/31Y+IT8ZeGvKIvD+iS/p5seNxjeD3RYQraD5Jxc9H6SMVOYABQE5PPCTgPQ07qxdd/SXch5bczsyVSOewySX4QFYAu8BZXlZIzvVvflMbSI/X5avjAy9GcZw8GpexMEenqbbIx2hpsPYf3Y35VDaMJqKgH5bxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649167; c=relaxed/simple;
	bh=F1XBoAgA1A7HhDHTJ0t62I+hO1cebBixQO9VWgmbQ5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JjzdnTlkCqUqGbZC6XEeq2mXaIjaAux82zgO7yfgGb7V7IjHrJrII6+ue0pBfdU9cbe9/lfUzE6fYCUSCgfHHKwAYz3gzxRd9n+gEbF0d0Hu2PqBYRJsx0rVPs6+dL5Mjerwqq75IBOLsP8DcKe0RkeEKxoZTf2aD4l1uwdTTb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTB3UB/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTB3UB/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973031F000E9;
	Tue, 21 Jul 2026 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649166;
	bh=R4+jBiOzSkpWgYmg5bmnbOBlg0P4KCFAwz157JhWJU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTB3UB/tQJcduo3rxIm4mQbXp5Aq7UVJWEzi3ezARVww+zuHbiZrtHxpxy/mCWhCX
	 gf10bnVeBCgKZfh11tjppEiSYkXAO+Dpnp6Aator4QnfyAc89T33Ljm/bOlzUXE4Ps
	 RelgsqD2nnjX0mJ47sfALJ//qmqbJkPRFQclvnp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0475/2077] lib: kunit_iov_iter: repeatedly call alloc_pages_bulk()
Date: Tue, 21 Jul 2026 17:02:28 +0200
Message-ID: <20260721152604.003758003@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 9ac9a08e4ac4bc063e56e1aff266c5e8aa5c6c03 ]

alloc_pages_bulk() is not guaranteed to return all requested pages in a
single call.

Call it repeatedly until all pages have been allocated or no more progress
is being made.

Link: https://lore.kernel.org/20260526-kunit_iov_iter-alloc_bulk-v2-1-24fbcd995c61@weissschuh.net
Fixes: 2d71340ff1d4 ("iov_iter: Kunit tests for copying to/from an iterator")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Cc: "Christian A. Ehrhardt" <lk@c--e.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/tests/kunit_iov_iter.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/lib/tests/kunit_iov_iter.c b/lib/tests/kunit_iov_iter.c
index f02f7b7aa79605..1e6fce9cb255ff 100644
--- a/lib/tests/kunit_iov_iter.c
+++ b/lib/tests/kunit_iov_iter.c
@@ -53,7 +53,7 @@ static void *__init iov_kunit_create_buffer(struct kunit *test,
 					    size_t npages)
 {
 	struct page **pages;
-	unsigned long got;
+	unsigned long got, last;
 	void *buffer;
 	unsigned int i;
 
@@ -61,7 +61,15 @@ static void *__init iov_kunit_create_buffer(struct kunit *test,
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
 	*ppages = pages;
 
-	got = alloc_pages_bulk(GFP_KERNEL, npages, pages);
+	got = 0;
+	while (true) {
+		last = got;
+		got = alloc_pages_bulk(GFP_KERNEL, npages, pages);
+
+		if (last == got || got == npages)
+			break;
+	}
+
 	if (got != npages) {
 		release_pages(pages, got);
 		kvfree(pages);
-- 
2.53.0



