Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0A114A4CF;
	Tue, 23 Jan 2024 00:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969220; cv=none; b=FVN0xsij/vTe2By/Wfqr9Usyx1qRBO5Wf/dI9UwWBHutOu5lh08twXZHUuchjliw3GTy+YnThXaXnoUDwZxFLBAbMjo49+5Qs/llu7RpgQY1rne9uLO1f+PrjKj0LaaOsTy0GFfiDfOW0wBALdq86XJmTvXMwsq/8x+JUkp63es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969220; c=relaxed/simple;
	bh=PS8reSd+/Szebk/j5zh93qM0puF9kNC4XX0QJKhPPbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXu41VcUlAKp6+4F6S+5MRzCBpJFQlN+9TazvADWJugvt9Z3OxyUbQ3ruMP2g/98e/pc8V+4smZQ6WS2GBdOu0kgtmC7+ENf1hFxM/z+ZthFFol/HCpg/osY8P9DrwibYEh/OhZrtHtYzTcmfzAHw67s+QjnRplnUW96Ahk2B8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ffj30w3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ffj30w3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB38C433C7;
	Tue, 23 Jan 2024 00:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969220;
	bh=PS8reSd+/Szebk/j5zh93qM0puF9kNC4XX0QJKhPPbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ffj30w3X2H/9dlixav+E5pOVlkoKcSHdH8mBXlUqBO0/Q/CUhJ//R5flpACsWf+WL
	 STQAhjCJpARzcakCJpp1Fhqovx52cihNJrKdGVr74iLbYIxKyyxJ+ovHQ66ewHpkTs
	 LKh5/GA8qIcGTstpfyuMirlWf9RVJIE+pbgOqXxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 084/641] csky: fix arch_jump_label_transform_static override
Date: Mon, 22 Jan 2024 15:49:48 -0800
Message-ID: <20240122235820.658932644@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



