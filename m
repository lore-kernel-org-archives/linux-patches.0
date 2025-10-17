Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2D6330B04;
	Fri, 17 Oct 2025 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716181; cv=none; b=g5LhRHRMN0QtUJYi+JxWowtRSGRYMBrzU2TEjn0zqTO9Yuyn0bjVTqSgPCRuKTgRDJjt5eL0oMN5vSuY/XyVhwFmbkmCpBB8CVPyXtI+7DR7mveRurGBHih7DiymZFumLgM4QTk9BMM7HYCVB7tiWK+xmOrh9xrGXYtkmSFzHLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716181; c=relaxed/simple;
	bh=qU++TwhRzzkq1iseotKeUUWpAZUTYpv4oopAsGGNfm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tADdVBtjJC7xiLqiJmcGJnBpgh+XFhopkRrTzjTnXYbTUxHFY+FJ+yyuOzhAQsGewo8WIdLzRSUR2bP6WBl9w9XAMFcjd5WjqkTZfk5HbvKekIKbgHOjNBaWfvRgDcVkN3wbaHUBDeVn4L4NrDE7j/GdNNNgx/B+/Yk8i2J0ZJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e40b0FuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e40b0FuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B8DC4CEE7;
	Fri, 17 Oct 2025 15:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716181;
	bh=qU++TwhRzzkq1iseotKeUUWpAZUTYpv4oopAsGGNfm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e40b0FuEJIDzyANLwFcjGP5hLDiC/qsHWljK2L22kMBGH73fwKLaxK+h84OhGXznM
	 6JM64/1+KP5IF6lZhXy+7AO7pe8ASzA5nLpNYQA8AJlSJF3x7merJpGxZXzsIvtVVP
	 jEJDOm3gDXPYO4Od2sFSwS6S6Iav32v1ySUefj38=
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
Subject: [PATCH 5.15 101/276] ocfs2: fix double free in user_cluster_connect()
Date: Fri, 17 Oct 2025 16:53:14 +0200
Message-ID: <20251017145146.169965946@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 85a47621e0c07..f9ecabe3c09e5 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -1030,6 +1030,7 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 			printk(KERN_ERR "ocfs2: Could not determine"
 					" locking version\n");
 			user_cluster_disconnect(conn);
+			lc = NULL;
 			goto out;
 		}
 		wait_event(lc->oc_wait, (atomic_read(&lc->oc_this_node) > 0));
-- 
2.51.0



