Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352C435C1AE;
	Tue, 21 Jul 2026 18:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658613; cv=none; b=mHKc4m4iuSGfL4bwBKDKms4nlhYAcSxMoy7dLE47qWPwxfJbJv2O+ACFTceur5j8Xd4wNJgSg92TeFZ9zXl/S2sZXTM4sOMgaRZKv5AJU5Ah11Yv/yJd3GCmXY7HMiBK4lJKprsnFZaQ+YI4O9wa+Cvy76z326ESyGVob39qrz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658613; c=relaxed/simple;
	bh=xEndKfvczZj/EaPc76DAL5wF3vOb+VnjLUm/Frw8Wbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJ2W2ySx48sqbUEQINKDDAFpw4/cnN0llLrm8IuD4UWbg7Q/sShkGlBEja+gM900raL+fIqaUQ8EKdeL/MyJ0iBLDn50M5CkUFRd/KuKLD6I1Q4guPtgoAG0KvR2OrUv90qS7+YtUJrvVnAPxh7LTTLej/yR7g6UKqYCA06ZTQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJtOcLZu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJtOcLZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D871F000E9;
	Tue, 21 Jul 2026 18:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658612;
	bh=hygmMryx96OrqyDx5qviEOved6YJt/42wd+CZJqOzko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJtOcLZuu9VA/vYaZA/dQTvocwfwRX6LG5MkCGqomIFQYt/8uo5wNEqmEq0dETBT/
	 d1ZPyKLnCPvcJqUcEnwO8rWpVHblc1w+Uux0NIVkkv7LNfgqIaM9ts/zkmPOQhhP46
	 4umkabHyu27HzwNDuUYcIYKvQ3ZOWKGT0xzFSv3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.18 1166/1611] netfilter: nfnl_cthelper: apply per-class values when updating policies
Date: Tue, 21 Jul 2026 17:21:22 +0200
Message-ID: <20260721152541.650447257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit d738feccb98cb224ebabecb703e98f5008276bff upstream.

When a userspace conntrack helper with multiple expectation classes is
updated via nfnetlink, every class ends up with the first class's
max_expected and timeout values.

nfnl_cthelper_update_policy_all() validates each new policy into the
corresponding slot of the temporary new_policy array, but the second
loop that commits the values into the live helper dereferences
new_policy as a pointer instead of indexing it, so every iteration
reads new_policy[0] regardless of i.  An update that changes per-class
values is silently collapsed onto class 0's values with no error
returned to userspace.

Index the temporary array by i in the commit loop so each class gets
its own validated values.

Fixes: 2c422257550f ("netfilter: nfnl_cthelper: fix runtime expectation policy updates")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nfnetlink_cthelper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -351,8 +351,8 @@ static int nfnl_cthelper_update_policy_a
 	for (i = 0; i < helper->expect_class_max + 1; i++) {
 		policy = (struct nf_conntrack_expect_policy *)
 				&helper->expect_policy[i];
-		policy->max_expected = new_policy->max_expected;
-		policy->timeout	= new_policy->timeout;
+		policy->max_expected = new_policy[i].max_expected;
+		policy->timeout	= new_policy[i].timeout;
 	}
 
 err:


