Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08DF3B83E1;
	Sat, 17 Oct 2026 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256474; cv=none; b=PntLDm3PlK23LFEulZ5AdjMc4dnYt9jeUHCwrKH+uopnBF4ylKb2SBGOjxA1H7hOzpWqnOzdDax8T8Z+D3Tj/ap7ZfO/qpUZBO5O0NgWIjJcym3q8S4uaI61jN7vc+1jAHocecDu9k45Gb+FOLTIzy7/1IiPCLf8YayN8Wa9oOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256474; c=relaxed/simple;
	bh=tWOVf3jux/p6TNbkOeyg7pJllJ7levDJ9RBUOUJ15Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OovHt6Sx+19cEao2TjIjjTzOdY/dX22XFIFp7c/IGJ0AVp1QM88bwlAoMM3Tb42QAPP1fPPfg695Eb2fF/6uvGhvzCa/d5wlwygvOLjOJkqZroIDnFtFzgK4KQOL4GL0RGIf6poCFUZPe559X2A33osMQhodFJjonKWTl7+LEbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUIdSLyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUIdSLyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B1A1F000C4;
	Sat, 17 Oct 2026 17:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256473;
	bh=j+PJM/xX7WYc90nAwvbdGO0mf22jD9uwAdKLyKEDHJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUIdSLyl3k5HLk1+fXVRH1DYvz3SJBRxBSqO2nKk/htEj6KxcQnmdDbybeXb5h2FK
	 BbFsr6zquKRF7QMSTc6YBPRBw0ndv2lHbNIG0IMsxoP2hI9S5s1Pb1ovDodhrAASVi
	 01dZuam/CzZFXUrCm67Kup4iiFeHAWetx8xL1cWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomer Pomeranc <tomerpo@gmail.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.6 0246/1674] binder: fix leaked fd fixups on TF_UPDATE_TXN supersede
Date: Sat, 17 Oct 2026 17:41:58 +0200
Message-ID: <20261017160437.444909372@linuxfoundation.org>
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
@@ -2841,6 +2841,7 @@ static int binder_proc_transaction(struc
 		trace_binder_transaction_update_buffer_release(buffer);
 		binder_release_entire_buffer(proc, NULL, buffer, true);
 		binder_alloc_free_buf(&proc->alloc, buffer);
+		binder_free_txn_fixups(t_outdated);
 		kfree(t_outdated);
 		binder_stats_deleted(BINDER_STAT_TRANSACTION);
 	}


