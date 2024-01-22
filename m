Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626AA3A8F4;
	Tue, 23 Jan 2024 00:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969867; cv=none; b=nplGl5LyXryHHwVbMHBEQO5g4NHuDS9Ve3CtK7E61nPJqcWZBlEYZvyQTzcVKVVHM/kLiYEHdKSHpYHoCHWKt98nu2VUumCR8AR7lMw6QKBT3f4R5zJBp9QT3vkZXkLGyZC2BmGOO1SrsgP9ceh7B0MTq5Cf//4UrHHfLa/vDEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969867; c=relaxed/simple;
	bh=GJxPfC9VIX0uXyDbb35DBCPZzFii9LcPLv6UvDPfyx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VobJqiZuJYDXQOZ1G8pGqrAfHJeE48/7jO4gl7NsJJpdwfho8+D6q2uRR2KpqlIdVbjcFjVokpCqG604HXyYi3HLTShuKCni4abAmv0RdlGlJMDosd29Gr3Uy4Y6LqOZNokwrzm4hkft+7BXwQ+aeVnsRqga4asT2BQnrh22o5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOVqFbF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOVqFbF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2020DC433C7;
	Tue, 23 Jan 2024 00:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969867;
	bh=GJxPfC9VIX0uXyDbb35DBCPZzFii9LcPLv6UvDPfyx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOVqFbF9KolFarXSuSsigoNBuI+za+e9wlXjFMDn5AxPaEx7pJsgBl6vJ0LFRWNws
	 NVlwK3vdWu5etEep0GEHxbdL+HAtaHVN7XzudVtDO+HSGD/7BSoCvgwJUyWjoBYzAm
	 I5QHbDK4nnpA8325POPWdcz5LPwx9unWGZdgmgsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+afb726d49f84c8d95ee1@syzkaller.appspotmail.com,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 495/641] riscv: Fix wrong usage of lm_alias() when splitting a huge linear mapping
Date: Mon, 22 Jan 2024 15:56:39 -0800
Message-ID: <20240122235833.558730812@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit c29fc621e1a49949a14c7fa031dd4760087bfb29 ]

lm_alias() can only be used on kernel mappings since it explicitly uses
__pa_symbol(), so simply fix this by checking where the address belongs
to before.

Fixes: 311cd2f6e253 ("riscv: Fix set_memory_XX() and set_direct_map_XX() by splitting huge linear mappings")
Reported-by: syzbot+afb726d49f84c8d95ee1@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-riscv/000000000000620dd0060c02c5e1@google.com/
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20231212195400.128457-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/pageattr.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index fc5fc4f785c4..96cbda683936 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -305,8 +305,13 @@ static int __set_memory(unsigned long addr, int numpages, pgprot_t set_mask,
 				goto unlock;
 		}
 	} else if (is_kernel_mapping(start) || is_linear_mapping(start)) {
-		lm_start = (unsigned long)lm_alias(start);
-		lm_end = (unsigned long)lm_alias(end);
+		if (is_kernel_mapping(start)) {
+			lm_start = (unsigned long)lm_alias(start);
+			lm_end = (unsigned long)lm_alias(end);
+		} else {
+			lm_start = start;
+			lm_end = end;
+		}
 
 		ret = split_linear_mapping(lm_start, lm_end);
 		if (ret)
-- 
2.43.0



