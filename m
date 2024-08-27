Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFF817C96;
	Tue, 27 Aug 2024 15:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771736; cv=none; b=rRVuipoHx8ustbkHqSolBz4Lm77Veb7F9s302wYWEtrNuHFkWH3b9zzmoOD047U1UH5Z7C8AkrRJOLBJY9DjV+g504OF9JYiHhDHIK5/JoF9pM/7bs8PPvFDcUn/pwgG3219t1zDVk9CkHcII7DgnbakofGID0t8cRZtdou814M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771736; c=relaxed/simple;
	bh=NYnfVfCQ8Elh8+H0M34oNGS5GJI3J4KE/8xn/AlM09Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rnl1XMd8EejzPsvcpWplVe0WCxohynJyP8+qDYQRKj9/KFLrN3W/XDzwTWQ5yaQIRKzUjo0+Zt9Fmd3u3X5g13j4MMmcTuf1UhhFR8vCGV0VThSqUAHi+wc9/sgWbf0vgS4r+BWJEAx2nXhQlz/1I7+qV8kUv4NCrT07QK28P0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RaYAmR+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RaYAmR+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52971C4AF50;
	Tue, 27 Aug 2024 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771735;
	bh=NYnfVfCQ8Elh8+H0M34oNGS5GJI3J4KE/8xn/AlM09Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RaYAmR+LcRRO94/4fZfsH0FQLpQiC+3UCwlPaQJcMR07tlevpTpdXcLZ1tRVVzA0/
	 4YQ0kPLJRCCuFKk6aPNT4/CtMpeiVDsCM8kxquZ/0KjdBqlIMXSIaOJS8oszCPbfju
	 s/uuC30wTZuKlmwOr/GEnp5TMDbl9rATXej9C07g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.10 271/273] selftests/bpf: Add a test to verify previous stacksafe() fix
Date: Tue, 27 Aug 2024 16:39:55 +0200
Message-ID: <20240827143843.710397045@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

commit 662c3e2db00f92e50c26e9dc4fe47c52223d9982 upstream.

A selftest is added such that without the previous patch,
a crash can happen. With the previous patch, the test can
run successfully. The new test is written in a way which
mimics original crash case:
  main_prog
    static_prog_1
      static_prog_2
where static_prog_1 has different paths to static_prog_2
and some path has stack allocated and some other path
does not. A stacksafe() checking in static_prog_2()
triggered the crash.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20240812214852.214037-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/iters.c |   54 ++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

--- a/tools/testing/selftests/bpf/progs/iters.c
+++ b/tools/testing/selftests/bpf/progs/iters.c
@@ -1434,4 +1434,58 @@ int iter_arr_with_actual_elem_count(cons
 	return sum;
 }
 
+__u32 upper, select_n, result;
+__u64 global;
+
+static __noinline bool nest_2(char *str)
+{
+	/* some insns (including branch insns) to ensure stacksafe() is triggered
+	 * in nest_2(). This way, stacksafe() can compare frame associated with nest_1().
+	 */
+	if (str[0] == 't')
+		return true;
+	if (str[1] == 'e')
+		return true;
+	if (str[2] == 's')
+		return true;
+	if (str[3] == 't')
+		return true;
+	return false;
+}
+
+static __noinline bool nest_1(int n)
+{
+	/* case 0: allocate stack, case 1: no allocate stack */
+	switch (n) {
+	case 0: {
+		char comm[16];
+
+		if (bpf_get_current_comm(comm, 16))
+			return false;
+		return nest_2(comm);
+	}
+	case 1:
+		return nest_2((char *)&global);
+	default:
+		return false;
+	}
+}
+
+SEC("raw_tp")
+__success
+int iter_subprog_check_stacksafe(const void *ctx)
+{
+	long i;
+
+	bpf_for(i, 0, upper) {
+		if (!nest_1(select_n)) {
+			result = 1;
+			return 0;
+		}
+	}
+
+	result = 2;
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";


