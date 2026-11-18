Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017692;
	b=ArZtICsStRZ/MBdlNjctneteTLOojpsRLNMbolYJ/s3tiu76AgfaYLmfhXujvArEh+/z
	 GNYkpxQd3Y8Uedw6ME4wwCbuSgSglKzx9X/8lIowIQFz0B3JBTyrc2lMmfddYNYz+HQ0c
	 yZTJd4U36ckmDCBTEsgp0a4sz0rVxttDTQMaJObmQMswZeTdMkRQ1Wndf8qcHmQaZuImB
	 6+gWkavkLNW4t9v0qAdCvYIiwA+sKNq0xOyrvK7zyNuH9wZC6lzEuK+C1vMJdHyIDRJXa
	 Bkif6JjtiSkNneswjjIR+2GtgQ+gXgpQvrrY90OChSMsGvQy39sw8s4YkX21nzDMwnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wTQ6yLspDZikrof2zfjb9Lu4igUjxSB9RF2t/NSvAd0=;
	b=VO0IC76FUPGcJnPlQjEms50qEhvIuCL1Goo8iZvrhHHobclBlDFCMBdFAtNUNoo4vfuo
	 xy599rQMPwxL92Hn61hG02oJevrmJG/NqQMmHGlS2Jpi/SBF5nkdsuxYAN6OciClZ4qgb
	 YVMKqPJq4GD+ZdcPH+Vv9wVNkrD6hFrITX1bkpc2plE5KQZwcfMNZCoaibafEnesj37xd
	 2L0R6+zBV4cl+M7ZrlsvEv6IpuXvtkDq1wMdGe/hcvu4Cc+X4S849wOuP+LhYSdmJw/wz
	 ZsbqaSI6Gz0VXrPYusWWh7CrJoK1unD8Y1lZmnRrbt11CzMHFkLsreTLxIR8RDZbbuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vm8B/+XK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F54606A325;
	Wed, 18 Nov 2026 16:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vm8B/+XK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643D61F000C4;
	Wed, 18 Nov 2026 16:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017691;
	bh=wTQ6yLspDZikrof2zfjb9Lu4igUjxSB9RF2t/NSvAd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vm8B/+XKJE7PTyOSPYWndtnkB4Ws431WOfW9FG1Sygc/4TdSq1U6IfHCl0ikncuE1
	 +AAwOuhfPyWle/0MRrpS021ZFBnC+YhaY9ylu9zsd3rPrv3rbP3wTDQgua25m3g0m6
	 MsA7avK36H56OU9RjoEibGCOCp5/p4rndXg66nhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0975/2651] perf test code-reading: Fix duplicate kernel maps and machine leak
Date: Wed, 18 Nov 2026 15:36:55 +0100
Message-ID: <20261118150323.002947206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f0e8ea8754ef5..c50b526f44fb5 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -716,10 +716,8 @@ static int do_test_code_reading(bool try_kcore)
 
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
 
@@ -739,8 +737,10 @@ static int do_test_code_reading(bool try_kcore)
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



