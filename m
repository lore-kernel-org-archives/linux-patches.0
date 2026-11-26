Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704670;
	b=JUJl3s/cwLNFX6JGgwnggBMUUFDTOI3u5+xDBP/6eaAHv7e8n1f5XOW5M4nIxY25Yz2R
	 sz9rkYgBdxnbfGCK32nl4gqm/RscUr3m+60gkLc/5sWICFXrJ6Wp59NikaN8h1BE5AhPz
	 qTV7oFHBlOs7+02MsxjiHWy89hX7/srnhm/CMiARetesi5qJwnhwRleXJnwjMjJHg5s4U
	 URGTBxKzu/HLL29n6+yKBk6hMgJ25JJn6ihDvqImHXy18PWD2bD9rIYg+5tfXH6C8kBQ8
	 yR96wyyIX9klXURdRsQkOEN4KsVVm+ySJyfUPLWifPQd8a5oo7jXU7ixStyktdEiHiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FTrIxUmvG1xYeLN7BkHEXr/8XJuRc5T2dRZUnpv1rn4=;
	b=nIVxqQeGhbSCNTYGmmQGGuIbur3uMnaHZ+coko9d9K8XcWyAkcE3IqaPSPiHzkhI7CcO
	 b3zF8CqJlSqs/kW53CBtZoAgAO89ZqoLf1BvYPn5bXI4GTZ8DN8awLNt+Msjt3pRi85kJ
	 iohRi1mkSBsXNoGero3o2EV0WFSMq1kpfFo9T3O/1dQbFIS6eh0hH0GZbDMFjD+tjVk0h
	 Ln5lmAMEMlvrgD3wA09W/nBQg41DNJgAJ0mKJ9kcxuIdg5bPPBH4tiFhokXS7pEfF9Sh8
	 mYJu6EV/UcuXYl4FsJX+go6b/jELocgW/uux3wYObmnSAd4xGJkOpSjPgqpca42gPlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lb0d0sck;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749A3606A31C;
	Thu, 26 Nov 2026 14:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lb0d0sck
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD11C1F000C4;
	Thu, 26 Nov 2026 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704670;
	bh=FTrIxUmvG1xYeLN7BkHEXr/8XJuRc5T2dRZUnpv1rn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lb0d0sckrLTlova8WFqbcTn/m4ZagLpOvf5tkjivC7p0rNSY3a2V2EqY7Iq477KLv
	 nOIcDryUmOWXa96qzDcyYRiIBkE9lFnZByfMloXwHRyDz2z161UwLaGNbnX7yXh3aI
	 qJL1v/lH1mW6cp2AYngZUB9P/VxVyj4i0jPb533U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 205/265] dm persistent data: dont leak bufio buffer if find_leaf fails
Date: Thu, 26 Nov 2026 15:38:55 +0100
Message-ID: <20261126143619.544546956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1506,7 +1506,13 @@ int dm_btree_cursor_begin(struct dm_btre
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
 


