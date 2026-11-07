Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060707;
	b=YgOrQtngV74ZxkpP4+EweqHH3oPaL4OECBf41Q267GFftMg+MyEjt0jK7nzCzCFq8gjY
	 v2Uli9vT6mdQTLR6hSLv67DyKV/Xa7873+pe0ogF0Y+nw76reOXJlNTaFkro1J0+XiJL1
	 V/lwv8WZ08A67+xKlebJGhRllQTyaWwgIVpMocYtS+kN3KwSfnqjQreUwhCjYipKZIEaX
	 vMBl8gZJB7CKl41DwsmdOVV3TA/OGGt2eZJGkjcRVAXzpmu++Pt9BlBB3//wI6uJpO8+w
	 ljBTOrhlFTYs0CVonEy4Ah8R3z/ABVXs/+mtBKedcybPyBK/u9Mw5nRqBwpHUnX7zRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZcvGNZF2hk2uVhAfUHwOqh/cE/c1WMRn1TAMxKd8qaQ=;
	b=mOU2tLsA3Bv8nCBuS0obwswm6nyT5ru4k5bMnGKcAfIv69LcBxuZs+8AFz0FVD4bSTDO
	 BM64J7+xZ4d/OqoQC87YnFUtWbGUGpS60Ww0BcyMqrXoVH7KGNHjnmyGig95NRBc6haoC
	 LM3fHkXz37Iu37aVbCw2Umo5RF7JhHnVlU0z24q7VvH7GxokM4xFvc4WD79bb/ZV/MahK
	 3g5+S0ZkliEEDYbMovL5DvpgpE4o5i6VHMK4AkAI3W+CkPNty7V7FlLdKfJ5IBZEOW1rk
	 sbKqA5BS8ig8RMS75zP9+K3hnz9H8BiGGrOv/87z89v+UhsWHMLVjgseqwGnskI/yVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odmP61My;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7749F606A326;
	Sat,  7 Nov 2026 14:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odmP61My
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD27A1F0089F;
	Sat,  7 Nov 2026 14:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060707;
	bh=ZcvGNZF2hk2uVhAfUHwOqh/cE/c1WMRn1TAMxKd8qaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odmP61MyzdChPwQ8YEjJbdEPx2omT9yvEvovxj9CVCHxFpnkg7lS8Bw3LPAnACjtW
	 FnMvC+BXBw/oKbeJd6nqW5RGlo4MTPpTj7+grkElBkDqJ5sDBNyzTLKdZmZMVyZKo0
	 0y9agnsxBDRoI/a1XiOWMNXOpcnUWrM6sVEn06oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Review <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0135/1536] tools/lib/api: Fix potential double-free from fdarray__grow()
Date: Sat,  7 Nov 2026 08:35:51 -0500
Message-ID: <20261107135001.480082045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



