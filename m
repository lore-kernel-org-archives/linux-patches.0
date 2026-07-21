Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05CF145B27;
	Tue, 21 Jul 2026 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654618; cv=none; b=YbosG+z5vnW1fLbShsQkwDMbS3hzCjzTaFB3Futu67Yzn/gbjdI+W1b7snHsloFqUGl9ArUWk0Xd9maz+ezdKK7rClZnR8QkNlz9AgYkQg2U+/zeG0oZ1FNSJeG4kK4+qR01HnHDiARHvRhzVjzBz7tRGBeRa2rgFoFlumQ/yp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654618; c=relaxed/simple;
	bh=ly3CE7pq4k2BE4wrrGm1NZaTiyUn8HitWXVMuad8tNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQwlemb/D8LFbBrUmmjgG2zIH778IVmq8AldxbmN2Pg48mxB3WUAHhMNcwSLKzpSkgK5mi8xCkvYXSKbmO5OSAK9qKvd5rUadIl8tsH8Upu3js+ytw/tr1Xyi1gutq3MIfSgcLzt+pGw5HD84ALlloKYfZSKSPjk6Udm8wiE/hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNILr1UL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNILr1UL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1208C1F000E9;
	Tue, 21 Jul 2026 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654617;
	bh=uPR1EAs1AifPICM08ftiYXnGOZqaZGBb+QJIhHrfDsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uNILr1ULz4XGYXk/TPpVhpArRDHxu7I3/acJysYmdx1tVnZ7VDAw8ry5CyBmSym2c
	 lFHPbxYrkMG2byCYsDjfmb2gr5uwrrye2xnIhDulx3R77XHc0GM/xO1avGzk9YjsRi
	 rnn7hpPcehyM3+CeVH0VDnQaLuqVg/jKT3ygUpxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.1 1773/2077] sunrpc: fix uninitialized xprt_create_args structure
Date: Tue, 21 Jul 2026 17:24:06 +0200
Message-ID: <20260721152634.571147497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

commit 17d90b68c3a3d7d7e95b49e1fe9381a723f637a8 upstream.

The xprt_create_args structure is allocated on the stack without
initialization in rpc_sysfs_xprt_switch_add_xprt_store(). While some
fields are manually populated, critical fields like srcaddr, bc_xps,
and flags contain uninitialized stack garbage.

This can lead to:
1. Kernel panic when xs_setup_xprt() dereferences garbage srcaddr
2. Information leak if srcaddr points to sensitive stack data
3. Unpredictable behavior if flags has random bits set

The fix is to zero-initialize the structure to ensure all unused
fields are NULL/0, preventing the transport setup code from acting
on garbage data.

Cc: stable@vger.kernel.org
Suggested-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -327,7 +327,7 @@ static ssize_t rpc_sysfs_xprt_switch_add
 {
 	struct rpc_xprt_switch *xprt_switch =
 		rpc_sysfs_xprt_switch_kobj_get_xprt(kobj);
-	struct xprt_create xprt_create_args;
+	struct xprt_create xprt_create_args = {};
 	struct rpc_xprt *xprt, *new;
 
 	if (!xprt_switch)


