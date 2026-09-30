Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F322C4E73B2;
	Wed, 30 Sep 2026 17:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788593; cv=none; b=t+5Krv1lnmYxEssTHpMVPrL/R9L2vk1uK/7+qCv9r1oip5fbfOMcUtVTCkiH8S/mr4a9ElGeQ19LhTase25nW3sOGzyh/P3cidn9R99s7OzTqDDYJYuQ53pGQM30lmWOJxYtbIBHQmVoZ0giXuKGuSeSKJW5UUhoGmXm4Qh5mFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788593; c=relaxed/simple;
	bh=mblkjXj94WdrkpDdPLwGaniB8oG2thNLh2WGNZWSGTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZwprDoJthBuDkGTVtQCQqyJbw34x/cHhBWBGRdAZam3tAXFqIAuXiFKR8pKUJsb0afQkoeOuR+GKnqWjZz3vgUoxkWIuBhkE9qjAlOeJZhdD7PIHCn0ecEdnFAmzxqZWd9J39jzdT/FHORB7bfChunxckqt4tZ5ZsSHrym8x2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odmbD1JO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odmbD1JO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF171F000FF;
	Wed, 30 Sep 2026 17:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788591;
	bh=im5QJqc0UhflLsKyHffF3qblrMPWZuRmuljkOXl1ZV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odmbD1JOxDIGFQRmF7Q3q9gqab2j3qT6oiN/BmxznPblx+KIBPxlHRVYCDWCXHcdD
	 DAaz0WHXAd6QIHMd44pjMW2HwlFZyDwpkLfQCv/7omJAKoTFkaAwqcKy8Q56n3M3s9
	 pnPSdWrURbshMPrlebgLHfjewefeGoRhze3h0Noc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 179/877] kselftest/arm64: Fix size of thread_data values for pthread_join()
Date: Wed, 30 Sep 2026 17:18:10 +0200
Message-ID: <20260930152418.592453723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


