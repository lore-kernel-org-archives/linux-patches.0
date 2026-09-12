Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501263314B7;
	Sat, 12 Sep 2026 15:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226747; cv=none; b=Bg99/jxfwO0mUlV8dPTLoBowZdSVXXDjRsu/7W8dPexQOQY6f0sxwfNRvPbZ6EEIb+e0g8lZd1rdYoGMiVlneiP8ItBGyEZp5AIa+2PuJ2M681KSGElwP3506BUR5FyndvoA9+iBxtUxJThEiQN893v9p0EIKzwaeRUloJ0ObP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226747; c=relaxed/simple;
	bh=QjsnnRpXcPRz89f9cpAeoClifmXrI3s8z7Zn3kvTjSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuzumMlEEOhUolakx8vPJ997Rzy0NIH+FddO3S/tKvKhm56o1OW6w85D5BZMTzdnuqZnYGD+dD3ZZJR+0wrDofaE/pdjZVydshYhTwIy/IhtYGhZLHDK1waIUMSO0ECk37xDM3i+a2na0K0Ydv59HhNe82JzM9RI7kizKBLKOyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uLp0WfB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uLp0WfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECD41F000FF;
	Sat, 12 Sep 2026 15:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226745;
	bh=LKy7yjzJp9DXZd3Or7hFRWl6EWUdc8HZb7u4TOzvpkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uLp0WfB1vLpdG26V0e27RPJzNgBJyL8Kb3gClHv6YnmD4bRhzsQPieqH+5rPrDUy
	 LHK2MZoY0YRDbkKhykH2+zggVV9RWuqNX39jcpHTR5w7un41fB1RSsNsAoQELaA3Xk
	 6FwRtkdbNNGR2RoREcdXoNIJ00mjnFEvZoNKkRMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0039/1191] NFSD: Fix off-by-one in DRC bucket pruning limit
Date: Sat, 12 Sep 2026 08:46:07 +0200
Message-ID: <20260912065549.010500229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit d0728723c80dcb3432effd67c7e919b596004b1d upstream.

nfsd_prune_bucket_locked() evicts an entry before checking
the freed count against @max. The check uses "++freed > max",
which does not break until freed exceeds max, resulting in
max + 1 evictions. Use ">=" so the limit stated in the
function comment is honored.

Fixes: a9507f6af145 ("NFSD: Replace nfsd_prune_bucket()")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/20260717001232.438792-2-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -284,7 +284,7 @@ nfsd_prune_bucket_locked(struct nfsd_net
 		nfsd_cacherep_unlink_locked(nn, b, rp);
 		list_add(&rp->c_lru, dispose);
 
-		if (max && ++freed > max)
+		if (max && ++freed >= max)
 			break;
 	}
 }


