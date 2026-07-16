Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B683FD121;
	Thu, 16 Jul 2026 13:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209930; cv=none; b=i3mfU1TDmGo8BbinrvscfQoIGCk5sEOZgxNMAw2l+qylXKOx9kQ8dZfzBYA2bWDorau3yeVnx8zZL/syWHpw3pw7CqrSaEsWl/DV4GtVGRwvYfLAwqUyesW8410e8CKl0PGvKGgcTJBSUYsBwdV/Il6qmPtUHe4wIh1zy+wc13M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209930; c=relaxed/simple;
	bh=FIMYjNEGHIdbXIKLcGLDA962I6XfrVTqt7I+8+hxP/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNHZQuf43nukNGW1kvz3aOEgAxhhcREmwqVf+fHE5P7OcSsh8sZLO0jEsJEUrXGwPT+3ej5tJCFMuGQfS7Wdp5AwlpfxOtICRgD7SXy4SamijKYXKI+zbKHvFuj8Ffhj+/q83pJclLk/iCojhjv6UycBbyz3MZY+FVXsM1Oehq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysRogL4g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysRogL4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C2A1F000E9;
	Thu, 16 Jul 2026 13:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209928;
	bh=jxEyQQhNO/uEfQlhbCYPTQBR1HZA4y6W2cm1RaOFR/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysRogL4gkjfZIvRDLi7dEBTRUtuG4Ef/CQUzXoT54qYW7B5uMstJ/aBAuMZiYuxFd
	 Dl336gyEAyF1sl21BrSKSFViGsrgxeN7tSsH4P2WkXKn/IS9oU1XrL583VrStNvfg0
	 L/63k2MUJ04h72CS5n/d+KkgJ46LYKceJUdyQVYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 372/518] crypto: ccp - Do not initialize SNP for ioctl(SNP_COMMIT)
Date: Thu, 16 Jul 2026 15:30:40 +0200
Message-ID: <20260716133055.968014991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

commit 5a1364da2f04217a36e2fdfa2db4ee025b383a20 upstream.

Sashiko notes:

> if SEV initialization fails and KVM is actively running normal VMs, could a
> userspace process trigger this code path via /dev/sev ioctls (e.g.,
> SEV_PDH_GEN) and zero out MSR_VM_HSAVE_PA globally? Would the next VMRUN
> execution for an active VM trigger a general protection fault and crash the
> host?

The SNP_COMMIT command does not require the firmware to be in any
particular state. Skip initializing it if it was previously uninitialized.

The SEV-SNP firmware specification doc 56860 does not mention SNP_COMMIT in
Table 5 as a command that is allowed in the UNINIT state, but it is in fact
allowed and a future documentation update will reflect that.

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
 drivers/crypto/ccp/sev-dev.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2437,24 +2437,13 @@ cleanup:
 
 static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
 {
-	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_commit buf;
-	bool shutdown_required = false;
-	int ret, error;
-
-	if (!sev->snp_initialized) {
-		ret = snp_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			return ret;
-	}
+	int ret;
 
 	buf.len = sizeof(buf);
 
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
 
-	if (shutdown_required)
-		__sev_snp_shutdown_locked(&error, false);
-
 	return ret;
 }
 


