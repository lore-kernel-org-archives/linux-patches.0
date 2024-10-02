Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D7E1D0B84;
	Wed,  2 Oct 2024 13:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877512; cv=none; b=uEA+kYOzw9OlkKZlyJm7Yw4F2eOxK0NmSxKcJjMcX85lg3a257fb4EjeAfuHwbukLcLBB8BDIR/nPZlOBZ6At7ucOI4dHfqdOw4kxVe0wFZzy2Y5kL/3iMcHrsMeAxgyGeaWkIze/fzI2Bn86VM6FtIpZjzIBDYmUOsA/nEdC18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877512; c=relaxed/simple;
	bh=kVQIzNB20BTlSFbLhtt6odeqxLgDFnomMHDqORSf/2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0zmXrukQYE2ww/y/P+Ypu8hXyLuabgDoR6qjWoBNytK7qh31BHgBBFpV2qzXiXaUbWz/CJQM8sbITon0mtTifuqdpfyGlccEU/FeAcLr9Fi1K+Svgb/1m3HdZiexOOcParq8G+ehJXuF6Q3S9uUcBgFKI50EiNcOJX973QhK6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5EVNrjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5EVNrjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7E9C4CED3;
	Wed,  2 Oct 2024 13:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877512;
	bh=kVQIzNB20BTlSFbLhtt6odeqxLgDFnomMHDqORSf/2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5EVNrjNky37pRMnbpuFYS3QDFVbcLf+lEB1wXld+psI/U/7qKDE54FxAIF8HXxXr
	 2ytbiS3i8rvFMWunLO2XKgkYVsHYMko00ZBOhq7Ow6EMXWTnDXk+TL7px84PHOrvgU
	 DltESCAJyQdyRk1aRbkt3LavoQ+54Pt2RFZ/OGYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Shah <amit.shah@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.10 072/634] crypto: ccp - do not request interrupt on cmd completion when irqs disabled
Date: Wed,  2 Oct 2024 14:52:52 +0200
Message-ID: <20241002125813.949599426@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@amd.com>

[ Upstream commit 3401f63e72596dcb7d912a5b67b4291643cc1034 ]

While sending a command to the PSP, we always requested an interrupt
from the PSP after command completion.  This worked for most cases.  For
the special case of irqs being disabled -- e.g. when running within
crashdump or kexec contexts, we should not set the SEV_CMDRESP_IOC flag,
so the PSP knows to not attempt interrupt delivery.

Fixes: 8ef979584ea8 ("crypto: ccp: Add panic notifier for SEV/SNP firmware shutdown on kdump")

Based-on-patch-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Amit Shah <amit.shah@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 1912bee22dd4a..f2ad4653a58cb 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -910,7 +910,18 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 
 	sev->int_rcvd = 0;
 
-	reg = FIELD_PREP(SEV_CMDRESP_CMD, cmd) | SEV_CMDRESP_IOC;
+	reg = FIELD_PREP(SEV_CMDRESP_CMD, cmd);
+
+	/*
+	 * If invoked during panic handling, local interrupts are disabled so
+	 * the PSP command completion interrupt can't be used.
+	 * sev_wait_cmd_ioc() already checks for interrupts disabled and
+	 * polls for PSP command completion.  Ensure we do not request an
+	 * interrupt from the PSP if irqs disabled.
+	 */
+	if (!irqs_disabled())
+		reg |= SEV_CMDRESP_IOC;
+
 	iowrite32(reg, sev->io_regs + sev->vdata->cmdresp_reg);
 
 	/* wait for command completion */
-- 
2.43.0



