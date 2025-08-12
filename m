Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E766221FAC;
	Tue, 12 Aug 2025 17:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020986; cv=none; b=CXS6KasPqLHyXFq/tldcowgt2tZOPPH0/84RJ7PNod7l+MhF4HtQMrFeTGd61RNZN32hDqvk9m2cSEaUDuUSwHsGYXQwNFXkGw578SZweqvZje/X8cfjAXQKJscDbXd91/KWVZZwxmox2j6ARUhl2zecRda/ixawD4U/SmfJ5I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020986; c=relaxed/simple;
	bh=AhFM8KU83xkN3OfZZ3A73/eXpqppQlxgXqyXm0fUQhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLouoWMu+CsuGvTPLzFyO1T2uYUMKm4gf3njBRH4iTBnA0d5gE32llts/zP1UP/5npWRxCQ5J/kSdy8rEC82TdJnK91oWlrcSOCsWtMOJhUkcgys+ioqr5RMioqTP6hS/eyTPf2tilGNYHNqvWEbIxycfnbLql+PtEIiIw3dPls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=devNH7x/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="devNH7x/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB485C4CEF0;
	Tue, 12 Aug 2025 17:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020986;
	bh=AhFM8KU83xkN3OfZZ3A73/eXpqppQlxgXqyXm0fUQhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=devNH7x/bGTIEpK1JKRY/IPPEQszaZehGFbt7kGjFdijN3/rf1ZWB29V4wyAA1TmK
	 PYGHy29sQYfGxMvkmlPRaLrCxUd/piH2uVRE2ziKi99xdxL8pcUTyt4mglNl+xQO3f
	 L5kcarsWFMz5a4SVPTC5UERtP9vQ1tXlRbNPwph8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/253] f2fs: fix to avoid out-of-boundary access in devs.path
Date: Tue, 12 Aug 2025 19:29:44 +0200
Message-ID: <20250812172957.146476746@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 5661998536af52848cc4d52a377e90368196edea ]

- touch /mnt/f2fs/012345678901234567890123456789012345678901234567890123
- truncate -s $((1024*1024*1024)) \
  /mnt/f2fs/012345678901234567890123456789012345678901234567890123
- touch /mnt/f2fs/file
- truncate -s $((1024*1024*1024)) /mnt/f2fs/file
- mkfs.f2fs /mnt/f2fs/012345678901234567890123456789012345678901234567890123 \
  -c /mnt/f2fs/file
- mount /mnt/f2fs/012345678901234567890123456789012345678901234567890123 \
  /mnt/f2fs/loop

[16937.192225] F2FS-fs (loop0): Mount Device [ 0]: /mnt/f2fs/012345678901234567890123456789012345678901234567890123\xff\x01,      511,        0 -    3ffff
[16937.192268] F2FS-fs (loop0): Failed to find devices

If device path length equals to MAX_PATH_LEN, sbi->devs.path[] may
not end up w/ null character due to path array is fully filled, So
accidently, fields locate after path[] may be treated as part of
device path, result in parsing wrong device path.

struct f2fs_dev_info {
...
	char path[MAX_PATH_LEN];
...
};

Let's add one byte space for sbi->devs.path[] to store null
character of device path string.

Fixes: 3c62be17d4f5 ("f2fs: support multiple devices")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ef9149bd398a..1ad9669666e8 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1226,7 +1226,7 @@ struct f2fs_bio_info {
 #define RDEV(i)				(raw_super->devs[i])
 struct f2fs_dev_info {
 	struct block_device *bdev;
-	char path[MAX_PATH_LEN];
+	char path[MAX_PATH_LEN + 1];
 	unsigned int total_segments;
 	block_t start_blk;
 	block_t end_blk;
-- 
2.39.5



