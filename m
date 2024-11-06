Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D65B1DF995;
	Wed,  6 Nov 2024 13:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899283; cv=none; b=mi/zcmv1xqcivHdkPPz3pcvNoFkrNwBN623FEoAe60PHAYjrX9GP0m65NB+OJuO3zQahZudJRMk+lMGdm4+mgXkUFP9p8ML9wqQuHf26xvu91+pg+3Gm8QZTUHVx+H+B0yAj5bRpj8fjMu1r2fmuqeBGd7etAEdFdSwpUefxRvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899283; c=relaxed/simple;
	bh=n4zvGsnWCEqHkufMzlA1u747l2qItide44PUsaupxig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okNExzqtr1t4pTGfsIhYsF4E9KG0aTLNTp0rTsiC4g/1yjNOy0AkLbHax4MYmQO9NuH3RH0oSxClHfBAY/THREnpYIwiy1qLpmiMbDiXdnSGDVUHQQyslPXxJ0U+MXogXvGT3mOfSdGBQJGrhqRp+A1VLL4h2LKwNRVkq6msX5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OM6bkD2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OM6bkD2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A95C4CECD;
	Wed,  6 Nov 2024 13:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899283;
	bh=n4zvGsnWCEqHkufMzlA1u747l2qItide44PUsaupxig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OM6bkD2BkQBBdXzHMvbnWMdx/HDZ9gZtVa8IluBvdf8HgVTPG6QznHA0k869DuuQQ
	 CJKz2aWiVwqoRc6hABLy8sMs/g9rsYQy/wOZBHj7c1L3YukEOXgai+8x1RYGYD/NiK
	 +1F3JaIwLumed1Hc6k522qVMmKvhZ/5KRUqHsPy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 23/73] netdevsim: Add trailing zero to terminate the string in nsim_nexthop_bucket_activity_write()
Date: Wed,  6 Nov 2024 13:05:27 +0100
Message-ID: <20241106120300.652779223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

From: Zichen Xie <zichenxie0106@gmail.com>

[ Upstream commit 4ce1f56a1eaced2523329bef800d004e30f2f76c ]

This was found by a static analyzer.
We should not forget the trailing zero after copy_from_user()
if we will further do some string operations, sscanf() in this
case. Adding a trailing zero will ensure that the function
performs properly.

Fixes: c6385c0b67c5 ("netdevsim: Allow reporting activity on nexthop buckets")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20241022171907.8606-1-zichenxie0106@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/fib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 14787d17f703f..b71414b3a1d40 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -1366,10 +1366,12 @@ static ssize_t nsim_nexthop_bucket_activity_write(struct file *file,
 
 	if (pos != 0)
 		return -EINVAL;
-	if (size > sizeof(buf))
+	if (size > sizeof(buf) - 1)
 		return -EINVAL;
 	if (copy_from_user(buf, user_buf, size))
 		return -EFAULT;
+	buf[size] = 0;
+
 	if (sscanf(buf, "%u %hu", &nhid, &bucket_index) != 2)
 		return -EINVAL;
 
-- 
2.43.0



