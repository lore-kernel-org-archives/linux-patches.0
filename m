Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FC2415F25;
	Tue, 21 Jul 2026 18:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658839; cv=none; b=vFsvyzSOifk5lLO7WCgiusu7ZseDtKORsBpZpoC90t1cTkf6PX+uuwdlyQ9rKNR7SrP3mePPQiOePzn96YNb3S3LKW3KCK8KC5a9dgj1+98+RVcZNsq7g4bJKMCvCEkzHO9KRHtl3wrVf5ksgKJSxgI+ft8FyOj2ToF0X2MU6t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658839; c=relaxed/simple;
	bh=7LlkXolELfXTAwJTiLGbA0Fu7Pc8yMHEXWl6zoyjOvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKNV6KZld4o3dhHKQ/kef98C52Pe6sAgjyQq/guWTruauXbH3AdGl4vabcvIAZUlJUx74sNb/YeQTVNSfxLh87ov6yKPAxvcOvgR9bS+Wzzytic2MOYabj1y8RdZPTPXkHD/b3PxDt8jLffkYvD5PoMDvboPGQOCrmlwrG1RtZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbBBQJAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbBBQJAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF79B1F00A3A;
	Tue, 21 Jul 2026 18:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658838;
	bh=7pagL3TFTqRjKE3qCFZbCJHS53IKgdDA+4LEoqUSq8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbBBQJAD6BZ5zJI8kZ35HoN4Nwcl7TndOEJdlRkS305tNStR+JlPUCK2Hf2LfYNZe
	 RPJkLYOcABeqkSRSpRZCaFHzgCh5BO5CLbo3ZlznYz0CHntj1SakejAVwAHAWhh4dL
	 pIEG5mKZWEPyufSJws13oM6xbXWjZ0G+M2RgE8as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 1293/1611] sunrpc: fix uninitialized xprt_create_args structure
Date: Tue, 21 Jul 2026 17:23:29 +0200
Message-ID: <20260721152544.528333914@linuxfoundation.org>
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
@@ -326,7 +326,7 @@ static ssize_t rpc_sysfs_xprt_switch_add
 {
 	struct rpc_xprt_switch *xprt_switch =
 		rpc_sysfs_xprt_switch_kobj_get_xprt(kobj);
-	struct xprt_create xprt_create_args;
+	struct xprt_create xprt_create_args = {};
 	struct rpc_xprt *xprt, *new;
 
 	if (!xprt_switch)


