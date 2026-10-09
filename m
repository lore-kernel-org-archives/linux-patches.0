Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE983D34A2;
	Fri,  9 Oct 2026 14:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556498; cv=none; b=glhuR4t7YBgNGJgypZhKEpHn0HJdbFD1+UsFfpnihJkGl5Cnjh/KLWJXNRXd6gx2d0OuHGDwx8r2yV/4Lyvy+PwXf6BITAn7I3nJBeN6ADI2qKW6kLfPK+Y5g+rxkUYLjSOzAqpSGNNvLigOvWPmZrB2YeBlkHJAjin/WwRfKwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556498; c=relaxed/simple;
	bh=agmgPwAUbtNOcWqDWcjq54FEYPIHfOeWAPNWj0DxzdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DL0gAwl3jW1/zZTzgztbTOIkGzofxNq0IhNejfoQbS8FPkp9pcClAEb1mcGRW1GkXQLLKz+w0kgijnwAEm9qiEBUESkTIzBQIo3rx0OcUQ8RhSnOcOn0wtqSGEfLzkvW60MmIpUCZo3o54FoSwcntVRNJU2dDSZPurknC8WKNcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBJCVWqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBJCVWqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3A21F00893;
	Fri,  9 Oct 2026 14:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556496;
	bh=Fxkp8KrH8oXzRrWyR6iNU2bwVCxoWMdG+10GtDc/XjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BBJCVWqIKmcc1QwpBOlx7jBPk2epgUKvS3PhPbZ1JcA99CC8Z5VQdSv/X6awhG2Fa
	 ROoCmhJR2OigP/E6haTU91pFshroVYiZjEgdGVw4Cf48LmommA1ShPoOIoI4dSXs6r
	 dS6uKm8pMFJGmRYu9aKVHzgvvaIxOIeokrcviqEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomer Pomeranc <tomerpo@gmail.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 7.2 191/428] binder: fix leaked fd fixups on TF_UPDATE_TXN supersede
Date: Fri,  9 Oct 2026 16:08:48 +0200
Message-ID: <20261009140950.337444128@linuxfoundation.org>
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
@@ -2932,6 +2932,7 @@ static int binder_proc_transaction(struc
 		trace_binder_transaction_update_buffer_release(buffer);
 		binder_release_entire_buffer(proc, NULL, buffer, true);
 		binder_alloc_free_buf(&proc->alloc, buffer);
+		binder_free_txn_fixups(t_outdated);
 		kfree(t_outdated);
 		binder_stats_deleted(BINDER_STAT_TRANSACTION);
 	}


