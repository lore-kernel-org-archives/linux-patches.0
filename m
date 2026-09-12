Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC94633E35C;
	Sat, 12 Sep 2026 12:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215513; cv=none; b=TKbmT1c8Qhhq40t6gSHENxKfeTxa5PrlPmvZpIHHwa5WSsH1uyZSjW6EnMerNpkLWDdLJC2h3ESmR1wr7PNfMG0pjCfA3D6TtQRpeymhpp4DA8n0zGwnz6OW28E58Yk0lA9uoJuFLDj1kiZoennfwAEV3H/O6dEFZGd1uSh9L/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215513; c=relaxed/simple;
	bh=AOR57x7EgPq9LnBe72J6revMM6f0WhK2Yw8UjulBae4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfV2h+/03zd3YwSCWyNmS4kcMExAq4tMiWa/ZIUC7F2jcN/4PXOGsHbQ0uP2K6Nf+koDRrsV5GnU3LwJJ9KvgoDMc2PQb4nLrkvH1HvE6rh8aAoDioSe+uNB+Dg7G+Gy273px0bC1Jfn73V6o2LqClPsKMc3kjZNzVIkvKXgdls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MssswseY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MssswseY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024B11F000FF;
	Sat, 12 Sep 2026 12:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215512;
	bh=6sv+higebyZG7l9T9HAb3jfnecJFmem0KW3Pd+JDiTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MssswseYqiRx0qYXxGCgP8VsYxJm4Wru6kZfWjT8o0TtNknNe9OfO1PWzafmQBabq
	 uW5hAE5C/+/VzADkw94FMbJa6nwstyMMNFVxF2igWbOeDZUeOlNA1wR2MMAzKqHsuk
	 KqW/Fwz+cqNn4SwwaExdpfFCQb8q9CsutXlL6RDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	John Groves <john@groves.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0546/1376] dax: read holder_ops once in dax_holder_notify_failure()
Date: Sat, 12 Sep 2026 08:49:32 +0200
Message-ID: <20260912065619.708890414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e16d1d40d7738..6eb7ecd233840 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -233,6 +233,7 @@ EXPORT_SYMBOL_GPL(dax_recovery_write);
 int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
 			      u64 len, int mf_flags)
 {
+	const struct dax_holder_operations *ops;
 	int rc, id;
 
 	id = dax_read_lock();
@@ -241,12 +242,19 @@ int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
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



