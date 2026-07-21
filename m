Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E2946AA86;
	Tue, 21 Jul 2026 15:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648340; cv=none; b=O2YHnOVanO044XByA27oHmIQSxikdfVV049t66s+k3VtnBshXk2nQOhAWYLCt4nyx4nm81J+ybohcRmnSH3eTbfsy2EMx7YVCC9KeLbRyPSDJMytib4AWDUECeOswzSqf7iK3KDzXdciTxEnmElcZP/j7edDXHdfdbI/AUdYm9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648340; c=relaxed/simple;
	bh=XOIvftIPuzC/QS2PZaOBZmUEKdAuDjeE+abmBQsapkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfPVMoO96mvq1zmnKRfLditQx+5C8kc1ZePmEm85UatUkG36S+I5bn2y0ML8DHjGBYxU9zL01CpfrrGeU+d3iVqPKbwQKi4fHdhdcA54Na64VTYhNznVo0v8EQegfSL3fV3GURtoqOMFBYDWM1dWXZu+BBA8R5nA7vzRopFFeXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnabKXBV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnabKXBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804EA1F000E9;
	Tue, 21 Jul 2026 15:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648339;
	bh=hL2v5B0H5v41WEvxErM28yUwmCelEORJlgdW0M4uoB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hnabKXBV2VRgeeiIoOK2sN4dHK4rGPBKEJFfFcEc+0UzaQhS+QM6CPFBzBw+QqyU2
	 NZ5y4m2pLlK2FgLXDhzuRZwzn7Ub8X2XFFpNLfxb3KkM7rtPAnld1vvSC2BGriz11u
	 Y5lBPHzg/mNTv+ZuhX0/bA56F3TOrYBT1YA7N/aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0161/2077] crypto: ccp - Reverse the cleanup order in psp_dev_destroy()
Date: Tue, 21 Jul 2026 16:57:14 +0200
Message-ID: <20260721152556.483935952@linuxfoundation.org>
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

From: Tycho Andersen (AMD) <tycho@kernel.org>

[ Upstream commit 4a76a164ba1617f60d1c8a2fd754466c9d9e48e9 ]

Before SNP x86 shutdown [1], all HV_FIXED pages were always leaked on
module unload. Now pages can be reclaimed if they are freed before SNP
shutdown.

The SFS driver does sfs_dev_destroy() -> snp_free_hv_fixed_pages(), marking
the command buffer as free. But this happens after sev_dev_destroy() in
psp_dev_destroy(), so the pages are always leaked.

Rearrange psp_dev_destroy() to destroy things in the reverse order from
psp_init(), so that any dependencies can be unwound accordingly. This lets
SFS free the page and the subsequent SNP shutdown release it.

This was identified with use of Chris Mason's review-prompts:
https://github.com/masoncl/review-prompts

[1]: https://lore.kernel.org/all/20260324161301.1353976-1-tycho@kernel.org/

Fixes: 648dbccc03a0 ("crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver")
Reported-by: review-prompts
Assisted-by: Claude:claude-4.6-opus
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/psp-dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 5c7f7e02a7d8ab..b14ce51065d5da 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -316,15 +316,15 @@ void psp_dev_destroy(struct sp_device *sp)
 	if (!psp)
 		return;
 
-	sev_dev_destroy(psp);
+	dbc_dev_destroy(psp);
 
-	tee_dev_destroy(psp);
+	platform_access_dev_destroy(psp);
 
 	sfs_dev_destroy(psp);
 
-	dbc_dev_destroy(psp);
+	tee_dev_destroy(psp);
 
-	platform_access_dev_destroy(psp);
+	sev_dev_destroy(psp);
 
 	sp_free_psp_irq(sp, psp);
 
-- 
2.53.0



