Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626177;
	b=5b3lDDXwgCqG045RqsL5nLdNTUhMkk39FQY6vCSkpWJp5EX9ENQdvTrD9WkWJpsSKXFz
	 adVc9fenD6u7u9XnEpwQ5D5hOFQFeJyc8Uoue1JtRuOTZ+WglSzb0h5/+mESBsSkTDGen
	 /5BOeL4YXLsKk01s2hDdmCkKuq8H5+4r4yaChrRXryoKWhaM6gPgPH7dI4GKxu7N19+8i
	 UM87QSwZ0OzkzU7u4q1c5SuhQV0V+F5BpAI/qrlLJBPbm0duY3eH8G21BTxGbIBCqjBgQ
	 hYU6msL864AEvHQ8GGC2+n6KauZVsoom3/mW1w9/vw5/eXK74vbNeAoztLYUonqRvHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dWi8vAA2z1OUlWqbYDvGn7CsRaLExkViCfLxZnhNDTM=;
	b=gtZh3t4xZ1QDAaSD3dQOl+3PU3U00ybZwcL5F55x7XPfHgkdDdQWF1H/q1H4q8rHtk8C
	 KAf0yZWHS+E9TtHkQaoxuGUTA1Wl9SMv4kK4o0/oxnhjTBr/W3qYIb7DP9TJHqS+RHmI/
	 3eiLOV+T9+NiM7kRiGptDo6GZnDaeoH7G7oxJzPSFjm+ChWNi+ZVjl+S6qg8aY0/28EHF
	 2cOE+z2y5mkg8goYVTriPgTv8mp0slDwfJLVum1gpfFQYPMXwTrvtHd4ktl6na/EXe14S
	 iW5kqXfKsgGgoLUFOcIZzVnRYS30CwmFVcTRLeJY8YVv08M9YnFvzCARVEdlPrBNeng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GmdFoi1G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C295606A31E;
	Wed, 25 Nov 2026 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GmdFoi1G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442F81F000CA;
	Wed, 25 Nov 2026 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626176;
	bh=dWi8vAA2z1OUlWqbYDvGn7CsRaLExkViCfLxZnhNDTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GmdFoi1G1b7E5JxOmfE/JcQ7tIHag0Oih1p6tzX8fePsjUnNVk7LcUK7mSxInTopm
	 vcK4Y9+F2/J628T2uEyRjavskbU/3XFEPX9QTrZ8dJTAyD0mqBQTK/aVbahjl5aKk9
	 fLj7UFN1tYccPfdNJcj1xyCu8I25wCx9vrTlSmv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 703/816] dm persistent data: dont leak bufio buffer if find_leaf fails
Date: Wed, 25 Nov 2026 15:37:31 +0100
Message-ID: <20261125143905.452856386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit b27523a0781aae0b51ac13f29dc65373d14b8434 upstream.

If find_leaf fails, the function dm_btree_cursor_begin would return an
error, but it would keep the dm-bufio buffers held. This would result in
a memory leak and a warning when releasing the dm-bufio cache.

This commit fixes it, so that dm_btree_cursor_begin releases the buffers
on error.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 7d111c81fa29 ("dm btree: introduce cursor api")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-btree.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -1582,7 +1582,13 @@ int dm_btree_cursor_begin(struct dm_btre
 	if (r)
 		return r;
 
-	return find_leaf(c);
+	r = find_leaf(c);
+	if (unlikely(r)) {
+		dm_btree_cursor_end(c);
+		return r;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_btree_cursor_begin);
 


