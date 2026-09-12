Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619AF3542F8;
	Sat, 12 Sep 2026 07:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198304; cv=none; b=SfKOTvHUYWXosw5y/bIAub3iO93Ec7PivEf94vi8GFmGLOyY0Hgxd52NidnnVGkKskdCQAy57IwpLlD//N5RCT1ROg4GV35MK2+G/kSNE/kqB+vqGInW7kOTxJbKcBOJ/Nd02RfD8QNh0aOAsRKxkc8o75p8Vj7Et8zVXqrX6QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198304; c=relaxed/simple;
	bh=LWo6PBODy4HK6yIJotXeR9gqvzgNsVbjXObTI68n2gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuLh+gZnboVFlybdVO5XRUJbKCrNm+KWSho/5a8M904ciWgpquns0qggU8LL8CPeWJcRrOd7PUs8vI5ollRwJV+xMl4Kn5DdRK8daLsLcgQc4pmae6dvz0Mx5ScjRq/gV+O18nBzLf7g/7xN9wzGalQnNsgvDDW5sA0HqjV2W9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWSLPn/v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWSLPn/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D51B1F000FF;
	Sat, 12 Sep 2026 07:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198301;
	bh=V2/lnAYvyLJ4W8ujqGGIl8+RBRFrg/h4ySR2QkD+zIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWSLPn/vPB92ZGXGEkn9PfWvVBdH55msvCAKEvfooi2XBiTvB77MCCX7dgtHGMs2R
	 BGrn1rjblsgVqplg6JN3yblNlhIu3qzMyNJ2BdscUb6IgxTLHSzz6GonXSFdAigVao
	 6cYobSAKulqEL/lrZeYNWDpJ9pJIpTO3urjOX9Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Atish Patra <atishp@meta.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0351/1815] crypto: ccp - Fix possible deadlock in SEV init failure path
Date: Sat, 12 Sep 2026 08:35:01 +0200
Message-ID: <20260912065657.152265642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ca473ca198b81..46ea24be22d04 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1562,7 +1562,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 		unsigned long npages;
 
 		npages = 1UL << get_order(NV_LENGTH);
-		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, false)) {
+		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, true)) {
 			dev_err(sev->dev, "SEV: INIT_EX NV memory page state change failed.\n");
 			return -ENOMEM;
 		}
-- 
2.53.0



