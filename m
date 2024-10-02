Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB56F1D0412;
	Wed,  2 Oct 2024 14:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878979; cv=none; b=qyqoQeIvVooB1G8B6nGFKhdfZpqWm5O6C3LHBb+dTOn8gPVdFKTOktIWpSvvqpurCXTV633D63+0Iyg5TmIn/sSxW8DvXuuGdSND0XcnrpzcozxDRpebf5PGzfNa2Wm3yuI48FCbGBGL8hopDCh7/w9fDewaoA6GNcjekYKt8G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878979; c=relaxed/simple;
	bh=xBBcqUNxlD5JyKxK4tHofcjxFNsonv12/3wgNmEwzW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7DH9au1Rsy82yh0d6v1PwogFnlun9Hgb6G1+4rrdto+S/N07+2Ii+w3jjOFrkM7D8FxT/jMw9HQuAW6Cs/wSZN3lss4WkD1Hn4JLQyIEdX3fGm0zN1gd8jJ9f0DyRJrPHzX84H9H+a6RK+n3kXwXznd51ih2C6aD6Z4MFj4nG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILSkYPz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILSkYPz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7039BC4CEC2;
	Wed,  2 Oct 2024 14:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878978;
	bh=xBBcqUNxlD5JyKxK4tHofcjxFNsonv12/3wgNmEwzW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILSkYPz+eil3X1AedOKATD9KnoDnD7N2lvRNa7upnAH3dLID3UHi0cY4PE3xP4prD
	 qkCIFrJtz43F9ONpj9GndTYVMbxJzHYmLaJufwRQQCpNFffnxEqRlYqRy4+VyjnHMs
	 ez8evt0p1//s6azTVF3NccSEBiBCvcE9BVdKz1LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Kai Huang <kai.huang@intel.com>,
	Tao Liu <ltao@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 597/634] x86/tdx: Account shared memory
Date: Wed,  2 Oct 2024 15:01:37 +0200
Message-ID: <20241002125834.678709803@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

[ Upstream commit c3abbf1376874f0d6eb22859a8655831644efa42 ]

The kernel will convert all shared memory back to private during kexec.
The direct mapping page tables will provide information on which memory
is shared.

It is extremely important to convert all shared memory. If a page is
missed, it will cause the second kernel to crash when it accesses it.

Keep track of the number of shared pages. This will allow for
cross-checking against the shared information in the direct mapping and
reporting if the shared bit is lost.

Memory conversion is slow and does not happen often. Global atomic is
not going to be a bottleneck.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Tested-by: Tao Liu <ltao@redhat.com>
Link: https://lore.kernel.org/r/20240614095904.1345461-10-kirill.shutemov@linux.intel.com
Stable-dep-of: d4fc4d014715 ("x86/tdx: Fix "in-kernel MMIO" check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/coco/tdx/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index fdcc081317764..729ef77b65865 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -38,6 +38,8 @@
 
 #define TDREPORT_SUBTYPE_0	0
 
+static atomic_long_t nr_shared;
+
 /* Called from __tdx_hypercall() for unrecoverable failure */
 noinstr void __noreturn __tdx_hypercall_failed(void)
 {
@@ -820,6 +822,11 @@ static int tdx_enc_status_change_finish(unsigned long vaddr, int numpages,
 	if (!enc && !tdx_enc_status_changed(vaddr, numpages, enc))
 		return -EIO;
 
+	if (enc)
+		atomic_long_sub(numpages, &nr_shared);
+	else
+		atomic_long_add(numpages, &nr_shared);
+
 	return 0;
 }
 
-- 
2.43.0



