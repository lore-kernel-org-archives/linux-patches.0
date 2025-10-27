Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011403191CC;
	Mon, 27 Oct 2025 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590520; cv=none; b=BXL0xV104Brntl2Zrn4Uxkd8kH7UQyIfU5qFO68uMUapd4VX98lwuHU9KY3xD57TnfFMTeuSrGEq+NXtgTOENWfIUAUh2CMGRZ9+Qr2nh7Cfi04E+LwqT8WCsRVy0F5NmaMSZH75aNrWz5j7+ozNxZNtzNompVvpMBM/Rfjs4HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590520; c=relaxed/simple;
	bh=0TmhwAv7a2asSnPx5ua5D4bRCl0FVFE2lEIVsSbfSD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXhUEXMmhf1QFvPLAlEBDd+ernBoiBiZOYjQuG8B9HITamkFZIrsSDGCArT1ISfNxbHg6SyeapFxoP66HyolKucoEd8xMsFiw38Hse1Z1bTuR0wTcPEZjkjXA2I9hA4vN95/K20QBgWD3LylOGpejY/oUV5PLQC204Bfk1nNUw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9aAe+ho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9aAe+ho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E61FC4CEF1;
	Mon, 27 Oct 2025 18:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590519;
	bh=0TmhwAv7a2asSnPx5ua5D4bRCl0FVFE2lEIVsSbfSD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9aAe+hoABtuuBOb1OOqmuCHyE/8S1mQzTkqJQnPhX6zwxkZJZ/9KBXeFCIHrTzT0
	 Ty5JqUaJ8GohL9dB8psRtKkDhB9V5EHFHYohti/18/qNV3XGbI+y6vsOVX9ry/41OO
	 Q930haWhvhE0Uhwqh8Z7Q/Zyj8LGYq9d/agu6Yz8=
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
Subject: [PATCH 5.4 068/224] ocfs2: fix double free in user_cluster_connect()
Date: Mon, 27 Oct 2025 19:33:34 +0100
Message-ID: <20251027183510.825481423@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



