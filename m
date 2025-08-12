Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBD42F291B;
	Tue, 12 Aug 2025 18:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023045; cv=none; b=V8tKhlck/VrpCJQKfQxXulGUc3RY4a3/EaRzvV8p3uZYZGqcinPDkBlVo+T7DAk4tMrlPQ022HsjHNds56/8S2P817EVawwaK54hY0RM1TN4Q85FDEh0pgQA0Kbjuj3fPTYBFMGRMfwFRBOm/4soWoqN/+9wuMjoVKY1QaFD/r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023045; c=relaxed/simple;
	bh=pjTqF9agWQmiO8hpOXLjDnqhcknoMYuOwD7pucD8q94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWy8D6M1CJ7XCrLTjQL5HtlZX5olsMG2X+Lt/tHCMIRyRCAAzucc3DWQCxCsK06UJNp2ljiFDOOGIlX8Gqchorhihs7O2CsD5b8j1QAEM7gHciI4cU3nDNCeDdpHO8fW+zf1I/sbCpoDan+m2uq+ivW4tCdwH6p2HJb5hKiWUW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDBfgga6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDBfgga6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15BFC4CEF0;
	Tue, 12 Aug 2025 18:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023045;
	bh=pjTqF9agWQmiO8hpOXLjDnqhcknoMYuOwD7pucD8q94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDBfgga6ktQCHN4SxqeHnyiLpvytj1wC4EgwphPG9c9nBzLh9900gpuuCaE6ubDMd
	 0y/iereCTRkSMZfwLpVyzI/QZGZ58ayfdQBh6+RFEV9rCNTDgocBfjdItGqJsF0ARI
	 PhotALBDPyAk1VLHG1XRiGtWRD/Inhwj7I+0mOMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <olsajiri@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Yifei Liu <yifei.l.liu@oracle.com>
Subject: [PATCH 6.12 334/369] selftests/bpf: Fix build error with llvm 19
Date: Tue, 12 Aug 2025 19:30:31 +0200
Message-ID: <20250812173029.272293824@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

commit 608e99f7869e3a6e028c7cba14a896c7797e8746 upstream.

llvm 19 fails to compile arena self test:
CLNG-BPF [test_progs] verifier_arena_large.bpf.o
progs/verifier_arena_large.c:90:24: error: unsupported signed division, please convert to unsigned div/mod.
   90 |                 pg_idx = (pg - base) / PAGE_SIZE;

Though llvm <= 18 and llvm >= 20 don't have this issue,
fix the test to avoid the build error.

Reported-by: Jiri Olsa <olsajiri@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Yifei Liu <yifei.l.liu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/verifier_arena_large.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/progs/verifier_arena_large.c
+++ b/tools/testing/selftests/bpf/progs/verifier_arena_large.c
@@ -87,7 +87,7 @@ __noinline int alloc_pages(int page_cnt,
 					   NUMA_NO_NODE, 0);
 		if (!pg)
 			return step;
-		pg_idx = (pg - base) / PAGE_SIZE;
+		pg_idx = (unsigned long) (pg - base) / PAGE_SIZE;
 		if (first_pass) {
 			/* Pages must be allocated sequentially */
 			if (pg_idx != i)


