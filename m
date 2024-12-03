Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DA11DE8A5;
	Tue,  3 Dec 2024 15:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241492; cv=none; b=N1kKBBw/hoyo4ZCHvVSDdZ7WWU/2pC5NmIM2r7R7g598ZHg8M742JHeieDoMrQBEjWhGVtUjYzOXMUSqTu/qJ2vuHJFuvVNAA9eRV29Cj9zF1d6aa3DrxBNV3J0vfp7//V3gVkFVq2iJSCqrOeFF17I7y4sOFgce2O8lC91wFrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241492; c=relaxed/simple;
	bh=mhnAR0J3uPZ+nIhD+A/zrrYYWKByWi+KaGQRLxwia28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCi+tnCQkZJj4KKk1nSzbBahb5aJJv5tR4qeHB4KN6h2WUB8zQ0ukOkcgRvetBDslVdTOn4fUO5oRaiPGNdINrzq0ZFTKbBG59vxSXfHuWQE2v2XcJNvTKJXFk+QBCTSlv1dM5pAcuJUzJg2uVeWJZNQwy3o3D9AKXJprE0pOEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDoT5LOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDoT5LOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DA5C4CECF;
	Tue,  3 Dec 2024 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241492;
	bh=mhnAR0J3uPZ+nIhD+A/zrrYYWKByWi+KaGQRLxwia28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDoT5LOxjsQWJUJub4cwGF00w7qoMxyuADAk64IoSjuoUB+upCzSAkuezVyvPyC5G
	 8MTni7njW/5c1ijEsmbvZWY1gwRxf+DowoJonVoLNOa29QqJBvAdJ3uDU0NR7SJJXB
	 oCmit4vE5EkG24IxVtXIhwM7He6uJS7p/x88mSv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Shi <alexs@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Hu Haowen <2023002089@link.tyut.edu.cn>,
	Jonathan Corbet <corbet@lwn.net>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Yanteng Si <siyanteng@loongson.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 433/826] kasan: move checks to do_strncpy_from_user
Date: Tue,  3 Dec 2024 15:42:40 +0100
Message-ID: <20241203144800.653416172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>

[ Upstream commit ae193dd79398970ee760e0c8129ac42ef8f5c6ff ]

Patch series "kasan: migrate the last module test to kunit", v4.

copy_user_test() is the last KUnit-incompatible test with
CONFIG_KASAN_MODULE_TEST requirement, which we are going to migrate to
KUnit framework and delete the former test and Kconfig as well.

In this patch series:

	- [1/3] move kasan_check_write() and check_object_size() to
		do_strncpy_from_user() to cover with KASAN checks with
		multiple conditions	in strncpy_from_user().

	- [2/3] migrated copy_user_test() to KUnit, where we can also test
		strncpy_from_user() due to [1/4].

		KUnits have been tested on:
		- x86_64 with CONFIG_KASAN_GENERIC. Passed
		- arm64 with CONFIG_KASAN_SW_TAGS. 1 fail. See [1]
		- arm64 with CONFIG_KASAN_HW_TAGS. 1 fail. See [1]
		[1] https://lore.kernel.org/linux-mm/CACzwLxj21h7nCcS2-KA_q7ybe+5pxH0uCDwu64q_9pPsydneWQ@mail.gmail.com/

	- [3/3] delete CONFIG_KASAN_MODULE_TEST and documentation occurrences.

This patch (of 3):

Since in the commit 2865baf54077("x86: support user address masking
instead of non-speculative conditional") do_strncpy_from_user() is called
from multiple places, we should sanitize the kernel *dst memory and size
which were done in strncpy_from_user() previously.

Link: https://lkml.kernel.org/r/20241016131802.3115788-1-snovitoll@gmail.com
Link: https://lkml.kernel.org/r/20241016131802.3115788-2-snovitoll@gmail.com
Fixes: 2865baf54077 ("x86: support user address masking instead of non-speculative conditional")
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/strncpy_from_user.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index 989a12a678721..6dc234913dd58 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -120,6 +120,9 @@ long strncpy_from_user(char *dst, const char __user *src, long count)
 	if (unlikely(count <= 0))
 		return 0;
 
+	kasan_check_write(dst, count);
+	check_object_size(dst, count, false);
+
 	if (can_do_masked_user_access()) {
 		long retval;
 
@@ -142,8 +145,6 @@ long strncpy_from_user(char *dst, const char __user *src, long count)
 		if (max > count)
 			max = count;
 
-		kasan_check_write(dst, count);
-		check_object_size(dst, count, false);
 		if (user_read_access_begin(src, max)) {
 			retval = do_strncpy_from_user(dst, src, count, max);
 			user_read_access_end();
-- 
2.43.0



