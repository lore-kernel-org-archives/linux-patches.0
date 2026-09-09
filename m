Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03523565117;
	Wed,  9 Sep 2026 14:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963410; cv=none; b=n67v0RmnNm4jp9EpljxmxMg43jFfX9tI6YSMyi5i1aJ04e2skfue18+v28v99h53ScrX0mhrupH1VrlNGB1XVmTHcBQ2aQtwCBaycg8tDrXRlMRvCEZemDFWdbKboqERTrLLlKxNCbmvK7651eVSio4NlvXee4k0ahH+lPhHyuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963410; c=relaxed/simple;
	bh=+13HupA9XkFiBys2Y6XvNOSKu0FYECr+PjUjOSnpqQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnlg8byBe8XryBEWcUGeV7jaUnuDYOD67wNpQLd1tqoBlR5BapDI6nh1+awXoLGK4BoQupWc1QA6z405T8pUYxMzYBXg1hWBfOSk8/1CHIOUsUCIgJjgOAg686hCikxnfyiVEJfrcz/RK3YARRBhFiYFnY4LuBjz3MaceuIID9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFZKaePW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFZKaePW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B56C1F00A3A;
	Wed,  9 Sep 2026 14:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963408;
	bh=FyaEp6cy9Edc/qsRMoWs88paREj5NdL44T0ojxJsOfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFZKaePWgR/SAiz55tQQX9L3iMB763pQzXun7vJYkHYVdhkGvI9N4cNyD2YD2o6Qi
	 s+VBb1J0WywddVhciLjMbIGldrRMF/ru0CC2XGsRF/+nnaSwslo9XmSpLCvILXJPy0
	 U0isiGXSGvrQ4aViZxJJv2jbPrnUAwQa3Sdaj//o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 068/583] dm: fix resume-vs-remove race
Date: Wed,  9 Sep 2026 15:35:53 +0200
Message-ID: <20260909134240.426208769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -3119,7 +3119,7 @@ retry:
 	r = -EINVAL;
 	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
 
-	if (!dm_suspended_md(md))
+	if (!dm_suspended_md(md) || test_bit(DMF_FREEING, &md->flags))
 		goto out;
 
 	if (dm_suspended_internally_md(md)) {


