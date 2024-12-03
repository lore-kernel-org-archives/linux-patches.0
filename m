Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7121014A088;
	Tue,  3 Dec 2024 16:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242704; cv=none; b=pqfCk9GX6yDqD1XKzj9K32/glbqGDY2rpXdePDCzW5C+0Lb1y2vdcl+Wv1KpMKnikwZ318t00I1x8A9gIPzZ21oA4fWjCy174IC5JBR19UsEllC8lZ2Fk0ei/tWAidZcXVs4ROjO6QnL1FuVOZ1gnyxX5ykLrhbh1ypi3GyGnKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242704; c=relaxed/simple;
	bh=jMiu3zXDc6wGM+Z4T2T3W/NWFMLpIKKxy8CmaEdkjCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbMmfl2CyS9a0kN6ZXbw9wfFjBGKby+RyfCufyPyls5Q9T1XSxUPoLztZdZQHnhh/bKSiB3XePUuZOrdioE6q2c3SYrhED1oGV3HMIQxUaMU83mxO/L80YGaK+5nIgjS86PQ1FxqWFj3kC6CyPdL54UqQVv1dVEB09VJZGpqTpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2iWlfxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2iWlfxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB419C4CECF;
	Tue,  3 Dec 2024 16:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242704;
	bh=jMiu3zXDc6wGM+Z4T2T3W/NWFMLpIKKxy8CmaEdkjCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2iWlfxBme1nOxiTJkPzrgFMt1U+jmbRl/VU4HD/cKV/hFFsomUctdjbKy4qwvWej
	 kQsb7xy4YW9LlP+n6Mpt0HbWKaNw4ujoXeq1YG8Pd+9d1lV7E1XvE5IsHEvK8A8ixG
	 3ruLXbjJnGJy8+uWIhnaMREszGZeaOHbOwEULzJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 783/826] ubifs: Correct the total block count by deducting journal reservation
Date: Tue,  3 Dec 2024 15:48:30 +0100
Message-ID: <20241203144814.306337457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 291583005dd12..245a10cc1eeb4 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -773,10 +773,10 @@ static void init_constants_master(struct ubifs_info *c)
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



