Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF9A32E142;
	Mon, 27 Oct 2025 18:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590980; cv=none; b=jVR7ixIabKBe+S9uv7nX6XB7/69zmWRRTiuC9/ArbIfXkjbhpqyzSN/Al9R/JQpPHNsc1EKHfACbbTOFb/VQcTDY8JtjFQULZxET3tSOs+zLph/QsIFfwGcUFMIrKMqeKE/mgfu7JPAWv7HUcZ3rf4NeJhgIQZqAWUpFUJ+zWj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590980; c=relaxed/simple;
	bh=hEGXR8O2KDLvJLTiMUsYitjCZlfXbxIP23PAOs7TFLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtMoli/OPUPBTAoSvpFAioQEDEAP4y0r0uyHbyQdE3+twOYx3Po681HTJbwZekLzSd/rXaL4KYbXVGaYAIzS3kqapOelo/+xHFjDJXKMoKj3N/l160+zFK4qbuGcWL4OSqwofF2fupcNJo6moUhBKxKTdWWPbgPcUgyztKplyys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUsROXfK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUsROXfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AF0C4CEF1;
	Mon, 27 Oct 2025 18:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590979;
	bh=hEGXR8O2KDLvJLTiMUsYitjCZlfXbxIP23PAOs7TFLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUsROXfKQtmex3yqXBO+/p/Omi9g4hVhbagBiEIqFx88wrjtxAOne690QhbDD/4V1
	 MpHNfykyP1pyTKSsSlV/N5/dI7SGLH4ViMFHSarsrdyM0dV9cESYSSs3IJUrRQps0X
	 TB5su8TUndrdea/ytHurZpadWAsdWA5fDS/fk1ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/332] selftests: arm64: Check fread return value in exec_target
Date: Mon, 27 Oct 2025 19:31:14 +0100
Message-ID: <20251027183525.180734659@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>

[ Upstream commit a679e5683d3eef22ca12514ff8784b2b914ebedc ]

Fix -Wunused-result warning generated when compiled with gcc 13.3.0,
by checking fread's return value and handling errors, preventing
potential failures when reading from stdin.

Fixes compiler warning:
warning: ignoring return value of 'fread' declared with attribute
'warn_unused_result' [-Wunused-result]

Fixes: 806a15b2545e ("kselftests/arm64: add PAuth test for whether exec() changes keys")

Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/pauth/exec_target.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/pauth/exec_target.c b/tools/testing/selftests/arm64/pauth/exec_target.c
index 4435600ca400d..e597861b26d6b 100644
--- a/tools/testing/selftests/arm64/pauth/exec_target.c
+++ b/tools/testing/selftests/arm64/pauth/exec_target.c
@@ -13,7 +13,12 @@ int main(void)
 	unsigned long hwcaps;
 	size_t val;
 
-	fread(&val, sizeof(size_t), 1, stdin);
+	size_t size = fread(&val, sizeof(size_t), 1, stdin);
+
+	if (size != 1) {
+		fprintf(stderr, "Could not read input from stdin\n");
+		return EXIT_FAILURE;
+	}
 
 	/* don't try to execute illegal (unimplemented) instructions) caller
 	 * should have checked this and keep worker simple
-- 
2.51.0



