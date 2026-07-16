Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACC3424645;
	Thu, 16 Jul 2026 14:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212312; cv=none; b=lbuHY15O5ndbg3kCdqTHzWFh2sLr028wjML72EroCr3/DGO4yWIR3PdR2H6kH5PbUwnebsPIe5VkQzjK+1+3i3NGx61jp/fNUAySdsVknwPWDD0vOmDvKdWL/c4wRa5vow1VXuC5RRlPWH/2qqIN8IMggLdBpcGngT8X7Nco7B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212312; c=relaxed/simple;
	bh=5booEV9hmxgSMlfKFJ6PyfqqjvkbqyS3HYyZUd16Nt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bapo0ebLCWLN3LztbYDyGDzA5G8Yk374XgfJJUC7sAPKnIH6A6pu0mc1L9lWBNtInHx5WprNTiIta+hlUTCNx4kg2Bj2MdEYCtH++CSLynwEAMhMjd4CbCMeF5XXVKRyMRMteAbTsP3/pvYemEQCyTAFheYEnxo9es9ixoxDFJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sA3GAjus; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sA3GAjus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8211F000E9;
	Thu, 16 Jul 2026 14:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212311;
	bh=pPZtJHTuoneJTj3BV0ujAZOgofvf4bYsXn7Js4Ra0ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sA3GAjusgwJOXx5Zii2i+LhRroOM4XuV/B44ABwSplJG4WrSZ5Q3Qo9zOjmwjPsde
	 YISeso8ZjYCZhvsD4M9oPOhRQahr14/av8PE6rgzSLvnBTlDbEkrDpH1Xy3MOhRIEd
	 Nm1YoclpBIOWJBQygPTACTNxpj8nhHsqWj8x/VRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 277/349] crypto: ccp - Do not initialize SNP for ioctl(SNP_COMMIT)
Date: Thu, 16 Jul 2026 15:33:31 +0200
Message-ID: <20260716133039.540221390@linuxfoundation.org>
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
@@ -2092,24 +2092,13 @@ cleanup:
 
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
 


