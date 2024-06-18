Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAFE15820C;
	Tue, 18 Jun 2024 13:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716050; cv=none; b=TnanlTs6p9sgNszZnwN8hv1938xkshLm37gDfwA3MkGcBjhxYA4ihOqun0HiKIQ8SRLtjiKxySMxClyrCPu4HspBORiTIY98yhMpBuu6Kh2B/nQro9/ADcIm+gPpCnz0FJJ1zbZcmC4d8yGPnyBbFc9NdotY705Tn7pGm7LXhJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716050; c=relaxed/simple;
	bh=Y6/M5a6bixl3zdJRRm9FfLEAgOCHUJGBYkQW9EWO/io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbJda4/Do1HtDlA2VM3YOQtmGegomYCiILnG2DXtd76cxMnf13ZGwDojvgA+14A3mC3TIodr+jWbjqXWu0+DbkvXLiqUrbCeq2Y7cRANarpfzf5BUMuMFBZqBGHOXRO4j5BRaTnNxkKKR4RNsOiKH7zVuOTBn/r0DPf1OBLFosA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4Fmt6T3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4Fmt6T3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDA6C3277B;
	Tue, 18 Jun 2024 13:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716050;
	bh=Y6/M5a6bixl3zdJRRm9FfLEAgOCHUJGBYkQW9EWO/io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4Fmt6T3vxi/+X+9Nc8mqbjSK/2VVWREvwjfOijcSu8IEnKKA30XbtSssgE+7Ce3v
	 SnGYN7babfkiOQuJVHbyRjp9fJ/L61wxWr0yEp4MkPZfEO/ghcO9Qf7Kd+I1dmlQJS
	 EP1OWi81dNRFWBVrvJ6FqNUnYR4rwySiYwBBJhCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Koschel <jakobkoschel@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 484/770] nfsd: fix using the correct variable for sizeof()
Date: Tue, 18 Jun 2024 14:35:37 +0200
Message-ID: <20240618123426.000070600@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakob Koschel <jakobkoschel@gmail.com>

[ Upstream commit 4fc5f5346592cdc91689455d83885b0af65d71b8 ]

While the original code is valid, it is not the obvious choice for the
sizeof() call and in preparation to limit the scope of the list iterator
variable the sizeof should be changed to the size of the destination.

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4layouts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 2673019d30ecd..7018d209b784a 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -421,7 +421,7 @@ nfsd4_insert_layout(struct nfsd4_layoutget *lgp, struct nfs4_layout_stateid *ls)
 	new = kmem_cache_alloc(nfs4_layout_cache, GFP_KERNEL);
 	if (!new)
 		return nfserr_jukebox;
-	memcpy(&new->lo_seg, seg, sizeof(lp->lo_seg));
+	memcpy(&new->lo_seg, seg, sizeof(new->lo_seg));
 	new->lo_state = ls;
 
 	spin_lock(&fp->fi_lock);
-- 
2.43.0



