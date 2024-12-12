Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABF92210E8;
	Thu, 12 Dec 2024 17:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022888; cv=none; b=QiogEEZaeRJ/4gXqVGde6bQzfW+bfT66IMO/5zdMJECBsdOI7uinlocz4mgjVFvLeEpjK5BEnfIj9hf5/j+yZHU+VZKjIyw9MRX3aGWsH56+0Cos4Cm59W/vVwAhUu7lT14DxVlwvtGhOOCxbRpmWxwJuzMsls0EZF8OsA0JTPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022888; c=relaxed/simple;
	bh=0SeeaHOPApUtUr6FpRBaOdDIYuEWAGWvHqaSXWiaBT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCSH0Rjzo0jXGIJkjhGIwu5FsrUqZQSuTDnwg1EAF4whD7IH95aQAKl/hdE701hYtHyHJhNCZBibRm5N9Bgm2XFB6ecIfhZ4YPajJYBlpCIO8m3lHlbxENcQEsxD9oCz2TM2VVA0ma6yetLgXTT9bD8MsLWUxHIOeZJuDa76mc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wccxEw14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wccxEw14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8375DC4CECE;
	Thu, 12 Dec 2024 17:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022886;
	bh=0SeeaHOPApUtUr6FpRBaOdDIYuEWAGWvHqaSXWiaBT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wccxEw1487SqLksiargVnLUuL03oeLeY9AwXGJXfMK+2bz2pvgmxoQ7Jc0RkESMyH
	 TC3bjjdEYFj/FRHCe1IuuBD+1UQuoDDW04omTwhDa4lfpaLc/VGkG5NzwbZxo6ZlD+
	 k2N3a7u66n7gZlhlbWSGMbcxCDqCy9tS+kgKHhZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 361/565] ubifs: Correct the total block count by deducting journal reservation
Date: Thu, 12 Dec 2024 15:59:16 +0100
Message-ID: <20241212144325.882341514@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 32c1f428054b7..e0420688bf918 100644
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



