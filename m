Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFB12D0C94;
	Sat, 12 Sep 2026 07:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198633; cv=none; b=WddCm+848CaAi4YokFPi4T7g59rh+QqEhDXpiYkMY02ewrxub5w9Nazn4NX0iJCCgwzyr2YIg3pD/LBD02rNukGZ0q9vEpOZrIri2KsH3lWU3HfM3zKutHgzZWqRx8D56eBXgzzMSltSwbWQWBjlwQAeRkwDoE7OG1R5NycmrPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198633; c=relaxed/simple;
	bh=gyn7sTNhwjgK1TVFMAVOhq+ctpEbq5C+z6OpQgF5Hf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3RFwD/9yUO50b4BL3iaL+YBsJO9ktnMS9nzzAqBCTV2YQDwg6q4QoOo8ArfR/ifELlUxKCV9zuCbNtaBNLvjljdrcOkDOoJ+snDMLIZdnfG/0v8vYOvxCfdW3UBLmTXiBzoCSTfCMcsGO1DLhyzxZIgWd4HkIQj7+9KN9D+yPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yhgs3CvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yhgs3CvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950131F000FF;
	Sat, 12 Sep 2026 07:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198632;
	bh=HQqYlXkivgPEDSkIPiQu0E6rqdXDqCLl2ctAnqphK8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yhgs3CvFYD7gQj9kc2QlmATyEzUk+Fr2XAzqTxyhDobml1oLZSfQ4xgFIxahLSOJC
	 9EOM5pSNqjxs8rvaYaWYrtP3D2bUv15T7Ja0DqNWHtAO3MeEI8CDjNJ/aZirVUiXoq
	 SuWT/Yum3Jd9Wfuaz716n+KmkgrPVsJScWmmDV7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	John Groves <john@groves.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0422/1815] dax: read holder_ops once in dax_holder_notify_failure()
Date: Sat, 12 Sep 2026 08:36:12 +0200
Message-ID: <20260912065658.801337028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 25cf99dd9360b..433cd431a6c06 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -303,6 +303,7 @@ EXPORT_SYMBOL_GPL(dax_recovery_write);
 int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
 			      u64 len, int mf_flags)
 {
+	const struct dax_holder_operations *ops;
 	int rc, id;
 
 	id = dax_read_lock();
@@ -311,12 +312,19 @@ int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
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



