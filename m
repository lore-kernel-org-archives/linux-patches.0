Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C484B44C4;
	Thu, 17 Sep 2026 18:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671327; cv=none; b=nkj4Rt4pL+gt4wA1fkigwXWvqkixHudzsoaYeW28PrLLvbBows7EDEME5EInSVftZDplOggYt19uSATh5x3qr7pC8EQLe8Getndje5RkeEqPEZRqvlZUmdM0onzvCMPcx67AbzllvFThOjbJPgD7h8+1lVn+Zeqif6L4o1p4lcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671327; c=relaxed/simple;
	bh=MPeoMBXp+U4GRU0N8IKbA4PAcknh8hjYGSmwx7UGtgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2vs6SLXVMFpS+gXfHv0hHjDQvIBj/wGHmIxqI/71zOeY4NaHlSki3Yun7p7JPXmNyHHMM6jHngg0+ctutbMvjF4luFYXKzDsRo7w6aA3g6a/BxbZlYJsw2GvMkBmUN7Sa9XRfAG0JbdyMIECk3QxD+//LMLAB1Plbpi5qRBl4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrbnFK8a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrbnFK8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9031F000FF;
	Thu, 17 Sep 2026 18:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671325;
	bh=lhg1nmikg/zkDE+OjbmnMCCkzTHqr3EvRhdtjU8E25c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jrbnFK8a0g0QwgcSfrk9zyI7vnC6aG3JLzYNAGhCahG8vni+s5etjWFrLOXTSjNz4
	 FXnn3jp/+zTWuyAVbqZ0wrGNMaJJrh5B174DTlY5hc96rSsc1n8MKMeoRpi0AQ9AjK
	 muGamYUtbm5Gkl9TAi4t32M0882vCmYqr5+VKXjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Atish Patra <atishp@meta.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0922/1102] crypto: ccp - Fix possible deadlock in SEV init failure path
Date: Thu, 17 Sep 2026 16:14:25 +0100
Message-ID: <20260917151603.779644080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atish Patra <atishp@meta.com>

[ Upstream commit b0e7ec0dab242c5e480121ba12400d0513e37ca2 ]

__sev_platform_init_handle_init_ex_path() calls
rmp_mark_pages_firmware() with locked=false while the parent
function of init_ex_path already acquired the sev_cmd_mutex.
In the case of an RMPUPDATE failure for any page after the first, the cleanup
path would invoke reclaim pages which would result in a deadlock in
sev_do_cmd.

Pass locked=true to honor the lock status of the parent function.

Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")

Reported-by: Chris Mason <clm@meta.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Atish Patra <atishp@meta.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6dc380537ece9..66b3e71871979 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1261,7 +1261,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 		unsigned long npages;
 
 		npages = 1UL << get_order(NV_LENGTH);
-		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, false)) {
+		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, true)) {
 			dev_err(sev->dev, "SEV: INIT_EX NV memory page state change failed.\n");
 			rc = -ENOMEM;
 			/*
-- 
2.53.0



