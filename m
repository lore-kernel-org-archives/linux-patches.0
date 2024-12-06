Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A473145A05;
	Fri,  6 Dec 2024 15:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498358; cv=none; b=LS0XQ5qp3ZrprzCLbN4mdV1maVCJXveigUUtmiK+SSsAqwAC8zrW3esKxOjhwolzZ5hWI91xutZyiHGHGR7EEM3YwBO+sXUddfL6dhZnr5BuqT/8ctrzCqohhb5hjKxHvW2cEeM0Ok/UAHwftte2HoFkT+SRfDbmVVDimIJrEQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498358; c=relaxed/simple;
	bh=iSK/3iYXVRNwzOqi7auHpGoKWxDWEiHCkBsbqErqmds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKh5HyNy7R96c6mH/dLrVcU5/8kdGGf7b7DLJxZDq8r9Xr5p3Ai6N+sKV69dAMRM1RvE9GdEvGmzOuOxBo6k5EkFZOZiz0IZm1UlgM9gmaK6Yge/aOfhXYdgQ5/2eoEhae2WNrVq6RMkHsnGQz8xfVNW1rq9Y+CzOdg6aEknlcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRwOnsqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRwOnsqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6F1C4CED1;
	Fri,  6 Dec 2024 15:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498358;
	bh=iSK/3iYXVRNwzOqi7auHpGoKWxDWEiHCkBsbqErqmds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRwOnsqqcDC1oRsT1wQsUSKP0aD1t8I/D+suMVUvTIn7BtK6ltGT8q7Jv1opvhC+w
	 Q0BuYnG9+xUGo4TxmyXaEvqHl5pQljT//ohQowR0f04+rC55ZhFmy24eL1rjHiWivI
	 XELlzgw0+XEbeQ+MVs7Ui1FVbm55bR4iY5bHfXcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 562/676] ubifs: Correct the total block count by deducting journal reservation
Date: Fri,  6 Dec 2024 15:36:21 +0100
Message-ID: <20241206143715.318380849@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b08fb28d16b55..3409488d39ba1 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -777,10 +777,10 @@ static void init_constants_master(struct ubifs_info *c)
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



