Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4561CBEAA;
	Mon, 13 Oct 2025 15:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368488; cv=none; b=tvw8y+vL2PY8gYeYqPzgheslzllaRc6Nt3RIT6FARckwP2yrM+MXKLL4WQgdjIyWyuL8t+3Uxa1GCRefsk4oHU1xDx1ny8mFaud/IS+vEZG/EVFyX9EpfCqGr2kiy2VONGIQKeqnicwEOupgUHTzZe9zKGxJO3JYj0Im0i3VbA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368488; c=relaxed/simple;
	bh=tqjAv2vbGVo0fqv5G9G/+jDMazBkTbJKcb8IbjCBvVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KsmFnLZNaEOxPzz260nZEbwkqBMc1b1JnZYw3xQOSx/ekjbhTWzpizIMsAa4WkIg9vl4Dk0GyI6WE+Q0H8UIpc/t9uTHlfqGJ3ZQxVF7R1xI7nHu7qB3Dc9dpLL1KDlMc7Tw8SEmjmhsOsaWTgtIXPNCGej8ip4epGcJM2uxOcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBjeRkE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBjeRkE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF3DC4CEE7;
	Mon, 13 Oct 2025 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368487;
	bh=tqjAv2vbGVo0fqv5G9G/+jDMazBkTbJKcb8IbjCBvVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBjeRkE9HfzH5aGYsw6j9xQSsOFTIFr5fGUUp5nLob8F4tZdS1ouzXIPQEc/G1NNf
	 h56UzoQLCdTV6E5dJVSoJkzXjoXR06Si1vzNRXU6TxUwsT6IoSRNr3ba4GDdzqAaGe
	 oztyUWXqparRAU/9EpiFMEkOCxQJtSnwkgGpw/wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/262] RDMA/cm: Rate limit destroy CM ID timeout error message
Date: Mon, 13 Oct 2025 16:44:48 +0200
Message-ID: <20251013144331.380361386@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 2bbe1255fcf19c5eb300efb6cb5ad98d66fdae2e ]

When the destroy CM ID timeout kicks in, you typically get a storm of
them which creates a log flooding. Hence, change pr_err() to
pr_err_ratelimited() in cm_destroy_id_wait_timeout().

Fixes: 96d9cbe2f2ff ("RDMA/cm: add timeout to cm_destroy_id wait")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Link: https://patch.msgid.link/20250912100525.531102-1-haakon.bugge@oracle.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index d45e3909dafe1..50bb3c43f40bf 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1032,8 +1032,8 @@ static noinline void cm_destroy_id_wait_timeout(struct ib_cm_id *cm_id,
 	struct cm_id_private *cm_id_priv;
 
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
-	pr_err("%s: cm_id=%p timed out. state %d -> %d, refcnt=%d\n", __func__,
-	       cm_id, old_state, cm_id->state, refcount_read(&cm_id_priv->refcount));
+	pr_err_ratelimited("%s: cm_id=%p timed out. state %d -> %d, refcnt=%d\n", __func__,
+			   cm_id, old_state, cm_id->state, refcount_read(&cm_id_priv->refcount));
 }
 
 static void cm_destroy_id(struct ib_cm_id *cm_id, int err)
-- 
2.51.0



