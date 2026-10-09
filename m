Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADA32BE7CD;
	Fri,  9 Oct 2026 14:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555984; cv=none; b=U3Oj7+jQyZ41HlqCvmxw6FTTDb37yw4DkRM/FQK1nZAmxVFUU6AoLqg0XcQ+Y+ElMfIun5WvkTpBT20mGJe456CyS0d+uNTznoyENMCemCN+2D43ydD75eALqhaVGaTGQyCEYe0VN/fjUfEnuvOzOv1mmlzBoWfd0iWbby8LzeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555984; c=relaxed/simple;
	bh=uTHbf3Sxg3EzSKdoI9sxOlqwtCqHnJN781amJxNHdds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsC8TPLGXRKeYHJsKdXRW1cKIaBuHUXnneD7/epcDCB1/wOV6CsVd1o/tGOa/dsrXfJnpzEVwPKjYmL9wnxqQYIKXWRItd33feKpfuBu+t6ePPeNsXefpzU6N+J77uNn0OBT8E8t4QCJBzLDxhgSf1MAtfmyp76Ub+GO/fMpOsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJikVV43; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJikVV43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698E01F000FF;
	Fri,  9 Oct 2026 14:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555982;
	bh=UO92HnfbK0uAXV9dvvUEgM2fjfF838VCn/ibjutuyUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJikVV438frTAHDc3SYjkcxaboNTcgWPsic1RPkDZsardvrDtqvCVtNjQfZodcBQ5
	 Xfjxw3nL3T2JGnemeBJfWLBJ2Y5Uq1UuAqQnnWTjk5u/+gnZQRMagrKZ9QjBlnIl2M
	 fLB9HPNopLpykfAnvrMHcgeJxsZITgoHxPpDfnOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomer Pomeranc <tomerpo@gmail.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 149/403] binder: fix leaked fd fixups on TF_UPDATE_TXN supersede
Date: Fri,  9 Oct 2026 16:08:30 +0200
Message-ID: <20261009140955.557069679@linuxfoundation.org>
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


