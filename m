Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052CD21772B;
	Tue, 29 Apr 2025 16:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945620; cv=none; b=HrdRpmT98A3So5gNLJzZJdAixVPoh5/NNCyspQsUWGG3oyIOOu0mDNbfmRAUMp6Gsvbl70GbT6jeSEdRkx46UvCkKM+rhZZTdFCOcHmUZd2ce/AfXgyj+wEaDBDobruHmz6VU9Zy/vpBoebyWuQWrfuPVqlxZ7vJCNNSGnUSx5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945620; c=relaxed/simple;
	bh=inuRLI9xkoKFOKHm2I76b56dKxL8l/BiZL59RStelFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8wx5n1CcT/lxx2MESz+UdA4aqzVP+rFYyf9dW8Z8SPnHN3QOibhze7ud8kCwqMISBrJr9k/nCH/WN1FpoR6EbhcrzeGN43xySedRNQ1tedPZRUVUO0Miwo2HAMAP+TRbZVpk/J18x8LVtnEgNBe1AwU4VLIvnm1dEg+n7tGM7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SabriPpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SabriPpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1835FC4CEE3;
	Tue, 29 Apr 2025 16:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945619;
	bh=inuRLI9xkoKFOKHm2I76b56dKxL8l/BiZL59RStelFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SabriPpnZRxtxF0rOvWzk8zt8LgttoyOqFzT9cYPOADj2qdfdZWOX25v0eQ6+mOe1
	 0uWK9FUsqC6zgf6n/9AbwYjljoj3l9fNX8CSiE3gek2a8YY4G3UNO7ldgpkRE/OWql
	 Df4Y2EiNCrvwfDLOrQ5f090Mt9EzD2sldaMeTmUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Amit Shah <amit.shah@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/179] x86/bugs: Dont fill RSB on VMEXIT with eIBRS+retpoline
Date: Tue, 29 Apr 2025 18:41:54 +0200
Message-ID: <20250429161056.394306314@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 18bae0dfec15b24ec14ca17dc18603372f5f254f ]

eIBRS protects against guest->host RSB underflow/poisoning attacks.
Adding retpoline to the mix doesn't change that.  Retpoline has a
balanced CALL/RET anyway.

So the current full RSB filling on VMEXIT with eIBRS+retpoline is
overkill.  Disable it or do the VMEXIT_LITE mitigation if needed.

Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Amit Shah <amit.shah@amd.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Link: https://lore.kernel.org/r/84a1226e5c9e2698eae1b5ade861f1b8bf3677dc.1744148254.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index af748d1c78d41..4f803aed2ef0e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1348,20 +1348,20 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 	case SPECTRE_V2_NONE:
 		return;
 
-	case SPECTRE_V2_EIBRS_LFENCE:
 	case SPECTRE_V2_EIBRS:
+	case SPECTRE_V2_EIBRS_LFENCE:
+	case SPECTRE_V2_EIBRS_RETPOLINE:
 		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
-			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
 			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
+			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
 		}
 		return;
 
-	case SPECTRE_V2_EIBRS_RETPOLINE:
 	case SPECTRE_V2_RETPOLINE:
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_IBRS:
-		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
 		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
+		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
 		return;
 	}
 
-- 
2.39.5



