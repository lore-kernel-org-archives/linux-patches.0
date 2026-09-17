Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8E04E01ED;
	Thu, 17 Sep 2026 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658775; cv=none; b=nbmD8OtnnTNfWbNpLl+tVp3fdG36sVVpH76Qkk0ZvRjY3ITXaIESMktEm/dGx4RNEdjGKTPtfmlG5ElvE3JzxMvXyUuQZptLMBLL3x/x8XvIAHPpMRZsT4sTPN/sB0k95EAsyjGrGnnqpm0iWO55eCFNTJA0HAJjwgno8NZwYpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658775; c=relaxed/simple;
	bh=ytzZqvQWRpLedopGophK0u2o2LCuduiRUlTFoqdmwXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2bGEafIV5zm5WzwnQH88LTlr3h2oxCZdKNmDsfzyEbb9sK4QwuGLFZLWiAOWOfxuXXssMUnLnCS9nhsy/bJljN4GyqOhpHBp1rX9qGGl5v1MHb0f2MJeM4CxjAgbXELkjYJTqqiZ0IBQ3R41vuhM8xDReDOfLFpRLDyAZzL31E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZNtF7hx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZNtF7hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5131F0089D;
	Thu, 17 Sep 2026 15:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658769;
	bh=wVDUGPqi6NpJ7kcLEnS0khyWG71hUuU64sQEDr3mYhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZNtF7hx3bVySrqNk0TrlNc8OiPWWIhWfIEe/kv63NqUm7C3WctCxvcrlN/aYLAHZ
	 n7jlankHd/J37YJjy25p0uZmsUJJ78UkLcrbWcE2CzT5Ddq0ObL+UqRr/rg8nFa50c
	 2pxCxmnOMf5XhMKNAHTh1EzVAL7baH/KNHOeMB+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Deskhmukh Shrirang <Shrirang.Deskhmukh@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 006/733] RAS/AMD/ATL, EDAC/amd64: Only load ATL when needed
Date: Thu, 17 Sep 2026 16:05:14 +0100
Message-ID: <20260917151350.788436245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit 4c3da04827dc01dc1cfc3d03654b7de656c42d80 ]

The AMD Address Translation Library (ATL) will attempt to load on all AMD
Zen/SMCA systems.

However, only systems with DRAM ECC enabled will use the library. Other
systems will fail to load the library and produce an unnecessary message to
the user. More importantly, that thing is dead code loaded and unused.

Remove the ATL module dependency table to prevent autoloading. Request
ATL to load from EDAC once all system checks are complete.

  [ bp: Massage commit message. ]

Fixes: 3f3174996be6 ("RAS: Introduce AMD Address Translation Library")
Closes: https://lore.kernel.org/20260305154528.1171999-1-mario.limonciello@amd.com
Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Deskhmukh Shrirang <Shrirang.Deskhmukh@amd.com>
Link: https://lore.kernel.org/all/20260307144910.GA113343@yaz-khff2.amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c  | 2 ++
 drivers/ras/amd/atl/core.c | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c6aa69dbd9fb1..475235c402e88 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -4173,6 +4173,8 @@ static int __init amd64_edac_init(void)
 		goto err_pci;
 	}
 
+	request_module_nowait("amd_atl");
+
 	/* register stuff with EDAC MCE */
 	if (boot_cpu_data.x86 >= 0x17) {
 		amd_register_ecc_decoder(decode_umc_error);
diff --git a/drivers/ras/amd/atl/core.c b/drivers/ras/amd/atl/core.c
index 0f7cd6dab0b0e..d77dacdd4f569 100644
--- a/drivers/ras/amd/atl/core.c
+++ b/drivers/ras/amd/atl/core.c
@@ -190,7 +190,6 @@ static const struct x86_cpu_id amd_atl_cpuids[] = {
 	X86_MATCH_FEATURE(X86_FEATURE_ZEN, NULL),
 	{ }
 };
-MODULE_DEVICE_TABLE(x86cpu, amd_atl_cpuids);
 
 static int __init amd_atl_init(void)
 {
-- 
2.53.0



