Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066902BF3E2;
	Tue, 10 Mar 2026 11:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141207; cv=none; b=a8dwyuNR3vTTIH1hRkivdDhOmVdRFdQJWI8EkzQWrQvpVFnrSIQ7ux2/MUSXvzS2ZjDBfSwLllHTUp7c2JkqPktAFqNABxTx2u3z3iB+J0B6zkz9FsmVas9jpRtZEcu4+p5sMN5rdtDruE+wP8ZowmVumUto3dHZxgB18GkJhR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141207; c=relaxed/simple;
	bh=GV6ZUhs+bT82GMQ5cPlMm9yXf+0y9AI6JYxLmgXdr7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOxblpDajMiVRl65DOgtSvGUdLlgu2fS8akYIAm9Ui2mVe+f1eaRfv3sLfwhvlGaob/J8H3zby9drFRIi2YtAp3LUx21QlLPDkZPyNMjzpBgmKFFB0D9IQMgMB4opCddT6VzJeBZZoiDjU0TyrNLev7X1IJE81BmExB1VJJ21PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+6sZniA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+6sZniA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D037C2BCB0;
	Tue, 10 Mar 2026 11:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141206;
	bh=GV6ZUhs+bT82GMQ5cPlMm9yXf+0y9AI6JYxLmgXdr7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+6sZniA9yWPIa45nAapHyNzVnU5xnrECPm57inD1WRFZxNNa/20d67bgrpcQZc4f
	 w1K1jABDfLQO9xiV5rN8E2HT2S6tp5WtfvqRL3N9SBspw147L0lCOgRryy9P6L077e
	 UI+rLZQd0fA/fO3M6U0OsDbqOnrq+LDAlmpLUioM9LgdN4bIqK4XakyxtF1x/t3T3f
	 OrPF3a3IId69HZX7BijQZnYhuJR6ER19j1G2Of3isr4dgwbXRmncmYJsnWiLdQAbEX
	 3X55erdHaXRKUHj69EbLjGFj2JvEG3bURqo79XhiJMP3uHevaq7J2Wt6dVex0owngo
	 WtqgpY+aQyK2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alper Ak <alperyasinak1@gmail.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 207/311] crypto: ccp - Fix use-after-free on error path
Date: Tue, 10 Mar 2026 07:04:14 -0400
Message-ID: <0f8187b30400ca0948c33092fe9d374a18571b37.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alper Ak <alperyasinak1@gmail.com>

[ Upstream commit 889b0e2721e793eb46cf7d17b965aa3252af3ec8 ]

In the error path of sev_tsm_init_locked(), the code dereferences 't'
after it has been freed with kfree(). The pr_err() statement attempts
to access t->tio_en and t->tio_init_done after the memory has been
released.

Move the pr_err() call before kfree(t) to access the fields while the
memory is still valid.

This issue reported by Smatch static analyser

Fixes:4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Signed-off-by: Alper Ak <alperyasinak1@gmail.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index 40d02adaf3f6d..7ad7e7a413c0f 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -378,9 +378,9 @@ void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page)
 	return;
 
 error_exit:
-	kfree(t);
 	pr_err("Failed to enable SEV-TIO: ret=%d en=%d initdone=%d SEV=%d\n",
 	       ret, t->tio_en, t->tio_init_done, boot_cpu_has(X86_FEATURE_SEV));
+	kfree(t);
 }
 
 void sev_tsm_uninit(struct sev_device *sev)
-- 
2.51.0

