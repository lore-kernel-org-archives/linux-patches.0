Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960531F7580;
	Mon, 23 Jun 2025 22:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717087; cv=none; b=RAHE90t/9VukU8rxOtHUWfOb9ZKwmysKTCi4Ve3OK1Qnq34iihA7xqLj7ikWbUqTxbAIgQugGyJLiJ8DpEwbvP/TYFu/F8RAIFpk42RxY+ZQ8PHJs4anxSRmWnvtDSGZH4ezNF0xJab92nZKRPpRsDmQ6CD7XNrslus4JWe/6AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717087; c=relaxed/simple;
	bh=TjWd+V1l18V0c9S/2KZjPRU655hf/50vGbtfz/QI+Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMfz9RC5cTqcfGgbocA23FNYa2WZdZzyK/3GMNmLo4hihTxxseCpfNbyTMeyxnIJbci41LcRFXxxWxLORVWsqm6cyeedhCTz9Jwtw2m1tI4oYkncrTM9kHSpTiV+wpvnwWuaBC/ulU79fXyz1CAluTeJZHm6EsXZUT4ZO6BhFjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqawiilU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqawiilU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C307DC4CEEA;
	Mon, 23 Jun 2025 22:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717087;
	bh=TjWd+V1l18V0c9S/2KZjPRU655hf/50vGbtfz/QI+Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqawiilUp1/W2GpPLQzRVTsRzZHR3fDq2MY5ZMsTANw7q8AcOMlI32Kmt3pEhrtIq
	 ll6gYeZHrjydLc7MwqasaC0u1GYsKRJVY0lOyPbvPcDRkfUKZFx9Xpnik7zXWqiOm9
	 zIuiWKevcGVKRHoro8eKBhC3TjlfS8HStXTyfr1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+d8f000c609f05f52d9b5@syzkaller.appspotmail.com
Subject: [PATCH 6.15 591/592] erofs: refuse crafted out-of-file-range encoded extents
Date: Mon, 23 Jun 2025 15:09:09 +0200
Message-ID: <20250623130714.490959048@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 7869738b6908eec7755818aaf6f3aa068b2f0e1b ]

Crafted encoded extents could record out-of-range `lstart`, which should
not happen in normal cases.

It caused an iomap_iter_done() complaint [1] reported by syzbot.

[1] https://lore.kernel.org/r/684cb499.a00a0220.c6bd7.0010.GAE@google.com

Fixes: 1d191b4ca51d ("erofs: implement encoded extent metadata")
Reported-and-tested-by: syzbot+d8f000c609f05f52d9b5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d8f000c609f05f52d9b5
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250619032839.2642193-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 14ea47f954f55..6afcb054780d4 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -597,6 +597,10 @@ static int z_erofs_map_blocks_ext(struct inode *inode,
 
 			if (la > map->m_la) {
 				r = mid;
+				if (la > lend) {
+					DBG_BUGON(1);
+					return -EFSCORRUPTED;
+				}
 				lend = la;
 			} else {
 				l = mid + 1;
-- 
2.39.5



