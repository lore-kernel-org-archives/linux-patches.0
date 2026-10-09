Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA3137E2E9;
	Fri,  9 Oct 2026 14:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555975; cv=none; b=YMwOIAiKgDjZ4WD14MvN2dBLHPUAgHT05G9aSwRv/yfaUW5n/QqnxTTcgXqrAVexISB60b8eSaB5C71uRH7sNCePOSl30vZD1JTWzKC+yUrqetpw2KKYlijWgopBjw5ekN7CXuvngpVmvjzbgo0xkek7jTVDjt5zcDYG/vnSb2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555975; c=relaxed/simple;
	bh=MvdQQ0iV48y/2hNECOXnYgMY3kmoLvcTAWILul+8ZtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fd9APMJSbE84bT6UyX6HwHXO17QCrSXtMaKiBg4bGt4rYmrZ+BpWVpPuNNMyCOFRGb7SAYnKU25oJ4qZSD//eeDzEE4e0/fBvI6OA9v3cbrRNii+SKrJDhYuCpr91vrAmSmWT7fNR9VWc+2eBBQBiqyPB5Z5uAjni5AqQSjmu6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myW2Cqr1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myW2Cqr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B041F000FF;
	Fri,  9 Oct 2026 14:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555974;
	bh=N4HzqI/gygwgsdDxT7abUN8CCjXO+aQEo/Izg/8JtkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myW2Cqr1M6pT4ghrr/mWQGgNTuUgysnPS4UvIMjijZhA8QXmhjmBw8LpKDsG4ecmS
	 KK/AOcnYlv+pgLNN65FB4LCAg3mw8LfeCdEkpdyvXtWwqbGq1XyUcHihBHpYnbamvm
	 E2A3lwUkOA5aDzSeZ4GN8MemJFwX+jenTVwl9cQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomer Pomeranc <tomerpo@gmail.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.18 148/403] binder: fix is_failure flag for superseded transaction cleanup
Date: Fri,  9 Oct 2026 16:08:29 +0200
Message-ID: <20261009140955.533704560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomer Pomeranc <tomerpo@gmail.com>

commit 22c135635fdd9816c0ef140d6de7b2e4fdf73e89 upstream.

When a TF_UPDATE_TXN transaction supersedes a pending async transaction,
binder_release_entire_buffer() is called with is_failure=false. Since the
superseded transaction was never delivered, binder_apply_fd_fixups() was
never called and no fds were installed in the target process.

With is_failure=false, the BINDER_TYPE_FDA cleanup handler interprets
stale buffer contents as installed fd numbers and passes them to
binder_deferred_fd_close(), closing unrelated file descriptors.

Pass is_failure=true since the transaction was never delivered to the
target, matching the semantics of all other undelivered-transaction
cleanup paths.

Fixes: 9864bb480133 ("Binder: add TF_UPDATE_TXN to replace outdated txn")
Cc: stable <stable@kernel.org>
Signed-off-by: Tomer Pomeranc <tomerpo@gmail.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260812195316.259136-3-tomerpo@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2930,7 +2930,7 @@ static int binder_proc_transaction(struc
 		t_outdated->buffer = NULL;
 		buffer->transaction = NULL;
 		trace_binder_transaction_update_buffer_release(buffer);
-		binder_release_entire_buffer(proc, NULL, buffer, false);
+		binder_release_entire_buffer(proc, NULL, buffer, true);
 		binder_alloc_free_buf(&proc->alloc, buffer);
 		kfree(t_outdated);
 		binder_stats_deleted(BINDER_STAT_TRANSACTION);


