Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC91A46A5F6;
	Tue, 21 Jul 2026 17:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656415; cv=none; b=XbQz98idqh0IOZMKblGQzk5p1TJoTJqfuSU++uJRQ9xfnew+RnnrWrkL3RpmgBNQOxW2AO5Z00UCjW2fVD6a9IT5PntR7piNQ6ulOYbsNbzNyPA3HvTYtpeMiXdPA/hnV5DY3cms0Ek++c6iKPZ7wC220YoUz1QGtTJRtkLEMZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656415; c=relaxed/simple;
	bh=x3x/CJduGOXfT9q5fkHhGkxD9QWOUXXBbrGhpiBjhHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JFqvX8pFWQ1voa9QD2eI4yf8Ejuy7NaaP38H+Kx8YLG6/mhGgW6D5BLO7tOypZIFvRj2Te8W6eV18iYzcAFGfLv4eMj/ZIZR8fedxl1tSYZY6jhemhvZpWNkLT0h3zHqj9U+RYlg5srhV2dVl7rSBiK0eG3Wvl0YufUYRoQNgTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtAgMPDZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtAgMPDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52AE1F000E9;
	Tue, 21 Jul 2026 17:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656413;
	bh=wciCwEYoId0F9wCUfcpGBnqXQ3kxx2oFzMcqECtFOdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtAgMPDZqImelPfEBO/L9HjEKvKFq8ipQKwqVZnq8vCuONZkBHqCOYoZb8q1dH2LD
	 x/daNTHqGBKiJvJIWBStMTn0MM1ZGXhPQMbu60o8jlqzVfYvKBfmPPcnroqs1wJ5sh
	 L1Wo4uO4JPqElNqs7eVCwxSlcI05G/TYYK1tJIQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0335/1611] lib: kunit_iov_iter: repeatedly call alloc_pages_bulk()
Date: Tue, 21 Jul 2026 17:07:31 +0200
Message-ID: <20260721152522.636320683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 43e63bf4c09568..0ee92536e5e7bf 100644
--- a/lib/tests/kunit_iov_iter.c
+++ b/lib/tests/kunit_iov_iter.c
@@ -50,14 +50,22 @@ static void *__init iov_kunit_create_buffer(struct kunit *test,
 					    size_t npages)
 {
 	struct page **pages;
-	unsigned long got;
+	unsigned long got, last;
 	void *buffer;
 
 	pages = kzalloc_objs(struct page *, npages, GFP_KERNEL);
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



