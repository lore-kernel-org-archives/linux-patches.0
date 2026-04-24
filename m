Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C5023E356;
	Fri, 24 Apr 2026 13:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037752; cv=none; b=BDmfhhu4s32WLhDuzV/mmGpnTKGTnRbRA/8c70mbwG03T7zd/aMGjdJ6Rt1g6O4SOVsvo9Hr4pk3WzHA1yZm7JS506CodBLtcCOkVBF91Dt9kuC5vXQAta8HEgWxVUeCux3bsivZc4ElPmleoczL21AxwO1SLX1RAs8Z8OJ0F8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037752; c=relaxed/simple;
	bh=UzuUsf7cdqZYc4R16imisgCz3ml362Z9NVnoiVnD0O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYfh1YlvYJ9qt6mwNfKnPXiNXxmMzMKAl1Ti9wUWGi3yx/5ke2o93Gv4dPfVfkRDSQrcCbu8IX+ALG0ICq87Q+BfcPDdsLMRtk1mcPi9gWhi78R5VPcpw+BLbBjmzwPRb7Aw+UuiTWNBqY78Guiih3KQEDHC9mzCocYAvIZV4GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeSseSQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeSseSQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673D8C19425;
	Fri, 24 Apr 2026 13:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037751;
	bh=UzuUsf7cdqZYc4R16imisgCz3ml362Z9NVnoiVnD0O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeSseSQyWvZ68aM5DoPby9yoHgv0rhJvlUvnwuK+Xz5EWDX8FOTsccZMNyuj1jtKB
	 GEn4gMdhlUJg9Me9V49gsWlZ6fK4RaCrXkR2yipW/mss9ze1eBJXuWo0A6SJeiuJ3c
	 P27BjRavxy6hBFLtTzeGSf1IiL+XyKnV6IoQeJh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/166] xfrm: Wait for RCU readers during policy netns exit
Date: Fri, 24 Apr 2026 15:29:22 +0200
Message-ID: <20260424132542.886327661@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 069daad4f2ae9c5c108131995529d5f02392c446 ]

xfrm_policy_fini() frees the policy_bydst hash tables after flushing the
policy work items and deleting all policies, but it does not wait for
concurrent RCU readers to leave their read-side critical sections first.

The policy_bydst tables are published via rcu_assign_pointer() and are
looked up through rcu_dereference_check(), so netns teardown must also
wait for an RCU grace period before freeing the table memory.

Fix this by adding synchronize_rcu() before freeing the policy hash tables.

Fixes: e1e551bc5630 ("xfrm: policy: prepare policy_bydst hash for rcu lookups")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 45851f822ec4a..82854aa258ea6 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4215,6 +4215,8 @@ static void xfrm_policy_fini(struct net *net)
 #endif
 	xfrm_policy_flush(net, XFRM_POLICY_TYPE_MAIN, false);
 
+	synchronize_rcu();
+
 	WARN_ON(!list_empty(&net->xfrm.policy_all));
 
 	for (dir = 0; dir < XFRM_POLICY_MAX; dir++) {
-- 
2.53.0



