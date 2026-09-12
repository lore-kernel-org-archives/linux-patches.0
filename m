Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505CF2F617C;
	Sat, 12 Sep 2026 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229561; cv=none; b=B2Dt0/I9QtdHaRZwHB/7+04q+CIyA2+fD+QBUBwqk4RADAHMZPQJlKtL5D9AoS7MrHnWXFqf3n5jV5b+P7S6zQFQ/kmkhUnsAvCIryvETgc9yXM9LhHyWDYF1FWeJyqrFzR/D9Ekb71yeQKQWAXOzaunRdVdkHBs8JJerRpA3FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229561; c=relaxed/simple;
	bh=UOtBslfJENuP8x4q5LVNyFL9a2cU86YDyibF3LsabhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gx+k2L81+zkpaCAPGssHlkp7hcDKn5gVlQjGhXm+oUXB6jUJZepj6jy2wcFnRpuNZo0R0EZNcHQPk/CQlJDPHQYUpGVWd6rXkDwP9wZccesgvTZIRbcaN2bV1RYG29mkwHlzaMzSYfnffiAMvCudvrw89uHKyWYV08yYsk2E1oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZFzgfbX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZFzgfbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FFF1F000FF;
	Sat, 12 Sep 2026 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229560;
	bh=bn6UJA1zqCS6ERY6pSKtqUT7WM4YIehk+EQb4TIB7ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZFzgfbXKipgjGUss9FuZBTcUfzVarAE4ffQkbjbuTW4qE9cCKp9fckM8/NjxF/pB
	 684MZjjk4lhLnxJ87LVT/iWGWtmTuFvZhXcbaelCgeDMoxiK/vFX/k9QRTuW7leVdM
	 o2NR9RBV0JRAX1MkNap7AgQZvZz3TlGU/1y+gJno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	John Groves <john@groves.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0616/1191] dax: read holder_ops once in dax_holder_notify_failure()
Date: Sat, 12 Sep 2026 08:55:44 +0200
Message-ID: <20260912065602.088708098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Groves <John@Groves.net>

[ Upstream commit 7ae9d15bdcde0f2955ae13b6a95587f9e23b2359 ]

dax_holder_notify_failure() reads dax_dev->holder_ops twice without
READ_ONCE() -- once for the NULL check and once for the indirect
notify_failure() call. A concurrent fs_put_dax() can clear holder_ops
between the two reads, so the check can observe a non-NULL pointer while
the call dereferences NULL. (kill_dax() also clears holder_ops, but only
after synchronize_srcu(), so it cannot race a reader that is inside
dax_read_lock(); fs_put_dax() does no such synchronization.)

Fetch holder_ops once into a local with READ_ONCE() so the NULL check and
the indirect call observe the same value.

Fixes: 8012b86608552 ("dax: introduce holder for dax_device")
Suggested-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Signed-off-by: John Groves <john@groves.net>
Link: https://patch.msgid.link/0100019ecc09bb56-5ecc9c6b-35ba-44f8-b112-921b01b34478-000000@email.amazonses.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/super.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index da4438f3188c8..d34788813da74 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -229,6 +229,7 @@ EXPORT_SYMBOL_GPL(dax_recovery_write);
 int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
 			      u64 len, int mf_flags)
 {
+	const struct dax_holder_operations *ops;
 	int rc, id;
 
 	id = dax_read_lock();
@@ -237,12 +238,19 @@ int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
 		goto out;
 	}
 
-	if (!dax_dev->holder_ops) {
+	/*
+	 * Read holder_ops once: a concurrent fs_put_dax() can clear it without
+	 * synchronizing against readers. Without the single fetch the compiler
+	 * could reload between the NULL check and the call and dereference a
+	 * NULL ops.
+	 */
+	ops = READ_ONCE(dax_dev->holder_ops);
+	if (!ops) {
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
 
-	rc = dax_dev->holder_ops->notify_failure(dax_dev, off, len, mf_flags);
+	rc = ops->notify_failure(dax_dev, off, len, mf_flags);
 out:
 	dax_read_unlock(id);
 	return rc;
-- 
2.53.0



