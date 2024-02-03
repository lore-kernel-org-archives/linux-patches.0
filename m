Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB4C168C4;
	Sat,  3 Feb 2024 04:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933521; cv=none; b=Hv48uZ46ihGm5S/DKSNDBobbqMFw4DmpUFCldHtU7dr2E3d6g6vmMuiMJJv0qDI3IkmJvJATMIOncZoYBfpIyNe0ddoiz6sihoKTAuKIrq5NT/xy1stX/JYpb1Kbj7AODcz0WiX2FHYhr9totYrPD9tohXUyIoyX1aVGz2w9Dv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933521; c=relaxed/simple;
	bh=qNEJ0eM+xIOh9Gjgql9G2tU3CFqFcZKPPwOnN8nQ7PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjg23tkQua9TW9+ztoO+bRZjMuF5szHQpJhwCxWdBxQ6uLkGAUxeobMPgcZ458ZekBJV17XUhY0aH0oPfo/Q2OlhF/vFx7y0aSECVt3lGbSbCZ4VC3bNUjvqh2LrnaAhYivFfYZVJX0QhvcBC17JY1DMMtSR93J/0YrCYPArBkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ol/P8InP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ol/P8InP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235A6C433F1;
	Sat,  3 Feb 2024 04:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933521;
	bh=qNEJ0eM+xIOh9Gjgql9G2tU3CFqFcZKPPwOnN8nQ7PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ol/P8InPN0fNltOlDBU5x8ZBqHZSxTTNNb+egPsL+VD4bR5ZtOMX03PvEVNKhwcbL
	 NKQxJXyPg4J6Flvlary10DFku3ChKT66tCAxh1MySl4JZetWo8nETlmU/X7E+KvTgi
	 5bTcYQmYm7WNm+8BkdWHMxmdE5Tt8eHabfofDtVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/322] selftests/bpf: fix RELEASE=1 build for tc_opts
Date: Fri,  2 Feb 2024 20:02:37 -0800
Message-ID: <20240203035401.080583480@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 2b62aa59d02ed281fa4fc218df3ca91b773e1e62 ]

Compiler complains about malloc(). We also don't need to dynamically
allocate anything, so make the life easier by using statically sized
buffer.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231102033759.2541186-2-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/tc_opts.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_opts.c b/tools/testing/selftests/bpf/prog_tests/tc_opts.c
index ca506d2fcf58..d6fd09c2d6e6 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_opts.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_opts.c
@@ -2387,12 +2387,9 @@ static int generate_dummy_prog(void)
 	const size_t prog_insn_cnt = sizeof(prog_insns) / sizeof(struct bpf_insn);
 	LIBBPF_OPTS(bpf_prog_load_opts, opts);
 	const size_t log_buf_sz = 256;
-	char *log_buf;
+	char log_buf[log_buf_sz];
 	int fd = -1;
 
-	log_buf = malloc(log_buf_sz);
-	if (!ASSERT_OK_PTR(log_buf, "log_buf_alloc"))
-		return fd;
 	opts.log_buf = log_buf;
 	opts.log_size = log_buf_sz;
 
@@ -2402,7 +2399,6 @@ static int generate_dummy_prog(void)
 			   prog_insns, prog_insn_cnt, &opts);
 	ASSERT_STREQ(log_buf, "", "log_0");
 	ASSERT_GE(fd, 0, "prog_fd");
-	free(log_buf);
 	return fd;
 }
 
-- 
2.43.0



