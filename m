Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7D841F5D5;
	Sat, 12 Sep 2026 09:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206555; cv=none; b=m4S0i4zfBWGBPCSwG9CiBL9hjzLcbmloz+dZ2oCdeBOJMnrv1RsxflMHYbYxrmYXVbE7WMAuEaSgAIU4oDC9qatPZfn097L+MuYkVcol81CvVSwVCOfmTzI+b0U5gDUeCfmy1qkifdk61GamBZo+Y0BOvwTlnx6t3r5C7HSplTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206555; c=relaxed/simple;
	bh=HqtrVQjLfLUfImAFBXwxIuX6mp8XJAqROxkrtgDEAeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acdrlD4sPIoEZFD6xS7oK/xw7dSWGp6+E53VAmqpW3tXcE27+Rg3UtdJT9AINioBZEYisQFSY/tEBY6hqdDgUhSV9RG54peqkoiAeRFjLrqiVMkQzUGV2cBuI8agA36VVywEubM8y9jKBFhT3xnpozRb7k363CmQpwTnhaF9xg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+gox6fW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+gox6fW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC9A1F000FF;
	Sat, 12 Sep 2026 09:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206553;
	bh=orYbqGV9LqwTFHpCKhRQ1Bm7cLJR+BrxoeMXK65RAEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+gox6fWHircSC1fVv3GtPVOnz7+/DHkhKlR7QDjf8uSQaeBiI61+5r7x2v0hzokI
	 j7rVV9to5v4bgkMxXVHbPujon16mxFJeoRQNx/Iik2TzaPgUcW/mNu/B4wI++X5D71
	 0grZfJyeNnmMLXfKbouZhI9975pexm3wExWx/NxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hisam Mehboob <hisamshar@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0187/1518] selftests/rseq: Replace glibc-specific __GNUC_PREREQ with portable check
Date: Sat, 12 Sep 2026 08:39:16 +0200
Message-ID: <20260912065627.720749349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hisam Mehboob <hisamshar@gmail.com>

[ Upstream commit d7b2769f8dba3e5f40d2a8a11988812d51160b17 ]

Building the rseq selftests against musl libc fails because musl's
<features.h> does not provide the glibc-specific __GNUC_PREREQ macro:

  error: missing binary operator before token '('

Replace __GNUC_PREREQ(11, 1) with an equivalent check using __GNUC__
and __GNUC_MINOR__ directly.  This pattern is portable across all C
library implementations and is already used elsewhere in the tools/
tree (e.g., tools/include/linux/string.h).

This also allows removing the #include <features.h>, which was only
needed for __GNUC_PREREQ.

Fixes: 886ddfba933f ("selftests/rseq: Introduce thread pointer getters")
Signed-off-by: Hisam Mehboob <hisamshar@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260618193724.589113-2-hisamshar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rseq/rseq-x86-thread-pointer.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/rseq/rseq-x86-thread-pointer.h b/tools/testing/selftests/rseq/rseq-x86-thread-pointer.h
index d3133587d9968..5a29d6bec51f4 100644
--- a/tools/testing/selftests/rseq/rseq-x86-thread-pointer.h
+++ b/tools/testing/selftests/rseq/rseq-x86-thread-pointer.h
@@ -8,13 +8,11 @@
 #ifndef _RSEQ_X86_THREAD_POINTER
 #define _RSEQ_X86_THREAD_POINTER
 
-#include <features.h>
-
 #ifdef __cplusplus
 extern "C" {
 #endif
 
-#if __GNUC_PREREQ (11, 1)
+#if __GNUC__ > 11 || (__GNUC__ == 11 && __GNUC_MINOR__ >= 1)
 static inline void *rseq_thread_pointer(void)
 {
 	return __builtin_thread_pointer();
-- 
2.53.0



