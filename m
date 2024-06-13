Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B06E56458;
	Thu, 13 Jun 2024 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281057; cv=none; b=Bgp38GX7j4bAd3Q0QWnf5SLfsfKXyoPH8LohBr1OFaYml8P2TFagGKjNVbgJVNjJ1E0Cy+wzKJMVB59EWJZ+C2gcK7F2fJ1hPUry1LZy/wk+VJw6kCAesQSJpLlQ+t44VQGOICR6E/DuoUEi5ok4O4TSxzfxb4LFiZ1Y7I8/IMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281057; c=relaxed/simple;
	bh=RkcuIwpoB/H3jfxr45llTx68lv7/di2kbcEDmYsBCMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNnpWzGb1HdYOM8BuvhxweFn2hcFLbeeXmCr51tuJK9pD1YiOsU/gKaaDQlJSm49oUlFq4NmyItqEh8zgo0cXL/v8/KIhk1ik9XOaa3URJklQ0bAYM0Fd3tYhfi6fqFLxYfrxu6AKUfFBkasGKKAcUkBHGBDvpK1Xiq+6r8iXCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZTBt5g5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZTBt5g5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8702FC2BBFC;
	Thu, 13 Jun 2024 12:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281056;
	bh=RkcuIwpoB/H3jfxr45llTx68lv7/di2kbcEDmYsBCMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZTBt5g5B2cYctdYFQF4KoEhcdEEPbNuKF5r7jZiWsWMGhgbmHuCFbv8ZrlBIgjcM
	 rEFmepJMgvHxjyMZ+ojAzH92Vjcx3Jd7MylucqfozBgg2HsLdfZRjyea753xeiKwLt
	 vr+X+/x4JkyQ+x20uj577K3ovm1NqJVM9AGY6KU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/317] ext4: fix potential unnitialized variable
Date: Thu, 13 Jun 2024 13:32:23 +0200
Message-ID: <20240613113252.386610038@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3f4830abd236d0428e50451e1ecb62e14c365e9b ]

Smatch complains "err" can be uninitialized in the caller.

    fs/ext4/indirect.c:349 ext4_alloc_branch()
    error: uninitialized symbol 'err'.

Set the error to zero on the success path.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/363a4673-0fb8-4adf-b4fb-90a499077276@moroto.mountain
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 099007ec774c7..87378d08a414b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5147,6 +5147,7 @@ ext4_mb_new_blocks_simple(struct ext4_allocation_request *ar, int *errp)
 	ext4_mb_mark_bb(sb, block, 1, 1);
 	ar->len = 1;
 
+	*errp = 0;
 	return block;
 }
 
-- 
2.43.0



