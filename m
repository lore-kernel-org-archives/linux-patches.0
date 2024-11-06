Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A8B1F8F0F;
	Wed,  6 Nov 2024 13:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898296; cv=none; b=OaFEaFLtE4iiqumWxkZLKgLZyp4AeD1KxY4EGL8JYOSE21STCx+yMy9wZZeq1xy5qVLTa4hOZsh1m9TDWCPaCTDb3xKZlj+o4i07IzgcXyhvZRd1hSShEv5KvSW/vnbzFkBpyNNXwYh4syn4ncZzS6XlY+Io/KjjkQM4mtnAbd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898296; c=relaxed/simple;
	bh=Qio0Qq2e/KZh7sPFYFXMZEk/ExEPgU6nA+nQYmpjDM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsaQJN0p6xvMKz5rGMjnczgJMGS1UJ8PqBF9WJFhxcDVCbiYyl0Z2i/mhQ3fPj3mwaISVMM9mIYnEimmhX/W2Q8D6JzFxYiTf3ELfbBWZ6Ch0/LVy67VRZAUfWqYDkRKqw3M7NpAy1Z06G7A24egdeSA6K9hDdqmLuN+ZzUJK1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXC6EOSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXC6EOSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702E2C4CED3;
	Wed,  6 Nov 2024 13:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898295;
	bh=Qio0Qq2e/KZh7sPFYFXMZEk/ExEPgU6nA+nQYmpjDM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXC6EOSNt10hItwq/QfmhOLmFdJb7TohZq3INy/PUeYjh7mwsHWfZTjagHqg7Yekh
	 KqeFv0IC8d3xrDi14sqRZRKoCjYgWyazNSpUnxh0lg2HfKncKnH8cO+OhW8w9s3L5J
	 swkv1wIBeKIUE6MmPc/55F3mf7g7mZYSXlMezXpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 153/462] f2fs: prevent possible int overflow in dir_block_index()
Date: Wed,  6 Nov 2024 13:00:46 +0100
Message-ID: <20241106120335.295144981@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 47f268f33dff4a5e31541a990dc09f116f80e61c upstream.

The result of multiplication between values derived from functions
dir_buckets() and bucket_blocks() *could* technically reach
2^30 * 2^2 = 2^32.

While unlikely to happen, it is prudent to ensure that it will not
lead to integer overflow. Thus, use mul_u32_u32() as it's more
appropriate to mitigate the issue.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 3843154598a0 ("f2fs: introduce large directory support")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -77,7 +77,8 @@ static unsigned long dir_block_index(uns
 	unsigned long bidx = 0;
 
 	for (i = 0; i < level; i++)
-		bidx += dir_buckets(i, dir_level) * bucket_blocks(i);
+		bidx += mul_u32_u32(dir_buckets(i, dir_level),
+				    bucket_blocks(i));
 	bidx += idx * bucket_blocks(level);
 	return bidx;
 }


