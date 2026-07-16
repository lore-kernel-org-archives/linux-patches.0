Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EEF3D25D0;
	Thu, 16 Jul 2026 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211252; cv=none; b=Y3ONkPk7qdql9YhPOCtnXLEntFEQesXqo9wvu9eFuj8bVF8vT/zisP3eaMPq5KNoz2fhuJ5ncLSrp8XgX32BUewjGQ6vPMzrx51Lwgoz9/QwIAW1s9ZtsehTrAEzSRMsRTeqZb+7p2+ueUfrPoCNTpyRU0NYh42gzz5NK+Pa/UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211252; c=relaxed/simple;
	bh=aj5Lq3BG3z9tvq/VyQgbcSyWl59Fa//e/6FpjgVf818=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMGcRHqTeAs5Tnj+DJut6qpDEof8xIkG68LDSeF26jI86tOWRg8Fdk6Y6kFP/yIGabE/481Ig7XbHz6btd3yKUw3gWwF/pqGrlOPWHicQ9d80U+iVFFTXATd+LeROqEARZioBrYEiYuoLCM9wrK+K+9YB8GHXA9TkRAtt5WPPpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fX0UkBs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fX0UkBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CB41F000E9;
	Thu, 16 Jul 2026 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211251;
	bh=SUfSr6gQd33nG9x02L+BSbv0c2UQy+VAscBvnJCUI4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2fX0UkBslybw+c34SzgkdgZH456Oty+TmZdIpm8NZrcsXPQeSh2FD2O1OPoPenAJM
	 R4fderlF3vKXUcTHc90ZIJeDdBNNYDPuiukyT6IdW3WAdqi9+p7Y1BztCQma/hjtII
	 qBLipsZqOjT9ETXrYBsFqD2X+YRHhGFY3iUcD8+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 356/480] crypto: ccp - Do not initialize SNP for SEV ioctls
Date: Thu, 16 Jul 2026 15:31:43 +0200
Message-ID: <20260716133052.505495850@linuxfoundation.org>
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

commit fb1758e74b8061aacfbce7bbb7a7cc650537e167 upstream.

Sashiko notes:

> if SEV initialization fails and KVM is actively running normal VMs, could a
> userspace process trigger this code path via /dev/sev ioctls (e.g.,
> SEV_PDH_GEN) and zero out MSR_VM_HSAVE_PA globally? Would the next VMRUN
> execution for an active VM trigger a general protection fault and crash the
> host?

sev_move_to_init_state() is called for ioctls requiring only SEV firmware:
SEV_PEK_GEN, SEV_PDH_GEN, SEV_PEK_CSR, SEV_PEK_CERT_IMPORT, and
SEV_PDH_CERT_EXPORT. After the firmware command, it does SEV_SHUTDOWN on
the SEV firmware. Since these commands do not require SNP to be
initialized, skip it by calling __sev_platform_init_locked() which only
initializes the SEV firmware. This way SNP is not Initialized at all, and
HSAVE_PA is not cleared.

The previous code saved any SEV initialization firmware error to
init_args.error and then threw it away and hardcoded the return value of
INVALID_PLATFORM_STATE regardless of the real firmware error. This patch
changes it to surface the underlying error, which is hopefully both more
useful and doesn't cause any problems.

Note that it is still safe to call __sev_firmware_shutdown() directly: it
calls __sev_snp_shutdown_locked(), which skips SNP shutdown if SNP was not
initialized.

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
 drivers/crypto/ccp/sev-dev.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1689,14 +1689,11 @@ static int sev_get_platform_state(int *s
 
 static int sev_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_required)
 {
-	struct sev_platform_init_args init_args = {0};
 	int rc;
 
-	rc = _sev_platform_init_locked(&init_args);
-	if (rc) {
-		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
+	rc = __sev_platform_init_locked(&argp->error);
+	if (rc)
 		return rc;
-	}
 
 	*shutdown_required = true;
 


