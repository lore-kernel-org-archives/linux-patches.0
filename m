Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8192241A547;
	Tue, 21 Jul 2026 19:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661999; cv=none; b=BX3AQ7sR4Py9lh35ndudEWhGf2wAbf+07093BRTMofbh9BvBdzZ0l9EDkdGCm6vLx57Xf6kpkxxfOVy075kByTkV1wesMdwxjlybnvwfPX1I3LVNjNBrLa9+VbiRhTc/X+ILSN7QgBu3wS2oihBzFDR0NaeTuFGiJ7OcjbFqAEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661999; c=relaxed/simple;
	bh=G/QADAYxiVIdd1u6AjwjeUQ/K8VS0ci5hCc/L6J4VoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUgrbF0b/4eFrvjiDEkOKBbxq1SvRtwIPJ0s9v01VhLoRpVjlcio+ImUOb+N6enOHOmwtQ2BYam9CXfZe3B/KfmUkRPKsHZeAi8Q3m2E6fCHGY2LBSuwLmjcREsmnoRwf8PqrEvk4+sQ7KnLCiZAzFpzKBtvplVoQOZaRIO+/jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYYLVfUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYYLVfUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D96E1F00A3A;
	Tue, 21 Jul 2026 19:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661998;
	bh=ekd4oUrmivkAD2dDvdK0f44N5gzmRShbGjx9K5kffS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYYLVfUyp/4IN2+rn8KDnuvgPM2PA9ZtUPhvN2LkXgyxoaN5IQ8PMCluNPlJXtN74
	 KHP3p5JL6DpI9eqlvVIB7kpxiDs9zJU5zdwUG8ehbVdME4KyZti8Hw+Xw1OAVA2mi6
	 +o/acBlHb06uWdGPLCeKnM9u+5rCZv+2Jm0Dv6MM=
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
Subject: [PATCH 6.12 0236/1276] ocfs2: fix buffer head management in ocfs2_read_blocks()
Date: Tue, 21 Jul 2026 17:11:19 +0200
Message-ID: <20260721152451.371283375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8f714406528d62..e52e202857d130 100644
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



