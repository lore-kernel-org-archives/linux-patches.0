Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F418F401A26;
	Thu, 12 Mar 2026 20:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346429; cv=none; b=eDnu7n9iZ3nFLjyyrZKpIbv2UgKEXetXUXN3r0XjmEEnzJIs2J98XH0D1gDF8NUji8E4wIhz5xg0Q9fINMF6GZ/akQHjXmTOpartMMLGUzMWSTwXK30ohpvKWTVPUHG/oQfkibq4Y/VzBeAhcDtkYBHjli3ctimWputTUMuOxmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346429; c=relaxed/simple;
	bh=UsCDJ60EdzZ8bi66C0+RGXwKjedkFaD7PkUyFcT33c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YR0guwRNJh5FAW9htJ9UxyMMgRYs07KZ0eupBfYXDyHS3Gvw/cjuiZSy4rgL3JT0QLMSSIETLr90ZZYqU6lgqzUahnYeEZFyE72duYamSavJyBxkymLmMuA5dV2ya/H+3DxIDWrndr6McvF5fPB+CoepkwfzZ9pPIrEmQHuZq7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNGrsqUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNGrsqUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1D4C4CEF7;
	Thu, 12 Mar 2026 20:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346428;
	bh=UsCDJ60EdzZ8bi66C0+RGXwKjedkFaD7PkUyFcT33c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNGrsqUAf/PI+/gFOwjd6Gy35lgeqBuwP3wC/lyq8GyLwzfVdIvux1ogb4Yi4ou+P
	 +EMXMHStOT+DS+sPyp6zrN6+b2ibRtM/Mj+j7T2rsS9u8obrg5rZDMbaumP+WHFyTL
	 1z99rlPKOb6KalyhuWc+nPvckVsueUyFHIwALXSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/265] PCI: Correct PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 value
Date: Thu, 12 Mar 2026 21:07:07 +0100
Message-ID: <20260312201019.644521430@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index f3c9de0a497cf..bf6c143551ec0 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -699,7 +699,7 @@
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



