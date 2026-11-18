Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030316;
	b=Fp1QVjlKrfG/vKnnmaEMxAQHI2tf9IjrYdDnEExCyoH4ptJePyKEVOvraXdL7xKfcQnB
	 o/lAN1Vz2ben4eEgUQ0F8dLK91vVgNsUmiKLaljpj/wVfOituZZ5znGKrh2AG4324w5iN
	 WU8fyQpCAsjsoaW27sFnuZHY+Mzc34Ht+rosOJ4CGv0lvWg6h/39Xde7cEnfHArlYHowQ
	 tdrdzXBO5LaYNzmNwmCyXYA7vhr2RgFvOSZAa8sWgYiAERr3sgOgDZ75HzfdCUQOgQIbg
	 GN3F8PVanPnITIdVFLue9iwed7Igj3w7Tu7raq6h4Rc7E8h8TzX2CxdhWuFNRQ+uSsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UGAdRU3c/cduEG5xV2/8bKoiE8wyqTavW7tTG2ysNp8=;
	b=K+FgWJsfnXT5RzHwLPEfN05Lm3Lu28R2RbFbIY3oQ2y4Yqu3A5F2hN0BnOgkJ2F2XHvI
	 LtcCL+Bdknw1s5n9/P4LVoSv6pc2Zq4RBEsR8X0xAyAPCjHoqbbru4kgT/eLiU2OAGCYd
	 hde05rWI2k5O4zSQi5StYkz95pRA4tIk3cK3gfMJSSgeiOXO/eLncpduFMPU/ckFN2O+f
	 CeZth37yconJbRThZH4u8ZYBGnuikgEEQWWNJpYdlwhySGxAs6m30v+tWpYdEiQPnpjRt
	 5eeY9hZKW9NzXsPsADPvVe2G1+LTgwzxKUAQfzDn4WN+QD/TBxBA8ZM41Pq9abnuCVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CHc6Cbaj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D883B606A334;
	Wed, 18 Nov 2026 19:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CHc6Cbaj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA94F1F000C5;
	Wed, 18 Nov 2026 19:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030316;
	bh=UGAdRU3c/cduEG5xV2/8bKoiE8wyqTavW7tTG2ysNp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CHc6CbajyyiA/w9Ox2jjsiX4RULK9big7L8O9RY9C+ThWNIBXjb6tFOQAgGtd6Cqs
	 Jm9KRrQumAgIYAax21UEzsuE3fz/uTqMJ49n45eGLkubGNz3txsV/GqBm/I8ANwCfQ
	 6T637Dq0Yz71JD3dCJltWLDQDwGc1MYq0xdfzkbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0662/1756] perf test code-reading: Fix duplicate kernel maps and machine leak
Date: Wed, 18 Nov 2026 15:46:29 +0100
Message-ID: <20261118150035.400936381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6f89b06cb5432..6a8efa99ddcd3 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -567,10 +567,8 @@ static int do_test_code_reading(bool try_kcore)
 
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
 
@@ -590,8 +588,10 @@ static int do_test_code_reading(bool try_kcore)
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



