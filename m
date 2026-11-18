Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019632;
	b=ybnSUmCPxWA173kM5WmSTDivj9yRSYq6nSue/1WNEK5HxHj23RBT9qNfIkojZXA/ppZm
	 74yx0sDZTKBiz7+AhrnCnH8fU9QadvyvQ6+9TN1plBOnzWSlF5kkORx6OKi6gcWv7pd6a
	 vjdCP/gWB2J4N6uYYZ3B3T+TPbErCriINJ9PvCSxVns+anaM7q3FxUI2+S38r8fd+C+8W
	 qL5urFSNgMi1rCCzoE6I7X1h0fjyX0tD2WDbpsyfGPyAqDooKbkHFKqqAGF51z8GQMKoy
	 m9BEVJCI2I2cFSvqxoDBzbRT7FGGZFE80EmwC3t0T59Z+i4nQ1FJSL20YR7d4xaeeMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cac9Jo4WDWrR7Bo62qML7RIRWrm/VSsU911OSFGvGAE=;
	b=Et9iWZ+ZbiA77DnZw4kLqmVjvI9P4ZT++EIggHkG5MtYRaRHKKa6hM43S32TI28vyHPv
	 uWFEVkC95JeZUtC+on5tVuNBKzX8Wv0zTZKvjZIsdcQsfEMGUO+dicH0v5U2mXU1uu1Zm
	 HQJScgd9EQ8JoKJ/ssbuQfeJOMN3f3I0XJo+t5VdrGFnzGAf5dni0dMXuhFUFhthbNDq1
	 L/yPIs8kaaZYb9XBQGhBTuSTkfNrAAYTikArOmac4+WJpmUFjztX1RE/rgKC0pI+lpT4K
	 IB0T2XeWfUBupb5fvkOFTM4HIKW1c+j8/oB9jfDwZPporpXm6QR6kgu2rB96MlksEUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xVowksrF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3FC606A320;
	Wed, 18 Nov 2026 16:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xVowksrF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7EB1F000C4;
	Wed, 18 Nov 2026 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019632;
	bh=Cac9Jo4WDWrR7Bo62qML7RIRWrm/VSsU911OSFGvGAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xVowksrFUmmrJ7NZMcDR/DS98y9KP3bq0QiV3EBwsRb06NsJlh3ulnyiePts4kyZP
	 3xdW9cyqEgJVN+s+Hz0k1FWsc4qgbcKTORo0USaER5Bf5zFcUUN+di86eX+eRQ9j+Q
	 QDzHpWQxfe44IQybjgcxuoJK40/HtHbUo0LtEgus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Daniel Vacek <neelx@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1658/2651] btrfs: fix off-by-one end offset check in report_setget_bounds()
Date: Wed, 18 Nov 2026 15:48:18 +0100
Message-ID: <20261118150347.439551337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 08f750d9f8930e4ca053913b5ca3fd49fd9268c9 ]

The addressable range with an extent buffer goes from byte 0 to byte
eb->len - 1, so if a byte address matches eb->len, it's already beyond
the addressable range and we should log that it's bad start address
and not end address.

Fixes: 234fdd2815ce ("btrfs: remove redundant check in up check_setget_bounds")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/accessors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/accessors.c b/fs/btrfs/accessors.c
index 1248aa2535d30..d63ac6eb92deb 100644
--- a/fs/btrfs/accessors.c
+++ b/fs/btrfs/accessors.c
@@ -16,7 +16,7 @@ static void __cold report_setget_bounds(const struct extent_buffer *eb,
 
 	btrfs_warn(eb->fs_info,
 		   "bad eb member %s: ptr 0x%lx start %llu member offset %lu size %d",
-		   (member_offset > eb->len ? "start" : "end"),
+		   (member_offset >= eb->len ? "start" : "end"),
 		   (unsigned long)ptr, eb->start, member_offset, size);
 }
 
-- 
2.53.0



