Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9342937A825;
	Wed, 30 Sep 2026 16:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785989; cv=none; b=K1jGp2FqVzHdrRw5QkqNnLnl8euqj3xSC5AEb/ENkLkIIxtXyOmVbPzbPw00i9NDRDKqxocsmHeae2hKr42m47eNI3mMhs1hXA5WwwyrYdnL2m65hgoVmBxX105Zf61HsgYuTWtxycJab6JPo28Cb/wV/xYWQp74EMy1RoEdD1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785989; c=relaxed/simple;
	bh=TKkjWmE4wv9yxuG3rYiRRAmC4uFyUtDlyVbbPKxetnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhrLPTJGZpAS+C5V+MV+CUjr9od0e2lu+AtrKJnD6LU7UPLOIXLVAtQIUngrC5qOyRO5zxWeROmCxYMHq03Pu3t/o4+OpwIb8xa7Slrv6BNm4dvhJKyDebrGXfKM8oYlrwtBnyuy34HpSw34sYMclpJiWI4q1d+TGmCN9JKnp3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KB5TunJS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KB5TunJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB1A1F000FF;
	Wed, 30 Sep 2026 16:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785988;
	bh=CWtkHpbx/8P+/x73Ct4n37N0s2q29r6jnWLh7Th3vBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KB5TunJSmO9ilIZgM/U0Nj7MQyJArcfzAoLQMMFPEt+nWeUR+5fopr50S2MjhvtyS
	 mhqcfg2UlkbigCMRJj5hI9oTZHi4Irs0q1Sy3S6GYF3GZrV6KA1gwo37CY35Gi3cUR
	 Uaw10pSNt1auTQQkNSSwwBo+iw2KXqMl/6tJsqhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 704/982] kselftest/arm64: Fix size of thread_data values for pthread_join()
Date: Wed, 30 Sep 2026 17:24:00 +0200
Message-ID: <20260930152431.879437569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Thomas Huth <thuth@redhat.com>

commit 3d1ba5cbfb622025690c218d8f20da92a9ecb383 upstream.

pthread_join() stores the thread's return value (a "void *", i.e.
8 bytes on 64 bit computers) into the address that is passed as second
parameter. However, the entries of thread_data are only normal "int"s,
i.e. only 4 bytes. The additional 4 bytes of the return value clobber
whatever is adjacent on the stack, i.e. other members of the thread_data
array (which will be re-written in the next iteration of the for-loop,
so that nobody noticed this problem), or another other local variable
on the stack for the last iteration. Use "intptr_t" to declare the
thread_data array entries with the correct size.

Fixes: 29f080881601c ("kselftest/arm64: check GCR_EL1 after context switch")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c
+++ b/tools/testing/selftests/arm64/mte/check_gcr_el1_cswitch.c
@@ -69,7 +69,7 @@ fail:
 int execute_test(pid_t pid)
 {
 	pthread_t thread_id[MAX_THREADS];
-	int thread_data[MAX_THREADS];
+	intptr_t thread_data[MAX_THREADS];
 
 	for (int i = 0; i < MAX_THREADS; i++)
 		pthread_create(&thread_id[i], NULL,


