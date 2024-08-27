Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D098F17C96;
	Tue, 27 Aug 2024 15:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771908; cv=none; b=AbkJelraQ3BBd5A0OzbupZRkl4ys6tQhHAsVq4RLbJv5FLFt/qVp96dgIvkgRCV2prBuTNZws5NDKkKNYBUpXpJ2Fp0uz+9oGLMtHMsgqEdaEahCf0OucI4QghBPrAiOuMXpDyu1EWRggLtlAW7UC5XpvSzP+qb5XL+SQH6JVOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771908; c=relaxed/simple;
	bh=Weg0IorvEMugAq+IBxKdXHFEy2tL88Dy0Bd0/7w/2/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahLk9aZz/UXoemL8mmj32TWcyEUxK2TTvHRTyt2RB4gaNpW/HZ1f7RnzLQQDH85NoRJaVJiCb3x7Mr0fEF8RAVGWegoI1gqYhATIOY/+W9GCU6U/5c3Af6IG95NNXHpmGCO6vx8Sob3B+Ov2B1BrVJ2Bfff96+l3enPEbK6z7Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEWz+9Ua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEWz+9Ua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6799C61067;
	Tue, 27 Aug 2024 15:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771908;
	bh=Weg0IorvEMugAq+IBxKdXHFEy2tL88Dy0Bd0/7w/2/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEWz+9Ua0VGxyEYMupxrisQ2kF/zXcZVKTZqvhWa3SCajElm/XZyoXr67MNUBRxDA
	 C5XZfWN2nhfSiMAE7LxH54wtxvjZRMQB1KLkj2Wa2ICOyXUrD9HTxWLEDElkrEnJ/E
	 k7PfFArYGr5cLNG4eEM1wny+j/h12r7aUlS/j0i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b3b14fb9f8a14c5d0267@syzkaller.appspotmail.com
Subject: [PATCH 6.1 056/321] reiserfs: fix uninit-value in comp_keys
Date: Tue, 27 Aug 2024 16:36:04 +0200
Message-ID: <20240827143840.368132431@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit dd8f87f21dc3da2eaf46e7401173f935b90b13a8 ]

The cpu_key was not initialized in reiserfs_delete_solid_item(), which triggered
this issue.

Reported-and-tested-by:  <syzbot+b3b14fb9f8a14c5d0267@syzkaller.appspotmail.com>
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://lore.kernel.org/r/tencent_9EA7E746DE92DBC66049A62EDF6ED64CA706@qq.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/stree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 84c12a1947b22..6ecf772919688 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1409,7 +1409,7 @@ void reiserfs_delete_solid_item(struct reiserfs_transaction_handle *th,
 	INITIALIZE_PATH(path);
 	int item_len = 0;
 	int tb_init = 0;
-	struct cpu_key cpu_key;
+	struct cpu_key cpu_key = {};
 	int retval;
 	int quota_cut_bytes = 0;
 
-- 
2.43.0



