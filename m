Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBADA2DFF0A;
	Tue, 17 Jun 2025 16:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176855; cv=none; b=UjLtQOF22HF64+sO6Z0HkPjWI+B6lSffAQt3quiS3WXX8u8yrjIxPy/ZFueQr1cZkCZRXThcCx6SeBaBBbAcqiSkzx/5mkiam0ci/JpjLD+fMH8haSy4r69JhmB47eLhkTKDBw30pXIJqi7DfeBUW4gGrt+yEtj6GdbhvdUOFNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176855; c=relaxed/simple;
	bh=t+YYKOOK8iikaXWTWNH/sTYP94MeJ1EOGb7Oad0X7WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyZsO+57lhuUR2AXRmLyldu67e2QpgK53ChDKE6ujey8V4gCuUW3aAdzDwXFRNVE+g1rtWPGAuLnSfeVxIVN5DxHYpgEOYS3ny02kb5MhZoCi5/+TtBx1bXPBM/14itSUqzX49pMOjzJiOR5FROu8Dt5pxMXI6JIExaM2ZK6cWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSaE2QAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSaE2QAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0B8C4CEE3;
	Tue, 17 Jun 2025 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176855;
	bh=t+YYKOOK8iikaXWTWNH/sTYP94MeJ1EOGb7Oad0X7WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSaE2QAWcIdEGUuGvADwaHmiFJBV1IA3h5wcdjoAPq8FbLagbTbcZw7B2kDlSxl94
	 d2LOZe9BjeI9YuW6flvFYI3z599BzCghpZMxESkXoQ8bGynKTNcYB1BlyeahgvrtCs
	 6yWePLJCblVTPRjnOXKX04pKXh/ew2zwu0dZAHUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"T.J. Mercier" <tjmercier@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 232/780] selftests/bpf: Fix kmem_cache iterator draining
Date: Tue, 17 Jun 2025 17:19:00 +0200
Message-ID: <20250617152500.898977156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: T.J. Mercier <tjmercier@google.com>

[ Upstream commit 38d976c32d85ef12dcd2b8a231196f7049548477 ]

The closing parentheses around the read syscall is misplaced, causing
single byte reads from the iterator instead of buf sized reads. While
the end result is the same, many more read calls than necessary are
performed.

$ tools/testing/selftests/bpf/vmtest.sh  "./test_progs -t kmem_cache_iter"
145/1   kmem_cache_iter/check_task_struct:OK
145/2   kmem_cache_iter/check_slabinfo:OK
145/3   kmem_cache_iter/open_coded_iter:OK
145     kmem_cache_iter:OK
Summary: 1/3 PASSED, 0 SKIPPED, 0 FAILED

Fixes: a496d0cdc84d ("selftests/bpf: Add a test for kmem_cache_iter")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://patch.msgid.link/20250428180256.1482899-1-tjmercier@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/kmem_cache_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/kmem_cache_iter.c b/tools/testing/selftests/bpf/prog_tests/kmem_cache_iter.c
index 8e13a3416a21d..1de14b111931a 100644
--- a/tools/testing/selftests/bpf/prog_tests/kmem_cache_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/kmem_cache_iter.c
@@ -104,7 +104,7 @@ void test_kmem_cache_iter(void)
 		goto destroy;
 
 	memset(buf, 0, sizeof(buf));
-	while (read(iter_fd, buf, sizeof(buf) > 0)) {
+	while (read(iter_fd, buf, sizeof(buf)) > 0) {
 		/* Read out all contents */
 		printf("%s", buf);
 	}
-- 
2.39.5



