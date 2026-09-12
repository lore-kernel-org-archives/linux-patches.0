Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89A3456DE1;
	Sat, 12 Sep 2026 11:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211169; cv=none; b=RChFxJ6fo1Rid8YyflV9FmUcGCs+92fKefF9DmQc1zJAbEreykhYF/vSZWEvgyI0uFO+iE+e7mHN0X+SvnxjwmgRkRXMEszWf/Yoq0EGkK8XltCo2DhhL8W/Bpyn3v+0gy2f5S4loJKwEk4GNUTFa+ZmoOPDx5Y4MR3GC/cN/OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211169; c=relaxed/simple;
	bh=OMBYh8zWt+D3nbs2GFKtubX3zD5kkRDo6sodfWKHhOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJMRrNOjTROlvGLk4hLVTqsEhSBtotc3TjZyGENFl235jlBX1Nqhkdhp0yZX51qrgAMCXHeDsTcMz/DMD2OQzEKaWfjXi3S22lHl3UJl9ay9cbD9T3jsjQn+Y0xctd7sZOydHA+x1OptksACFIlKCPxWDgfyU2TEqN6tmf5kEj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3gKSvAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3gKSvAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27E71F000FF;
	Sat, 12 Sep 2026 11:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211167;
	bh=LGSgYMYqL53r6GpOKd/9FUyg+kaH+SH/Qzwg+kr1BuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3gKSvAeYpj4hTe63S6fZTz3iiQERxCYM6o3QD6necp6L8JnHrrwnj6111ieJSIpV
	 c0oKJyEPA3dGIFbVClrkAvBiqWlt1N/AHPfy1qHdw/y+YcIxBagmjDMA7/X38MDaEX
	 Cu1VW6tMaWn+a+FpZl7VH90jRUWlgN+TOiMVN6m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bijan Tabatabai <btabatabai@wisc.edu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1175/1518] x86/pkeys: Fix pkey_alloc() return value when pkeys are not supported
Date: Sat, 12 Sep 2026 08:55:44 +0200
Message-ID: <20260912065650.055490692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Bijan Tabatabai <btabatabai@wisc.edu>

[ Upstream commit dee87e09b0dd63da9b1e1876167ccae37842dfd0 ]

The man page for pkey_alloc(2) specifies that it should return -1 with
the errno set to ENOSPC when pkeys are not supported [1]. However, on
x86 pkey_alloc() sets errno to EINVAL when called for the first time
on a CPU that does not support pkeys.

The root cause of this is the x86 implementation of mm_pkey_alloc() not
directly checking if pkeys are supported. It only checks if all the
pkeys have been allocated by comparing the allocation map against
all_pkeys_mask. When OSPKE is not enabled, init_new_context() skips the
initialization of the allocation map, leaving it as 0, while
all_pkeys_mask is 1. mm_pkey_alloc() interprets this as there being a
pkey available and it returns pkey 0. Then, pkey_alloc() fails with
-EINVAL from arch_set_user_pkey_access() instead of returning -ENOSPC.
Subsequent calls to pkey_alloc() do return -ENOSPC because pkey 0 is
left marked as allocated.

Change mm_pkey_alloc() to directly check if OSPKE is enabled, and
return -1 if it is not, which causes pkey_alloc() to return -ENOSPC. The
arm64 and powerpc implementations of mm_pkey_alloc() already do this
check.

[1] https://man7.org/linux/man-pages/man2/pkey_alloc.2.html

[ dhansen: use arch_pkeys_enabled() to follow arm ]

Fixes: e8c24d3a23a4 ("x86/pkeys: Allocation/free syscalls")
Signed-off-by: Bijan Tabatabai <btabatabai@wisc.edu>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://patch.msgid.link/20260716220604.26452-1-bijan311@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/pkeys.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/pkeys.h b/arch/x86/include/asm/pkeys.h
index 2e6c04d8a45b4..32d327609cc41 100644
--- a/arch/x86/include/asm/pkeys.h
+++ b/arch/x86/include/asm/pkeys.h
@@ -89,6 +89,9 @@ int mm_pkey_alloc(struct mm_struct *mm)
 	u16 all_pkeys_mask = ((1U << arch_max_pkey()) - 1);
 	int ret;
 
+	if (!arch_pkeys_enabled())
+		return -1;
+
 	/*
 	 * Are we out of pkeys?  We must handle this specially
 	 * because ffz() behavior is undefined if there are no
-- 
2.53.0



