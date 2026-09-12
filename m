Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82678246BCD;
	Sat, 12 Sep 2026 10:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207361; cv=none; b=bxrhpQlIGJVpZz8TYxNjLwCTnj1Tdc6Di06hYa8mHQ4kQEl5648EtjQ/IIgRz5mLS71EQY86f3wey7XfiAbzph3rzaJYlEmsTKtygnHY37W/1bGsF5XQxj8LXPo80iXNJO7gja1RhOqMosEIIqemgmeuRboVNgyjXElFJ8hNkjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207361; c=relaxed/simple;
	bh=L0KD2VO79GCp+3w2DtCXHv+0CSJexf0N/RCFIs9ABoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EO2vPYznQcMIneoKUHrcG4Q1J0EL2gV+MesFYludGF00UA66j26mv5mCW77K9Rw2eS/LlcbIbBLCgrWCbqWuhzSI/kZxHsl9PieJm8tGuiJ9vrtghnomXJiNVTI90ht5vWxWubahfg21tCNKWzgdP0MP9yN33otVrxL/ZMz1l+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5vRucKr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5vRucKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3240F1F000FF;
	Sat, 12 Sep 2026 10:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207360;
	bh=fK7i0SPuxpFo+9NL8jvEjsCxVuoJ5mvK2xcI+Xq6sLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5vRucKrsilXq0tatJcltP86/XwqBco07jeDPoUILAJzhGNpgJssDR9xGzIxBKznW
	 xj97wOnOFcL1fvtoKmanxxsKTE1x3PIfr/TNRSPvU/G55D0x8HcjEENGZIiz0o09Pm
	 LGznYra90pV9GzRVBbPx+lRE5trizG7mjLA8p7jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	John Groves <john@groves.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0396/1518] dax: read holder_ops once in dax_holder_notify_failure()
Date: Sat, 12 Sep 2026 08:42:45 +0200
Message-ID: <20260912065632.416383599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index d7714d8afb0fa..efa5f61860190 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -232,6 +232,7 @@ EXPORT_SYMBOL_GPL(dax_recovery_write);
 int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
 			      u64 len, int mf_flags)
 {
+	const struct dax_holder_operations *ops;
 	int rc, id;
 
 	id = dax_read_lock();
@@ -240,12 +241,19 @@ int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
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



