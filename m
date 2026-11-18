Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026230;
	b=CtglE/nEUjxtZxA3TT1hQiECE8u1x277kNUbnTZKhTYtNYcwcgphc8wa72EUBo0R6J7c
	 VC5wDuJ9/Whsq62SH8PUaEtl+fRhNLVRsC9Fj9zXcdaYtJrUDmTsRpi5mMemVRbylo5vu
	 uOUJAz0RPm6GSU5ZcUbpwBoUHSpi2+4NZVKZLhpxoxSCJ6rRR9jkT79xXMNbZ3CEvkGZj
	 9DYAnVXjzqXw95i4nwRY867WPagXk1SBekQ+JBYcSRt0UQmZbwwjtok7QJErKKSgA8Zqo
	 7s7iyj4tjS2Ea36KOikJj+6Aj01S8AGC9HcsdaSEsyrSRh2+OcNHxDIirpt9oTURoDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/O28yxiHAQ8uR0Y5nSEk6bUWGf3+y771nGZVH0vF8I4=;
	b=l49sm5RtblBdn52Q79dIcLJYhu5P9E/sru1ipihoyN1+RGo97uB18L7ZZ5DQ81Ov86zq
	 NmgbFq+RDOUqKq+zsqS7yGh4vTfGNemgL+dX6BQuT6em6vam0rHk6ilm/q/B3LYY9xGXi
	 IMa3g09NdzXEIyG9sCTyCwrhbv3R5OpLd+xaROOhgnYFagflmNxI8tpw5iciwHf8nKbKp
	 ta5Ss9VI/H05CvDyyRWzSuNJJKACPXSyCjnK0VWloB5s75QSmJ/cqmvIEccqH4SYmOweC
	 1feBqaXt7v80/J92DzddwymPveKIp53V25U1+x23JO2VkkSxbxtKUGymFmOm3YDShbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeGZerFI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DFD606A338;
	Wed, 18 Nov 2026 18:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeGZerFI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CF41F000C4;
	Wed, 18 Nov 2026 18:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026229;
	bh=/O28yxiHAQ8uR0Y5nSEk6bUWGf3+y771nGZVH0vF8I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YeGZerFIwhT4D7ISq5/CZyr3+i+1a3SwYEil9kxy2j/wZMR6GyNs0CJXNLA+Nd/HJ
	 tTo65WADDjjAMiD6jBo8MSK+jMu/X2LRNvh/WiXd+6NCHXtsTzOwE0a9cPhvq8mbf7
	 JbIjZ6jW1EgkUnd7IDM+E56ZZdB/7BWSG8klh5XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Daniel Vacek <neelx@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1360/2151] btrfs: fix off-by-one end offset check in report_setget_bounds()
Date: Wed, 18 Nov 2026 15:51:35 +0100
Message-ID: <20261118150211.571274699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



