Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443A238DC72;
	Sat, 12 Sep 2026 16:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229270; cv=none; b=gumS2CiNI1RGQDbMjTE8gdm2ZPOLKTo8R2xyyjw68hXCrx1tuLtm5gpZao3pawMylv+2VVXYnAik0Xtcq/WKIJwklh5Ic0wJ2kBRyt81u5tj78fNecO7G4qsD28RbBWxJcHb/yr2B4/uvcx9UIa2tJ+hlqsI7f5mWF4G02ERdyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229270; c=relaxed/simple;
	bh=Lzpjzp5LIY3Bhq+uA4gz1LFS4tln9SwR4ZGCKZbVtfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdFsiDvyNSvZOj77Bi45aIzTPkPmlq3HGbvmdTmjsqgpmmY+d0tEaF5dy/VTE4Jl4CRhd/HhhgeWM3u5ag6mvsFu/7Zz+ua8PjU8k+w3joymExqYblL17uXhvgc9pwFt3pKLig+ev1UQ0gFsG1CQTkAMuhEsB2xMPYdPoDX0sFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSbW7ti0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSbW7ti0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36FA1F000FF;
	Sat, 12 Sep 2026 16:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229265;
	bh=inYWV6/csa1E10bJb796ounyghm1TxvnWKcQESsfy7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSbW7ti0UY5sXny64BFOBWDF5t+lqc3jj62JfwW+7ssnWbpA3PjKDCyN7R78eCYIC
	 ywGQ8Vk5Nl+e/VW4AKEpwWnr2B9FyujXAu9Y8zHhWAbhTncAjffuDP0X8Nj1U1Ct/6
	 7VmuVuEYJZSFYKO1TLrugKAN7YBcAk1URNei0vQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hisam Mehboob <hisamshar@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0512/1191] selftests/rseq: Replace glibc-specific __GNUC_PREREQ with portable check
Date: Sat, 12 Sep 2026 08:54:00 +0200
Message-ID: <20260912065559.750546131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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



