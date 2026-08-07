Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6721473C84;
	Fri,  7 Aug 2026 15:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117017; cv=none; b=tJt7LQCoWg4I+sTcY1oH/1pPoMBbqtDjXjZw9/R/ShCZA4ACtiK128MnGy5kef5dRXp07D9SGTJEIY7pAWW2UiF0I3ZJFhRDvndVLOT1d3tPQ1PJTAGlfWIrVssI7/nrmAseKwGBvjv7V8jJD0G5a/MTVyJY2PugIUPq5YXLPWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117017; c=relaxed/simple;
	bh=+6duDSaiYeFn2TVc0OBKdm+5P/raSQRF3/jt0URuD5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyUkuhnwtiN5hxe6hZARuDE7TtJuhu+khLg6xDxBoMEizK5ZG47ynZ+AvEsuFtcvChKJvaIE83NF1nNdqszOukRkkfnmD+T2M2Q4JHt5tM/Mc2qWQasRvoouYMFzzURURYSH/H4LCi87w1rq2/1Ri8Yeav0rtOkhGcfGQEtbWkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJLE3Bed; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJLE3Bed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1D71F000E9;
	Fri,  7 Aug 2026 15:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117016;
	bh=csztGByZV8iBgvEV1bvZBNDPnJffV6rGqih+RTlrJCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJLE3BedivnJHQm+i/IwtzHmvw7xELfJnN931lbBJsDc7ysFfX6gOwj9u1dRifD1x
	 +wqLgA9yWdU1qRuG88rB4JgGWXPpy9Ls857hT312D1hHW5Tk4OWNT6w7ufjD19frEi
	 V8+zbGTBLa6WyGSeGdthsTZ1y6zraw3PxZEHRqWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 172/438] ipv6: release fib6_null_entry on subtree failure
Date: Fri,  7 Aug 2026 16:36:08 +0200
Message-ID: <20260807143431.700247359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[ Upstream commit 93cad1f6bd1e27c75c4a5ab000c2a2fc01181ccf ]

When adding a source-specific route creates a new subtree, fib6_add()
installs fib6_null_entry as the temporary leaf of the new subtree root
and takes a fib6_info reference for that holder.

If adding the first source leaf fails, the code frees the just allocated
subtree root but leaves that hold behind. fib6_null_entry is a per-netns
sentinel and is freed directly at netns teardown, so this does not keep
the object alive. However, it leaves its visible refcount permanently
elevated and can eventually saturate the refcount on repeated failures.

Drop the null-entry reference before freeing the unlinked subtree root.

Fixes: 5ea715289af6 ("ipv6: broadly use fib6_info_hold() helper")
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://patch.msgid.link/20260727185339.1545169-1-shuangpeng.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 414fc3c567360..b4641bfffdf3f 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1495,6 +1495,7 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 				   root, and then (in failure) stale node
 				   in main tree.
 				 */
+				fib6_info_release(info->nl_net->ipv6.fib6_null_entry);
 				node_free_immediate(info->nl_net, sfn);
 				err = PTR_ERR(sn);
 				goto failure;
-- 
2.53.0



