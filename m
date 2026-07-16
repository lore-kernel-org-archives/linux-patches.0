Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CA042BEAB;
	Thu, 16 Jul 2026 14:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212315; cv=none; b=Azo5bT2BExl5CJomCnbOWCzjndBca+qmdaZSXF889HhbPzDggQ16K0fz54JzT9qZFkb6Zx6HIKmb0njbVxVZtkx0nYS6sw1zuhBunKaYaMjvW2I18DBnDpFOQGBfQj2uftTkYcK3bC89EiaQnrezAecrkd9ydKA4y1VCNOhcSwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212315; c=relaxed/simple;
	bh=3QmkqIsNJbwKBdBUj3SfAvYN/y9AK6S/jQQBwW5tIVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVBno7uwqLxTovFGYLpvAKj+Pq0/CacsKh81Rb3CEh9bDN/BQocLLwIV20ho+bHCXUvSftTOwJzZ+U+RLDR1uJjadmE9GxsxjDGXpKMq2KrJpep/FL9fYa74Wg22USbuebX6pT39ujsh6Y8lq9ZPA2A9PjfZzrBfthxnWusnIcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK3FXDA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK3FXDA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458191F000E9;
	Thu, 16 Jul 2026 14:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212313;
	bh=igSQa5d2jX5h+Bd1rL4amojpV49DnCgfnkkn7cn3VFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GK3FXDA4OFgvl2K0IpWwcy4/KyPXse1kGtiO5ydI0lMOI3sG8ShPghY7BejuszZuU
	 XbJVidn/TaRuiZSwv90cp1qCHM6LTQ62GQ8DJexwov0/5vkvK/8RQ7f2Ug7xl5xWmI
	 06vIHbyP+xv9yCin6hGO9Jc5ha59hXHUo7EhFtcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 278/349] crypto: ccp - Do not initialize SNP for ioctl(SNP_VLEK_LOAD)
Date: Thu, 16 Jul 2026 15:33:32 +0200
Message-ID: <20260716133039.563434949@linuxfoundation.org>
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
@@ -2136,9 +2136,8 @@ static int sev_ioctl_do_snp_vlek_load(st
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_snp_vlek_load input;
-	bool shutdown_required = false;
-	int ret, error;
 	void *blob;
+	int ret;
 
 	if (!argp->data)
 		return -EINVAL;
@@ -2146,6 +2145,9 @@ static int sev_ioctl_do_snp_vlek_load(st
 	if (!writable)
 		return -EPERM;
 
+	if (!sev->snp_initialized)
+		return -ENODEV;
+
 	if (copy_from_user(&input, u64_to_user_ptr(argp->data), sizeof(input)))
 		return -EFAULT;
 
@@ -2159,18 +2161,7 @@ static int sev_ioctl_do_snp_vlek_load(st
 
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


