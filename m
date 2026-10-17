Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA9C3C98BE;
	Sat, 17 Oct 2026 17:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259460; cv=none; b=lytZWMgd/+tdZxldAvy7uHd7Er1dj1KxT91E7iPE3wKkXo4KnGoN5C0tusvOF4/BeA1tufLLSRrTuBxyEH36bISKz3Cm7pdNvItrT8rJgB9SaVxlr9EPXvPhaEgUvwWbNrwr4IhcIO58vWrKTO4UaZn8buTM0SrAqJINLEZkzHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259460; c=relaxed/simple;
	bh=PXU0RrSUE636hZsol2ZGyNZQCQn/waocVK+pgynn8k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1G8Q3IwC9X5xNEgY65LJ7qS7brb6k9cQYZNvLgp/6DeToWo7RZ9Gd1aOV7ESMaRtJMSeVvAPC0WDOm0vhg85NHxNjJfQBcYZgrrUgcuyX0RYCpo2+Z4rGiRy8RhnDeEaa9xvAvwIPR+GQJMdEg9+xq4ZVTwwTr8mHAXHYKt070=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zc3hxRA8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zc3hxRA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B8F1F000C6;
	Sat, 17 Oct 2026 17:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259458;
	bh=eRUFAXX4cqw2XQREl8RfFcNSu+s/ckxm9jxTyLEmkMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zc3hxRA8IhOrjHYEriVF5A2BTOaLrhYIhmiLJ8LKuovcB7eQw8Zj59Emi7/MEbSYw
	 myTjzyGcj0PfpIYIJf+vuicqh/QzDBG2AXmA5AEcDoDIctbi8FyJEbIs2GWtlljnzW
	 uBGLy9VvbLAuSGh8yyqWywldwD8vmQq3qj1lh/DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1220/1674] netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag
Date: Sat, 17 Oct 2026 17:58:12 +0200
Message-ID: <20261017160502.460089563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit e052f920773b73be49eb4d8702a9f85de7464363 ]

The DEV_PATH_BR_VLAN_UNTAG case post-decrements info->num_encaps
inside WARN_ON_ONCE(). num_encaps is u8, so if it's already 0 the
decrement still happens and wraps it to 255. The break only leaves
the inner switch -- a later path entry can set info->indev back to
a real device, and we end up returning with num_encaps == 255.

nft_dev_forward_path() then walks info.encap[] (size 2) up to
num_encaps, which means an OOB stack read and a bogus count copied
into the route descriptor.

Should only happen on a malformed bridge path stack, hence the WARN,
but worth handling sanely. Move the decrement out of the WARN.

[ While at this, remove the WARN_ON_ONCE since this can only happen
  with a buggy bridge path stack --pablo ].

Fixes: e990cef6516d ("netfilter: flowtable: add bridge vlan filtering support")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index eca4bfe05b849..b2d8e82373546 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -149,10 +149,11 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->num_encaps++;
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
-				if (WARN_ON_ONCE(info->num_encaps-- == 0)) {
+				if (info->num_encaps == 0) {
 					info->indev = NULL;
 					break;
 				}
+				info->num_encaps--;
 				break;
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
-- 
2.53.0



