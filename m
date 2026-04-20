Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6520A341077;
	Mon, 20 Apr 2026 16:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701317; cv=none; b=Si9VmpgNeI9t1eb5guk7Ht2i7hngVT3xHp2UyZF4a+iB1k8E/YigI26tkJnYRXIqN0FE+u7WLSLRgFFbyJRPM4flnG1ttIR/k3BKsjKq3kaGL7Kd/IjTaMJwqsUhlnlcfhY+a82a6fZ+lDebXjgcaD6G4kMQ3eCvDcAgABJGYBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701317; c=relaxed/simple;
	bh=3RMkqj54O6eqylpxMLf8i+nbOZqJ9P8wItv0r5YPUYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiOYe+xmCH41v0C0C2C21o7PXUeEoOmzpsukDuMcP9OdLWKSxybQ3ELKbyiACm+OTxBbcPEBHr5u9KHFAkg1EkXg1NiC/VbqjSxNKCxpfFt8T3XGwvp9+Adpptpg06Z0Xm3+AVbEuxFPUc543jrxbGAD+iOGTrhRm0KpsWWhHbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r48jJrdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r48jJrdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E2BC2BCB4;
	Mon, 20 Apr 2026 16:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701317;
	bh=3RMkqj54O6eqylpxMLf8i+nbOZqJ9P8wItv0r5YPUYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r48jJrdDFXshhmPbXxxg/2WaDqgrI0Z3sqK6zKwnEOQ8MfjwEiivi7cjHE2ZxvW7A
	 mWYmtC1eGxpd1sMUhq47e6+GT17FYKbIyZW3uAqHwpLtnqUuk+GgIhss7ZgdTbcQoc
	 AiGVL61skZLZ8LtO+QpEucSfDd7Nc2LN5wgGoN8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kotlyarov Mihail <mihailkotlyarow@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/162] xfrm: fix refcount leak in xfrm_migrate_policy_find
Date: Mon, 20 Apr 2026 17:41:38 +0200
Message-ID: <20260420153929.426971643@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kotlyarov Mihail <mihailkotlyarow@gmail.com>

[ Upstream commit 83317cce60a032c49480dcdabe146435bd689d03 ]

syzkaller reported a memory leak in xfrm_policy_alloc:

  BUG: memory leak
  unreferenced object 0xffff888114d79000 (size 1024):
    comm "syz.1.17", pid 931
    ...
    xfrm_policy_alloc+0xb3/0x4b0 net/xfrm/xfrm_policy.c:432

The root cause is a double call to xfrm_pol_hold_rcu() in
xfrm_migrate_policy_find(). The lookup function already returns
a policy with held reference, making the second call redundant.

Remove the redundant xfrm_pol_hold_rcu() call to fix the refcount
imbalance and prevent the memory leak.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 563d5ca93e88 ("xfrm: switch migrate to xfrm_policy_lookup_bytype")
Signed-off-by: Kotlyarov Mihail <mihailkotlyarow@gmail.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 5fa648a5abe96..fca07f8e60749 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4516,9 +4516,6 @@ static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *
 	pol = xfrm_policy_lookup_bytype(net, type, &fl, sel->family, dir, if_id);
 	if (IS_ERR_OR_NULL(pol))
 		goto out_unlock;
-
-	if (!xfrm_pol_hold_rcu(pol))
-		pol = NULL;
 out_unlock:
 	rcu_read_unlock();
 	return pol;
-- 
2.53.0



