Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594B618D65C;
	Mon, 28 Oct 2024 06:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097987; cv=none; b=KQs1xtJ4xpIa/ya8yLqfpf+CXmOWrZKOl9rExKX1wB3MXvpng4NF0u+k2gbyKydekNEZ4mqk9KNhg291jSdneGsVHQouKwm94xpOlzPANLmpDFGARaIkXWIvRv+vt9Gs39D71Xj4uvj5eTz/RmRj3jMNQs1cB8CyNmug6pD+aJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097987; c=relaxed/simple;
	bh=9d0grcQthTRY0gBLkpaN6DH2CzlbTtGXUw/tvCkFiW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUpD5vtQuzUIkLWYgkwbsZ4t1U4//OB6lWLAX/jZjw+OmCBHISgWpRwVFDtRr5AJe5X3DPdmbWOSVCA1lYhxLvg6lNDUYWbedIfl2Lp2DsL0382ExD59y6K3BSNA+FBGKXjFAoJEWuosx7TevLkKs0bZq4CYdBoPqFltQgGsdW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEDggf8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEDggf8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0DFC4CECD;
	Mon, 28 Oct 2024 06:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097987;
	bh=9d0grcQthTRY0gBLkpaN6DH2CzlbTtGXUw/tvCkFiW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEDggf8I3xKN25plWz9ib7kPC4E9/BhhlRwbcdULYNWqk6krAXc4XmfEE8VUmcC+P
	 V95epWt2wjKl33SaEs5X0fK6lOJ8RcU2tol01YRBuLAVrkPMlJijJvAoCHlt0JWE38
	 3oYiIlITJMpPL9NUuB3bDs1i0ZJi8lsvaMCzVllk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrone Wu <wudevelops@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 028/261] bpf: Fix unpopulated path_size when uprobe_multi fields unset
Date: Mon, 28 Oct 2024 07:22:50 +0100
Message-ID: <20241028062312.721723478@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyrone Wu <wudevelops@gmail.com>

[ Upstream commit ad6b5b6ea9b764018249285a4fe0a2226bef4caa ]

Previously when retrieving `bpf_link_info.uprobe_multi` with `path` and
`path_size` fields unset, the `path_size` field is not populated
(remains 0). This behavior was inconsistent with how other input/output
string buffer fields work, as the field should be populated in cases
when:
- both buffer and length are set (currently works as expected)
- both buffer and length are unset (not working as expected)

This patch now fills the `path_size` field when `path` and `path_size`
are unset.

Fixes: e56fdbfb06e2 ("bpf: Add link_info support for uprobe multi link")
Signed-off-by: Tyrone Wu <wudevelops@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241011000803.681190-1-wudevelops@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index add26dc27d7e3..d9bc5ef1cafc3 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3222,7 +3222,8 @@ static int bpf_uprobe_multi_link_fill_link_info(const struct bpf_link *link,
 	struct bpf_uprobe_multi_link *umulti_link;
 	u32 ucount = info->uprobe_multi.count;
 	int err = 0, i;
-	long left;
+	char *p, *buf;
+	long left = 0;
 
 	if (!upath ^ !upath_size)
 		return -EINVAL;
@@ -3236,26 +3237,23 @@ static int bpf_uprobe_multi_link_fill_link_info(const struct bpf_link *link,
 	info->uprobe_multi.pid = umulti_link->task ?
 				 task_pid_nr_ns(umulti_link->task, task_active_pid_ns(current)) : 0;
 
-	if (upath) {
-		char *p, *buf;
-
-		upath_size = min_t(u32, upath_size, PATH_MAX);
-
-		buf = kmalloc(upath_size, GFP_KERNEL);
-		if (!buf)
-			return -ENOMEM;
-		p = d_path(&umulti_link->path, buf, upath_size);
-		if (IS_ERR(p)) {
-			kfree(buf);
-			return PTR_ERR(p);
-		}
-		upath_size = buf + upath_size - p;
-		left = copy_to_user(upath, p, upath_size);
+	upath_size = upath_size ? min_t(u32, upath_size, PATH_MAX) : PATH_MAX;
+	buf = kmalloc(upath_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	p = d_path(&umulti_link->path, buf, upath_size);
+	if (IS_ERR(p)) {
 		kfree(buf);
-		if (left)
-			return -EFAULT;
-		info->uprobe_multi.path_size = upath_size;
+		return PTR_ERR(p);
 	}
+	upath_size = buf + upath_size - p;
+
+	if (upath)
+		left = copy_to_user(upath, p, upath_size);
+	kfree(buf);
+	if (left)
+		return -EFAULT;
+	info->uprobe_multi.path_size = upath_size;
 
 	if (!uoffsets && !ucookies && !uref_ctr_offsets)
 		return 0;
-- 
2.43.0



