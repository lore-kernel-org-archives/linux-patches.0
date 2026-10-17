Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D654D3B9DAE;
	Sat, 17 Oct 2026 17:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256471; cv=none; b=fFlWYOCP9S2jwKASv2c83Y2kK1VOzaSxF1OGfC50vkItVtwI4M+3DeGEZpqFOwhdBm1F8KaydJzaoGFo35m/qSJ7P1JTgcAmZFzwwUddm1yQSyd5a5fNGymOWakqtm90PFVwcnYFGmovoZEM7eAitidFHOU+49KLrrmQTXYGdGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256471; c=relaxed/simple;
	bh=VQd+yMOZsdVFuqt849Hz/mn5vTbJ96vVSyYJ5j2AePk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=damYQ5QQr6WdvCpU8z/tocd0QSdjiXiIObPacIIsnQbVdsmr4H4yteDwijYKBuIdefvc5ynO34BQ5833uWTxKmx7hw/EF/S+WI+mnt7kJXKxQV2SdQyCmyjTiZzhO01e7v51L4RdDfBiQ3eh0RzBm/A4agHiKuGxa9XV9ta/slA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0Mi+PJK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0Mi+PJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116151F000C4;
	Sat, 17 Oct 2026 17:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256470;
	bh=e1wqBR51pToTW2V+a6hDWDkxTj1DhLSygbCXkFIi7Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0Mi+PJKSdNy/mzfK+p1HBBLu9ihw9Yk4uO40sJxypxyPZ3KPFcXVMetzKL4IZwn9
	 6mkRj3hC0XvMYeD09KLt0pp5Vrl6rR77zTh+wWzMFYkU/De5xkVWijRWQbokjFu6Qf
	 i5wrQ/7Wh2vh4YqQtfp1OLtNB6XvBuDnXtKNpKBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomer Pomeranc <tomerpo@gmail.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.6 0245/1674] binder: fix is_failure flag for superseded transaction cleanup
Date: Sat, 17 Oct 2026 17:41:57 +0200
Message-ID: <20261017160437.418115569@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2839,7 +2839,7 @@ static int binder_proc_transaction(struc
 		t_outdated->buffer = NULL;
 		buffer->transaction = NULL;
 		trace_binder_transaction_update_buffer_release(buffer);
-		binder_release_entire_buffer(proc, NULL, buffer, false);
+		binder_release_entire_buffer(proc, NULL, buffer, true);
 		binder_alloc_free_buf(&proc->alloc, buffer);
 		kfree(t_outdated);
 		binder_stats_deleted(BINDER_STAT_TRANSACTION);


