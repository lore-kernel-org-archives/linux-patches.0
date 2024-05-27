Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE29626AF2;
	Mon, 27 May 2024 19:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836542; cv=none; b=GTO2moQmuWwsJJKjIyJV4SJ7J/dhVRn74e/jZSmIAouGfqgPzgqY3ySZExbXx0WnNcMQ79DAsYnCtLPsIDuLHbqkrMZSjCc/yOmihdD4VOeEvPPJCaQ5rduLhkspZi17AMVXztWkVBsTXFm2wMqNlJz3mtUyhb7LKHsLW03bWCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836542; c=relaxed/simple;
	bh=XV3R9ytdJx19jR+Ppar+XzZyzPWixxLIbsniVQnD29E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPOIAmO93/cvHVXf+ERtaNmy5n5yiP+Rje3cB2ucZB1oCHbxAidNxbX4i/HA6Kt8Gl5P3X3p5AfGSib1pWBPyy0IbLjiZ+znSetz0WoggeIF/0b4ASH0LzUo+JjEux/h6s2qIO/HrX4TVZ7Gi3bK1eT49YHGKZ8O/xTNKWa2QsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0GX7u9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0GX7u9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24992C32781;
	Mon, 27 May 2024 19:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836541;
	bh=XV3R9ytdJx19jR+Ppar+XzZyzPWixxLIbsniVQnD29E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0GX7u9KAQLh85OcmNhqDbIa4Z5Ps/wcTB9aYegpWaz8GOhQoylPSK6jYObTLWvxX
	 51kdJYjkYoxKhZNqvOvg4xUfD+THW5roLrkApiWZaiOUY9DNXg0nL8mLJ6QE5h38ci
	 ub0tSOMRIovIeCk8Qr9mp8/PDVNk65oXGurwzN9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 052/427] crypto: x86/nh-avx2 - add missing vzeroupper
Date: Mon, 27 May 2024 20:51:39 +0200
Message-ID: <20240527185606.562470323@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 4ad096cca942959871d8ff73826d30f81f856f6e ]

Since nh_avx2() uses ymm registers, execute vzeroupper before returning
from it.  This is necessary to avoid reducing the performance of SSE
code.

Fixes: 0f961f9f670e ("crypto: x86/nhpoly1305 - add AVX2 accelerated NHPoly1305")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/nh-avx2-x86_64.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/nh-avx2-x86_64.S b/arch/x86/crypto/nh-avx2-x86_64.S
index ef73a3ab87263..791386d9a83aa 100644
--- a/arch/x86/crypto/nh-avx2-x86_64.S
+++ b/arch/x86/crypto/nh-avx2-x86_64.S
@@ -154,5 +154,6 @@ SYM_TYPED_FUNC_START(nh_avx2)
 	vpaddq		T1, T0, T0
 	vpaddq		T4, T0, T0
 	vmovdqu		T0, (HASH)
+	vzeroupper
 	RET
 SYM_FUNC_END(nh_avx2)
-- 
2.43.0



