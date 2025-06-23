Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255054409;
	Mon, 23 Jun 2025 21:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714694; cv=none; b=OFIx7IPBE1z4AhdY+nj4CeL1RE9DSAUe4UwfNpxyBG3LOnr5jzAWYqXTlrGmUCKWzCEkRkORIlfTy+h3yDz2Fzh3JHrpqFggvL7GEJK5BovbDqEnuKT3qNZ/ymJivcsbGfF0DT4dh+4xd+OLak2lokqaHNR3z0D+Nuo6evZylFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714694; c=relaxed/simple;
	bh=J1taC+dlnXLbay+iOthXHJTJCHl4uqv4UjEa6Z/GOq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOvnUxhCaVCuLTtrZxZI0pXtqZGLLZW6fQAmlbRpZDPNeBikxMdgKxpNDUnAOT2WRBikUcd25G9ZLV5CbFiH5E20TwqX0nwHdkExjFdXmn49byYG1JoFrasFoBhkHQTQXsR7UPZE+tJ1c2CPFm9sQIQRJS2c29wYPUyBzVJbSQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGXMDREQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGXMDREQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3769C4CEEA;
	Mon, 23 Jun 2025 21:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714694;
	bh=J1taC+dlnXLbay+iOthXHJTJCHl4uqv4UjEa6Z/GOq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGXMDREQK0MPesyxo8wALVyLRXfeqNOTxBuFdDSWY4Xv5A6ZIu3GRIyQxStQaZJxb
	 mw81foI6U1TQGDftmHFcnHwG5lToLwF+8tKCR2CjXmIXwo1yXrsw9FpXf43G95pTMi
	 fejccGPLmmTNoxoQpp0cwc63Cz8Ti2f8YGw6M/V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/355] sunrpc: update nextcheck time when adding new cache entries
Date: Mon, 23 Jun 2025 15:07:04 +0200
Message-ID: <20250623130633.444061962@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 5ca00634c8bbb2979c73465588f486b9632f5ed5 ]

The cache_detail structure uses a "nextcheck" field to control hash table
scanning intervals. When a table scan begins, nextcheck is set to current
time plus 1800 seconds. During scanning, if cache_detail is not empty and
a cache entry's expiry time is earlier than the current nextcheck, the
nextcheck is updated to that expiry time.

This mechanism ensures that:
1) Empty cache_details are scanned every 1800 seconds to avoid unnecessary
   scans
2) Non-empty cache_details are scanned based on the earliest expiry time
   found

However, when adding a new cache entry to an empty cache_detail, the
nextcheck time was not being updated, remaining at 1800 seconds. This
could delay cache cleanup for up to 1800 seconds, potentially blocking
threads(such as nfsd) that are waiting for cache cleanup.

Fix this by updating the nextcheck time whenever a new cache entry is
added.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 486c466ab4668..0a91945db88fe 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -133,6 +133,8 @@ static struct cache_head *sunrpc_cache_add_entry(struct cache_detail *detail,
 
 	hlist_add_head_rcu(&new->cache_list, head);
 	detail->entries++;
+	if (detail->nextcheck > new->expiry_time)
+		detail->nextcheck = new->expiry_time + 1;
 	cache_get(new);
 	spin_unlock(&detail->hash_lock);
 
-- 
2.39.5



