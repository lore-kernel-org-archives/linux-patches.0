Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAA91DFFB;
	Thu, 15 Aug 2024 14:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732455; cv=none; b=f1WTJgaib5BbmOgjgXRWy4EBNHe76/BT1hYPztxUTnUrX/A/ay/DAfVTFlim0cbdFdtO5O6e0wwml3xt3b70oDWplcA+vZN22IyWwFqQK1nRcE8HDSlbtbv6r2rP5U/NQnflTddWlkFk/tRLuVL7HfNiVYYIup+XTueBNK2qvCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732455; c=relaxed/simple;
	bh=Cq0Ry/dZmCRnZtXbzIeuEkoKJOeXmx606Z3uw9rEGO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JCp1RLGm8P6OGmWsPW/vrgnDv4oZx9l+xmPecEt9aiFvKl9x93v+8+SwxrgKmiI1IXTUmK1jP7EBYJ6H+BwaVOQhJASAilKaGiCr/GM1o92YgGJJWXIvGqa9bOPflUNzBqk+yx7dOk2Oo5jFHrjRJrvsABDFuUKVZkdmiQF+lR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7qRQdDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7qRQdDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13C1C32786;
	Thu, 15 Aug 2024 14:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732455;
	bh=Cq0Ry/dZmCRnZtXbzIeuEkoKJOeXmx606Z3uw9rEGO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7qRQdDy+ZW9dgQPsRdMjaL4zo4XSP029FDizVlwloMJb4YTMmyniM1+QBiGPD+go
	 KbTTCBsyJ7NaqNyE9OZMURkQWq+M/rFRlK1u2+kntm0kNPauABuOiCRItieR0/BUvf
	 VGC65UfHCwUapez4kLylNwnRun9xUUBXhkVm+TP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martijn Coenen <maco@google.com>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.10 154/352] binder: fix hang of unregistered readers
Date: Thu, 15 Aug 2024 15:23:40 +0200
Message-ID: <20240815131925.219612282@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 31643d84b8c3d9c846aa0e20bc033e46c68c7e7d upstream.

With the introduction of binder_available_for_proc_work_ilocked() in
commit 1b77e9dcc3da ("ANDROID: binder: remove proc waitqueue") a binder
thread can only "wait_for_proc_work" after its thread->looper has been
marked as BINDER_LOOPER_STATE_{ENTERED|REGISTERED}.

This means an unregistered reader risks waiting indefinitely for work
since it never gets added to the proc->waiting_threads. If there are no
further references to its waitqueue either the task will hang. The same
applies to readers using the (e)poll interface.

I couldn't find the rationale behind this restriction. So this patch
restores the previous behavior of allowing unregistered threads to
"wait_for_proc_work". Note that an error message for this scenario,
which had previously become unreachable, is now re-enabled.

Fixes: 1b77e9dcc3da ("ANDROID: binder: remove proc waitqueue")
Cc: stable@vger.kernel.org
Cc: Martijn Coenen <maco@google.com>
Cc: Arve Hjønnevåg <arve@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20240711201452.2017543-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -928,9 +928,7 @@ static bool binder_has_work(struct binde
 static bool binder_available_for_proc_work_ilocked(struct binder_thread *thread)
 {
 	return !thread->transaction_stack &&
-		binder_worklist_empty_ilocked(&thread->todo) &&
-		(thread->looper & (BINDER_LOOPER_STATE_ENTERED |
-				   BINDER_LOOPER_STATE_REGISTERED));
+		binder_worklist_empty_ilocked(&thread->todo);
 }
 
 static void binder_wakeup_poll_threads_ilocked(struct binder_proc *proc,


