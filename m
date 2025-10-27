Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBE931CA50;
	Mon, 27 Oct 2025 18:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591086; cv=none; b=DNADAHu9ZOWTlLXq+1Amoz8cri+IXZY567LHmpGl7p3irZRtEj8XhwxARtIvp+Y3Zc/nP0QdqNntdBDm84SqplpUJA7ab46OfA1mPxRYy/qm73AxPhjCsCmyWZJNFjUNxQwrGZn5ltn1nBhErWhaxMla+Erk5LdOygxAW+83ETE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591086; c=relaxed/simple;
	bh=icjcqnE0KwC1EGobTeNgWI+g/zma+qMRp9uoQKXUsXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h8ybYSyrGsIMvd8uDEnEExsU9yndeBPCp8z33VqeOAuCObNJl68Q8533K5KCkSkfCtw+7dkvBoaO8Miw6KIn1U55xQX6y66Wa+dm/dzqN1bGHxg8zFeajIryZ7vly3az8banbgQKbUp7VA436rzFfgPuF03EFT5GJn0E2fJjhMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lf/LYBkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lf/LYBkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00448C4CEF1;
	Mon, 27 Oct 2025 18:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591086;
	bh=icjcqnE0KwC1EGobTeNgWI+g/zma+qMRp9uoQKXUsXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lf/LYBkkA7NfkLENFfDEhuxylrWfKBW4yXPYsy6duxOQf0VEEkHxcHPNCC7m3xy8g
	 V/nNrh/Yl5sONE99c3LPwkuSDIG8RLxcOE6/1I740RzHs+kSIKCAzQz8kDNIq9/Cl+
	 ihHtOAfJtOcB4rAFCKqTqNbnV7zEMwPE5mOjr2Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/332] RDMA/cm: Rate limit destroy CM ID timeout error message
Date: Mon, 27 Oct 2025 19:31:54 +0100
Message-ID: <20251027183526.230845727@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 26c66685a43dd..a9c5852f52165 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1063,8 +1063,8 @@ static noinline void cm_destroy_id_wait_timeout(struct ib_cm_id *cm_id,
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



