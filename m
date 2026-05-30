Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D4A3A9623;
	Sat, 30 May 2026 17:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160926; cv=none; b=EcyiomoNIXBath5NM1KprL/6UP99YHtuLr13Ybn3C+ovEehCOJxAu2A8x74FSK51ytQUX3Vlp6fqWIkVdO6y1RJwgtuGmbvsmCkOiC3ZzxWT5Y/6dyRoF4Xx1aRQEDKgJhIC5o38WCUXcQ1EZi7t/70GnXqltPVJuXutLnG1E8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160926; c=relaxed/simple;
	bh=15SAd+pd0gMfBUYlvn8pK1Cj4hw4gigB14WvZ5DL3+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDeNHMOxcmt2K2rJyDHdeVBzwLp7r9nj69unqfd8r6HdGHMtpgPuBx9bvILw9km3MGHA2kjkHOzisN6LiyL6+XW6thOoUwZ4LugV8pGvqfn+dDepnPTb7m0AWWA2H48G7pAImKozX7Bm6s/ZYSBgavovAPb008KzFkZm/euN0zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjEPwt0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjEPwt0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9711F00893;
	Sat, 30 May 2026 17:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160925;
	bh=aqHeYGS3x87kKOtevPWV+dAcEDY/4xoDj54Hy6SXfbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjEPwt0ktnkyrC190JH7/k4wL9RD2i1TJDuSl6qFq20Atxsn49TUag3LEbC2n7PDU
	 OQAVKnEya6oqsNcFpiuWuuJKIyr0VI0N1AuFDX3f99drwkmei8bcUNdspSp3xtpBg4
	 rpV+H9A542oNulMoCmtas5xTGAvijMHrhWHdmFXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Wensheng <wsw9603@163.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 467/969] arm64: kexec: Remove duplicate allocation for trans_pgd
Date: Sat, 30 May 2026 17:59:51 +0200
Message-ID: <20260530160313.182916316@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ce3d40120f72f..f660648cbceee 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -142,9 +142,6 @@ int machine_kexec_post_load(struct kimage *kimage)
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



