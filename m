Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397C238946E;
	Tue, 10 Mar 2026 11:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141943; cv=none; b=CL3oRWWBT3DKGkiebY3OKoNp6sKQDuIlH6axukYBE8vbxshpjj4XyQQkV78kinn3xiZUOYQWe8+dQBcbVvs3svFP8vzW5ipiq3YvvC9s6wszAJmpisyP3KmPkoAhcm52LgEyJ/NQSLZnjQv8CVHZDolcyfkyyisba1NMSQgLrLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141943; c=relaxed/simple;
	bh=aDixeLrerspsPvB4Dn9Hw6eKfbbx9aahhBnLksqfq0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f5iuzLYveoZsY70mxQ7saF2BOnjae/cS4h4bUodL+bVwQv3xaSxA6YTRHcpsI5/WXXRL6pWhsF1/4269jyow0CQB/Msk9G1O3YUIxQ/JcWNMjR5o3USLxziesJhMECNsH663Je74d5l2m/tkd6ssvjUg01mUfZhmIspOlJbV2Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6phvOHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6phvOHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699A4C2BC86;
	Tue, 10 Mar 2026 11:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141943;
	bh=aDixeLrerspsPvB4Dn9Hw6eKfbbx9aahhBnLksqfq0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6phvOHmJXz2Wc3jwz4AgB2vx1o4u5OCbOnCr1Bpy3XxPH4fv4YUS5OPiDRXcNp86
	 hSCrhtbfhvXw7d+ZQ9VYPimven5yZMZ1zbeLYSsXfUxpGLm7oCuJBgXTjghtbCJKVH
	 gkrKrLCNNaPodCpYQ9bKH890Skr1czq1lKtHhapPtKyz6cZ1cxaxSogguQZbPV5hi7
	 uHQ0zbhGbugplM6Ls7eAc1YDHjWTqwRC+ddvIrsBMNVItUr2Oa/nm8AY59GAknWkNx
	 XPspZgwyZvxKxV/edFJrS77SQJYTRTwM9TD7ffBgnaabBr/x/0T8vBY6PYSGF8F2XU
	 5A6f2UbLJKIaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/314] PCI: Correct PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 value
Date: Tue, 10 Mar 2026 07:15:26 -0400
Message-ID: <7eec0ca69791117ad1fd3a70e65c4ddbb6c5ce06.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 39195990e4c093c9eecf88f29811c6de29265214 ]

fb82437fdd8c ("PCI: Change capability register offsets to hex") incorrectly
converted the PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 value from decimal 52 to hex
0x32:

  -#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 52      /* v2 endpoints with link end here */
  +#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 0x32    /* end of v2 EPs w/ link */

This broke PCI capabilities in a VMM because subsequent ones weren't
DWORD-aligned.

Change PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 to the correct value of 0x34.

fb82437fdd8c was from Baruch Siach <baruch@tkos.co.il>, but this was not
Baruch's fault; it's a mistake I made when applying the patch.

Fixes: fb82437fdd8c ("PCI: Change capability register offsets to hex")
Reported-by: David Woodhouse <dwmw2@infradead.org>
Closes: https://lore.kernel.org/all/3ae392a0158e9d9ab09a1d42150429dd8ca42791.camel@infradead.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/pci_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 07e06aafec502..1172bda87abff 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -706,7 +706,7 @@
 #define  PCI_EXP_LNKCTL2_HASD		0x0020 /* HW Autonomous Speed Disable */
 #define PCI_EXP_LNKSTA2		0x32	/* Link Status 2 */
 #define  PCI_EXP_LNKSTA2_FLIT		0x0400 /* Flit Mode Status */
-#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	0x32	/* end of v2 EPs w/ link */
+#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	0x34	/* end of v2 EPs w/ link */
 #define PCI_EXP_SLTCAP2		0x34	/* Slot Capabilities 2 */
 #define  PCI_EXP_SLTCAP2_IBPD	0x00000001 /* In-band PD Disable Supported */
 #define PCI_EXP_SLTCTL2		0x38	/* Slot Control 2 */
-- 
2.51.0

