Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894DC267731;
	Tue,  8 Apr 2025 12:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115126; cv=none; b=to3h4KBnJyQsvGntGd9h6fqgJblkOYA7p4pPCTVHvGArqjW33Au5WlAw0axYBumb97O3R0ShsuRxw5ydBoWX+osVsRyDnzNOOJBShL3bKr49ay+E8QDOU1dCwihB+iCpHtxa3cMnP+Zgon3YoMUSdgY4iBNrcCVWAOXICTlOtpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115126; c=relaxed/simple;
	bh=YpX+WWvsYl53yThz0wkm5HY/moRCDx7hPIZGaDkwnYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=susu+Y2qh1n0UVxy+k7PX4AY4ex9bIZK1cgIB9BkR+fQUMIhlZlJcG/F/KMT5OP/VDRdVzf16tceKHxmWn/+Yu3xgNmVkbesKgV3tJeB+eUJ4PFk87GNw9sQKZ/Ls9+7MFazqCOqTvlDcznFFBERqQtWFxD/zigaCsKhSEjxnoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXNkkw9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXNkkw9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18745C4CEE7;
	Tue,  8 Apr 2025 12:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115126;
	bh=YpX+WWvsYl53yThz0wkm5HY/moRCDx7hPIZGaDkwnYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXNkkw9HO10rU6znpIgtSWd42JFpvx+axDP/TY4WZDr4QNLi3gqKxl4BHZT+ri+qh
	 h6RXd7p0mQ/3HmpDgz+c+M8S8BCRtq1Q8DsjLGLvrDRpTKBagP9WqEfpeunV06KVQK
	 RMCSbV64gHC3GjZULTJIuk0cUsKYPEiXKYVtuawM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Tingbo Liao <tingbo.liao@starfivetech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 359/499] riscv: Fix the __riscv_copy_vec_words_unaligned implementation
Date: Tue,  8 Apr 2025 12:49:31 +0200
Message-ID: <20250408104900.185354670@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tingbo Liao <tingbo.liao@starfivetech.com>

[ Upstream commit 475afa39b123699e910c61ad9a51cedce4a0d310 ]

Correct the VEC_S macro definition to fix the implementation
of vector words copy in the case of unalignment in RISC-V.

Fixes: e7c9d66e313b ("RISC-V: Report vector unaligned access speed hwprobe")
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Tingbo Liao <tingbo.liao@starfivetech.com>
Link: https://lore.kernel.org/r/20250228090801.8334-1-tingbo.liao@starfivetech.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vec-copy-unaligned.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vec-copy-unaligned.S b/arch/riscv/kernel/vec-copy-unaligned.S
index d16f19f1b3b65..7ce4de6f6e694 100644
--- a/arch/riscv/kernel/vec-copy-unaligned.S
+++ b/arch/riscv/kernel/vec-copy-unaligned.S
@@ -11,7 +11,7 @@
 
 #define WORD_SEW CONCATENATE(e, WORD_EEW)
 #define VEC_L CONCATENATE(vle, WORD_EEW).v
-#define VEC_S CONCATENATE(vle, WORD_EEW).v
+#define VEC_S CONCATENATE(vse, WORD_EEW).v
 
 /* void __riscv_copy_vec_words_unaligned(void *, const void *, size_t) */
 /* Performs a memcpy without aligning buffers, using word loads and stores. */
-- 
2.39.5



