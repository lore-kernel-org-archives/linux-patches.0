Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638181F6688;
	Tue,  3 Dec 2024 14:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236890; cv=none; b=CIHra76GSEQewHBiuG3luGlBP7o9/8XTuV84k835agGxQ3ZXx0zt4YK3BpmnOWEkWXp3Jz214qZd+BCXS56K7utQMT5l3eYbHqysTWkLZNnsKwzkPNhKcsf8DY/hMGZ9r7ZQgbr15aa0SJZXVu5ZMB0j18hJfky+SpizfhXNGDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236890; c=relaxed/simple;
	bh=qBQhaaH0R6Qzk5b4WHdxWJiv1GmtkNhe0eSrABCKKAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKMshCAUmkO3H/I6aV4THDcOO4X233rvY6QQw4X9Wf2FNwFGfIWD5oGdYVaE2iIP1gCL7PGPQM/i+Rd9dbptR49uZa0BmPU7nM7fGzXh+2y6rgsLzcJQmd0DjRhJvbvKB3ASPGDDqlFzb3NFotAQXy7LTyFlIsDXYCn62+eCJKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAPe3zB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAPe3zB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C947BC4CECF;
	Tue,  3 Dec 2024 14:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236890;
	bh=qBQhaaH0R6Qzk5b4WHdxWJiv1GmtkNhe0eSrABCKKAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAPe3zB1/wWG6MzzBV4KRIlevwRfGiEvVwqZ5HRNH/pzd+nMDoN6FDfkO8zectPiv
	 a95JxHEZ/pNMUH5kMuCFonDsRu9fchE4KAHLvMLU6JGtybVyaobfe28zpL69whLekF
	 vrkWfGZ6HjV73vPfNSmrkSpA+2RLKLO1IaAX18hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/138] ubifs: Correct the total block count by deducting journal reservation
Date: Tue,  3 Dec 2024 15:32:40 +0100
Message-ID: <20241203141928.578818394@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 84a2bee9c49769310efa19601157ef50a1df1267 ]

Since commit e874dcde1cbf ("ubifs: Reserve one leb for each journal
head while doing budget"), available space is calulated by deducting
reservation for all journal heads. However, the total block count (
which is only used by statfs) is not updated yet, which will cause
the wrong displaying for used space(total - available).
Fix it by deducting reservation for all journal heads from total
block count.

Fixes: e874dcde1cbf ("ubifs: Reserve one leb for each journal head while doing budget")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index f5b663d70826c..1d548f86a41d3 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -755,10 +755,10 @@ static void init_constants_master(struct ubifs_info *c)
 	 * necessary to report something for the 'statfs()' call.
 	 *
 	 * Subtract the LEB reserved for GC, the LEB which is reserved for
-	 * deletions, minimum LEBs for the index, and assume only one journal
-	 * head is available.
+	 * deletions, minimum LEBs for the index, the LEBs which are reserved
+	 * for each journal head.
 	 */
-	tmp64 = c->main_lebs - 1 - 1 - MIN_INDEX_LEBS - c->jhead_cnt + 1;
+	tmp64 = c->main_lebs - 1 - 1 - MIN_INDEX_LEBS - c->jhead_cnt;
 	tmp64 *= (long long)c->leb_size - c->leb_overhead;
 	tmp64 = ubifs_reported_space(c, tmp64);
 	c->block_cnt = tmp64 >> UBIFS_BLOCK_SHIFT;
-- 
2.43.0



