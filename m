Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA96881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD2DC4339C;
	Fri, 10 Mar 2023 14:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459258;
	bh=tKD2ZkoWNHTSGla3F6QF/48Y4Uu5xgNKL9h5vOUFhtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6nM8KgQp30RDIOB70ttAp+It1bOCdVHOGWhW+zZ24dWphuC9QNrY01o10kcXIgS6
	 Rs92IPWbTesEbVRiDKjnAn8LDw6pN6lXw2oihZLajcvKmFGIM3yds1auwfTUQ2VCdD
	 Jwra6JARwtsHYRIgM9tJpyU2DgXJbeBVAS3+Xbok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 302/357] ubifs: Re-statistic cleaned znode count if commit failed
Date: Fri, 10 Mar 2023 14:39:51 +0100
Message-Id: <20230310133748.054462630@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

[ Upstream commit 944e096aa24071d3fe22822f6249d3ae309e39ea ]

Dirty znodes will be written on flash in committing process with
following states:

	      process A			|  znode state
------------------------------------------------------
do_commit				| DIRTY_ZNODE
  ubifs_tnc_start_commit		| DIRTY_ZNODE
   get_znodes_to_commit			| DIRTY_ZNODE | COW_ZNODE
    layout_commit			| DIRTY_ZNODE | COW_ZNODE
     fill_gap                           | 0
  write master				| 0 or OBSOLETE_ZNODE

	      process B			|  znode state
------------------------------------------------------
do_commit				| DIRTY_ZNODE[1]
  ubifs_tnc_start_commit		| DIRTY_ZNODE
   get_znodes_to_commit			| DIRTY_ZNODE | COW_ZNODE
  ubifs_tnc_end_commit			| DIRTY_ZNODE | COW_ZNODE
   write_index                          | 0
  write master				| 0 or OBSOLETE_ZNODE[2] or
					| DIRTY_ZNODE[3]

[1] znode is dirtied without concurrent committing process
[2] znode is copied up (re-dirtied by other process) before cleaned
    up in committing process
[3] znode is re-dirtied after cleaned up in committing process

Currently, the clean znode count is updated in free_obsolete_znodes(),
which is called only in normal path. If do_commit failed, clean znode
count won't be updated, which triggers a failure ubifs assertion[4] in
ubifs_tnc_close():
 ubifs_assert_failed [ubifs]: UBIFS assert failed: freed == n

[4] Commit 380347e9ca7682 ("UBIFS: Add an assertion for clean_zn_cnt").

Fix it by re-statisticing cleaned znode count in tnc_destroy_cnext().

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216704
Fixes: 1e51764a3c2a ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/tnc.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 33742ee3945b3..b162561ca9c31 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -3054,6 +3054,21 @@ static void tnc_destroy_cnext(struct ubifs_info *c)
 		cnext = cnext->cnext;
 		if (ubifs_zn_obsolete(znode))
 			kfree(znode);
+		else if (!ubifs_zn_cow(znode)) {
+			/*
+			 * Don't forget to update clean znode count after
+			 * committing failed, because ubifs will check this
+			 * count while closing tnc. Non-obsolete znode could
+			 * be re-dirtied during committing process, so dirty
+			 * flag is untrustable. The flag 'COW_ZNODE' is set
+			 * for each dirty znode before committing, and it is
+			 * cleared as long as the znode become clean, so we
+			 * can statistic clean znode count according to this
+			 * flag.
+			 */
+			atomic_long_inc(&c->clean_zn_cnt);
+			atomic_long_inc(&ubifs_clean_zn_cnt);
+		}
 	} while (cnext && cnext != c->cnext);
 }
 
-- 
2.39.2



