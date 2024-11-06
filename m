Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF451DE8B4;
	Wed,  6 Nov 2024 12:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895427; cv=none; b=X4RDDIupO8gc8rjX0DWJUVWJjakbBjfjoeChWeyz9ZAc/YF2iRSklctOFgY6RWf0Qpt4ueJoPRzAq8a38KjQhS9CXyR834INxSwwoUv0QF1TmMt8WWOR5DyvqQJLaRJ7yOxD6+2jFQmYagYDq0YHISErnDOu0qUE+J4ZR4If8NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895427; c=relaxed/simple;
	bh=Npq0ejoPEzmE8HYcOO/rj+Akm9i6hopjFbLy5SrmgSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpGrxdrrqJV1unZpBcMgOmI3EItUppRsRIC8PgHiBRUhwTzd8h28mmDBEJMB3RggsO6hFVlrG4tQFYMfJiUzugiUCjBrsWrYrDhdjCWvfwOdK96H2CXPqpUGP8sT3ZRrfEAU6VIwhWBGaMWRGi/mtnKR4gkENWl6dBjT2PQNsck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngjUfCaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngjUfCaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26871C4CECD;
	Wed,  6 Nov 2024 12:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895427;
	bh=Npq0ejoPEzmE8HYcOO/rj+Akm9i6hopjFbLy5SrmgSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngjUfCazgLoICKxaW2fjxP8WcYNAnW1iV9D+I7JWiu3ZloUAna8691u3Dalc7Q3+P
	 SJEGgN4ZvLohFrz7PBYcD7v85AGsX1esyezB8AlKWvpPH5m7P05youjAfZsItK226h
	 YaEhZrAXDqhqR4t+U9XgACtV3ZiCQOTNPhiZw4I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com,
	Remington Brasga <rbrasga@uci.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 168/350] jfs: UBSAN: shift-out-of-bounds in dbFindBits
Date: Wed,  6 Nov 2024 13:01:36 +0100
Message-ID: <20241106120325.075232910@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

From: Remington Brasga <rbrasga@uci.edu>

[ Upstream commit b0b2fc815e514221f01384f39fbfbff65d897e1c ]

Fix issue with UBSAN throwing shift-out-of-bounds warning.

Reported-by: syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com
Signed-off-by: Remington Brasga <rbrasga@uci.edu>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 1128bcdf5024a..9f731847ae634 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3097,7 +3097,7 @@ static int dbFindBits(u32 word, int l2nb)
 
 	/* scan the word for nb free bits at nb alignments.
 	 */
-	for (bitno = 0; mask != 0; bitno += nb, mask >>= nb) {
+	for (bitno = 0; mask != 0; bitno += nb, mask = (mask >> nb)) {
 		if ((mask & word) == mask)
 			break;
 	}
-- 
2.43.0



