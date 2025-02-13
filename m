Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA5D35961;
	Thu, 13 Feb 2025 15:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460083; cv=none; b=WoxGK5sO0HR8oMEEMecfmb41rR3b5BhZcHfIp2YvtUgeoN2f2lS0QyKChxUGvxekEGDeCS1/9fK9AhYXR0g/3s9zZO9YvcGYkUHfrUwI6O5aqst6+PSc8dX0SScb1X6Lgwt6MG3ZBhYNB3ycZOCFvTsVAlh6U/RC9/0B39HatKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460083; c=relaxed/simple;
	bh=+ZP7PxDRDfo9gDhvGDJTOQDmEePGhmbAMVHfa6Ndhtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULUEZEO7HZx89/9zMeglyR3exKp1Y6qnq74V728QZWd9yTMfYoWCwhsTj966w/Dd6i/1cwKWvMJw6b3+hEeGlaHHfNflxq1vRIM8Q0eMZk/EcUO6bLcWcjB4MD8eIThn7pZDmYn6sjuhQy9mm+8142VfDa3e2aGrBqan6gQ1+bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThBKil9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThBKil9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FFDC4CED1;
	Thu, 13 Feb 2025 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460083;
	bh=+ZP7PxDRDfo9gDhvGDJTOQDmEePGhmbAMVHfa6Ndhtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThBKil9nh16GKQBYZoRIWHl8Y199wP660GfFoLdAyUBmB+uSFYr645/eukiVFKE/l
	 EQKfBs00F9VkqkY70GHyDoaglnlRINEtGJZQfXYAw/w6FWA1rk1cTZUZ5Z38SNkDaB
	 8pMIon0FPfsebCpaUgWGKF7izLnOHP40KxGTIHCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/273] x86/amd_nb: Restrict init function to AMD-based systems
Date: Thu, 13 Feb 2025 15:26:22 +0100
Message-ID: <20250213142407.770247099@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit bee9e840609cc67d0a7d82f22a2130fb7a0a766d ]

The code implicitly operates on AMD-based systems by matching on PCI
IDs. However, the use of these IDs is going away.

Add an explicit CPU vendor check instead of relying on PCI IDs.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20241206161210.163701-3-yazen.ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/amd_nb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 6dabb53f58a44..b6d5fc396f88c 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -537,6 +537,10 @@ static __init void fix_erratum_688(void)
 
 static __init int init_amd_nbs(void)
 {
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
+	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
+		return 0;
+
 	amd_cache_northbridges();
 	amd_cache_gart();
 
-- 
2.39.5



