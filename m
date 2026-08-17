Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C82C43CE64;
	Mon, 17 Aug 2026 14:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978781; cv=none; b=hnH1AQNlJmlcMvOnjWwN91e1tUkeuNYDTANtDkv64OutqrElwX5cOV65p77xRGJHGMnKnQadJSpAF2M8ehsYpCsH8miXMj6SCZ2qQlv1LlepJCs/3mFP0Je1POon1tKEnRNkKtpC8yoStITYjImaBvrNvclIJ/lKRZ80fA+6Rhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978781; c=relaxed/simple;
	bh=Ai7Loujy+8/dnBrnOceqa+eRNEZbhqGFC5P3AnG7LfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9MtjnVaWaGJhx5LDXqFfd3ob8wNdZhgZLTqS5oWac7yaLSFCOix8cgl/GQFGu1fdOd0u7smTdsWmyERNMIwRgD3MyILIGxg11BsYaqXxbZqKBWrtU3z9ndtFjJb/gjKtp6N1f98/0vWDYdyVohh0DcB4T5bv8yBV8crzmX+zfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1Q4tBet; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1Q4tBet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007A31F000E9;
	Mon, 17 Aug 2026 14:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978780;
	bh=EF8n4WQy/yagTbfwpDJojeRNVXy8t8ofnf3WbfoyNuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1Q4tBetVfs/Mho41W7ANSgQcwq1QNxqxRtb6c/kzFubCBWehu5ceylbJP6kQBZny
	 RFQ1kdtWIH8hAmLXdZ1NjH//nf06PUNnHV6ciRgT/j2679uHRDlKXBYrVScIHllV6S
	 bfZUO8/fVtnHMxDRqHzFFuAcCfxL4vvCIqcufeWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dmitry Safonov <dima@arista.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 154/156] net/tcp_sigpool: Fix some off by one bugs
Date: Mon, 17 Aug 2026 15:34:48 +0200
Message-ID: <20260817132540.789747687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
User-Agent: quilt/0.69
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

commit 74da77921333171766031ea213b11f1e650814f9 upstream.

The "cpool_populated" variable is the number of elements in the cpool[]
array that have been populated.  It is incremented in
tcp_sigpool_alloc_ahash() every time we populate a new element.
Unpopulated elements are NULL but if we have populated every element then
this code will read one element beyond the end of the array.

Fixes: 8c73b26315aa ("net/tcp: Prepare tcp_md5sig_pool for TCP-AO")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Dmitry Safonov <dima@arista.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/ce915d61-04bc-44fb-b450-35fcc9fc8831@moroto.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_sigpool.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_sigpool.c
+++ b/net/ipv4/tcp_sigpool.c
@@ -231,7 +231,7 @@ static void cpool_schedule_cleanup(struc
  */
 void tcp_sigpool_release(unsigned int id)
 {
-	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg))
+	if (WARN_ON_ONCE(id >= cpool_populated || !cpool[id].alg))
 		return;
 
 	/* slow-path */
@@ -245,7 +245,7 @@ EXPORT_SYMBOL_GPL(tcp_sigpool_release);
  */
 void tcp_sigpool_get(unsigned int id)
 {
-	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg))
+	if (WARN_ON_ONCE(id >= cpool_populated || !cpool[id].alg))
 		return;
 	kref_get(&cpool[id].kref);
 }
@@ -256,7 +256,7 @@ int tcp_sigpool_start(unsigned int id, s
 	struct crypto_ahash *hash;
 
 	rcu_read_lock_bh();
-	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg)) {
+	if (WARN_ON_ONCE(id >= cpool_populated || !cpool[id].alg)) {
 		rcu_read_unlock_bh();
 		return -EINVAL;
 	}
@@ -301,7 +301,7 @@ EXPORT_SYMBOL_GPL(tcp_sigpool_end);
  */
 size_t tcp_sigpool_algo(unsigned int id, char *buf, size_t buf_len)
 {
-	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg))
+	if (WARN_ON_ONCE(id >= cpool_populated || !cpool[id].alg))
 		return -EINVAL;
 
 	return strscpy(buf, cpool[id].alg, buf_len);


