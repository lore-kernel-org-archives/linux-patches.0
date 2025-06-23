Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871CA1E487;
	Mon, 23 Jun 2025 13:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686117; cv=none; b=vBIFwnozbVdG3VwbxRP5Ybrw89wd4dTXr800T9Uk4bLh9hqzFbWLdYTFgMbcogWYStEiiA7Vf3IjGt8+knrN1KVp4U8i+DLiL6jalefZNvKp8F6ZCJxhYPBSjVjc0OfB7wNO98K7eW2kEwK2dLY+122E5E5aTLe/sOfZ5s0/qZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686117; c=relaxed/simple;
	bh=/HztbWDonsroAdqlsszZvmlJnYxAtEAaxtHsf3bvSUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eu+LDGnSylcC8IMrGZPkHvvioW1FYbjWjQWF2qRWKNDQkaX6kAJCsWztA5L3bfj9Drp1vtbLqQad7hv3iQ+K7lnF6ygsMLl4NCoU1gkO3pL0d3zato0KyUC430oTAjfSctAgXfmXR8CiroKKWEthkopIZMK2GxDkhEtDL3bKjes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxr7IPR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxr7IPR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3C0C4CEEA;
	Mon, 23 Jun 2025 13:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686117;
	bh=/HztbWDonsroAdqlsszZvmlJnYxAtEAaxtHsf3bvSUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxr7IPR9EJu9ZLLGEcoEpXTKGPyUv95/j+061OY0TRLqZam/6wZvjMNOc1bY4C6Yp
	 mhFslGaL480kbE8K4SOKWGNzhJ0U+uZvTJYNi2lPCxBDYLA93JsFI+sz3RO5AdVlBa
	 rm3Wz8s6cc0zjVk5CHDSbA0yAmua+IdtbSVmXbKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Jan Kara <jack@suse.cz>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/411] ocfs2: fix possible memory leak in ocfs2_finish_quota_recovery
Date: Mon, 23 Jun 2025 15:03:44 +0200
Message-ID: <20250623130635.406144402@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit cdc3ed3035d0fe934aa1d9b78ce256752fd3bb7d ]

If ocfs2_finish_quota_recovery() exits due to an error before passing all
rc_list elements to ocfs2_recover_local_quota_file() then it can lead to a
memory leak as rc_list may still contain elements that have to be freed.

Release all memory allocated by ocfs2_add_recovery_chunk() using
ocfs2_free_quota_recovery() instead of kfree().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Link: https://lkml.kernel.org/r/20250402065628.706359-2-m.masimov@mt-integration.ru
Fixes: 2205363dce74 ("ocfs2: Implement quota recovery")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/quota_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 1baa68c01c671..e199c54aeb0bc 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -671,7 +671,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 			break;
 	}
 out:
-	kfree(rec);
+	ocfs2_free_quota_recovery(rec);
 	return status;
 }
 
-- 
2.39.5



