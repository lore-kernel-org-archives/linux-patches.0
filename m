Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9CB3FD121;
	Thu, 16 Jul 2026 13:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209932; cv=none; b=noDQPiBWN33zUxSf2Ao+Ga0lkY+fJLwJoa0LLjwCIRhi2iiR/oLxJGHZzQTQ2wbxwp/BQQJTRFr65mV1XtGSnl2V65LqGay/4+WGSZsEbSzckU2tUTxVhclcWwuSvOvprkepA2idUFQ/oh9omRnyqhV0eEJBRC7oBLabsmtm+iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209932; c=relaxed/simple;
	bh=KUbjcTJUsN/GMps0xawh3m4WYOWrt6HLG9I7PNa6jbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiDEZpqjmmJq2UVBBT+CHKkcMtdSUlyuemPwMFc6nHVLilJ6Q/r7EQNbPU4i56hGvVeLu4KY03fq1gP/VNEGvIqb89Nqbnmxu3COYjd4mHDJvi72x3zburu4cle6XwbTzCiKnpsHzMUbUNz3fsvaOU0H4mZB9KEHVPnXJ0Okg4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYJxcu8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYJxcu8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3B31F00A3D;
	Thu, 16 Jul 2026 13:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209930;
	bh=Zv8XArBObhz0z08EhLBHSyrOuxchiM86TJ660IbhU+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYJxcu8+ScXXPupscvkqXY/nocvt791SDdBkhQuwp1e3xQKfjrhL9dHTheRqrJVgd
	 14FLuzX/nRwKMbHCNBNzqNBD7jJ3mpka5khUI6G4eQ1evD7/cOQ1tgyzgU++CeckVj
	 vgknMed7LHCv7qYM+lpys5XYLU1ez9cqTN8ppIuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 373/518] crypto: ccp - Do not initialize SNP for ioctl(SNP_VLEK_LOAD)
Date: Thu, 16 Jul 2026 15:30:41 +0200
Message-ID: <20260716133055.989813087@linuxfoundation.org>
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
@@ -2481,9 +2481,8 @@ static int sev_ioctl_do_snp_vlek_load(st
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_snp_vlek_load input;
-	bool shutdown_required = false;
-	int ret, error;
 	void *blob;
+	int ret;
 
 	if (!argp->data)
 		return -EINVAL;
@@ -2491,6 +2490,9 @@ static int sev_ioctl_do_snp_vlek_load(st
 	if (!writable)
 		return -EPERM;
 
+	if (!sev->snp_initialized)
+		return -ENODEV;
+
 	if (copy_from_user(&input, u64_to_user_ptr(argp->data), sizeof(input)))
 		return -EFAULT;
 
@@ -2504,18 +2506,7 @@ static int sev_ioctl_do_snp_vlek_load(st
 
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


