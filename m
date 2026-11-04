Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828948;
	b=ApFZocXIoCFpuDZeLNErx5RFUHkXMQYZi89aJy2mXgg7K4dxbHL3b0BadtsNYt0CKwmT
	 AXn2mutYPGvsynZBqk/NyToePhKWN0FacWaYBB1gXnLsj+r/BJ8nvi4RScE69TmG4sQnZ
	 hefJgqKjm2oyfE1KswIBIaBuRyRSL3v+g+wGA9X4BGZqGDwwieehu/YRFJc5rJR1dImpo
	 4J22R3hYs5sDWAxvF/+vhiOzivNPO/M8XwJP45aysY7oz3t+7RBjh51PnLljIWdgrBG46
	 EoIGFV6EFwEOOWKrDdr/5IxUbss3figNOdRLV495NQmEiJU9sjelh8BPKaHdTs8+HGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RqakyaNxABAp/TKpAYTPPSEjWIuSZm1wqePpsTRzcdg=;
	b=sH8DN6wyNddc1iE7MxhpddaW4ESfdME69ZS1NmP0OzGv6IUAshRb9nSVIT92a2a4HSwi
	 VDIUQOBCqWWb4HP0KywIhOepdfM8Os3wz0ydlBaYOxOlLwfyp/PKqbdG8Y+bCCcwrFTO7
	 Jx0DMcskV2BiiKYaCyFWxN6G42huBTiflFQQuNvEA9pGUAdEQyT2uggGf7C4yhW4TgEFB
	 h5tK1GjCjPpLoHa13Vkobk4GYdhcw/i2hre8mjFTPKC9qi16i1ME7HUZrtKwWVL0jIJWb
	 LbDmFMs46JjuhpK7XAls8t4US0oBzVuNqiKJO9MFKJFYp+7t6Aagc30cIqMKSaEZORg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bnJ68hZO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC6E607043F;
	Wed,  4 Nov 2026 21:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bnJ68hZO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A9C1F000C1;
	Wed,  4 Nov 2026 21:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828947;
	bh=RqakyaNxABAp/TKpAYTPPSEjWIuSZm1wqePpsTRzcdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnJ68hZOk+QqGfk1EdZCqcXu2HmOfSG6vFc1QwMJMFsSi+tafuMQc+IQqa9Foci+f
	 cZmLHWsNiVnJ9d784XQ+QttOVXK5VcwSnxMSRPQyHm7y2CGtpQNVGdd5BHKBpShpfM
	 tUbar3Mmd02NYPlET+0+vS5hvYFEz+/ohd5oFiH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 343/547] xfs: abort directory tree repair whenever dl->aborted is set
Date: Wed,  4 Nov 2026 16:08:47 -0500
Message-ID: <20261104211047.997387452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 4582327e7068194d55941b49dd66be211b9e3f90 upstream.

LOLLM observed that if the live update hooks for the directory tree
repair code ever fail, they'll set dl->aborted, but then the main repair
code path won't check it to exit early.  This can cause incorrect
repairs, so let's check for hook errors and abort the repair.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -575,6 +575,8 @@ xrep_dirtree_delete_path(
 
 	if (!error && dl->stale)
 		error = -ESTALE;
+	if (!error && dl->aborted)
+		error = -EIO;
 	return error;
 }
 
@@ -720,6 +722,11 @@ xrep_dirtree_adopt(
 		error = -ESTALE;
 		goto out_trans;
 	}
+	if (dl->aborted) {
+		mutex_unlock(&dl->lock);
+		error = -EIO;
+		goto out_trans;
+	}
 	error = xrep_dirtree_create_adoption_path(dl);
 	mutex_unlock(&dl->lock);
 	if (error)
@@ -780,6 +787,8 @@ xrep_dirtree_move_to_orphanage(
 
 	if (!error && dl->stale)
 		error = -ESTALE;
+	if (!error && dl->aborted)
+		error = -EIO;
 	return error;
 }
 


