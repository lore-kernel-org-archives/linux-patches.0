Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4621263C90;
	Tue,  8 Apr 2025 11:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111646; cv=none; b=F/BnsVaxO9edNOAgZFYrHM7I4o9lAaAa7ywDsjAiFDFTbO84pFeFXPFQhKhAxNewTs4tmXpVMz75rXdKuNl50YcrB4ZFXn+/mcwxq4uo5ZMBui0dxyAF52jMkGkVEZN8+GPNi166ZWjvpUvwQwOGmxrY/pQ2tR9WzKINzK+0+ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111646; c=relaxed/simple;
	bh=t6TlUMOE/h/KOsW+og9f4zINdN/kjzRehY+qycgw7M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvC49qaDx+4762/GDHu9QhUAFmPl54j2ioPAWcSDGguM8gjsdqIkXOk0+ZBXVGXWyOdK98CUdpzeborrGNNUximcFOZJviQQnMP4TbIhx+h+XjHmag0J80dmrt/5mUSfcRaixVCycl6mk4f4uKVjAztdRhjXiqQjRN3GMEvt7RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idxQNRmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idxQNRmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F940C4CEE5;
	Tue,  8 Apr 2025 11:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111646;
	bh=t6TlUMOE/h/KOsW+og9f4zINdN/kjzRehY+qycgw7M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idxQNRmVUcReoh717pi1y8cbrYD/KeN5C2AEycIsH3UZ+Cp4HVyugEjcCB9Sd86dw
	 6EEIxZ34Jq+DzRNUdJeBcWkUCbx31GpIlE2HmmNjsaaPENip2gefgceMPulH4A4+II
	 DqxzdOnvdVHizuj2jx2HfAfzh9SZglLxIMTupY6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Kurt Hackel <kurt.hackel@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 505/731] ocfs2: validate l_tree_depth to avoid out-of-bounds access
Date: Tue,  8 Apr 2025 12:46:42 +0200
Message-ID: <20250408104926.020887030@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit a406aff8c05115119127c962cbbbbd202e1973ef ]

The l_tree_depth field is 16-bit (__le16), but the actual maximum depth is
limited to OCFS2_MAX_PATH_DEPTH.

Add a check to prevent out-of-bounds access if l_tree_depth has an invalid
value, which may occur when reading from a corrupted mounted disk [1].

Link: https://lkml.kernel.org/r/20250214084908.736528-1-kovalev@altlinux.org
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Reported-by: syzbot+66c146268dc88f4341fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=66c146268dc88f4341fd [1]
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/alloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4414743b638e8..b8ac85b548c7e 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1803,6 +1803,14 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 
 	el = root_el;
 	while (el->l_tree_depth) {
+		if (unlikely(le16_to_cpu(el->l_tree_depth) >= OCFS2_MAX_PATH_DEPTH)) {
+			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
+				    "Owner %llu has invalid tree depth %u in extent list\n",
+				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
+				    le16_to_cpu(el->l_tree_depth));
+			ret = -EROFS;
+			goto out;
+		}
 		if (le16_to_cpu(el->l_next_free_rec) == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
 				    "Owner %llu has empty extent list at depth %u\n",
-- 
2.39.5



