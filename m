Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817FD545D82;
	Wed,  9 Sep 2026 13:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961905; cv=none; b=p//35HQgV3yqrxDe3dRCquUr4gUE59SqGy4TAVW+LrCEPxCpZNKH3Us3/kNPCSahj30W09B/LZKolqYJR+UyZ/6SaOrI9MEwZCa67p/U+DNP7IA49YvtsKdKKG0HGAop2R7HFVa4JOCs7B9iEa78FwQzJycrV0ayKUTu1rVpkgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961905; c=relaxed/simple;
	bh=qB2SvPwLVqrRNZjuoygMy09dVi4doqPNPecVMxEnUKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdTx1VErtbmYS7PKXjLCwDkR/392TCZLQGD2R7y6QPWo8HK5LBnOgBaOSvuJheDixypLClVlHAhlde5g4J+5FG1jSbd+LvgtPTSwlUOYcA+0r0QogeT/s+jIjLNRNyFrjeaw/I7gVVEtdba122124owvVH34IOUt7L4TU69iJ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkT6fdMk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkT6fdMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961951F00A3A;
	Wed,  9 Sep 2026 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961904;
	bh=wUfbSsqYyDbvpKt5P3osnKmfMyz+ulzkhFRrnSsA4FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mkT6fdMkPyDd7te6C26sXrZoIstyGH6Y1RRJaD28IsfuW7vuY4AU2d0Iyg6/3oSeH
	 /zNEMW4cIVcPdr7b9OsIyJpXN5pm8wS3NrKpbClxGhnMCye5SocE6p2Vnbf8by6Cvx
	 2eXUqc2o24dGAyheFYIYw/jihKqqzB7U9hbbR8ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 106/556] dm: fix resume-vs-remove race
Date: Wed,  9 Sep 2026 15:36:26 +0200
Message-ID: <20260909134234.219678549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -3144,7 +3144,7 @@ retry:
 	r = -EINVAL;
 	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
 
-	if (!dm_suspended_md(md))
+	if (!dm_suspended_md(md) || test_bit(DMF_FREEING, &md->flags))
 		goto out;
 
 	if (dm_suspended_internally_md(md)) {


