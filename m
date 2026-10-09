Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EA92D592D;
	Fri,  9 Oct 2026 14:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555783; cv=none; b=cron6st+xHvrSZQR2ePSGSYj+bnSU7OMhCyA2hN0SOoaEyW9ESDVqAO5anIijiDgEBz89oPefcjx4WO55whqj6/EGikloUmEFCTsXV1+L0FiPD9ro825G5ouT3QlmxNStkUR/KuJYBxqCq6XktR5gW8cJVDPLJroELUZOgFZiz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555783; c=relaxed/simple;
	bh=OOJJkAP2R1qGK+KnQlqnreWTj13M72lXNMRKQLrQfu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6B7tFePJ7HllFad7T8Xcq7T74pJvu2eWyURdeU8204q1GjhNPEC2tAJiYBrvB9JCmzoLaLko2IRaI7xX96vyzqnyJi+Fw/d9nZ95iPjDXqjw0w1yLjdAUaoL+Xfhe1KNtoNsiu+Oh0O6PU+YKuVS7Y7dU6Dnl0xTsqWUeCdlh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2dl32NP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2dl32NP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E351F000FF;
	Fri,  9 Oct 2026 14:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555782;
	bh=yQrGvI6H+Bu68LHIKsYWuWhqJlstQMP7c0ueCafltzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2dl32NPZRWEarCzn2vUZ8wuGpxrJWc1Fw0VFi8rkiPCJe7Swexrt6bHrjkNMfcol
	 DCTU8Fzf0DQemiTCOK9elswkwwO6Vl9N4D+e3QBvpOBkW/g0ZFkxd8sTToQoVsB4A0
	 nTG+LhICpx/jW2KDSm0ATDK64yMHYvEko7FsqSbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 069/428] mtd: core: avoid double-free of OTP NVMEM device
Date: Fri,  9 Oct 2026 16:06:46 +0200
Message-ID: <20261009140947.668451579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 26300879cd8e4612dce66bb8f6ff7cd35fcf3e59 ]

If factory OTP setup fails after the user OTP NVMEM device has been
registered, mtd_otp_nvmem_add() unregisters the user device but leaves
mtd->otp_user_nvmem set. On an error, the caller unregisters it again.
For -EOPNOTSUPP, registration continues and normal teardown unregisters
it again.

Clear mtd->otp_user_nvmem after unregistering it.

Fixes: e0489f6e221f ("mtd: core: fix error path for nvmem provider")
Fixes: fe0b8213c012 ("mtd: core: Don't fail mtd_otp_nvmem_add() if OTP is unsupported")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 16629382a787b..6158452be24d6 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1083,6 +1083,7 @@ static int mtd_otp_nvmem_add(struct mtd_info *mtd)
 
 err:
 	nvmem_unregister(mtd->otp_user_nvmem);
+	mtd->otp_user_nvmem = NULL;
 	/* Don't report error if OTP is not supported. */
 	if (err == -EOPNOTSUPP)
 		return 0;
-- 
2.53.0



