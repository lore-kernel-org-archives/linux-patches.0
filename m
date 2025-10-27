Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FDB218EB1;
	Mon, 27 Oct 2025 18:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591137; cv=none; b=p4d4AllvRab5yRldercKwqgFupGoOsEHNFq1pPbcmRshpeocVYcZvFd/1tVWj9vVNcSbz7AnxyRn9fQ+DxCSaeq3zK4gSPR+Sbi7BDlGlM1Rxh7fFjmEYx/VTBIxeS+4hkJsx+X0/5JKJ+gd1hpN6eKRj9jzupfxk4rWhq07IjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591137; c=relaxed/simple;
	bh=/nHtjQp8qknvXiAKt+7/vlv7s9VkgwHWyodSJOzqKb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxOIg+N9iUaK19D93Ah8PRXcFEoH7cARcl6e1fSgrTCGo/a1U/R1jfFUqP88Hm8p0rm5N5pLUiI/Dvc1ldawAXYRCLZ+KHwjWrXM2CMrdzcLnla5Wn74PfwE/lAcPL8XuRIsBeXY4kM8pb2iHwHxZVlpwLw/iTDPo7G/wIDw6/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lhtha4L6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lhtha4L6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31091C4CEF1;
	Mon, 27 Oct 2025 18:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591137;
	bh=/nHtjQp8qknvXiAKt+7/vlv7s9VkgwHWyodSJOzqKb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lhtha4L6VIlueXcmklukHRuTgY29VIrAtQ1gE7026NH1iMD2uW8b09tbzo5phRuKt
	 84aj216gh/zIDbQdbAdvKGNwJ76Vax0wkoqcNQ0jEQpOw+xnZLkZ4Wm+8MCBKD75o0
	 pK+iqO7YARfyFaLOKCbMS4yrjeD0MEwu7Qgq5LPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/332] ocfs2: fix double free in user_cluster_connect()
Date: Mon, 27 Oct 2025 19:32:15 +0100
Message-ID: <20251027183526.784831177@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 8f45f089337d924db24397f55697cda0e6960516 ]

user_cluster_disconnect() frees "conn->cc_private" which is "lc" but then
the error handling frees "lc" a second time.  Set "lc" to NULL on this
path to avoid a double free.

Link: https://lkml.kernel.org/r/aNKDz_7JF7aycZ0k@stanley.mountain
Fixes: c994c2ebdbbc ("ocfs2: use the new DLM operation callbacks while requesting new lockspace")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/stack_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 7397064c3f359..c7a0625954c60 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -1032,6 +1032,7 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 			printk(KERN_ERR "ocfs2: Could not determine"
 					" locking version\n");
 			user_cluster_disconnect(conn);
+			lc = NULL;
 			goto out;
 		}
 		wait_event(lc->oc_wait, (atomic_read(&lc->oc_this_node) > 0));
-- 
2.51.0



