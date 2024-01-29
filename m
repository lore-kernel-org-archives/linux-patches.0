Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA2E15B99A;
	Mon, 29 Jan 2024 17:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548136; cv=none; b=Tr+aB0wL+jrYuS3SQUgjx0XlZVTUTXrCLR7mylfJ0x6TcP99r4x+2wT/foTPQUouZam5HocsdZRWuOVgw2lOHxZPGlVBvI3EuavncPLey8v1gvN2di7VkCjfZ+JbRD9Bt8JV8S++dcMWkwQeB0ta85oeZ/0iOaT4BQUI+eDxTK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548136; c=relaxed/simple;
	bh=A8T/TUOJ+UECMnrImOZkcMQGtVI8zIz/NsYVPgBml88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6yywk8COKMoW3+SGxWgenpnr6QJeJnj3RkDOijl1m+U/C8bAkCHYo3kqmHkDelmCIXgk9yZnk5hVWkBNVh3SunxynM2rsrXvtsanIDiTfa3egB/2oTtuhKznMaavgDJyUQmC9psn699jwFSY4lQvjEbaIrCG4kM3gSz1Pq/Zyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTHrbZQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTHrbZQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5ECC433C7;
	Mon, 29 Jan 2024 17:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548135;
	bh=A8T/TUOJ+UECMnrImOZkcMQGtVI8zIz/NsYVPgBml88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTHrbZQdrtkd+rl9kDVtZiJBosT33+EH4OXNKWWr3m2d68a+rDqSEAIkWllb+Un65
	 t41ooHkANWYhdGT4TPbGUF2v85mYjCuGEK7gu1nZ2wRJRqEhZhxk6IfNxc3O+DePD2
	 HTXyMGFzK0Iud/DfcD2znorJ83/Bcnm/etG8zRts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 167/346] netfs, fscache: Prevent Oops in fscache_put_cache()
Date: Mon, 29 Jan 2024 09:03:18 -0800
Message-ID: <20240129170021.309863730@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3be0b3ed1d76c6703b9ee482b55f7e01c369cc68 ]

This function dereferences "cache" and then checks if it's
IS_ERR_OR_NULL().  Check first, then dereference.

Fixes: 9549332df4ed ("fscache: Implement cache registration")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/e84bc740-3502-4f16-982a-a40d5676615c@moroto.mountain/ # v2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fscache/cache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fscache/cache.c b/fs/fscache/cache.c
index d645f8b302a2..9397ed39b0b4 100644
--- a/fs/fscache/cache.c
+++ b/fs/fscache/cache.c
@@ -179,13 +179,14 @@ EXPORT_SYMBOL(fscache_acquire_cache);
 void fscache_put_cache(struct fscache_cache *cache,
 		       enum fscache_cache_trace where)
 {
-	unsigned int debug_id = cache->debug_id;
+	unsigned int debug_id;
 	bool zero;
 	int ref;
 
 	if (IS_ERR_OR_NULL(cache))
 		return;
 
+	debug_id = cache->debug_id;
 	zero = __refcount_dec_and_test(&cache->ref, &ref);
 	trace_fscache_cache(debug_id, ref - 1, where);
 
-- 
2.43.0



