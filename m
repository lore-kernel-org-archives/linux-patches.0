Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AB03F4DC0;
	Wed, 20 May 2026 18:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300172; cv=none; b=ZSk2TLudlK3TEpRAgrMdDsFv2X6qbRt8fG7KavAixOGKK7+nrZzi6n48/VR5+wWdOcVXplnE+21GTozAIxFOFC/au7IAoIaenjM1k/vDN4mHFBCL+J0R0TgK4bCO/TzMqyCADtFynbs8wKrjV4he22hX23LSSDQSCQ9U6d2E3rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300172; c=relaxed/simple;
	bh=9hP/PRFett7uuVpQEdVadLt/AaMf3248wy5/MXwsQAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpqlNauQBIwhKxMJKz72//QNbORFGmmuOKLr87SYp1ksMvM2Ywppb81mFEntUGM4q/PzdoP9ld1NXy4yc4KcOY19y+IYI+KWbqcdDXZwMgA4HBFx55taZT6fQijkAAj//DRRqdPBtqiqWn5TS7f7B9vhF0UUze2pLSU3sZml3YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J66rG26s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J66rG26s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3413A1F00893;
	Wed, 20 May 2026 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300171;
	bh=UiBB4oGS3uK0dWffFpvj0P1AnyCHOHgiQ7g0SUfiTJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J66rG26s2+mzPbmA92ekU3HFqlz9tOZA2hhZigDFZbWm+VNFKjIZQzbdp8G5utxE1
	 ctdGbA+Wcx+t5rHa1q9ZEr82NmSrq9lUgmH+ilznijFOQha2AyUT6ZGSj2lb6vvzUs
	 Y6yGqBKUgoyQWbiGG5Pn/qtQRzVAJUE3zE8nYUKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Wensheng <wsw9603@163.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/666] arm64: kexec: Remove duplicate allocation for trans_pgd
Date: Wed, 20 May 2026 18:14:43 +0200
Message-ID: <20260520162112.792387987@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Wensheng <wsw9603@163.com>

[ Upstream commit ee020bf6f14094c9ae434bb37e6957a1fdad513c ]

trans_pgd would be allocated in trans_pgd_create_copy(), so remove the
duplicate allocation before calling trans_pgd_create_copy().

Fixes: 3744b5280e67 ("arm64: kexec: install a copy of the linear-map")
Signed-off-by: Wang Wensheng <wsw9603@163.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/machine_kexec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 6f121a0164a48..28df62051cc97 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -129,9 +129,6 @@ int machine_kexec_post_load(struct kimage *kimage)
 	}
 
 	/* Create a copy of the linear map */
-	trans_pgd = kexec_page_alloc(kimage);
-	if (!trans_pgd)
-		return -ENOMEM;
 	rc = trans_pgd_create_copy(&info, &trans_pgd, PAGE_OFFSET, PAGE_END);
 	if (rc)
 		return rc;
-- 
2.53.0



