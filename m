Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0B03976BA;
	Sat, 17 Oct 2026 17:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257143; cv=none; b=kkgeCwXTRKz3LesyQ49L7jdVQoN8Ocsa40itcCVj0HmdsyfsC9XI1ED9igRy8SOb3dUxq/LxcjdrNG7Q6fMHo74TodttxOxt/tnF7CMydNuaXMXF7HqKOgU4C6Rau/nObsdXRND8pL8/s46bhftOVw7pBYKZN+JlmNJRHSP5Pa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257143; c=relaxed/simple;
	bh=XLUpatY57Q3llvKtHrIVoSxSf6c6c5vhGTc4nHHbwEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c659UbuGjZBuJWrjFe8fwn2nTBQismqeD/tA74CzKUO3es0DIhmxSbVHDMBc1u3jJ+i3l8hgJh0pyH6Az3Sg6JwxIZw/oN6vuxSdaBzBasafCl8Cv0WoaqXco5bBvP6EW/yBx3TfK8vwlcHUjiKCjIRuDJFX/GvOUlHYacAATBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgFIF4rT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgFIF4rT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C75E1F000C4;
	Sat, 17 Oct 2026 17:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257142;
	bh=/70+MDy9rZbJSyoOzX8NdDp5f5+B9+TNT9MgNRi9x0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgFIF4rT3aDjBprGTTVdsQr/cf7P/9xAd6ZN4C7WjHgKb+vnOh5x0RBtUGrCflGSe
	 HQeeDl1XL5iCql/UXFb/YDOQeMP6M0CX9JbCdu6szVl0pa67mbRS8a4VVBlGziI+3o
	 A7RhdH8jgub/aS3qJb3vT/raOPrz3FTR5laVepSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0464/1674] ipv4: stop route notification sizing when nexthop group shrinks
Date: Sat, 17 Oct 2026 17:45:36 +0200
Message-ID: <20261017160443.030636482@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit d3daa33c7af92e38f2274bbd2576f58bfbaf89e6 upstream.

Commit 680aea08e78c ("net: ipv4: Emit notification when fib
hardware flags are changed") added an RCU-only fib_nlmsg_size() call
for asynchronous hardware flag notifications.

fib_nlmsg_size() checks fib_info_num_path() before each iteration,
then fib_info_nhc() independently reloads nh->nh_grp. If
RTM_NEWNEXTHOP replaces a group with fewer paths between those loads,
fib_info_nhc() returns NULL and fib_nexthop_nlmsg_size() dereferences
it.

Stop sizing when the indexed path is absent. Nexthop groups are
dense, so the current snapshot has no later path.

Fixes: 680aea08e78c ("net: ipv4: Emit notification when fib hardware flags are changed")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/1054fa46165bba1b473782fa41367804aa908e86.1790915964.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -514,6 +514,9 @@ size_t fib_nlmsg_size(struct fib_info *f
 			struct fib_nh_common *nhc = fib_info_nhc(fi, i);
 			size_t nhsize;
 
+			if (!nhc)
+				break;
+
 			nhsize = fib_nexthop_nlmsg_size(nhc, nhs != 1);
 
 			if (nhs != 1)


