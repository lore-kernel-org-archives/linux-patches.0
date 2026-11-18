Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033721;
	b=qxAWBCAMGRuJshMQRjAQdjJNALdhdPITmNpgtOSYDYLo69HWN7CT7EmW0hpynSAPF+I/
	 a1dZIWfOIXm2UkMEY0zHFwPMHXifTgS8YeJ4lM7efQZjYt8f2F1ATZb0ejg2/Pkf5ZOYY
	 uWq3JumNkE8islEobKrh3SN+s/6gjFHPW72qDDMYNhjUViywCgd7xags09pu9dXtVKDnh
	 wOUz7A2l8ToQz21lffB0ytEw9qikvUU6S9N/NTN9YvkCXLmzxxSHqhORJ7laGqxIWuLAI
	 3/8akdSL/focvgMM5Pktm90dpWcj/cxtSBHzxns66I/VU+BrQ+wz0PQd9K1BLRBNN2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dDmFk4kHyT8UZVh45gdW56PPf9hePkTgq3+CR52x/8Q=;
	b=tFiBhYO6QIodQm163ITnrdt63Avo6jFN3ahek4MGWWx6HIunhm1NwdZ0ajg2+nvF8pIy
	 YlUjjyweOMJh89PClMVFsczQKT5XYVdyCBZMhYztuuimqlVHUqzkLaA16sZnZ2YAnaWlj
	 QyPpHYKDFGAxH/Q/z5FNBzZyOEgQgY8YNdxJH10QDiNsBcduKsErSmJBgj2y4tuIFQ+9X
	 xR9c7za0zPQ/253JVjKoLy1Njj7HeENDy+FpZ/o1X5DUZb9AvhxztkGiyaFev2A3YFk5A
	 gymSHoqkUZ0c6QaC/MCt/pYkUAHpFVHLeSJ54olmjrReEoHWENcWfX4XrPnJhCfp/yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JT5Praac;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9B3606A33D;
	Wed, 18 Nov 2026 20:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JT5Praac
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF77D1F000C8;
	Wed, 18 Nov 2026 20:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033721;
	bh=dDmFk4kHyT8UZVh45gdW56PPf9hePkTgq3+CR52x/8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JT5PraacyDz1WiS5a2N9hKtsc5AEl5cZw1aLmcJlhmvzY9++KtdAOpeJulYX5CgEZ
	 t1NBzZtZCf7ErkKkYMnYnnKQiN2nxLbZmkBoW7hGK9UVCXEgyQlmElsaL/u7JQzSJ7
	 Wzih0uDKt4gHnDoV0E5D40BeYYTL3c8g/4lGM/fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Review <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0113/3318] tools/lib/api: Fix potential double-free from fdarray__grow()
Date: Wed, 18 Nov 2026 15:12:15 +0100
Message-ID: <20261118150317.682714848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit eadce0f46a1d066b812c7e5aa46a33711c78a755 ]

If the realloc for fda->entries succeeds but the realloc for fda->priv
fails, the error path frees the newly allocated entries.

However, fda->entries is neither updated to point to the new entries block
nor cleared to NULL. If realloc moved the allocation to a new block, the
old fda->entries pointer is now freed memory.

When fdarray__exit() is later called to clean up, it executes
free(fda->entries), which would trigger a double-free on that old pointer.

Reported-by: Sashiko Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-perf-users/20260710200150.11FE71F00A3A@smtp.kernel.org
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fd/array.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fd/array.c b/tools/lib/api/fd/array.c
index f0f195207fca9..dcb396ab51eb1 100644
--- a/tools/lib/api/fd/array.c
+++ b/tools/lib/api/fd/array.c
@@ -31,7 +31,8 @@ int fdarray__grow(struct fdarray *fda, int nr)
 
 	priv = realloc(fda->priv, psize);
 	if (priv == NULL) {
-		free(entries);
+		/* this will be freed by fdarray__exit() */
+		fda->entries = entries;
 		return -ENOMEM;
 	}
 
@@ -50,7 +51,7 @@ struct fdarray *fdarray__new(int nr_alloc, int nr_autogrow)
 
 	if (fda != NULL) {
 		if (fdarray__grow(fda, nr_alloc)) {
-			free(fda);
+			fdarray__delete(fda);
 			fda = NULL;
 		} else {
 			fda->nr_autogrow = nr_autogrow;
-- 
2.53.0



