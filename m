Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003B946AA82;
	Tue, 21 Jul 2026 15:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648348; cv=none; b=CKJzNosqdYDYors5t0X1/319T1LL+USmjYuNzBTdwr25pyLdR3cIcLztEYthG5O6I0p7p+anwfkym8bd8hgUeXcKOUunb5obW7J3txSRY3Z4uiZk81Cz95nKdpMQdgiMWd33Bue3Z6kYLGkioipDO8YzVLUm3oz0qb+P1JI7mi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648348; c=relaxed/simple;
	bh=plD/NylS/pG3oL0OuKkbY3CoZTyGizxiEL/+CrUCNPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAGLnNS2oU6ICQRuXVunnOjK6kXKVzvjae1aizlJ8q76YWpeFpSyebRmBJYvQoeCh9fOeBXHqxKxfs1Uhe4yzmgAyma3UNKaO1M5/9f/ehA/GQ8mpGwiN/VECwG4S3g2a7E1J4Dk7JKUEh58xOJ00cvQn8pJ0IZXINTyW0CQGWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opJYg7E4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opJYg7E4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676C71F000E9;
	Tue, 21 Jul 2026 15:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648346;
	bh=HAyDtnZ0Ol3VD2XBv0LYka5oumXGeiF4agbEG/Zey+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opJYg7E41WRy00OKKdfTPqkkIcVYNwKiIfK4FXijC5sgaJYzpORbCsvB2Nrp9nz8k
	 WKC2X5F9osB0mEcVP7mGmhUefMMPPcexc8cIMvthwnioX9G+JrN/Q54/845mWAsQtA
	 7kWPKbuWsPCn9OQbsdBsehYRhq9uy4FUJ4lespCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0164/2077] crypto: ccp - Initialize data during __sev_snp_init_locked()
Date: Tue, 21 Jul 2026 16:57:17 +0200
Message-ID: <20260721152556.558053727@linuxfoundation.org>
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

[ Upstream commit fed613c1230277105bb512bce6e1fda8f316d178 ]

Sashiko notes:

> is the stack variable data left uninitialized when taking the else branch?
> Since data.tio_en is later evaluated unconditionally, could stack garbage
> cause it to evaluate to true, leading to erroneous attempts to allocate
> pages and initialize SEV-TIO on unsupported hardware?

If the firmware is too old to support SEV_INIT_EX, data is left
uninitialized but used in the debug logging about whether TIO is enabled or
not.

Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3991d4b355e606..14df519ae7eea7 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1356,7 +1356,7 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 {
 	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
 	struct psp_device *psp = psp_master;
-	struct sev_data_snp_init_ex data;
+	struct sev_data_snp_init_ex data = {};
 	struct sev_device *sev;
 	void *arg = &data;
 	int cmd, rc = 0;
@@ -1420,8 +1420,6 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		 */
 		snp_add_hv_fixed_pages(sev, snp_range_list);
 
-		memset(&data, 0, sizeof(data));
-
 		if (max_snp_asid) {
 			data.ciphertext_hiding_en = 1;
 			data.max_snp_asid = max_snp_asid;
-- 
2.53.0



