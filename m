Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DB5471439;
	Tue, 21 Jul 2026 20:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664503; cv=none; b=Pjo4bXSTSwBGQlnsWwwWsSAKe55P/6ReeysPko3ZBkPiFew0Iokw9/5H5rIg9vrLeNttikSlCo62nrTkDVvdkX1tEW2sg8sQ649TWGcdP6Z0/8UKV0nxNbBGvFZS15FzZSrV2AB4gYnyksLy6Jj62925JggK73CAhMLy7DpebNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664503; c=relaxed/simple;
	bh=MISBg/NF7UWe8y+5pI3msZL6nqxo6H5/7si/V9h25Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXKs1RCZ3qgJF22W8NsukpWBVmQ8C+h5xa5Vha1ebhxB0QrFq+WPnirUT8N0VEgcMGVk3Z/0XFfMFCzAXfMl2TKshPTHJhczeAUOUpVuiC7zhg0VqQb+nLnxtz7N91iAxnRcWNavlAoGEidkrWYDmDj/kAkykcLfbbOGfCTFp44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+UDOSto; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+UDOSto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9C21F000E9;
	Tue, 21 Jul 2026 20:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664501;
	bh=iglANKmUNdhOQvyWg8rWsgsvLPfTSRBSleuFy7TL/oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+UDOStozDihFI21mhXCAmBwdQxJlsquUhScA3QtI9RSgL1ojC2q0yR1vzCvAM3AA
	 +iJcm5dqmfye64AuXmt52yOJeuug3+94ImbkIPit7j8pWM3E7v53hD30kR2ETG40CI
	 RzX4g0r2yUC1HPB/VoZcQSgYYdFxl8SG13HfeHGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1224/1276] crypto: ccp - Do not initialize SNP for ioctl(SNP_CONFIG)
Date: Tue, 21 Jul 2026 17:27:47 +0200
Message-ID: <20260721152513.469745935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

[ Upstream commit 08f0e65e784c4b20e6e620dd4f68d8636073a3d2 ]

Sashiko notes:

> if SEV initialization fails and KVM is actively running normal VMs, could a
> userspace process trigger this code path via /dev/sev ioctls (e.g.,
> SEV_PDH_GEN) and zero out MSR_VM_HSAVE_PA globally? Would the next VMRUN
> execution for an active VM trigger a general protection fault and crash the
> host?

Refuse to re-try initialization if SNP is not already initialized for
SNP_CONFIG.

This is technically an ABI break: before if SNP initialization failed it
could be transparently retriggered by this ioctl, and if no VMs were
running, everything worked fine. Hopefully this is enough of a corner case
that nobody will notice, but someone does, there are a few options:

* do something like symbol_get() for kvm and refuse to initialize if KVM is
  loaded
* check each cpu's HSAVE_PA for non-zero data before re-initializing
* once initialization has failed, continue to refuse to initialize until
  the ccp module is unloaded

Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
CC: <stable@vger.kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |   33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1434,21 +1434,6 @@ static int sev_move_to_init_state(struct
 	return 0;
 }
 
-static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_required)
-{
-	int error, rc;
-
-	rc = __sev_snp_init_locked(&error);
-	if (rc) {
-		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
-		return rc;
-	}
-
-	*shutdown_required = true;
-
-	return 0;
-}
-
 static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
 {
 	int state, rc;
@@ -2143,8 +2128,6 @@ static int sev_ioctl_do_snp_set_config(s
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_snp_config config;
-	bool shutdown_required = false;
-	int ret, error;
 
 	if (!argp->data)
 		return -EINVAL;
@@ -2152,21 +2135,13 @@ static int sev_ioctl_do_snp_set_config(s
 	if (!writable)
 		return -EPERM;
 
+	if (!sev->snp_initialized)
+		return -ENODEV;
+
 	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
 		return -EFAULT;
 
-	if (!sev->snp_initialized) {
-		ret = snp_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			return ret;
-	}
-
-	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
-
-	if (shutdown_required)
-		__sev_snp_shutdown_locked(&error, false);
-
-	return ret;
+	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
 }
 
 static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)


