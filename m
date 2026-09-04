Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578193B2FE4;
	Fri,  4 Sep 2026 05:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498619; cv=none; b=GNHPSzWKju3s2JiUsNZJcT4a7GU2HzEOlJFaFvgW7Ft1z2Sy7f37IxOWqmg6DWXtCwCdy3eXhSFicXV5jkdw+DxSjmjqE8oqXNnvFuAbQ5gnKvPy/izC8/3bnIfJncOwnM00r1hrv7yBrqBnaAghGAdMqRH4cTWMorJ07xc2GeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498619; c=relaxed/simple;
	bh=TCoNFg+xalz1ycQvFMDWDd0wEw9tf2m4Qcl83BsgcII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8gqWCKeOoW1mzyp+dAT6Q6to+HOlhXTSvlB4do8gkLe3VSC5E0tIke1fOiuddRTCvLSkqoI8+lr84H1juPMKHbRZ5F1hd7FvGEyHB4O+qcWXDQp+m1PdCDiUeec2JCLm6VHe2jKp45RuV3wkiPEzTZ37MlDmx1y1vqMSdbsHHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wb73cAX4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wb73cAX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C8E1F00A3D;
	Fri,  4 Sep 2026 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498618;
	bh=hTI+VVLHoFM9ks7aAR0Z/brxTC4qMZF+2S4EIYRSXq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wb73cAX4950eFiajUmFOmW07KcsNr2y5Qpuwiul3J58OvJGemtxVbSrImkNoSOwwA
	 hsRzCPWX/nt1PhAyaMUrgcsiBAp7gAq/Fy7/r4l1P7bprvPgaCm/nMuqfGtWAwvJJ3
	 u1SVntoSbYjFDfHGf2a9u/ZX4LUYRJsEVb8tpTlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borys Tsyrulnikov <tsyrulnikov.borys@gmail.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 7.2 084/713] x86/tdx: Fix off-by-one in port I/O handling
Date: Fri,  4 Sep 2026 06:50:52 +0200
Message-ID: <20260904045805.723023496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

commit 0f63e656b1c679d32ac595de29d10c03efca6a25 upstream.

handle_in() and handle_out() in arch/x86/coco/tdx/tdx.c use:

    u64 mask = GENMASK(BITS_PER_BYTE * size, 0);

GENMASK(h, l) includes bit h. For size=1 (INB), this produces
GENMASK(8, 0) = 0x1FF (9 bits) instead of GENMASK(7, 0) = 0xFF (8
bits). The mask is one bit too wide for all I/O sizes.

Fix the mask calculation.

Fixes: 03149948832a ("x86/tdx: Port I/O: Add runtime hypercalls")
Reported-by: Borys Tsyrulnikov <tsyrulnikov.borys@gmail.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Link: https://lore.kernel.org/all/CAKw_Dz96rfSQc6Rn+9QBcUFHhmkK+9zu+P=bxowfZwxrATCBRg@mail.gmail.com/
Cc:stable@vger.kernel.org
Link: https://patch.msgid.link/20260713133753.223947-2-kirill@shutemov.name
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/tdx/tdx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -694,7 +694,7 @@ static bool handle_in(struct pt_regs *re
 		.r13 = PORT_READ,
 		.r14 = port,
 	};
-	u64 mask = GENMASK(BITS_PER_BYTE * size, 0);
+	u64 mask = GENMASK(BITS_PER_BYTE * size - 1, 0);
 	bool success;
 
 	/*
@@ -714,7 +714,7 @@ static bool handle_in(struct pt_regs *re
 
 static bool handle_out(struct pt_regs *regs, int size, int port)
 {
-	u64 mask = GENMASK(BITS_PER_BYTE * size, 0);
+	u64 mask = GENMASK(BITS_PER_BYTE * size - 1, 0);
 
 	/*
 	 * Emulate the I/O write via hypercall. More info about ABI can be found


