Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113A04ABBA5;
	Wed, 30 Sep 2026 18:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792071; cv=none; b=Wnb7QZe4wp3s9gsjGTbBUlNAo/k9FO5zXc2wHjZCkXQ2QI7/OsAaK5H/lFxSZfIZJjMCi8IDCd1CI7glMGN3k09t3SXxD59ZSayv8PeFZRBDgvLAUEQGKaobiDZ2Js274KbVkXLnRfVw/p36XosE6LUlUgg+MoK5hdLECxZqYOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792071; c=relaxed/simple;
	bh=qfO73dGxZtMnP3x6OPUJEdGx1++L9H3SPWgvWxszFlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0Eg3rDqZZ8aw8DIiLyWzv5eriCB5hpR7KpyOhYg64oi5FU/iySNf3JfV9lPI27rFqtaSDglGcEopdD5uUo3bH99juG/k1kq+nHJcz2ieMEo5ODcX8rY6v4i/BmPQTC47Z0VqLOHzGvfRxPRBRkg+trD0CiHH7j5NZmVxSQ6cJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seV5cLd1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seV5cLd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600E01F000FF;
	Wed, 30 Sep 2026 18:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792069;
	bh=3v9kBVLv38hav1j6P5T418ept7EFSmsdqlHP3CtpXhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seV5cLd1wIuo5Og2IphtyyiLgBrVPM8M+P7q8kb7O7RI/MyJN0eJzqKdDBiK087Sb
	 CrXWtR7vAk4sZNBjnz02KdPuLLvd6yfuMIdzAmt0eU7ad3WUK0xxrzeiBaibP8X8M6
	 bBIacfARqjNTPej/vB1RPSJpVtK5bfx/Ou6W8KlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 526/752] kselftest/arm64: Fix size of thread_data values for pthread_join()
Date: Wed, 30 Sep 2026 17:26:36 +0200
Message-ID: <20260930152409.635277817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -80,7 +80,7 @@ fail:
 int execute_test(pid_t pid)
 {
 	pthread_t thread_id[MAX_THREADS];
-	int thread_data[MAX_THREADS];
+	intptr_t thread_data[MAX_THREADS];
 
 	for (int i = 0; i < MAX_THREADS; i++)
 		pthread_create(&thread_id[i], NULL,


