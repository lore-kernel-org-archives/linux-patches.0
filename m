Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE6846D556;
	Tue, 21 Jul 2026 15:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649169; cv=none; b=mGYvTd8QTs7+ZPZ647w8VqKU7Nl2O9tC4OBLrhEw5m7kNh/5UvPIHYJKtvQFBXbFKBpGJI0CPe2gbXPbXW+2BxHDBeus4uxbE5ce1CwAEXC4fjSCuX3q28jSaXEenD8Mj06ukW8+ezUuwFyYZa2AJKzaF1gA+xgsa2HbmEf8Bz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649169; c=relaxed/simple;
	bh=uKWsd/v7DwMYssjv1vQocLrW0E1w+twpZm7b4CkY1KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjtGnH+Ug+vdm7NuTmElCOmL61ccHXsv1UZq9RLQ/nMMYGEJNWt77BIfHxIEKmzDQeudSwyh66L9KgdyU+UggvcXy/cnrt7tFMWlNIsIu25lNUineQJW414riQH9pmTiHXoerew3CUm1rkZ5curyTOggIShtV/DT11/7xtUjIW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvZDLcR2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvZDLcR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B7D1F000E9;
	Tue, 21 Jul 2026 15:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649168;
	bh=wJ7VJYYAoHwbwrJhAyxX84SPMOod5obSd+EM7ugHiUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvZDLcR2sR3O4HO1hxdQy9NjuosJitH4uozcO/S0IVuWMuUy2Kp878s8FM6Wc8bNW
	 kAY+8bKWFRG4HMC9ghPSZdyOgxZJCdhh+ccK18Za/+sJytpl5RoeQR77pHDoaqPqaA
	 xn+gm4dR+G/Ki2Cp/GxXRtqe0+Uezzlhg2+Y7EuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+caacd220635a9cc3bac9@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0476/2077] ocfs2: fix buffer head management in ocfs2_read_blocks()
Date: Tue, 21 Jul 2026 17:02:29 +0200
Message-ID: <20260721152604.029372755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 6371a07148ee979af22a9d6f4c277462953a9a4a ]

In ocfs2_read_blocks(), caller should't assume that buffer head returned
by 'sb_getblk()' is exclusively owned and so 'put_bh()' always drops
b_count from 1 to 0.  If it is not so, buffer head remains on hold and
likely to be returned by the next call to 'sb_getblk()' unchanged - that
is, with BH_Uptodate bit set even if it has failed validation previously,
thus allowing to insert that buffer head into OCFS2 metadata cache and
submit it to upper layers.  To avoid such a scenario, BH_Uptodate should
be cleared immediately after 'validate()' callback has detected some data
inconsistency.

Link: https://lore.kernel.org/20260529094128.494293-1-dmantipov@yandex.ru
Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+caacd220635a9cc3bac9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=caacd220635a9cc3bac9
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/buffer_head_io.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 701d27d908d4b2..6114299b121e52 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -350,8 +350,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 						wait_on_buffer(bh);
 					put_bh(bh);
 					bhs[i] = NULL;
-				} else if (bh && buffer_uptodate(bh)) {
-					clear_buffer_uptodate(bh);
 				}
 				continue;
 			}
@@ -380,8 +378,11 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 				BUG_ON(buffer_jbd(bh));
 				clear_buffer_needs_validate(bh);
 				status = validate(sb, bh);
-				if (status)
+				if (status) {
+					if (buffer_uptodate(bh))
+						clear_buffer_uptodate(bh);
 					goto read_failure;
+				}
 			}
 		}
 
-- 
2.53.0



