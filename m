Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51C0361651;
	Tue, 16 Jun 2026 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624636; cv=none; b=l8oaK06KSZL6E1hMzKejKjBZ7S3yiC85rbNCRFSq6zDsjmKMH0uPT/Tua98NamlvzQaQbN84u5kC/bQpr/piqnDVjhfEGxCIEW+BOvDiwwOC5jKx6UF1Daa+4fFCFdZknUuvlFv2ysu12VSrmUaZyAk0CD2v9EgeLvAqRNFyeb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624636; c=relaxed/simple;
	bh=uaUIN5vttVdeNG5BLwbiCOPdrluChIIOeloYcekL5fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeOwwEYJUaMxRu9azwpTlPFJu5jyjJhFJuFhHrKGQOp0Gqoq3SOhO/8xc36JPA0GBxEqpJX6dpIFTAaISg7mHHCKLSSVvQ9cPM6oSFt/vMzxwvFvcT56fKCD/0tSU8SE3/KStgu5RftGmTew7arut9gwj5wn7g3Fj8EbJi3Z8OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtl6Picr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtl6Picr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58081F000E9;
	Tue, 16 Jun 2026 15:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624635;
	bh=r/6xgimjk6SNsUYdusPEOGUG1BmKX6b1zAD9eHkSt7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wtl6PicrX8ljfb+WoaRDCQpFDk99J3XIjkG2raqZAvV0P5k/Gnk9YBIKzs9fFeUNw
	 xv2fuATjOpKqWvCiX0I9XnFoGw7vOWm5FahOvK1RrJ86678oGvPRmKtKE/7ktQsgQZ
	 wnDBDqFlpYMs48Dh7j8JkiB5k75wUHTiGbk+n4+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>,
	Thomas Hellstrom <thomas.hellstrom@linux.intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 7.0 339/378] drm/xe: Clear pending_disable before signaling suspend fence
Date: Tue, 16 Jun 2026 20:29:30 +0530
Message-ID: <20260616145128.038879995@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>

commit 54f2a0442a30fe7a0f6bc8345e81f8b2db8effbd upstream.

In the schedule-disable done path for suspend, we
signal the suspend fence before clearing pending_disable.

That wakeup can let suspend_wait complete and resume be queued
immediately. The resume path may then reach enable_scheduling()
while pending_disable is still set and hit the
!exec_queue_pending_disable(q) assertion.

Fix this by clearing pending_disable before signaling
the suspend fence, so any resumed transition observes a
consistent state.

Fixes: 87651f31ae4e ("drm/xe/guc_submit: fix race around suspend_pending")
Cc: stable@vger.kernel.org # v7.0+
Signed-off-by: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
Reviewed-by: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patch.msgid.link/20260603065217.3131066-3-tilak.tirumalesh.tangudu@intel.com
(cherry picked from commit 4b1ae138b0e103d753773956a84eebc2edbf62c4)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -2760,8 +2760,8 @@ static void handle_sched_done(struct xe_
 		xe_gt_assert(guc_to_gt(guc), exec_queue_pending_disable(q));
 
 		if (q->guc->suspend_pending) {
-			suspend_fence_signal(q);
 			clear_exec_queue_pending_disable(q);
+			suspend_fence_signal(q);
 		} else {
 			if (exec_queue_banned(q)) {
 				smp_wmb();


