Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024735;
	b=unl4urOm/v5Dw22o5JnpcEfx8BudHCeVUv3lzgjZVLKEQt73LBRVHeX+ywj64WatlVSO
	 lIW0oopCIY29gcfwdMcD7UHz2nvDJ+1CGSveT/HcUk7YVwFSFnmcbcNRP7uju6LjeZ7MA
	 +Zttk+lBfXofXlPGguXl/Ry0SSwVq77Xvt+i2HPLc137JgmW6QsAbN+fVi1flL/mbTcJ9
	 lwFB2/BZcajvWOLjtlboaz7Mbtxw8mqVeIlcZcbsAv4LBozV9ATKhsh/VbTpCPaI59xNa
	 mZ57TPd38zbtMWxumTLqF9jN+MddXN5byoLXULIZbf+aXZYqCJQ4kk6rgYUJaNT4EDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6XYXU3kwv87cC0D0xJb5xLXuqLR/K+eKGZJMwM/zgq0=;
	b=b8X+IBCObd8HFpKd5k6tB7Pj9/y+DPd3ICJLrEDnKyLlEGfpJpWXd2hhGLIFcbS+qjl8
	 W1F45lPQNFDx/b1QQwHtYfDy+t7DTad0/HzHPPtmSJmgl9FH2goUxOrb+vYNkHbxk97yl
	 6yYG862YKDV0mXHIUvBg1tQWqSEs7ziNsiNALj0YpsMd6s7La8qqVTgJz52kIhTnEE+bb
	 Tdo0j/gMikeOS4fFxYXhCjTsmpLSSfRXtaYs5VDS0SShLT0qbEchqALZBRoRgLqrUgxU/
	 r9kTShrhrgHVSBZTAQ/ZERv7Ncipnz64M2m4w9T4TC5WDeKcUPzZT9ntPMb4uJWeL1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQe0RWf1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C627460A2601;
	Wed, 18 Nov 2026 17:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQe0RWf1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B87B1F000C6;
	Wed, 18 Nov 2026 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024735;
	bh=6XYXU3kwv87cC0D0xJb5xLXuqLR/K+eKGZJMwM/zgq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQe0RWf1RqezTyudoJGGXWVNq4WXaJYTC176+K3jKJQtoyFZWgqDwhVe7vOwW1pQe
	 4Tu6GdtVm5OASjb7K5AkuDnF1+VXqQrvQE5GedjiAaQw/C/PGuT2MK+1mVJeQS65Yr
	 Swnxs8Ays4msTfglFCmWyaCsv5WF0yZouXT18syI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0832/2151] perf test code-reading: Fix duplicate kernel maps and machine leak
Date: Wed, 18 Nov 2026 15:42:47 +0100
Message-ID: <20261118150152.437270340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 58bf7b7af359d4c6f1af29fd8d2067bbcff1d8c7 ]

In do_test_code_reading(), machine__new_host(&host_env) already calls
machine__create_kernel_maps(machine). Calling
machine__create_kernel_maps(machine) a second time immediately
afterwards duplicates all kernel module maps in machine->kmaps, causing
dso__load_kcore()'s module validation (do_validate_kcore_modules()) to
fail and fall back to /proc/kallsyms.

Furthermore, when try_kcore is true and !have_kcore, returning
TEST_CODE_READING_NO_KCORE directly bypasses out_err, leaking the entire
struct machine, its kernel/module maps and DSOs, all kallsyms symbols,
and host_env.

Remove the redundant machine__create_kernel_maps() call, check for
!machine after machine__new_host(), and jump to out_err when returning
TEST_CODE_READING_NO_KCORE.

Fixes: 0fd4008ed755c52d ("perf test: Use machine__new_host in mmap thread code reading test")
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/code-reading.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 4e759b8989806..5535c58b777d1 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -710,10 +710,8 @@ static int do_test_code_reading(bool try_kcore)
 
 	perf_env__init(&host_env);
 	machine = machine__new_host(&host_env);
-
-	ret = machine__create_kernel_maps(machine);
-	if (ret < 0) {
-		pr_debug("machine__create_kernel_maps failed\n");
+	if (!machine) {
+		pr_debug("machine__new_host failed\n");
 		goto out_err;
 	}
 
@@ -733,8 +731,10 @@ static int do_test_code_reading(bool try_kcore)
 	have_kcore = dso__is_kcore(dso);
 
 	/* 2nd time through we just try kcore */
-	if (try_kcore && !have_kcore)
-		return TEST_CODE_READING_NO_KCORE;
+	if (try_kcore && !have_kcore) {
+		err = TEST_CODE_READING_NO_KCORE;
+		goto out_err;
+	}
 
 	/* No point getting kernel events if there is no kernel object */
 	if (!have_vmlinux && !have_kcore)
-- 
2.53.0



