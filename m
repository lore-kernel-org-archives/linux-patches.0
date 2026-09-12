Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED29832D7F8;
	Sat, 12 Sep 2026 18:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237405; cv=none; b=RzSHj474IPNUsA/2HE/b+b/wLSi14CX1GeI0z9QDr4ICQU8JDBhNaZTim8UcrHwN1kwFVBf/IM7mPuJ40KNDYfhRJScoA9aTSJZSl4wr5oXQ42znAfZC/JsGq132UvbsB5gZlpiG55DYoZ86PurPUJCSqmP2dnBwzvs6JbJ1Cds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237405; c=relaxed/simple;
	bh=wBM2j/S0WzOb3i+VJKknJaowhASOBAcEb9NdK+CHwuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEa2TkqqI4frCS5tIQsFUY5BMZVI6nLUlK31HNgzYRLhVF4K5l1ma5LwYt2RjnvrRff9eKOwpoUTDdkX3Q5/u9FMXS7eDRwCylnZv0NWoDU0kBL6Wt2aTc9JQgvDxXJfBHUP8+NKPwxcllKK//CErYFNNbHqNYx0edKsJwNenPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ni3hlARA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ni3hlARA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2F61F000FF;
	Sat, 12 Sep 2026 18:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237403;
	bh=98716LJR5juQuVeldlJgSOFRXbix6fhzrj38+3Bxak4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ni3hlARA/Hq+C4aj3xVXRaHu+V1/zCxE+P/yCaj/EGob3g8l5IipGvg+WP1teDfqg
	 NT08MglCkBbsCltXHuJS14yf8k9z4z4CLmBzvGwJvyug6sRcLdfuMak0P9q4wYYe3B
	 hr0v0cnK01spK1WB4PYl7+Fb5RSccfI4firw2FjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 251/935] dm: fix resume-vs-remove race
Date: Sat, 12 Sep 2026 08:54:41 +0200
Message-ID: <20260912065532.582903582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 44b43ec132f1cf3275ecc182d0c82f50c3c4c3d5 upstream.

If the user issues the resume ioctl and the remove ioctl at the same
time, it may be possible that the device is resumed after it is suspended
in __dm_destroy. The result is that the table is destroyed without
calling the postsuspend method.

Dm targets expect that they may be removed only after the postsuspend
method method was called. If we break this expectation, it can cause
misbehavior in various targets. For example - in the dm-integrity target,
the reboot notifier is not unregistered, leading to use-after-free.

Fix this bug by refusing to resume if the device is being destroyed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2582,7 +2582,7 @@ retry:
 	r = -EINVAL;
 	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
 
-	if (!dm_suspended_md(md))
+	if (!dm_suspended_md(md) || test_bit(DMF_FREEING, &md->flags))
 		goto out;
 
 	if (dm_suspended_internally_md(md)) {


