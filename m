Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A16BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C4CC4339B;
	Tue,  7 Mar 2023 17:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209445;
	bh=anWK4BZaITy0XSARCu9RwGG+L/gUg3n2076L28i3ww0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nX2KR4RZ96tK6abe514o4SIMA7W+QJUubpvSheWThmnr0t/1lK0jBFwI6F+n3nrAG
	 PjxWXED2pK9n+GyjKFTE2r06kZX/Hc0j4qVPmPSUdKiwdHWd39UvP7tQggtxJBKe5i
	 2EIxduVU9PGOM7dvD/8ZDk4bn5lev5VrALYrSdl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0191/1001] kselftest/arm64: Fix syscall-abi for systems without 128 bit SME
Date: Tue,  7 Mar 2023 17:49:23 +0100
Message-Id: <20230307170030.178011639@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 97ec597b26df774a257e3f8e97353fd1b4471615 ]

SME does not mandate any specific VL so we may not have 128 bit SME but
the algorithm used for enumerating VLs assumes that we will. Add the
required check to ensure that the algorithm terminates.

Fixes: 43e3f85523e4 ("kselftest/arm64: Add SME support to syscall ABI test")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20221223-arm64-syscall-abi-sme-only-v1-1-4fabfbd62087@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/abi/syscall-abi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/arm64/abi/syscall-abi.c b/tools/testing/selftests/arm64/abi/syscall-abi.c
index dd7ebe536d05f..ffe719b50c215 100644
--- a/tools/testing/selftests/arm64/abi/syscall-abi.c
+++ b/tools/testing/selftests/arm64/abi/syscall-abi.c
@@ -390,6 +390,10 @@ static void test_one_syscall(struct syscall_cfg *cfg)
 
 			sme_vl &= PR_SME_VL_LEN_MASK;
 
+			/* Found lowest VL */
+			if (sve_vq_from_vl(sme_vl) > sme_vq)
+				break;
+
 			if (sme_vq != sve_vq_from_vl(sme_vl))
 				sme_vq = sve_vq_from_vl(sme_vl);
 
@@ -461,6 +465,10 @@ int sme_count_vls(void)
 
 		vl &= PR_SME_VL_LEN_MASK;
 
+		/* Found lowest VL */
+		if (sve_vq_from_vl(vl) > vq)
+			break;
+
 		if (vq != sve_vq_from_vl(vl))
 			vq = sve_vq_from_vl(vl);
 
-- 
2.39.2



