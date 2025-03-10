Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECCB2D023;
	Mon, 10 Mar 2025 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629324; cv=none; b=FnPDZ3SicLkaz3ax71cOtySTT0o52rG78M6baPcUYY2XbFbMEgy0uDrWKJZiLH9h++niUvYG78iyGNbhlPtk8tYHvtXxcEpqNPgGuBr/iwSiN08+HLvt1bOnzy+one1lzrNltbrLR0LKGbSjNNf1YybJ3CJrkPcMYec/YYazelU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629324; c=relaxed/simple;
	bh=jJLMK0mwJpWzC0HCUn0kJM3hVsH5g48jPMrbcQXxcYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIWJ7MnKrMZHwCfgWALgac2z9Zxm3nphXWZ1whRyeZX35rMdYYuzDxT1iZcwBrri/Gxal/nK6+IymShVhJLgQBzGWc4Q1Crig9n6wGAnRWCDlw8KJJ9k2TG0EHD/7yJUUs9e43YCFImGZ139o6Ou3FIRQ9supjdheOy4/vPJb+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odgI1jhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odgI1jhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BD3C4CEE5;
	Mon, 10 Mar 2025 17:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629324;
	bh=jJLMK0mwJpWzC0HCUn0kJM3hVsH5g48jPMrbcQXxcYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odgI1jhc9ayCBbFwE/7LF2AatKqjy71yu3gyCag8HwQykUzvPvvgk7e15tVhYu5tM
	 FHwimJqJ2oM6respcAi1tu9LVoO2OdDC9KZKJDWao6J5gn8Pc8yIDXRNFlnRnxvGgN
	 QfAl+soWJJUvkfo/hhDqnNkoZOgMBd50hkfBic8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/620] x86/xen: fix xen_hypercall_hvm() to not clobber %rbx
Date: Mon, 10 Mar 2025 18:01:34 +0100
Message-ID: <20250310170555.417474946@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 98a5cfd2320966f40fe049a9855f8787f0126825 ]

xen_hypercall_hvm(), which is used when running as a Xen PVH guest at
most only once during early boot, is clobbering %rbx. Depending on
whether the caller relies on %rbx to be preserved across the call or
not, this clobbering might result in an early crash of the system.

This can be avoided by using an already saved register instead of %rbx.

Fixes: b4845bb63838 ("x86/xen: add central hypercall functions")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/xen-head.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 152bbe900a174..0dce73077c8cb 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -115,8 +115,8 @@ SYM_FUNC_START(xen_hypercall_hvm)
 	pop %ebx
 	pop %eax
 #else
-	lea xen_hypercall_amd(%rip), %rbx
-	cmp %rax, %rbx
+	lea xen_hypercall_amd(%rip), %rcx
+	cmp %rax, %rcx
 #ifdef CONFIG_FRAME_POINTER
 	pop %rax	/* Dummy pop. */
 #endif
-- 
2.39.5



