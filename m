Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3CE38D6A2;
	Wed, 23 Sep 2026 14:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173513; cv=none; b=Ug+jxn6zabZ156y9mAW5NMmzA/CHRSc60RBg4Ub5z2YQ3sDMB29EUoHYCmQR/JmospDc0Ko9c6SbhbUdL0rZ8VnycYMGzFdKzQx53fkm5lqTsfKQCHMgCqVxWruMx7Hc1jflctNn9uhm7bU0jEUqsHzzqA3z9/Uu3STFg3zIoXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173513; c=relaxed/simple;
	bh=9Er12kunufJy0kNoord0HumqhEGsf1Gmr5zL/3NU2wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgCOknx5pl96PVV0eiT+S+T+HRLOAwcBdArkdST2+om/XnjdR00bAhgVPxaO9mGj8UY2gJl4IXqVb2DPGlRYosLZ5YA0w/DsFLNeYC3rzZ15dgQy8obItQCgKHJZY2YoWLY3W3tbDkiL5lTm6B8ZWRyL4U9b3/OBz8qNncNdTow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADSCDDr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADSCDDr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523081F00893;
	Wed, 23 Sep 2026 14:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173511;
	bh=63eGJsLiR1IhmULCAAceorKS4EN4DLyp/kDL5sOgc5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADSCDDr+U40G5nDpSX0F6sIVMyaAr4QJKbrK/Qw+gxb6UvwG98QaD7kIc9QBb/R2r
	 8zi13GrujbkBuRmRPVleChZ8gHlnBeWHOq2h/IUuRnCgi5wtha9kBcMLvmjpk8XMSQ
	 y/n63zxIeHCop+nJtIcARglQsZANIRO2mVAoRGN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.2 270/438] kselftest/arm64: Fix size of thread_data values for pthread_join()
Date: Wed, 23 Sep 2026 16:04:51 +0200
Message-ID: <20260923140651.765899810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


