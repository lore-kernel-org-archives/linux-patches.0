Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620293;
	b=XIrJo/3uA+1SI4MjGh+dbfWcNak+1YyLi1oTol7wf0YgfTVPIip4tOsBSySBc5n3NLW+
	 X7+1k0bqzYEH1cog1yKuu4hyZX5vmnx/zEDqRlTEg37p7++IhZ63KoWq02Q/9SSuJDNKp
	 8sg+/C4yKAczImZy6Hjz85H6YEhw/JJsYbTY8AIjuXIsHqPS0ct/M9qCF1QpBXlItu83U
	 ZOxReS5JQXz65yD/em2TLaoCxkLZSOxhMiv8naavqJntVq2E3G9RpXWhZ89XLRKj+h6T0
	 IzISTT0iodWh/v5HP2c3+zJKOxyO56nAeBUeCbk56pxiryZ0e+DMdpAR3yEswFA8rUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7QnETkf51Sim4sJ40SUPib8moi+JMRJdvVk7ee1z9YM=;
	b=nD9XKy/nRHaiVMsBRepja2tqzdHVulwhuaEFC1utM/thH8hrLPBeq8wlv8vGsoaEVd/O
	 ld5m35Lk2v+pC+Fc6agjzYrPELtmE8pCj/V5GeUrOWhLNHDklpwtR48Yc+538soJpc53f
	 q5k3uXYvvNqIUdhP6R5qGNLN3Tymi1zxu6goUjA/s8Y3+UHmDf/3H7tacZBZ04Y7RLyvs
	 JlFtgSexnZhPclSpWidIojq9OpvGyBzYU5jGyez1lQXcaMMjpaYvEOGjCUJShL2eGzvQK
	 jaEMXKuX+VSUvdIq4cx3B6Fn8Iag0ZRw91s4/d3Mmx8bXnfcjRGCBwIH8wFuQYTb8ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojvuqKaO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E2A606A323;
	Wed, 25 Nov 2026 15:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojvuqKaO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5FC1F000D3;
	Wed, 25 Nov 2026 15:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620292;
	bh=7QnETkf51Sim4sJ40SUPib8moi+JMRJdvVk7ee1z9YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojvuqKaO+YjgVsf3cnNunG4yNemQvmPxXi+71KHaeJRCnafZfczYDXRrVTcHYSUKy
	 ya0welzs23Foy6Mj7uybrxU6WH3XBuP92S6Ru6/HSQ/Ii073UE8ujnrP6kTN1dwE+A
	 bf2Hbzng7oT+SfSez73Nef0p8INKT5KCVs0qEd9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0869/1005] dm persistent data: dont leak bufio buffer if find_leaf fails
Date: Wed, 25 Nov 2026 15:36:47 +0100
Message-ID: <20261125143842.064674360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 


