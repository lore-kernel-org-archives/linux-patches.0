Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC44403AFB;
	Tue, 21 Jul 2026 17:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655732; cv=none; b=g30qlLhcjgJCYe3tPwpsL/+m8SlLuouZ0RM5WpYhyaxiO0ZHpOI+umO0TWisBWW59yhvMmEbvcP4I+P4NGgcRcz5q35dAzeItcikIsvI5V3jgGcgq3aeY9lm/ZTRwfxcFg+XoJDy2/MKpR5b8fhRzzPTTHS6EZ6AbHwYWjFrmtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655732; c=relaxed/simple;
	bh=LLrMDbN9RC7JoburPdct9oDZ2GkMw6GghRUqCij5rbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3Qj7PQAHNzMAnxdKTEmDS6pqIhgNOd5Q05vNxugL/c39OF4rG3C+Y5qDTxXX+gVe5OVAPtx17qPG25FoXoS9Z8V0fB04bwdYruPbnRwir/tBBxuwsUy5C5R1vnoARFSzk7JQ/R96sjwgQqXwaIHOvm8Zsc4YYWJpsBv7kw/lw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUb2ONaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUb2ONaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D0B1F000E9;
	Tue, 21 Jul 2026 17:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655731;
	bh=Hfho2tGHoXISqZdAbzPwN0HWamfIDi7J7NkZqgd9uIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUb2ONafW/TOhGH59bQPs7tNIhyJJxEWqHhcQIrRaVMc0J9SkHue7zbk5QFeP8U1G
	 bIk6baWmEC5DdaGGK0wGODt3+W1twaIf9dB05uAFbi9hRNfRzKjyp++KfEhRLS7gd7
	 0mlxVe6Dn5eKH7AJ37d3kO1OnNSttU31Gc3uXhCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0120/1611] crypto: ccp - Reverse the cleanup order in psp_dev_destroy()
Date: Tue, 21 Jul 2026 17:03:56 +0200
Message-ID: <20260721152517.558279210@linuxfoundation.org>
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



