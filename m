Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841AC225A21;
	Thu, 12 Dec 2024 17:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025491; cv=none; b=H/O4pREaL/dQ1ppoxRZfGWn/QwDD3okEAjofIVfGWCdc3V8M2yOeHXBstrIDtHN8VbQVKNd/4A9qqb7CuVXaida/IxVhWTgwZq6U5+wnWYShbh5c3wvhdlRR/8w8T90yjZk1Pe91e9Q8cLvMQZ0AO+Hk4zLjBblyXV3UekS5dFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025491; c=relaxed/simple;
	bh=nLsymGhNxM6p2dldtUXTo6hBLA4g0AbBC2D2EIdIl48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eC2u80newZtE8d+1LZQEcnjlzkNEJoJ2LQGWAnpbvZGOeg9/RPTrRURKuxlBL3m3E6yYJg/nBf2t/9cf17rw9LskNmjQJPRTa6wg0O6IoWyGvFOU2UYjxXzMUNZKJ6rEGit6Ve6RkGR61uMt8GE7XITo8FlPxg9awSmx/bYD9XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlZpidK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlZpidK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B199C4CECE;
	Thu, 12 Dec 2024 17:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025491;
	bh=nLsymGhNxM6p2dldtUXTo6hBLA4g0AbBC2D2EIdIl48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlZpidK+pv+DoJvdHWRzm1U4nPxXsue3GemSlHYK8N1lIE9CroIivVV9WOCONOkkV
	 OoieYKpZh8gMeE51+xUwPs2fhUVYvWIk4Z7msOXR/+edJJcXeGW/T74/VAUD5kV8R1
	 hVfKYQ9m0NkNChJXt1dROf0eOaV3YB+W0VBnstlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/321] ubifs: Correct the total block count by deducting journal reservation
Date: Thu, 12 Dec 2024 16:01:46 +0100
Message-ID: <20241212144237.410020513@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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
index 29526040ad774..0b114f685be14 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -759,10 +759,10 @@ static void init_constants_master(struct ubifs_info *c)
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



