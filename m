Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4673A3CF688;
	Wed, 30 Sep 2026 18:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791441; cv=none; b=I6Q0VWmI9ffqXZlxWbdAPYB8Q1d+m3IWQz5axeAJ2lZ5cV7I97LfH46FxXt/n/iETolEtyKnp6zC18p14yODiPB1WNirYl2wvX0QA4SK7mPqKMK0HYCT56UaC+xvIZY0nm3Ym3tNlnAN9yWPJ7Wln2UKIgbG+W253SmhteWMwCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791441; c=relaxed/simple;
	bh=/zF7wn0E+pbIcryagg26Nvtb4mCzK6Ow1wRJKmfkc+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvhZ36+UppBePqhtI4HJCUGpyp91TP9WCjFfofK8ZXaIBW4ZcNh3p8ftEyXRLg04flyd9Jb2EkB2Bm22QKgcbetteDUVhBiZqlX3N7wX/CrPbvSNVUXPdIO9S6b1gq7v3IeOPlyDx/+YtZQpRD/rLOPDhlTnZn3qDQNAQ/ljGQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuQu70X8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuQu70X8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EE11F000FF;
	Wed, 30 Sep 2026 18:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791440;
	bh=0HirxJKc461bhTzjLpmO1FFBotevtgteM3VchRfftfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nuQu70X85lKXk1hKUuubXynhvM609bjRr9JK7jKzgccQV5aoQWbTx0BOd/Zih3s7G
	 7qU5sv6rEw6EKAXyJ+XHICQecsnENb8qn4CfWiHRVzK8dyOb7vS4JYtsA0YNMuOziJ
	 Z+h2MQSJPvQFMmKrQ+CdwGBjljZbaKmfGg3oVjdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 302/752] nexthop: Initialize extack in remove_nh_grp_entry()
Date: Wed, 30 Sep 2026 17:22:52 +0200
Message-ID: <20260930152404.824281030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 5bd9e4e7cdaa03879e9b73b12ab52cceb1edd55b ]

remove_nh_grp_entry() prints the extack message when a listener fails
to replace the reduced nexthop group. However, extack is not
initialized and listeners are not required to set a message when
returning an error. Neither netdevsim nor mlxsw do so when an
allocation fails, resulting in the dereference of an uninitialized
stack pointer.

Fix by zero-initializing extack, as was done in commit 6347c5314cee
("nexthop: initialize extack in nh_res_bucket_migrate()").

Fixes: 833a1065eeb1 ("nexthop: Emit a notification when a nexthop group is reduced")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260903080259.10378-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 9257a63b9ffd9..6ccf247090555 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1735,7 +1735,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 {
 	struct nh_grp_entry *nhges, *new_nhges;
 	struct nexthop *nhp = nhge->nh_parent;
-	struct netlink_ext_ack extack;
+	struct netlink_ext_ack extack = {};
 	struct nexthop *nh = nhge->nh;
 	struct nh_group *nhg, *newg;
 	int i, j, err;
-- 
2.53.0



