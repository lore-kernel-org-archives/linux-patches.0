Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4ED19E825;
	Thu, 15 Aug 2024 13:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728790; cv=none; b=TV3VNN5YWP4Q2yWlkwDoB6w364FdW7yHwwJvvxJC3mnLaM+Pr5DxTsBoMbkHTvn3BNrk8oaqkC8tr3/1BNEgx2DeJpcdJXv05q8TH5ZmKVccxhoS6GrkyrbngsqeHxHUVl9yhClT5xT07OUlUc/sBjG54LE1KCxqB7BfxlhlosE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728790; c=relaxed/simple;
	bh=TNKyA5eiVsn4Ff3JKqxy8yjU0D4jF8zWolKfuTQRbtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NuFXTBkVExF1K+yh0Exeyvv1DHDk4CC4dX94vtu6oLGfRgC5Sc1wjLCbkgtGP+eHvf7VU/kpspdMtkoHGwS8+vedd3zPu9S24uW/m/JDZKqvt0WCe0BRPu0+DViUZCDG5xvhtqQskLAh5zKULDSpJA2XbFP+OayK52wriw+jJIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qana+M1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qana+M1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7714FC32786;
	Thu, 15 Aug 2024 13:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728789;
	bh=TNKyA5eiVsn4Ff3JKqxy8yjU0D4jF8zWolKfuTQRbtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qana+M1qAI1vPHLQQNpi2J5pKHiZBPIz9/rKVasnyVY7H/aZmYf6f27LL2tM/AyfG
	 QZLGLqYRRsBL/NHLV2hwgiqagFJZsCNiNILU9rGIQt840PH/qDcvHg8o22cBUmLbUR
	 bsYZ/OOpA7B+ZB4OjPrFEHvF5PpE4Ql8RMtF22q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martijn Coenen <maco@google.com>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 4.19 079/196] binder: fix hang of unregistered readers
Date: Thu, 15 Aug 2024 15:23:16 +0200
Message-ID: <20240815131855.098603776@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -998,9 +998,7 @@ static bool binder_has_work(struct binde
 static bool binder_available_for_proc_work_ilocked(struct binder_thread *thread)
 {
 	return !thread->transaction_stack &&
-		binder_worklist_empty_ilocked(&thread->todo) &&
-		(thread->looper & (BINDER_LOOPER_STATE_ENTERED |
-				   BINDER_LOOPER_STATE_REGISTERED));
+		binder_worklist_empty_ilocked(&thread->todo);
 }
 
 static void binder_wakeup_poll_threads_ilocked(struct binder_proc *proc,


