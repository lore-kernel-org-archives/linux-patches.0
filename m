Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D763EB0F3;
	Mon, 17 Aug 2026 14:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978131; cv=none; b=ZKu1dEljVx1FiwSx3pPmQusGBTKIQiTwiWTTP6hAxJB1gd2+uSZsCz4mt7naVPK0RlSWD98Ts5d52GHKJFkCMOCadNOcjOPGByvC65dnhwSlnyRNNzwXlBZcMUB/TBBQ6rmntKHQuIX//I2W4OVtLlKgv38vL7jEKGdIhQ5cnwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978131; c=relaxed/simple;
	bh=H0z53aNjID9T+xswoJAOo9bzs/Gbm4yfX6fGnG3X7og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuXdOWJTYPFeBN90B3ukPfyLQMMepPt4TsJKjSw50EBeEl+Lb3l6IMhm5sbVK2Z3Fuc0L90jd6NUhzO5VnZN+2lANW4lsIraBxZt+bXHOLK76r70ywsni8VFXJhf0vGTemx6aFpTe4S7bHE7kxmn4HWZ5vUtjtGRKEUMEB8K9j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrUGqgck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrUGqgck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A6E1F000E9;
	Mon, 17 Aug 2026 14:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978130;
	bh=qGfK/3fcrVzsV1G9TRiuDlE5ZRZiwHsYAYLGdfWGLUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QrUGqgck6a9qOwX8i1pvS4sqIIjBbqxTNQC3geDSJ9f2+cYzFNvGMdOuip0MXnJib
	 33LxncxTBhz7ztq9wX+XFpVDLDnindXXPKsb64KaeRpXX+msT8qexPlc22/IZRPR+B
	 nUgHPw5EHckl0DvRLF7wCLBzn/Beanmx+1QrW798=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/181] KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
Date: Mon, 17 Aug 2026 15:33:25 +0200
Message-ID: <20260817132539.879554007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Ashish Kalra <ashish.kalra@amd.com>

commit 6f1d5a3513c2370bbd6115dd430906bc2f4bdc53 upstream.

Move platform initialization of SEV/SNP from CCP driver probe time to
KVM module load time so that KVM can do SEV/SNP platform initialization
explicitly if it actually wants to use SEV/SNP functionality.

Add support for KVM to explicitly call into the CCP driver at load time
to initialize SEV/SNP. If required, this behavior can be altered with KVM
module parameters to not do SEV/SNP platform initialization at module load
time. Additionally, a corresponding SEV/SNP platform shutdown is invoked
during KVM module unload time.

Continue to support SEV deferred initialization as the user may have the
file containing SEV persistent data for SEV INIT_EX available only later
after module load/init.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6cec696461da2..bd0344bacaf1e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2972,6 +2972,7 @@ void __init sev_set_cpu_caps(void)
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	struct sev_platform_init_args init_args = {0};
 	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -3088,6 +3089,15 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (!sev_enabled)
+		return;
+
+	/*
+	 * Do both SNP and SEV initialization at KVM module load.
+	 */
+	init_args.probe = true;
+	sev_platform_init(&init_args);
 }
 
 void sev_hardware_unsetup(void)
@@ -3103,6 +3113,8 @@ void sev_hardware_unsetup(void)
 
 	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
 	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
+
+	sev_platform_shutdown();
 }
 
 int sev_cpu_init(struct svm_cpu_data *sd)
-- 
2.53.0



