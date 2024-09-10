Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CD9186E4B;
	Tue, 10 Sep 2024 09:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961377; cv=none; b=mpNhty5wPHLoMjrfkMFrhrXc1nKCzsUb+E69W6l2256x9DdNLN9CTcrEsW36AGsry0KhjF0ViBxJ6Dvetc0n7d2Ixc26AUF6ODyu0SftaC6IJRDDR8Jh/qkdjkLFk4dKfg++KwnZE2hfe4xzwgISICNdXT6sOwoxWegSS9lzUZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961377; c=relaxed/simple;
	bh=s6+nW3jAgUwgXTgkD70/UI1eiE/UzFfuPrM972Vu4rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ttaq6cCKwVZQIH34aCk13rXRvaR+vaLr3HkP8mzLfUloXX8wXNegROxUrBLywqPOKcnlwTUHEhRKMzy6vHZtTX4XQcf62RIBTSC/wk3xf26TnGXKidR/U4wdy5BXtvKtyM/FrDuxFoDcQFUknvi0X8epFjp3yf/34a6LmRjoyLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ljh30IHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ljh30IHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E99C4CEC3;
	Tue, 10 Sep 2024 09:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961376;
	bh=s6+nW3jAgUwgXTgkD70/UI1eiE/UzFfuPrM972Vu4rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ljh30IHj9QP7UpZpBMxR/hsBS5+RHqsKGdD7aFqBtb2MkfBGY1sLC2xrO0Y0MBF7i
	 XjE/XZgV7Rp93TWJU2igBntaywMTCV5LrUMaM4XUi2P/OcJsfp9rYN/tbV6ENfu7Gz
	 JvzTWOlP48ciF9E83ymuS691EFfEVhYO3uKDwuas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.10 021/375] x86/tdx: Fix data leak in mmio_read()
Date: Tue, 10 Sep 2024 11:26:58 +0200
Message-ID: <20240910092622.982364958@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

commit b6fb565a2d15277896583d471b21bc14a0c99661 upstream.

The mmio_read() function makes a TDVMCALL to retrieve MMIO data for an
address from the VMM.

Sean noticed that mmio_read() unintentionally exposes the value of an
initialized variable (val) on the stack to the VMM.

This variable is only needed as an output value. It did not need to be
passed to the VMM in the first place.

Do not send the original value of *val to the VMM.

[ dhansen: clarify what 'val' is used for. ]

Fixes: 31d58c4e557d ("x86/tdx: Handle in-kernel MMIO")
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240826125304.1566719-1-kirill.shutemov%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/tdx/tdx.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -385,7 +385,6 @@ static bool mmio_read(int size, unsigned
 		.r12 = size,
 		.r13 = EPT_READ,
 		.r14 = addr,
-		.r15 = *val,
 	};
 
 	if (__tdx_hypercall(&args))


