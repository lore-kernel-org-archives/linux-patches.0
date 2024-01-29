Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F0D73722;
	Mon, 29 Jan 2024 17:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548542; cv=none; b=t6J2ekUd7r6a0EZQlLPqesvX4YuGOWNqio0LR1SWPDeN6k5vt0dCj1CiwKeJ1WVY0ywXU0vQR344lVXBHSX0vTzI5iP6IMYQdw+FuwJ4ZMPbqrs1l5qBF0KxUBjSWrxplYG4WwjoOMuHkswE6S7MbyVxtb7eKmERyDiUqn180x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548542; c=relaxed/simple;
	bh=FshGyPnN7aErYl27bI5K9dYuHZFSRpTDvLMp3IR9vGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFj4FZiwIpX5FD7rDa9xf+ZIvf+KU4jy97SXNxukcX9ZSLocjxtTfsw3FM5xvGhT0nD0AFL8TuczLBsIE7EjabQofEmOY0l3m7d9SVVvP/g0we99tUeknKKdyM6oJ2IKA1/knZG+jWl2Chgpc7NI2GctILVEuDUiZuLEArOjJ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SQF8oAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SQF8oAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB35C433C7;
	Mon, 29 Jan 2024 17:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548542;
	bh=FshGyPnN7aErYl27bI5K9dYuHZFSRpTDvLMp3IR9vGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SQF8oAp6Zjtuls/T67OBjCCRPEVUM0vSVIA7ZNcka9QCu79VOjoXWsFbrIjjtval
	 DvWI/a8DEjU367TIz9y7TWmcFbpnX8ZpeG1MdbeYT/jtWt5y/pHzZwTQhClE2kbR36
	 6Qg3dktOw9AvTlQkL6UDg6fzi1SMnHVAUJrySnd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/331] netfs, fscache: Prevent Oops in fscache_put_cache()
Date: Mon, 29 Jan 2024 09:04:07 -0800
Message-ID: <20240129170020.252484948@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



