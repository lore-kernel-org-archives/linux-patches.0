Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442BD469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BA0C433C7;
	Mon, 28 Aug 2023 10:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218889;
	bh=MYvkx70+CRhlVzLYEgrJNHosxu/LDFnJRMIogMttFq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCQObj9O4OeAl3fBFczEQdyeJNtWTeYrgGp4AcxVnnUUNpqRK5cDbX7tw8XuW+x+R
	 4bSXNIJ8QB1dls/FjC2GCDxJpcKtSZU0KMCjMvtcQwgkA4+0Q+lHxJPWRQdOClKAvT
	 KXoqpZzQFx5hhXrgf0EeLbFofK40DdY6NrFnwXFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/122] maple_tree: disable mas_wr_append() when other readers are possible
Date: Mon, 28 Aug 2023 12:13:56 +0200
Message-ID: <20230828101200.461264443@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

From: Liam R. Howlett <Liam.Howlett@oracle.com>

[ Upstream commit cfeb6ae8bcb96ccf674724f223661bbcef7b0d0b ]

The current implementation of append may cause duplicate data and/or
incorrect ranges to be returned to a reader during an update.  Although
this has not been reported or seen, disable the append write operation
while the tree is in rcu mode out of an abundance of caution.

During the analysis of the mas_next_slot() the following was
artificially created by separating the writer and reader code:

Writer:                                 reader:
mas_wr_append
    set end pivot
    updates end metata
    Detects write to last slot
    last slot write is to start of slot
    store current contents in slot
    overwrite old end pivot
                                        mas_next_slot():
                                                read end metadata
                                                read old end pivot
                                                return with incorrect range
    store new value

Alternatively:

Writer:                                 reader:
mas_wr_append
    set end pivot
    updates end metata
    Detects write to last slot
    last lost write to end of slot
    store value
                                        mas_next_slot():
                                                read end metadata
                                                read old end pivot
                                                read new end pivot
                                                return with incorrect range
    set old end pivot

There may be other accesses that are not safe since we are now updating
both metadata and pointers, so disabling append if there could be rcu
readers is the safest action.

Link: https://lkml.kernel.org/r/20230819004356.1454718-2-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/maple_tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 47d0c95b9a01e..250b4c67fac8f 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4333,6 +4333,9 @@ static inline bool mas_wr_append(struct ma_wr_state *wr_mas)
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char node_pivots = mt_pivots[wr_mas->type];
 
+	if (mt_in_rcu(mas->tree))
+		return false;
+
 	if ((mas->index != wr_mas->r_min) && (mas->last == wr_mas->r_max)) {
 		if (new_end < node_pivots)
 			wr_mas->pivots[new_end] = wr_mas->pivots[end];
-- 
2.40.1



