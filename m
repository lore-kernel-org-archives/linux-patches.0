Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730738BE8;
	Tue, 30 Jul 2024 16:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357177; cv=none; b=N2Ko0F7vo+TP4iCoF9VCFyIpJNIjJmavJM8jiSXqtQBe/+6Jo84cm+BJjIEYAFtXTVMgfOQOsqrgcMxIIXMQxnDapgtdeuwQgdBzMb7+9ykO8Oc8yRb1JoScZNm1tQ4w+Vkfah3JPad8RwmLK66Aekp0vNsTu/UHNVGQLpqZN4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357177; c=relaxed/simple;
	bh=UQ/sblWXFAAjbaiIILxHmlXhBov052se6edV5/DsQAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOw7PubU5LemKeJNLkHamArVPw/QfGgrZo8gAewG9z7K4JOKtyKQlK7sqeWkcJ8+gV3ELaIwlUDC3uFz5OqL+POuRWL5rCrtcLm53eQ1ZXgaCEbdJzirLrPG5v9zXnmJ/uLDJDUswABFR6b12Esf4FkOMsTMwENAxpWbRQgi1Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYnI+7Q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYnI+7Q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBD1C32782;
	Tue, 30 Jul 2024 16:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357177;
	bh=UQ/sblWXFAAjbaiIILxHmlXhBov052se6edV5/DsQAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYnI+7Q13tNqIY7MN6kDvYrWdPL/b/M/aoLPEgHc/iwFT3XZ5zC5QoYxYMLo/chfm
	 kQ24RVhvWjCMWfPzYZLQZWP8eUDxpE1wEhpFmSCHDYvXZdBByxL9J5o3wVG93/x72p
	 HHdpx3iwOWRK5RYueQarJUw+X1vllloTme8ohbOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 266/440] sbitmap: remove unnecessary calculation of alloc_hint in __sbitmap_get_shallow
Date: Tue, 30 Jul 2024 17:48:19 +0200
Message-ID: <20240730151626.229436870@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit f1591a8bb3e02713f4ee2efe20df0d84ed80da48 ]

Updates to alloc_hint in the loop in __sbitmap_get_shallow() are mostly
pointless and equivalent to setting alloc_hint to zero (because
SB_NR_TO_BIT() considers only low sb->shift bits from alloc_hint). So
simplify the logic.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://lore.kernel.org/r/20230116205059.3821738-2-shikemeng@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 72d04bdcf3f7 ("sbitmap: fix io hung due to race on sbitmap_word::cleared")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/sbitmap.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index c515072eca296..b9dd0a0a28f89 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -243,6 +243,7 @@ static int __sbitmap_get_shallow(struct sbitmap *sb,
 	int nr = -1;
 
 	index = SB_NR_TO_INDEX(sb, alloc_hint);
+	alloc_hint = SB_NR_TO_BIT(sb, alloc_hint);
 
 	for (i = 0; i < sb->map_nr; i++) {
 again:
@@ -250,7 +251,7 @@ static int __sbitmap_get_shallow(struct sbitmap *sb,
 					min_t(unsigned int,
 					      __map_depth(sb, index),
 					      shallow_depth),
-					SB_NR_TO_BIT(sb, alloc_hint), true);
+					alloc_hint, true);
 		if (nr != -1) {
 			nr += index << sb->shift;
 			break;
@@ -260,13 +261,9 @@ static int __sbitmap_get_shallow(struct sbitmap *sb,
 			goto again;
 
 		/* Jump to next index. */
-		index++;
-		alloc_hint = index << sb->shift;
-
-		if (index >= sb->map_nr) {
+		alloc_hint = 0;
+		if (++index >= sb->map_nr)
 			index = 0;
-			alloc_hint = 0;
-		}
 	}
 
 	return nr;
-- 
2.43.0



