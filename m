Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396081E52C;
	Wed,  2 Oct 2024 14:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878873; cv=none; b=KRYmRBGK0E2DCXdZ/yfy6/XBA71C9NKr/FP70I7l4o3MpMV5r2vXu5ajcwOyHmq27QlVoyQ3FfwYAZz52bEirUWHTdQ8iC4fxnu/mLdSou1YGTJXsaaRk0Q/NmvD0GCdZ2vJq+ODx0dCb4yQFo8NExmx2dMZdEEGNIut1WlCOC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878873; c=relaxed/simple;
	bh=ZwdnOgtHoSgFBnQHF1yRMtXtCQnVQrwFuPXzlH/6OcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InXUNFnvaYKki+9R/UCm3oKzFgd0LMzGA8nJMUXex05CBvBhfAG6uREqmdo/IMlUcUrbI5dHHpXFknradb1gWtEuO4AHfWXNiI1YSajqtaYZ0HCFnEej8Atm6tPBGFLSHiMYe6GrBxlmgoeeWdoVcw5l/bZkgiL6TIX6rBBcNPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xW2Gf10T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xW2Gf10T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B585AC4CEC5;
	Wed,  2 Oct 2024 14:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878873;
	bh=ZwdnOgtHoSgFBnQHF1yRMtXtCQnVQrwFuPXzlH/6OcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xW2Gf10TFldfdyy1c/DPjEqsmbk+j0WPnFcKYQ71xksNd923BYo6bs+s9pujLkA/g
	 J/DXYtm6zMnz6NSFNtDIQw5Li6SE+Q+w1PglOLImJ8CK3wbd8Ey5C7lsI1MgDGrGSa
	 9HB6XwVDk42a6LG5x5EqZ6qZEegUV9HLYSdYeNXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.10 561/634] f2fs: prevent possible int overflow in dir_block_index()
Date: Wed,  2 Oct 2024 15:01:01 +0200
Message-ID: <20241002125833.259972760@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -157,7 +157,8 @@ static unsigned long dir_block_index(uns
 	unsigned long bidx = 0;
 
 	for (i = 0; i < level; i++)
-		bidx += dir_buckets(i, dir_level) * bucket_blocks(i);
+		bidx += mul_u32_u32(dir_buckets(i, dir_level),
+				    bucket_blocks(i));
 	bidx += idx * bucket_blocks(level);
 	return bidx;
 }


