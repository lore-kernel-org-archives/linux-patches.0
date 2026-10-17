Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1634F3A6B65;
	Sat, 17 Oct 2026 17:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257445; cv=none; b=Zi1RyV8p0/v8KR4wuhuJqiYcJFpr5znaa3ALhUo/YRRujT8OKzXZULFBHZHVEjg08G1zs/N0U3j/siKT1z7Tbi29I8wukbmU//pruBYWnaHDuOZ5ajH3v996ncG3poofcGwWi4kAbnw1+cYvPsTiivzZbbX0M/5GI0axCcjCYvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257445; c=relaxed/simple;
	bh=PJW+l8uwC3mfD7Sn/+Db0LsLgHj9vcS7kwiv7xkD5CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhHZOqVzJWeYTW+Ybpnfi9QZfkqsBHDe4OUJ4vG8zdzOZbsOUmNYi+QyMcF1J5LlU0Xlk/A03PLHerrNQzXsDnGFghjXK7gCLH88ViqCp2tujh1L9ApDE4DGHHUj2bdUnfUXwzIJLFZxGEUT2WmQWMzIgR+8HzKzkdsHhap/PAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WO0mJEjA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WO0mJEjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B48C1F000C5;
	Sat, 17 Oct 2026 17:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257444;
	bh=+muDtd16iXDnz3g3UAFq5MIM6X59OvlcNIY0QvlWwQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WO0mJEjAdJExwQHIDAatojdUhWItdpOJ606U48pzlk33wRbZSdEskxhoa1MY/7aHQ
	 3CYZzC5QQ55Wl0FFHzGExxk0j0gXe2pxWjQ+N8xePp54O5ezYcEd6y1Ny/kg4/BC4H
	 RoCYO/J+HChXpBrPeV4ZJAzbXRKGJp+4hzMgtwRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ezrak1e <ezrakiez@gmail.com>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Srikanth C S <srikanth.c.s@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0560/1674] dlm: validate length in dlm_search_rsb_tree
Date: Sat, 17 Oct 2026 17:47:12 +0200
Message-ID: <20261017160445.468593302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Ezrak1e <ezrakiez@gmail.com>

[ Upstream commit 080e5563f878c64e697b89e7439d730d0daad882 ]

The len parameter in dlm_dump_rsb_name() is not validated and comes
from network messages. When it exceeds DLM_RESNAME_MAXLEN, it can
cause out-of-bounds write in dlm_search_rsb_tree().

Add length validation to prevent potential buffer overflow.

Signed-off-by: Ezrak1e <ezrakiez@gmail.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
[ Contextual conflict due to dlm_search_rsb_tree() using the RB-tree
implementation instead of rhashtable.]
Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 6712d733fc90b..dd2fa54f2b7dd 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -444,6 +444,8 @@ int dlm_search_rsb_tree(struct rb_root *tree, const void *name, int len,
 	struct dlm_rsb *r;
 	int rc;
 
+	if (len > DLM_RESNAME_MAXLEN)
+		return -EINVAL;
 	while (node) {
 		r = rb_entry(node, struct dlm_rsb, res_hashnode);
 		rc = rsb_cmp(r, name, len);
-- 
2.53.0



