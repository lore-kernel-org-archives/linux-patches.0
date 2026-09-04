Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF55415B71;
	Fri,  4 Sep 2026 05:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500437; cv=none; b=DMwi1Vjv/j3carW8yb7X+LXkmsS8kLkbTy/SxIp5KXHF1MynMmuMn0ldFM0LpzMARl589tk6whFfgwidSyIvQ7tObCVj3GpmAfezPMUkGkKslKD5wgt5PuaBxVPtTxmW1ku7j0kLj7bYPGKuRFFXxbW/AcWq9MlZAmtG+Op6kfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500437; c=relaxed/simple;
	bh=DZO9WC8URcIlsar44YwJenlwx5KxEwwi4lwbYLXdSnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mddWcQdeanY3pbUN89Xdk9FYDAVEzCbV6V6rNwBycEk4dKDOXj9CXNTMhK0jbpIhmqj0PhInvOGJ5cDiY8riTeh/IYnKhDCbmY/z84r8WMDgLwZlKgf27Md9RCoW8c+kx3EFT+7qEgxHQkE8YXq/wHgJ8Jpfmz9DEfGmW3ECUsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6n+4Eo+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6n+4Eo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05AB1F00A3D;
	Fri,  4 Sep 2026 05:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500436;
	bh=A/imvOwY1DyIJZY9x8H01OcWBavMoLwRY4AoBBcqyb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6n+4Eo+QJqQY//yAeA5u6xL0slxwQjE1pjqrci5uPi/cQuhHG9fusJWFh83UZXHi
	 mLBewA+W2QR8cM4t2Xpefi124wO33IvX5MEFLeyVJMj13Vj/zYpDvdxGVOmwaJ7/1y
	 D4UO/3SHNhUvSxHtotfpo+9yDBEJrag/Q6vk/QK0=
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
Subject: [PATCH 6.18 055/552] x86/tdx: Fix off-by-one in port I/O handling
Date: Fri,  4 Sep 2026 06:53:32 +0200
Message-ID: <20260904045749.090665475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -693,7 +693,7 @@ static bool handle_in(struct pt_regs *re
 		.r13 = PORT_READ,
 		.r14 = port,
 	};
-	u64 mask = GENMASK(BITS_PER_BYTE * size, 0);
+	u64 mask = GENMASK(BITS_PER_BYTE * size - 1, 0);
 	bool success;
 
 	/*
@@ -713,7 +713,7 @@ static bool handle_in(struct pt_regs *re
 
 static bool handle_out(struct pt_regs *regs, int size, int port)
 {
-	u64 mask = GENMASK(BITS_PER_BYTE * size, 0);
+	u64 mask = GENMASK(BITS_PER_BYTE * size - 1, 0);
 
 	/*
 	 * Emulate the I/O write via hypercall. More info about ABI can be found


