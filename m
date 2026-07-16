Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F634313E30;
	Thu, 16 Jul 2026 14:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212309; cv=none; b=n2zB7l/X2i8UGWQQYOfCoOuHkOng93qluCrQ+bganJs33Qflyhsja7GYM0PYtS3pEKlGvBGvyT8M1+woY620CQ2V+68brg5z7v1DtsP21RTtDVSJecsTwJ9hFh+KNm6F9xm18/cqR2AtX7QFfo3Lndl2FNGoJc26Ucpcjb6tVwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212309; c=relaxed/simple;
	bh=A/x40X3ZnINYRCXc5JwTcmA92zcMUBuF6+C7VAAzjlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLmI/U+YoKke/d+tl9mgXQmMk2jMZqeUqWyjQ4DhghQ1Fa1axNaD7ZqRY6MVhsjOtZq2kMH5pPAKT/WgNbF1Pcwf2Q7JW+4DPuHxUrKAqrndKoNgg3EwEmu+M/uAoR5ib7wXy/XnqPs0mrrSsGr4EqBhcGiSnQhRuo3F3nLi5Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1tz6y3Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1tz6y3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DA21F000E9;
	Thu, 16 Jul 2026 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212308;
	bh=66jCEkEKZrOSdVTELb8cuzp7tA6GcVNlL8Q9iu8jU5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1tz6y3QrJf+FEQxnUkQjQFhfbyIRmupqpNNwiJjLupuEu3pqvPNNdOFdKW1L+hO0
	 FgGV8mXXx1LSK+xfP6fPlrejNZ2wIcckIn2aljU0Lx4cahWUVEWW5uUcajbL8tZQQq
	 xp6XGwfHJhlju350mzIa6+holPWFgMUoDZHXX7fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 276/349] crypto: ccp - Do not initialize SNP for SEV ioctls
Date: Thu, 16 Jul 2026 15:33:30 +0200
Message-ID: <20260716133039.517799127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -1397,14 +1397,11 @@ static int sev_get_platform_state(int *s
 
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
 


