Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295C12FF17D;
	Tue, 12 Aug 2025 18:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023957; cv=none; b=O9l+0TARGYjcYM0C6AxPZTQPFtwxWuR200o1GPHYgIJY8fthy0NL8qvO05dTeHjRkhYj7nBQO803bj7KNPwF6zRZIhPeq4Cyrqdsyl/jjPpVcMJjz1j+V6XYy2SCNfGfgXbaDg3SLwFaANj9xruVqAhNL3wP1Jo7iCC/hPjRL7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023957; c=relaxed/simple;
	bh=VaatFkSbL0679VAI+K0ss96AyWLeXuhjVtfYL/Rq8Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ce3QhQzJ44uV2m38292UNKKK7GQw7m7x9RyHJfYph9U1oOteWsalxGxgNe7Gt+MAUk3j5c+9ZS3WKDmnvO6eC8Z8l/M/ziZvIG2HjIUMyfgWOdvpyB1BbaTFTJHbH9GjTC19nCQTcSyt0ojww2EpdPKKO0yIXnByFNe1QmU7uC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6BdA5dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6BdA5dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A877C4CEF0;
	Tue, 12 Aug 2025 18:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023957;
	bh=VaatFkSbL0679VAI+K0ss96AyWLeXuhjVtfYL/Rq8Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6BdA5drs3TcHIp+n3DyOizhyTxKMUZZCjECwey6cfjujBIgragGfrcWR01aWe53q
	 v6I9q2mQB0i00eytszCHzOq0mvSua6eWGRtxTsqFxhcAFfCQiElIo0SE497mYIu08Z
	 tM1WHzROI8G/3sGkaFKJgE0fKlRZ/GZ1aWKhKQmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 231/627] selftests/bpf: fix implementation of smp_mb()
Date: Tue, 12 Aug 2025 19:28:46 +0200
Message-ID: <20250812173428.085233647@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 0769857a07b4451a1dc1c3ad1f1c86a6f4ce136a ]

As BPF doesn't include any barrier instructions, smp_mb() is implemented
by doing a dummy value returning atomic operation. Such an operation
acts a full barrier as enforced by LKMM and also by the work in progress
BPF memory model.

If the returned value is not used, clang[1] can optimize the value
returning atomic instruction in to a normal atomic instruction which
provides no ordering guarantees.

Mark the variable as volatile so the above optimization is never
performed and smp_mb() works as expected.

[1] https://godbolt.org/z/qzze7bG6z

Fixes: 88d706ba7cc5 ("selftests/bpf: Introduce arena spin lock")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20250710175434.18829-2-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/bpf_atomic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/bpf_atomic.h b/tools/testing/selftests/bpf/bpf_atomic.h
index a9674e544322..c550e5711967 100644
--- a/tools/testing/selftests/bpf/bpf_atomic.h
+++ b/tools/testing/selftests/bpf/bpf_atomic.h
@@ -61,7 +61,7 @@ extern bool CONFIG_X86_64 __kconfig __weak;
 
 #define smp_mb()                                 \
 	({                                       \
-		unsigned long __val;             \
+		volatile unsigned long __val;    \
 		__sync_fetch_and_add(&__val, 0); \
 	})
 
-- 
2.39.5



