Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AA6320A01;
	Tue,  2 Sep 2025 13:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819659; cv=none; b=gY7ZeF8RVadfE14hvTKyVL5pk5DiX66ocEgSvePJqn1PxNSN38DYnPblB1noHuIKvPYkUZoc0U28PiNjTp7SFLZ611qzDGNydjScCLVbAgk9YRdQpNj/liJUMo8Emh8TeZJ3i24nrpE8cqo09yFY/tZ8MvEkMx59kkvssEaFEQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819659; c=relaxed/simple;
	bh=PIOZcn5A6eWnxX/57jvY/2rVzurVYxzN8eizpoWAqaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CaGKDD20Y9LNBUlDf8KcTbMq8YH4zFsBOay0MI5nx4HF3slQU5JkLuTyUMXcPJfXlF6ukBBAFj/wnX8s1BWLXa5YLOc5/orMvbMP16bd1CUD8ak6BCgnOK9tlsDrwteXJXdUqKp7y+LxtPzBpW/HSnnLKxesWVoQbBZR1WDMMKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfBpHmp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfBpHmp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65537C4CEED;
	Tue,  2 Sep 2025 13:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819658;
	bh=PIOZcn5A6eWnxX/57jvY/2rVzurVYxzN8eizpoWAqaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfBpHmp7pE/Tfyel16mrZuxihjUs4av1QU18+dDr88P9DUGgwaDPY/Jm3iE6fQUE7
	 fdvZ/lK2WbTriS3Cj6kHSANeph8l7oN9dPPkKdHqXICRL2JwBuXQ2h8DkGeqUBBKbm
	 4lBNjBQb4qWYJ9V/FrMiRwBpKhx85+T7qCFR8qjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Zbigniew=20Kempczy=C5=84ski?= <zbigniew.kempczynski@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 069/142] drm/xe/xe_sync: avoid race during ufence signaling
Date: Tue,  2 Sep 2025 15:19:31 +0200
Message-ID: <20250902131950.903941192@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zbigniew Kempczyński <zbigniew.kempczynski@intel.com>

[ Upstream commit 04e1f683cd28dc9407b238543871a6e09a570dc0 ]

Marking ufence as signalled after copy_to_user() is too late.
Worker thread which signals ufence by memory write might be raced
with another userspace vm-bind call. In map/unmap scenario unmap
may still see ufence is not signalled causing -EBUSY. Change the
order of marking / write to user-fence fixes this issue.

Fixes: 977e5b82e090 ("drm/xe: Expose user fence from xe_sync_entry")
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/5536
Signed-off-by: Zbigniew Kempczyński <zbigniew.kempczynski@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250820083903.2109891-2-zbigniew.kempczynski@intel.com
(cherry picked from commit 8ae04fe9ffc93d6bc3bc63ac08375427d69cee06)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_sync.c b/drivers/gpu/drm/xe/xe_sync.c
index f87276df18f28..82872a51f0983 100644
--- a/drivers/gpu/drm/xe/xe_sync.c
+++ b/drivers/gpu/drm/xe/xe_sync.c
@@ -77,6 +77,7 @@ static void user_fence_worker(struct work_struct *w)
 {
 	struct xe_user_fence *ufence = container_of(w, struct xe_user_fence, worker);
 
+	WRITE_ONCE(ufence->signalled, 1);
 	if (mmget_not_zero(ufence->mm)) {
 		kthread_use_mm(ufence->mm);
 		if (copy_to_user(ufence->addr, &ufence->value, sizeof(ufence->value)))
@@ -91,7 +92,6 @@ static void user_fence_worker(struct work_struct *w)
 	 * Wake up waiters only after updating the ufence state, allowing the UMD
 	 * to safely reuse the same ufence without encountering -EBUSY errors.
 	 */
-	WRITE_ONCE(ufence->signalled, 1);
 	wake_up_all(&ufence->xe->ufence_wq);
 	user_fence_put(ufence);
 }
-- 
2.50.1



