Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C3A37BE77;
	Mon,  9 Feb 2026 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648369; cv=none; b=adSgvXEDTXw7STUTh6V8ZZR8VKXcSNVjpOiBFOC1v3HdFk72REKkeu4D4rLe27E6jsJX+YhoLI0c15NQ42yxCfdvlHOuwNLxLVNGIr3oycaz18B8OBdtx/CSFqIlmLe9ZLJ5lnVenBFXQtgIjpQsQ48yuC9rXORGHD8lunocnAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648369; c=relaxed/simple;
	bh=B17VxzZX1998adQMWqIWQVC3288Vv09AzJB++q++u+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEOEj/O5oC45BqUAZOtdGZ0q3rfv76jr5nGNIWf9ovgtygBZ3ENRO4HT3+njKUVgANGVR2WbYWTkXopceM+tNTTTB0WHHM06XXsASqyuKFMIijBOtlq8rvdi9YTlsPz7RCSPEGBqHQzPPZ1shBQnxQ5ajBB59Qq+adootG4G+Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mejJR+1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mejJR+1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C98DC19422;
	Mon,  9 Feb 2026 14:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648368;
	bh=B17VxzZX1998adQMWqIWQVC3288Vv09AzJB++q++u+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mejJR+1/PsYIyJVCVU061lGx+WN+Je0Kbzy77jbNLMu8jTxNo0oaIkcwmM179+zff
	 FLfnQ1zeh3V340+i7DKJHK5tDx7yjvOdIc/qe+RsfPlM/y8Pt6KNyssJl0PDIsnkyb
	 mM0E1RxWnQM5tMIHVSm7Xql9+4GZiV42Lf8UPpIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Steven Moreland <smoreland@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.6 17/86] binder: fix BR_FROZEN_REPLY error log
Date: Mon,  9 Feb 2026 15:23:40 +0100
Message-ID: <20260209142305.397359451@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit 1769f90e5ba2a6d24bb46b85da33fe861c68f005 upstream.

The error logging for failed transactions is misleading as it always
reports "dead process or thread" even when the target is actually
frozen. Additionally, the pid and tid are reversed which can further
confuse debugging efforts. Fix both issues.

Cc: stable@kernel.org
Cc: Steven Moreland <smoreland@google.com>
Fixes: a15dac8b2286 ("binder: additional transaction error logs")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260123175702.2154348-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3663,8 +3663,9 @@ static void binder_transaction(struct bi
 	return;
 
 err_dead_proc_or_thread:
-	binder_txn_error("%d:%d dead process or thread\n",
-		thread->pid, proc->pid);
+	binder_txn_error("%d:%d %s process or thread\n",
+			 proc->pid, thread->pid,
+			 return_error == BR_FROZEN_REPLY ? "frozen" : "dead");
 	return_error_line = __LINE__;
 	binder_dequeue_work(proc, tcomplete);
 err_translate_failed:


