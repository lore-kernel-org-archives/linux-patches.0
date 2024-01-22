Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E621626;
	Tue, 23 Jan 2024 00:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970685; cv=none; b=sei5+vA45cb2IZiF4YdHGa8xhyglxOEyVnzGFTYocfYkopDGMQ8ZBOgPEC2vAyqdOl7d1MdRc6TmfYcWsRWFIKrHlpFS8J2CEDWWFH1qTbHkI3QeUBlsXbI05H0nhrHr0gLhUSTD6Jvf/4FTUXWflHEMGy07woyMqemCy1/MI/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970685; c=relaxed/simple;
	bh=gRUM8NdEDn55lpaRqAG2bEInVjad10o0npK52lLAhn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+QUqKuMkyVBFvL3Es7QcPLr4VIw2gMM8D2/ee+ViaF6SE2cEo6GZcRq4DXECtp7QdWK5Mvl/9Dpbo0ZW9aM0lPbiLBWA+wSezVJa8/yFK5BHb8atSSuiQ+X9Gv4/TXFV1fCNNPToefoC9LmShS16Pn6Iw0U+6bXRygR/BMZM/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZUI4oUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZUI4oUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B332AC433C7;
	Tue, 23 Jan 2024 00:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970684;
	bh=gRUM8NdEDn55lpaRqAG2bEInVjad10o0npK52lLAhn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZUI4oUkR/XStFB9g7ohfw8tjKeMcrFOa0TW8ido9I4hkUrJHkK9/V2/xo2FA4NIF
	 v6Sgw8XRnibvW1z7Qh+SIQvWcw+iqtD9zSILZfvN16x+BOJZ4mvsDmDmV5SM/Lrti2
	 DyjRMTORi/e3oY+KawpLMOn73vwbM0MmiyVZFFB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/417] csky: fix arch_jump_label_transform_static override
Date: Mon, 22 Jan 2024 15:53:51 -0800
Message-ID: <20240122235753.892673453@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit ca8e45c8048a2c9503c74751d25414601f730580 ]

The arch_jump_label_transform_static() function in csky was originally meant to
override the generic __weak function, but that got changed to an #ifndef check.

This showed up as a missing-prototype warning:
arch/csky/kernel/jump_label.c:43:6: error: no previous prototype for 'arch_jump_label_transform_static' [-Werror=missing-prototypes]

Change the method to use the new method of having a #define and a prototype
for the global function.

Fixes: 7e6b9db27de9 ("jump_label: make initial NOP patching the special case")
Fixes: 4e8bb4ba5a55 ("csky: Add jump-label implementation")
Reviewed-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/include/asm/jump_label.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/csky/include/asm/jump_label.h b/arch/csky/include/asm/jump_label.h
index d488ba6084bc..98a3f4b168bd 100644
--- a/arch/csky/include/asm/jump_label.h
+++ b/arch/csky/include/asm/jump_label.h
@@ -43,5 +43,10 @@ static __always_inline bool arch_static_branch_jump(struct static_key *key,
 	return true;
 }
 
+enum jump_label_type;
+void arch_jump_label_transform_static(struct jump_entry *entry,
+				      enum jump_label_type type);
+#define arch_jump_label_transform_static arch_jump_label_transform_static
+
 #endif  /* __ASSEMBLY__ */
 #endif	/* __ASM_CSKY_JUMP_LABEL_H */
-- 
2.43.0



