Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A361AF0AB;
	Tue, 15 Oct 2024 13:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997735; cv=none; b=QkJ1/Dq8vsOC/rHDsd8DMuBT806m4zUhFnN+EDhnZtJoIzDZRz44HxBJbNO5ncLmQaduUreZRN1OS/AgGucpUsN1AuKm9KWjNLM4S+mqLh+1CdtCJCHzX4c/S+r8waxkaBup/PTVyqYV8QIxNbW4rgYQvikQAS2Zdw7g4mEPCgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997735; c=relaxed/simple;
	bh=ioaLN5GssGQb6e5+rb8I+jh8bLToFvpzbp8KYbeTkp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POAQJ74JvrEX4ZmGRcZrm3PbsC+G57YhXaw/RUhKkmo26DL1Xtotm+UkSjXfuBI/aDOEEQbKeb218CJOH1ONKylSCUfNzgQGjw01lJdE2KX/LRYoHQWPvozzXDFusLaE1nXeXq6XhOovTI2eLQL3DSMTcBsuAmPcknYfAYa2en0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0kynUTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0kynUTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67335C4CEC6;
	Tue, 15 Oct 2024 13:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997734;
	bh=ioaLN5GssGQb6e5+rb8I+jh8bLToFvpzbp8KYbeTkp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0kynUTzC7Rm7h0Z+SKdqhbu+NHlrPXK87dBxjt4DVTO1M2754gBTgY5cTqSWk4RU
	 iEH9JSzfoEvC5zVaKwdV4SY3QzPqAvBGtUpS7ZKKEwqMLMzWh4k8cFtadGiaVirGuP
	 ssaYV9nbREXWuov5V2tWb7qE3HMh11vNB6TLODRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 239/518] f2fs: prevent possible int overflow in dir_block_index()
Date: Tue, 15 Oct 2024 14:42:23 +0200
Message-ID: <20241015123926.217727219@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -183,7 +183,8 @@ static unsigned long dir_block_index(uns
 	unsigned long bidx = 0;
 
 	for (i = 0; i < level; i++)
-		bidx += dir_buckets(i, dir_level) * bucket_blocks(i);
+		bidx += mul_u32_u32(dir_buckets(i, dir_level),
+				    bucket_blocks(i));
 	bidx += idx * bucket_blocks(level);
 	return bidx;
 }


