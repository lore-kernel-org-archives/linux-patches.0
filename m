Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458FF3537EF;
	Wed,  8 Apr 2026 18:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672912; cv=none; b=nDUEZVEtUUln26N6kl2fqQOCf/4g30HFp53XIL01fOAODlZjb+HvKT4kGsU7LLdh/P2azQBCXJiTs6q6hv91RaixwYsWFYT6/HaPgvvGRCGP9OLfiTfR14Qn/BiC/XRVNWciokR9pdSRZmwT07S4FtNhx2Uo3z533uMCXlGAmpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672912; c=relaxed/simple;
	bh=ZWbLcg5sFmS1DsrSjRB4lDuOx+btpVxPeCHxVpn7mw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6ceXzSFLADoGdJHKdmiyznEsa7ljNLQP289BjX13UcTmP7vgcTgNaB7AidBerOkGpOtXdCmJQQa8MFtSG4PyegmVFDe6b37stnzfBjH7nokaQq6L7lQykXswUGAU2wGD0MYNBnS4+uUqFDpBz+tgJGOVk/VpsEzBl0nRLclEEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGvBAXjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGvBAXjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D184DC19421;
	Wed,  8 Apr 2026 18:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672912;
	bh=ZWbLcg5sFmS1DsrSjRB4lDuOx+btpVxPeCHxVpn7mw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGvBAXjKDC2+cQNWF13Llf+AnqJnZ9QlUPEZr9qY/+LhSfLY+3MAbbGAVAk2hQrJM
	 NtlbLCpHH2s4pQC9c2GZaoiFeqMl2HYXiEao4IUEW42TwcJOX5c98CwdewOegTKtcS
	 OqlLxg2R/CODVJPxxccRlYNCioR3DiMWZi7nbf1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/277] crypto: af-alg - fix NULL pointer dereference in scatterwalk
Date: Wed,  8 Apr 2026 20:00:13 +0200
Message-ID: <20260408175934.903778726@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit 62397b493e14107ae82d8b80938f293d95425bcb ]

The AF_ALG interface fails to unmark the end of a Scatter/Gather List (SGL)
when chaining a new af_alg_tsgl structure. If a sendmsg() fills an SGL
exactly to MAX_SGL_ENTS, the last entry is marked as the end. A subsequent
sendmsg() allocates a new SGL and chains it, but fails to clear the end
marker on the previous SGL's last data entry.

This causes the crypto scatterwalk to hit a premature end, returning NULL
on sg_next() and leading to a kernel panic during dereference.

Fix this by explicitly unmarking the end of the previous SGL when
performing sg_chain() in af_alg_alloc_tsgl().

Fixes: 8ff590903d5f ("crypto: algif_skcipher - User-space interface for skcipher operations")
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 6c271e55f44d9..78e995dddf879 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -623,8 +623,10 @@ static int af_alg_alloc_tsgl(struct sock *sk)
 		sg_init_table(sgl->sg, MAX_SGL_ENTS + 1);
 		sgl->cur = 0;
 
-		if (sg)
+		if (sg) {
+			sg_unmark_end(sg + MAX_SGL_ENTS - 1);
 			sg_chain(sg, MAX_SGL_ENTS + 1, sgl->sg);
+		}
 
 		list_add_tail(&sgl->list, &ctx->tsgl_list);
 	}
-- 
2.53.0



