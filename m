Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F211ABEBB;
	Mon, 14 Oct 2024 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917362; cv=none; b=apCJUp8FGYhTnb0H44HSDJ6jEWo5u/ZjOYuEccYAO4AInfuXELs4pAqc6oVAzEYKQ3d0Z1mrKxhmPVftuJgtlhrCQ/9WdGf4/IpS84aNRkIwdcqFZYWQTMGznoLRuzx+3UaLKbpZx/XdcLc+wOmbBUGL2Ujwvj4F3LlL/zXUnyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917362; c=relaxed/simple;
	bh=MyIdi8X/V1k8jC2NDyZVyarS9q3Oqsf5kBJpBzgX1O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MP3ilYK8rWXWTjf4HXhw2fJ6U8w5IxUAW3l8RzDG4CE/H7N1041hg7gx2gzh1Ke+g0pn1B0aicKn2KwzsjUvOuCjZkpnO2Joho0i2hoU3YY3Bp2aKA64FvyaIsnfLVDDcP/ZNX6zTFX0l88dNhL8FGow1BZcQc4n3J9tg7S8/oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2XkbJEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2XkbJEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C85CC4CEC3;
	Mon, 14 Oct 2024 14:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917361;
	bh=MyIdi8X/V1k8jC2NDyZVyarS9q3Oqsf5kBJpBzgX1O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2XkbJEeLPBxiW5ZJZmxVSupYQssh+/hdkIdgJsweM7Vizx6oSvWoiuNWGufgQH8J
	 c4fnzPub5jC1k5BDTAVJkRp9NeQd6onXJGv5j7zKTqUE2PdweIh2TNlbiEsuAGt7YE
	 kK6W4g0HOiBEs/Zc0wunurF7RYjyBNM60yeHvRYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/798] kselftest/arm64: Fix enumeration of systems without 128 bit SME for SSVE+ZA
Date: Mon, 14 Oct 2024 16:09:29 +0200
Message-ID: <20241014141218.549283562@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit a7db82f18cd3d85ea8ef70fca5946b441187ed6d ]

The current signal handling tests for SME do not account for the fact that
unlike SVE all SME vector lengths are optional so we can't guarantee that
we will encounter the minimum possible VL, they will hang enumerating VLs
on such systems. Abort enumeration when we find the lowest VL in the newly
added ssve_za_regs test.

Fixes: bc69da5ff087 ("kselftest/arm64: Verify simultaneous SSVE and ZA context generation")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20230131-arm64-kselftest-sig-sme-no-128-v1-2-d47c13dc8e1e@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: 5225b6562b9a ("kselftest/arm64: signal: fix/refactor SVE vector length enumeration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/signal/testcases/ssve_za_regs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/arm64/signal/testcases/ssve_za_regs.c b/tools/testing/selftests/arm64/signal/testcases/ssve_za_regs.c
index 954a21f6121a2..1f62621794d50 100644
--- a/tools/testing/selftests/arm64/signal/testcases/ssve_za_regs.c
+++ b/tools/testing/selftests/arm64/signal/testcases/ssve_za_regs.c
@@ -34,6 +34,10 @@ static bool sme_get_vls(struct tdescr *td)
 
 		vl &= PR_SME_VL_LEN_MASK;
 
+		/* Did we find the lowest supported VL? */
+		if (vq < sve_vq_from_vl(vl))
+			break;
+
 		/* Skip missing VLs */
 		vq = sve_vq_from_vl(vl);
 
-- 
2.43.0



