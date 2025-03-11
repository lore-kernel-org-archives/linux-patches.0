Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAE3846D;
	Tue, 11 Mar 2025 15:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706681; cv=none; b=S8aKtl74Vl2wNk34RfnCOzt4abWWlN4JkZAoIBlDMhTWWEEIKqGYnxzMODlm8YLKmVpJGiJjswFU4BWFWCZUhNM1LBFIxv5UAwAQoMmCoBT1imifu5IfOaqgQmxKCU9P3NYGvCplbc/Xv3VrvUiFenqSmFOyIFbjOrFJH7ptjRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706681; c=relaxed/simple;
	bh=xGibmD9Wlfyf7oaMJiQEQ6jUsFL7t8QF7kTSKS0WIK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7TCPfMS5OKdp/iw7vklln1VF3JAJ2CGi8NLxGl4cwLwcxpzC3Dknyx8SeibrbsCpaH0uOKeoLITn8MTkE0+GjjmnHrNtGO7qcX364NKk2fzryEeGPgt/OCVV9+ADfzkgYY19vVe2vhMg1mhIJD4CslLM2EeAtGgjeX5gOw2QuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pw/lnBrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pw/lnBrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F9EC4CEE9;
	Tue, 11 Mar 2025 15:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706681;
	bh=xGibmD9Wlfyf7oaMJiQEQ6jUsFL7t8QF7kTSKS0WIK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pw/lnBrzUy8H4DbqxGnXWd4pic+oww4GtKZxUOZzJtMPb9sPNcvrhAmA0Zw7X6Rjj
	 1UYOqdQAiHWI2rqtyjA9NRCbrUbmM3foGTq5oTsxapUQq536HWBzsBU+2/W6Kp3G7x
	 Oh2VUOpWPhjPoVsYYMYbsnM8GQrbuhlXC0NPoU2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/462] x86/amd_nb: Restrict init function to AMD-based systems
Date: Tue, 11 Mar 2025 15:56:36 +0100
Message-ID: <20250311145803.494358447@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 16cd56627574d..3dcaeb25ee301 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -536,6 +536,10 @@ static __init void fix_erratum_688(void)
 
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



