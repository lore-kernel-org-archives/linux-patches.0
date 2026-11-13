Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591206;
	b=yLBP8XhI+WZobCrVityVvXpDRrjB5e6AbjcOHL51duWqG9XxEYMv2gElOcXfyp510pJJ
	 E4f8a5PAZuBZ9VFN+n9G/EHtGQXh3sQ2RT1UhsGjW/h4oCglVEHscBqvk6eBwclOalPTm
	 jlWr7ZbdsDCPbFcDJQleByg3bTssGSTP4+uNnPZUttiktw9LuxUQzEHhjGGAkAEhzHlni
	 8g1W9jCszTFo2hUDbtmxfX2BD+DOodXLlzvyMsHWlFpfEVnf0IC8rck88xrZuQyEIFU3P
	 6kDH6u4PlPsEWE3R0SPO7b0WsNrE9yeo2lSZJ0TH0Nz/5z3wFH216SaXn09Js/R++UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d1lHjlDhVLZFZZuWMnQJUzdGRgidGkSD5knN9fZ0HgM=;
	b=mg0DDT2eXkb43OukUaaRupwm83V2idhb4Q3eEZ2HUGSLnCDkl9cdgdvOdmfIzrMBqPAc
	 Dm90v7JlZRCoglYNhFrvuISSbEr8AELs90Q8/cuQv56vDYDoMs8v0eu8DHqdy8wJv88lv
	 pNNaRJFPQ7l8Vn4fD7pSTRYMPMI5OdW5tHCV0g/y9uFo0KIIDkZI2ZUKF31StO/3ENtzB
	 nyB0CBVXxWh04tpqGsCJ134c/AzKOFiyGeUUaXCMEk8CRK/m6mntK3GrXssqZqA5Yfh0s
	 xocuGdCfTwpkc4nJu+/JfOzKjH3ZLYGYFSrNSFdYQ07kZPqU4F8H1NluFf1gcikqWWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eodFAO4q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C896075854;
	Fri, 13 Nov 2026 17:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eodFAO4q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D781F000C4;
	Fri, 13 Nov 2026 17:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591205;
	bh=d1lHjlDhVLZFZZuWMnQJUzdGRgidGkSD5knN9fZ0HgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eodFAO4qVEPPA4kGcFNzmzFliY6R+T2MALlJVue1bogMo78MKtSQstko9rQVt4t/h
	 /i4Nm9Vsu1v7KOfBJF9ThB4/36ZdEXocdRYStU1YWT7VSw4txuRx9Qb12bg6TBrr7+
	 63tDUmYe1EF+ZgzqJjzzzNp61rc1C87JAQniaPzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 298/670] xfs: fix temporary cursor leak in btree shift corruption paths
Date: Fri, 13 Nov 2026 10:47:42 -0500
Message-ID: <20261113153822.026520650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyun Gao <jianyungao89@gmail.com>

[ Upstream commit 2bbca049deeb1699cafd966cb2793fee576ee409 ]

In xfs_btree_lshift and xfs_btree_rshift, when XFS_IS_CORRUPT detects
an invalid firstrec/lastrec result after xfs_btree_dup_cursor has
successfully allocated a temporary cursor, the error path jumps to
error0 which returns without freeing tcur.  This leaks the cursor
memory, the xfs_group reference, and the per-level buffer references
held by the duplicated cursor.  Jump to error1 instead, which calls
xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR) to properly release all
resources.

Cc: stable@vger.kernel.org
Fixes: 9eaead51bed95 ("[XFS] implement generic xfs_btree_rshift")
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f0ddaa136a0bf..de09db78df1ad 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2568,7 +2568,7 @@ xfs_btree_lshift(
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2738,7 +2738,7 @@ xfs_btree_rshift(
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
-- 
2.53.0



