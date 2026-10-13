Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9F94D98E6;
	Tue, 13 Oct 2026 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894996; cv=none; b=M6f9RWI8o4LFlNeH6uY4Xyj1qMeltYwKk35hWI5mDYvwazWb7WLzlkplf8WFfLe08eHBjjxRtDf3tzy4rfv8aAuT5uH6xq1QrD7kzIvmObOZc7KV7FqsTqejKsu0F2SoFYse0Egh5sB9RP89P6uy07iJfzCAGrqTZVXTCZiyuGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894996; c=relaxed/simple;
	bh=pVA3A7YrxG/XquWbpEJsH/kubsHvvWimqyOMC4pb1ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/ORtgTYzZhCEDmhGt2pXqUYq5QURRX9OO5opmijri6PaSsT+CAZtVEk0kUGSQx+koVPqdgU7/17N9mWqIp++ms4g+zY14Aj/UNW5ektCxkws6OTrEyjEvdr5O402IjGXG+RQPAVGsFwuuVs0885XB08X7a+HeeS/9Nfg0K39nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcWTJKrh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcWTJKrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B801F000FF;
	Tue, 13 Oct 2026 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894995;
	bh=6Ue+NqGkzyWW06NeLK8bmxjzEJVRg6ZGWX2jfwlHZzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcWTJKrhVojPtHa0hvH9jDhDDlbIvXxLh2LMWW54Rk30JP7qwWqzv5nzBSxkIvhga
	 afHrXlDL2KwS+HyOiAZlVaJNJ7lpDVrd/l5ferLedaNum6PG7Z4O3/UQUnKSBsMO7Z
	 lR8tAg+LTvd2rGxZtDftg85IsUgZQQiuF2bz1QsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomer Pomeranc <tomerpo@gmail.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.12 124/497] binder: fix leaked fd fixups on TF_UPDATE_TXN supersede
Date: Tue, 13 Oct 2026 13:34:51 +0200
Message-ID: <20261013112910.834250889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Tomer Pomeranc <tomerpo@gmail.com>

commit c4c02084d6687d5cd5edccaf52cc45e5160f1184 upstream.

When a TF_UPDATE_TXN transaction supersedes a pending async transaction
in a frozen process, the outdated transaction is freed with kfree()
directly. This skips binder_free_txn_fixups(), leaking all
binder_txn_fd_fixup entries and their fget()'d struct file references.

The leaked file refcounts never reach zero, so the struct file objects
are permanently pinned in memory. They survive process exit and
accumulate across invocations until file-max exhaustion.

Every other transaction cleanup path (binder_free_transaction(),
binder_transaction() error paths, binder_release_work()) correctly
calls binder_free_txn_fixups(). Add the missing call before kfree()
in the t_outdated cleanup block.

Fixes: 9864bb480133 ("Binder: add TF_UPDATE_TXN to replace outdated txn")
Cc: stable <stable@kernel.org>
Signed-off-by: Tomer Pomeranc <tomerpo@gmail.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260812195316.259136-2-tomerpo@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2928,6 +2928,7 @@ static int binder_proc_transaction(struc
 		trace_binder_transaction_update_buffer_release(buffer);
 		binder_release_entire_buffer(proc, NULL, buffer, true);
 		binder_alloc_free_buf(&proc->alloc, buffer);
+		binder_free_txn_fixups(t_outdated);
 		kfree(t_outdated);
 		binder_stats_deleted(BINDER_STAT_TRANSACTION);
 	}


