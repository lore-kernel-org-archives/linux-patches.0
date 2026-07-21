Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31473B2FC0;
	Tue, 21 Jul 2026 20:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665931; cv=none; b=SA2HcXxG6S2V9I06N0/tAL7vvh8HIoTcg6WYdk57u+TQLMkLiIAQmVcay1IAjH21ELLLXYLi/JEomWm2OLiQDuxq/OUXc+w/ExyVYAMjDpn1rn3nsN2hpO2dzgYKVWROcOVU7glRGdfzeIHioDZJ1j6ppNq7G3qBwZUa6LtxCdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665931; c=relaxed/simple;
	bh=agE2kuJke0BYdQGxLXX0RLX0Uq81+6sw6IBigFY2Er0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXvLMukx3m8Sh9Yed0OQUI76UbBx0+z+k6PJCT9q5L3XeiXrvv/nuPLusN2VRnr2cxI4VNFFB/WZqyum8VSrFwnTL13UqKeHS0SkCM4OiegZjhzDQTWStOCyGp7LAhh+ZDTbYOqL0Fvxa4LJvb1FZer/ifly/QQBeqWMpH21dbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05GQS7Fc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05GQS7Fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC6F1F00A3A;
	Tue, 21 Jul 2026 20:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665929;
	bh=pBVCvWf5EAfGLpgzbHegQXj8D0RdlxsyCbwirGQ7fn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05GQS7FcMC98oZcHrOgO0K2Mmricb/zn6jNu7Dc046j2WEW3h8xo9t5uM+PbOHE2f
	 uZ+7rkxPMi78nQr/9c3W3lRaUlQIrlgOYi8SKbwzi7rFyu7JddkaW/vlfnjbxfWTpC
	 NMlOcfCHNhRv37n8lDy0HmUfvDZW93Oa24Yxcs2k=
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
Subject: [PATCH 6.6 0489/1266] ocfs2: fix buffer head management in ocfs2_read_blocks()
Date: Tue, 21 Jul 2026 17:15:26 +0200
Message-ID: <20260721152452.784810570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 45ca3cb7c0974c..71f3787bf82f07 100644
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



