Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705584;
	b=ivHy9hhkw7ucfOKZek2+DwxLYrseJBqW/eAHJUzq5y5krTZ+Cun9JF1E2RSiOCLjgNe8
	 VbFeLr1XNvQ50mr2gLVtbA7Hf8L40H23cb4jbvVqlzQM3WehNnBpSSoMJriQEXCgIQLKO
	 WCDbx/uKhrO/8PgLfXrM8da5Ir8bqTeHy7+saRU+oC03jOEhX52eAuo3oK0a4+yur/Ifr
	 dgu2iwo7sofOLs1gFqt2KoGoVpKcfh21tyt/VcevjuyHYjrkFujLgtHF9OkdGA6Fhuw1q
	 3dhd8nM7ZC8W5UHSHVLMlSqlsB0BrrThsqdc3t8zunEJDLWEhQz8BAgiELQ3VlYoGIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iCHlXdzihB4qDq09ayBuHv9K7/m9Tt4cnF6f27qYMiA=;
	b=zLcRWmEB/MuCmQ1Ki9/t/h+phAJ0e+dRmwZl9P/gFLqWHi2HrRsJEqQMLNyZrbigwwr4
	 4lOkRzUiNkCUmY6w2Ff3Fh6H31UkoLuJHxJGQEz2MKIf8Ff8zGEK/pzpLGdZmAe6/PFp8
	 5XMwqgFMfbRGnJYuzR51dCPY4UGyjSWawbWNwP2ZWj/OXUS0h3dQot/Zr1YzASF+zfHkW
	 A6fkwvp+NkUL3dG1H5o9tlhz2nljBefgHFV469++slavHshZ/JM2PzEMyQjUW0zcfBt3g
	 5w7hZL6wO/QDxXQO2rbx5K1UVOVY03PCiPpcna7ssixmBN6XuDwsCMvu1RKkAP6zTfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2GeucBv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D631606A327;
	Thu, 26 Nov 2026 15:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2GeucBv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CBB1F000D1;
	Thu, 26 Nov 2026 15:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705584;
	bh=iCHlXdzihB4qDq09ayBuHv9K7/m9Tt4cnF6f27qYMiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2GeucBvoYO4MfgiXDfBGxARFhDiHMDnjNIB7MR+m2oj3EbwaVT8evWm9yNX8vC3d
	 nsjpgjLZA0FazB6oTCoH/vG6xYessIztFnmmLB0QQeZJE/RlEkVJQQBLIfV6q9/jMB
	 mXp5B3FRXa8COj8WeA2ZVdC/FcUoqnkJWjZOj2Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 247/319] dm persistent data: dont leak bufio buffer if find_leaf fails
Date: Thu, 26 Nov 2026 15:40:15 +0100
Message-ID: <20261126144012.319393756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1571,7 +1571,13 @@ int dm_btree_cursor_begin(struct dm_btre
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
 


