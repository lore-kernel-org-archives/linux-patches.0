Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF2F1D0492;
	Tue, 15 Oct 2024 11:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993192; cv=none; b=cyYtLf9enmrJFAun8+TcF15Neh7BiGqDioMPcaiFJ1ff8S+HTAbWdSLJHVMor/7nYt5+0yp0oKMN31vFYsq+UGZxcY7NA1dPFxAfGeIyET74tE1dSyNRRDaMMO6aFtA6oAvx70Sd/RqzUoYCzdfXRGv8HeLDycSABjfSC97m40U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993192; c=relaxed/simple;
	bh=afHXgfzBW9ucb8Jg/xRBqPKSMo+ZCve0suaNktaP1Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/+v0bVvnBYDFVbNMeON2QERm+NILUshzu6KvwZycufDuLCJg7pJxM+18Ix5i7yN4wml+KRgrt0nHAcUVIZ9ckrW28q0C83hYMJrJ0OtXUa2KXlPVmfPlEs87DmcJOA9N3LZ8xsUKQizQCOU0l4n9GVpNznUftJ+HxRY+bq2v5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnBk+KcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnBk+KcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F305C4CEC6;
	Tue, 15 Oct 2024 11:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993191;
	bh=afHXgfzBW9ucb8Jg/xRBqPKSMo+ZCve0suaNktaP1Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnBk+KcZnZh/W/jtW/phBSBOuTcRefEtp1ukRA44Hyt5Mj0IBtnHbW/ymuvDzOEbs
	 e3Q0iIbngNg5e9r7YHTjn/t/mKSkmejBCZqIzQn8tBA/eLS+l3o8X3wrijHzq4EXiW
	 s8EbEbuvG05D6vEyFzmLMcF3vvmZRqX3oOuBcBOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 338/691] f2fs: prevent possible int overflow in dir_block_index()
Date: Tue, 15 Oct 2024 13:24:46 +0200
Message-ID: <20241015112453.757184712@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -190,7 +190,8 @@ static unsigned long dir_block_index(uns
 	unsigned long bidx = 0;
 
 	for (i = 0; i < level; i++)
-		bidx += dir_buckets(i, dir_level) * bucket_blocks(i);
+		bidx += mul_u32_u32(dir_buckets(i, dir_level),
+				    bucket_blocks(i));
 	bidx += idx * bucket_blocks(level);
 	return bidx;
 }


