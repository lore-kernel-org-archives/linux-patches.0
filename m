Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC6B17744
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4C4C433C9;
	Wed,  9 Aug 2023 11:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581391;
	bh=vva/hb3ixTg8jmfM+Plf+S54kvTGNDLdObk1XvjQAZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvC3TcJXf9N+ZPlHM8f2uIqSq+1/940h0ARYZW2ghxHK8fxjZ2LmULPI5PavxTgTI
	 WRYJMeRO2YP2nA7YBnWpt+3MFluA9lNymhndtahuy8Y0ubc6fO6MhEGC+lm/KGtW56
	 TKbIWGbK2rYoK0aQMiR/Nze9sOWFXBJ43016z650=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Jeanson <mjeanson@efficios.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/201] selftests/rseq: check if libc rseq support is registered
Date: Wed,  9 Aug 2023 12:43:08 +0200
Message-ID: <20230809103650.035035772@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Jeanson <mjeanson@efficios.com>

[ Upstream commit d1a997ba4c1bf65497d956aea90de42a6398f73a ]

When checking for libc rseq support in the library constructor, don't
only depend on the symbols presence, check that the registration was
completed.

This targets a scenario where the libc has rseq support but it is not
wired for the current architecture in 'bits/rseq.h', we want to fallback
to our internal registration mechanism.

Signed-off-by: Michael Jeanson <mjeanson@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/r/20220614154830.1367382-4-mjeanson@efficios.com
Stable-dep-of: 3bcbc20942db ("selftests/rseq: Play nice with binaries statically linked against glibc 2.35+")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rseq/rseq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
index 986b9458efb26..4177f9507bbee 100644
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -111,7 +111,8 @@ void rseq_init(void)
 	libc_rseq_offset_p = dlsym(RTLD_NEXT, "__rseq_offset");
 	libc_rseq_size_p = dlsym(RTLD_NEXT, "__rseq_size");
 	libc_rseq_flags_p = dlsym(RTLD_NEXT, "__rseq_flags");
-	if (libc_rseq_size_p && libc_rseq_offset_p && libc_rseq_flags_p) {
+	if (libc_rseq_size_p && libc_rseq_offset_p && libc_rseq_flags_p &&
+			*libc_rseq_size_p != 0) {
 		/* rseq registration owned by glibc */
 		rseq_offset = *libc_rseq_offset_p;
 		rseq_size = *libc_rseq_size_p;
-- 
2.40.1



