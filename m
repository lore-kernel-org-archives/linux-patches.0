Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1969536A37D;
	Wed, 20 May 2026 16:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294791; cv=none; b=JP4gqXhk0m7oogciL0RleuljH++O2IwDBjZaFbBaPXi3yFnkLHhrqvIR38nl/ti+DU80nNpgnMKOWQFQduFT14CForb3k4ZIibspH8LEixfObV9RgiyajoqRgHCuG1aFzIBOzz9tZz+eS4JwTpo3oNu7706Uga3TningFl+8AEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294791; c=relaxed/simple;
	bh=AfR0mCyk1MqOzd6ziBHyp94DipUUMzq/0paPbhAVgZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4/YBHAthiyqzLcWfz+vwdswrfqs+aLKfRV6a3fIU6Ymwo2C9xXcOQwLVj07LMIF/dPwMMM3KBWKrVprsPczvoBjq94Gq08SukitM6ePdAn+U+e0xK6XqtBiORIpTEeL+hPK3+Zq7ulGTp1RfDB+PrNjzkIt5g38qOty8IYWJ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UME3gJsQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UME3gJsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFBD1F00893;
	Wed, 20 May 2026 16:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294790;
	bh=+PJOUMOYoiLl5K/uN2BiJA0GbnWLcnt/7hzQ27mTQVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UME3gJsQ+0pCVpiLlm9zl9A3FqY7Pq7YOXFYUaR/b4PCVEu2/erhKX8Po4bLlComF
	 lBVStWZaBSD+SJ5H4WO4/d4n19CfrkzhBOKFLRIywBLUM9yMTSeGiE28m9suXEZOdy
	 gVi5dWFNGcR6AgliJGRKTP0063ceheq1EiKh0rMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Wensheng <wsw9603@163.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0166/1146] arm64: kexec: Remove duplicate allocation for trans_pgd
Date: Wed, 20 May 2026 18:06:56 +0200
Message-ID: <20260520162152.047607127@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 239c16e3d02f2..c5693a32e49b0 100644
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



