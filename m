Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942A4157E6B;
	Mon, 29 Jan 2024 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548314; cv=none; b=GQvxv9VsLr15kAjCf3VGRrGL0OPIu6iOiHdnHhMp+SJVI6s8DyjeYo2DBBPWgSRii1Np6QNJDjPRoPswRpd768L/QeFhyYMHipLjbAz5Rh5mup70yokuVYtPV4bm3WkOB/zpysqivFy7cxKnLjTC0MbpXy1myJeWYDGq7IHgUrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548314; c=relaxed/simple;
	bh=St5nbuI+758iCPvqIIPRdG1f6Q9W2snBwWY3GOyVGqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJOyq7cJ5FaCIDH7zjmtekPH1/6t+KOn+XWif8Cpnmf5R7eVcZZ8UsJOX50aeWpO9XlznZqwaArlWGKRjH1fA0zXXOqxjhUpc31edGd+mJQph0NHTp8Znw7hRrLUizOJcU5R3GNQmGrBRjZ9StzQkW3SDUyoPh1Jexery9kzAc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mC9RjHFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mC9RjHFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593C5C433C7;
	Mon, 29 Jan 2024 17:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548314;
	bh=St5nbuI+758iCPvqIIPRdG1f6Q9W2snBwWY3GOyVGqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mC9RjHFXfEQnfOzYE27a4oPaFXQ4j1OHW0IyUVnLH12f0B4CYZUWFjbDjZt1BhoAv
	 dFcgCpkDcWS7Sn2mmeKmIEqlkMM10fP9+bpTJO/lWVBeNF9E0CAXLVFDZASpaTdd3Y
	 t3gXyMh6hu/fTx7xPpyDLg2fzGcUBWvxNhVExtq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/185] netfs, fscache: Prevent Oops in fscache_put_cache()
Date: Mon, 29 Jan 2024 09:04:49 -0800
Message-ID: <20240129170001.457463655@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



