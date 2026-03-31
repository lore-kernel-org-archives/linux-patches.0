Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A573EF0A2;
	Tue, 31 Mar 2026 16:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976050; cv=none; b=EBJSKcMMrV8fqki6NNMxbn0BwnkuTr3ZGr2e2mLJsm/gWFJUsYvT7TOc9ynTXEI2hUkk4etKNswpA//BZgRAOwVSFDGGHc5ZwXj6csfHf8gRLZra7ICUvAPZbP2GABz39QZKBWz5fG96XxX/a+xphXGfVbs5N950m6h8wxQ8jDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976050; c=relaxed/simple;
	bh=H3KnPAKGjdXvqd6w/kRytiOjbc+WAdQUTvC1DylUsxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rc3XQyWT9uK/iz5sCTo3kWuyjhzu7vKgffm6vRJm5hSx5mUqTLanBaoCGJYLm0pKUQNahnlcmU3I96u4fmCKWYc7vasMFQdbpErsIrhalcvwAZBPh/JU6BXPi3h84U3wFC9twrdMTTTRmycjZkczPTslqXN3LEPBGPS9LuUp1+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5pnOGKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5pnOGKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A107BC19423;
	Tue, 31 Mar 2026 16:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976050;
	bh=H3KnPAKGjdXvqd6w/kRytiOjbc+WAdQUTvC1DylUsxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5pnOGKYDUH7DP0v+wGvIbH74QlVkjUEaEcpOBNQZblVYKO4zOq0lBsxtAEeCaCzU
	 mn1TKoQiHCiAhyfdX/ipb+t/7qAzQ9ek7E74/4XcvQQ3Tq2f4NmNzjnhm5XIR8botL
	 I+0La2ckGRZqw5XR2cKpUT1pJeZAWzOpOi4wLl38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.12 188/244] ext4: replace BUG_ON with proper error handling in ext4_read_inline_folio
Date: Tue, 31 Mar 2026 18:22:18 +0200
Message-ID: <20260331161748.698911455@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuto Ohnuki <ytohnuki@amazon.com>

commit 356227096eb66e41b23caf7045e6304877322edf upstream.

Replace BUG_ON() with proper error handling when inline data size
exceeds PAGE_SIZE. This prevents kernel panic and allows the system to
continue running while properly reporting the filesystem corruption.

The error is logged via ext4_error_inode(), the buffer head is released
to prevent memory leak, and -EFSCORRUPTED is returned to indicate
filesystem corruption.

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
Link: https://patch.msgid.link/20260223123345.14838-2-ytohnuki@amazon.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -517,7 +517,15 @@ static int ext4_read_inline_folio(struct
 		goto out;
 
 	len = min_t(size_t, ext4_get_inline_size(inode), i_size_read(inode));
-	BUG_ON(len > PAGE_SIZE);
+
+	if (len > PAGE_SIZE) {
+		ext4_error_inode(inode, __func__, __LINE__, 0,
+				 "inline size %zu exceeds PAGE_SIZE", len);
+		ret = -EFSCORRUPTED;
+		brelse(iloc.bh);
+		goto out;
+	}
+
 	kaddr = kmap_local_folio(folio, 0);
 	ret = ext4_read_inline_data(inode, kaddr, len, &iloc);
 	kaddr = folio_zero_tail(folio, len, kaddr + len);


