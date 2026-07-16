Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CB63195EF;
	Thu, 16 Jul 2026 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211258; cv=none; b=pDAKE6ven78Ger+7S0wsZcM/itrbgcFBocIwh2r39trAfBuoO+kkEOdo4y5D6k8LIiKmAdPB66v1jVroIy2z18sPjHMBNR0Lea+qePyZxTkSIO3ii1SJXim3OqjwuTwcvXggwmpnXpx4FjdJ8asDdPozPEDKKSlKe5IemKdBrXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211258; c=relaxed/simple;
	bh=amP/a9HbK5xgc+lKvaSZpMCr+P/vH1tgVwdpeIzrzD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er20yzYFXx9/ZohAgmN1d+Mo33o+/ahuQaGTHbta/qmsrEeHc9lvfIvMP9Qx/TNnPo6DytJe4mbuvcFli+YSZfiqP6kuElFX7FpvzTFfBU99A0BmwUSdf2z1LnGGiO497B0bcNUM+L/M6J9zlmi0ZKsTuSRB6ctNzSbTrQ1ClYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nndqi/yr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nndqi/yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EFD1F000E9;
	Thu, 16 Jul 2026 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211256;
	bh=Ho7oywLmlcDkwfxhzgrC1HmYS/5CtsTlVbKe1DymCOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nndqi/yrJmw9Uc2KONYxZ3rYiAEjBwg20YKh85ySVKSwGGuj+M12qdGCxoxv+LMN5
	 /kYucbFUS9YDE8Q2eyew57ASdkvuMnLoB05Fol5U7uJJag4sv901LiCIyIB0pP+/Ci
	 kzUW5fWjxmwiDBXzWKSO7UkmE35b92/jNmWnhxQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 358/480] crypto: ccp - Do not initialize SNP for ioctl(SNP_VLEK_LOAD)
Date: Thu, 16 Jul 2026 15:31:45 +0200
Message-ID: <20260716133052.548169480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

commit f91e9dbb5845d1e5abf1028e6df57dcf61583e1b upstream.

Sashiko notes:

> if SEV initialization fails and KVM is actively running normal VMs, could a
> userspace process trigger this code path via /dev/sev ioctls (e.g.,
> SEV_PDH_GEN) and zero out MSR_VM_HSAVE_PA globally? Would the next VMRUN
> execution for an active VM trigger a general protection fault and crash the
> host?

The SEV firmware docs for SNP_VLEK_LOAD note:

> On SNP_SHUTDOWN, the VLEK is deleted.

That is, the initialization/shutdown wrapper here is pointless, because the
firmware immediately throws away the key anyway. Instead, refuse to do
anything if SNP has not been previously initialized.

This is an ABI break: before, this was a no-op and almost certainly a
mistake by userspace, and now it returns -ENODEV. ABI compatibility could be
maintained here by simply returning 0 in the check instead.

Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
CC: <stable@vger.kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2455,9 +2455,8 @@ static int sev_ioctl_do_snp_vlek_load(st
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_snp_vlek_load input;
-	bool shutdown_required = false;
-	int ret, error;
 	void *blob;
+	int ret;
 
 	if (!argp->data)
 		return -EINVAL;
@@ -2465,6 +2464,9 @@ static int sev_ioctl_do_snp_vlek_load(st
 	if (!writable)
 		return -EPERM;
 
+	if (!sev->snp_initialized)
+		return -ENODEV;
+
 	if (copy_from_user(&input, u64_to_user_ptr(argp->data), sizeof(input)))
 		return -EFAULT;
 
@@ -2478,18 +2480,7 @@ static int sev_ioctl_do_snp_vlek_load(st
 
 	input.vlek_wrapped_address = __psp_pa(blob);
 
-	if (!sev->snp_initialized) {
-		ret = snp_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			goto cleanup;
-	}
-
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
-
-	if (shutdown_required)
-		__sev_snp_shutdown_locked(&error, false);
-
-cleanup:
 	kfree(blob);
 
 	return ret;


