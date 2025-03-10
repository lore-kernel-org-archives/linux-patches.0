Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2540522AE7C;
	Mon, 10 Mar 2025 17:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629184; cv=none; b=PzHUrjFSZYxnXHYFgi7k9kC9q4KhtGZYPOTbOADVrwL8tyMI4S4KMc8HVP7jX0CeaPpFzkqpm7BW9FICDpxSG6TE2g2C8lgXKuU3YJeVA1yRvW+3emmtZ9MUtp3eDnLIxuhSuTbCktPTZuTc5MaNYAgHnXZpTYBYvam4z+JyG4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629184; c=relaxed/simple;
	bh=TZSiZqavsMkVgx05JhTJgjEU0mzBSMp2D/bLwEJnVLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSq2DRiYQqWRS3POZhE0uUUufJcoD9ZXQd9KnkjJhLKfceHcuM+AfLf0dg+w7774WIHkVgboNX/aOxvrRDDGMFC2SwWReoZug+WDDv1aHqydRM4js7U/1DUIn3pakt59WcbGOhjkxoaS0xWH1r48rgAlZIvZcDFJ8jXLiS7E0so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGf+npyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGf+npyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0107C4CEE5;
	Mon, 10 Mar 2025 17:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629184;
	bh=TZSiZqavsMkVgx05JhTJgjEU0mzBSMp2D/bLwEJnVLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGf+npyTLJFiA7IWktj73+Y038zJ8NzSslXd3UnXQcgWPyQ3ajCioHNVKg3RMFdba
	 nJvubGqlkANJ2KtR+yMajk9+ZHy3bKD1X3SaaJ4vHSVy3MPjTM+TWT+RNlluVEB87T
	 gbqrkGHi6LdTETbYK/yOQrTiKHzvTQ7a0dM4vgOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/620] x86/amd_nb: Restrict init function to AMD-based systems
Date: Mon, 10 Mar 2025 18:00:52 +0100
Message-ID: <20250310170553.758065630@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 62cd2af806b47..eda11832b6e62 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -544,6 +544,10 @@ static __init void fix_erratum_688(void)
 
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



