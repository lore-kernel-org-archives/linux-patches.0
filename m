Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5E51F1534;
	Sat, 12 Sep 2026 08:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201448; cv=none; b=F3uqk958nc2S1rOPz9skvR6rkS0OHJFaAS9+YmWEecdg0MgZQP/Xs6Rs2ui8Ug/JiC2mowI4URIcyZNtdpGA42Je7O1jnf43ZQA8xZQdh/D66b8+glc88KJf1NcWLFPnSDwplurXTlspr5YvHGw7uwGmHBxSvHbKiCFMsokkS/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201448; c=relaxed/simple;
	bh=VsANwS4G2Eh54Rw5XzkK3lWO9p++vmLlrvU9nRj2wYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r46ROeWVolrTQ68qXaYRl1c7qdvHnWlOD8feubIQO1t1LX3OZS/TPXSi5Idp5e1biH1ErjN2CtEjBJrcSd1AZU58vg4Ye20xB0w0CIMf7xrpLQJ7TElPT48KEeqtIgjP8EjyPU72C4aNBc8p+TAvWKjjqXLp5S9IA+9OseAT5nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5eT2ppG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5eT2ppG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65081F000FF;
	Sat, 12 Sep 2026 08:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201446;
	bh=yG9DDe5BxetVAXmzYxbXt1uhTR5AuHf3dYi1tHAF8Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5eT2ppGTINWBMCzgJyRhex04ly3tiDN8ezBWXmLCG4YmhyZ7gKf7h+aMaEZ5cTvF
	 yBxAhJYbTtnpYrhUKgY52Z93tgFfivqpChHu+ut9r0/uHV5Ux126EAfIsl3uHx9io2
	 KcJV69G4AabTEWmfhR4w53F7Iz1iezWItE42Gup4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0961/1815] kselftest/arm64: Dont write to P0 in irritator on SME only systems
Date: Sat, 12 Sep 2026 08:45:11 +0200
Message-ID: <20260912065711.531907552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 2b989c411ab98fa76b7bb3b87ba7a2a4c3b5e946 ]

Commit 3e360ef0c0a1f ("kselftest/arm64: Corrupt P0 in the irritator when
testing SSVE") added corruption of P0 to the sve-test case in order to
ensure that the predicate registers were covered as part of the
corruption.  On SME only systems this results in an illegal instruction
since signal handlers are run out of streaming mode and the predicate
registers do not exist out of streaming mode without SVE.  Switch to
entering and exiting streaming mode in the irritator, this will reset
all relevant registers to 0 if they somehow weren't already by the
signal entry.

Fixes: 3e360ef0c0a1f ("kselftest/arm64: Corrupt P0 in the irritator when testing SSVE")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/fp/sve-test.S | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/fp/sve-test.S b/tools/testing/selftests/arm64/fp/sve-test.S
index 80e072f221cde..7ef7835389e76 100644
--- a/tools/testing/selftests/arm64/fp/sve-test.S
+++ b/tools/testing/selftests/arm64/fp/sve-test.S
@@ -298,15 +298,20 @@ function irritator_handler
 	add	x0, x0, #1
 	str	x0, [x2, #ucontext_regs + 8 * 23]
 
+#ifndef SSVE
 	// Corrupt some random Z-regs
 	movi	v0.8b, #1
 	movi	v9.16b, #2
 	movi	v31.8b, #3
 	// And P0
 	ptrue	p0.d
-#ifndef SSVE
 	// And FFR
 	wrffr	p15.b
+#else
+	// Enter and exit streaming mode, will reset all of the V, Z, P
+	// and FFR registers that the system has.
+	smstart_sm
+	smstop
 #endif
 
 	ret
-- 
2.53.0



