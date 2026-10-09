Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4D43431F8;
	Fri,  9 Oct 2026 14:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556492; cv=none; b=YjkyqtcqHixg/CtylYYUagQa4V8IwCkDH9XvmIwq05lj/Yd2Tedp/cfxUKvNvIOo0KaDQyq5EqnECTQeXDuHNYd97wZM6Ryw9ANd1tHeU8x+wZANh8zAazczwHOvclM0sa7rMsd81hw5teAhoAhVywsDztIwjVjvgz7NoOFTdX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556492; c=relaxed/simple;
	bh=rnh9h7DTS4lZL2lpx1nw3fwOzxBNXEPT9vM5Lz4KTdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pk4EOdvRGpQW0ZDBnpjGvZz21BtFdIPYLye4ACLvWoD53fDqnWddYhbgfacwu0GN1qCOvJcYkK27798SoYhzbpa24NdxvKf2TEWakeO/H18DInC8xqr5LsOFNweJdLpmdsQoDi+zXZDwEGBiIEF+eLsRUp3GmCmkJI3VW/EfVrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPTefuC4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPTefuC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F1E1F00898;
	Fri,  9 Oct 2026 14:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556491;
	bh=3lJV/FCFe6/UpE+mxWxOr5iDxx4Km83zUeCsUuvrZ9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IPTefuC4pGMNw7a5stCzy4DEhu9JmtBqUcIz0YeeBQZkeYTX6KjxT+hokN/qmXRf1
	 y6LM6fYrKd4fVqqhlz6iDjXQboqnUx5NPr2ANuYVD8VBXzhU45m0xVfgImWCT4oGqJ
	 d0MK7t8CvFe3r+8iWQkhlDO7G1Pir5z4BRGIKIx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomer Pomeranc <tomerpo@gmail.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 7.2 190/428] binder: fix is_failure flag for superseded transaction cleanup
Date: Fri,  9 Oct 2026 16:08:47 +0200
Message-ID: <20261009140950.315622515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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


