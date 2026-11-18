Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040031;
	b=dLHo7tYNk74zvGfo6coJLmWGSjMV6wcrtgrmfW1H5GRP7ynKW1pwITukEocnUt8GPSwt
	 pWYH/2hEVV+HlxUXKPXod3W1tQv+npvttJntwHLumeU0yTbPgDJZ337Lr8oUDZ9iIYYtG
	 MihvkRdIqLHW0r9Y04koXznxm8KNjBzMNay5TpTD4bau9UT7ZjFoHDOwNPnse7lAT0yQq
	 hWh9WGtTLuPb6So+W0pqZs9usEF3057xjv0w+8HuAQfii4/XjFpKmvctT5WZ2jygENTSM
	 zmcHhG6MeYpq14BVjot6CxUyNYTyJ8DTSqKcjVZ4GSlkTvPyy4yOVALczY5izDsX9+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q6WBMspoHlyxE/yQf4auTj6cBEwAC0JLVg1+wsQpO9I=;
	b=iMBgKWaLRxArhfdTjErfTz/PJao2NcM8OIUzuKVhWCFSZipE6RTvTzaft6w2rH1+I1Ml
	 7rNbWvERU+7T2GjmTqCeJJUXPB1zns0IPzgmcQ4B9LZG65hiNQYmkd65nxMChxyko0iQ1
	 6FCjBLOG4h7qrk5zkoYizin4j8C43DQFBUfk5GHzrd3qiixkqVw8lI9IUVWPE9z9RgyEO
	 mDPL/rrOPQg23ZVErYEMkDnhUwsGWF1xLlTqzfiXF576oEXrRen3RfygDDu1JBDeJ6gLY
	 y+zaCikZzVd6kxL74Oj0FKSWrBXoM81nNUi+yJF61ImPck2OXcpkoJ7wDDPvZg5Lbew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXRguSn7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71B6606A31C;
	Wed, 18 Nov 2026 22:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXRguSn7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BDF1F000C4;
	Wed, 18 Nov 2026 22:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040031;
	bh=q6WBMspoHlyxE/yQf4auTj6cBEwAC0JLVg1+wsQpO9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXRguSn7JWB7UtrfthW5kN9Y9aMrBf7fThedAp8FuEYcKJsoJUcOSJzSNuXWRELEs
	 YetjiZoZ943yIJJsRu89efqVdN6lhwL9UPLCTk26/2BTcvw9E6SdjXIjY8MyssST6B
	 iFDjKgGRIzyAgXS6JmmRvNbSsAcShgVfbIRhQ/0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2275/3318] fs/ntfs3: fix valid_size not being updated in attr_allocate_frame()
Date: Wed, 18 Nov 2026 15:48:17 +0100
Message-ID: <20261118150430.032538577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit a1972501ffb15313f7ae598989bb2cd32829e625 ]

At the end of attr_allocate_frame() the on-disk valid_size is meant to be
updated to the value passed in via @new_valid:

	valid_size = le64_to_cpu(attr_b->nres.valid_size);
	if (new_valid != valid_size) {
		attr_b->nres.valid_size = cpu_to_le64(valid_size);
		mi_b->dirty = true;
	}

but it writes back the old valid_size that was just read instead of
new_valid, so the field is never actually changed even though the record
is marked dirty -- the intended update is a no-op.

ni_update_parent() spells the same read-compare-write out correctly a few
hundred lines away, storing the newly derived value:

	valid_le = cpu_to_le64(new_valid);
	if (valid_le != attr->nres.valid_size) {
		attr->nres.valid_size = valid_le;

In practice that path, reached from ni_write_inode(), re-derives
nres.valid_size from ni->i_valid on inode write-back, which normally masks
this, so the visible impact is limited.  The assignment here is still
wrong though; store @new_valid as intended.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 75b3a895a1c79..37c2b7e0e2835 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1882,7 +1882,7 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 
 		valid_size = le64_to_cpu(attr_b->nres.valid_size);
 		if (new_valid != valid_size) {
-			attr_b->nres.valid_size = cpu_to_le64(valid_size);
+			attr_b->nres.valid_size = cpu_to_le64(new_valid);
 			mi_b->dirty = true;
 		}
 	}
-- 
2.53.0



