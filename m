Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676A08481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96F4C4339C;
	Fri, 10 Mar 2023 14:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457149;
	bh=ORrQwT7B8uh8P1WHVWre5/RWCEtz1yoJf8NTPsGdDi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrtimSS278hjYNenp+RP9ZRqo2dHTM7My8voVe4QCbtEK8ntgVOFhu8qdPQnzfxMw
	 obmy7efsKaHbzGob+uFrztMlgFSdCrvcdEhuy9eamxzNNU4as6EPkTRk9i7+7Tnvj/
	 NPGqh27f2EgZj74TWP/pThGN47mh964Ryys/MeMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/200] ubifs: Fix wrong dirty space budget for dirty inode
Date: Fri, 10 Mar 2023 14:37:16 +0100
Message-Id: <20230310133717.936277245@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit b248eaf049d9cdc5eb76b59399e4d3de233f02ac ]

Each dirty inode should reserve 'c->bi.inode_budget' bytes in space
budget calculation. Currently, space budget for dirty inode reports
more space than what UBIFS actually needs to write.

Fixes: 1e51764a3c2ac0 ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/budget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index e8b9b756f0aca..986e6e4081c76 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -400,7 +400,7 @@ static int calc_dd_growth(const struct ubifs_info *c,
 	dd_growth = req->dirtied_page ? c->bi.page_budget : 0;
 
 	if (req->dirtied_ino)
-		dd_growth += c->bi.inode_budget << (req->dirtied_ino - 1);
+		dd_growth += c->bi.inode_budget * req->dirtied_ino;
 	if (req->mod_dent)
 		dd_growth += c->bi.dent_budget;
 	dd_growth += req->dirtied_ino_d;
-- 
2.39.2



