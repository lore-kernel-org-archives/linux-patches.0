Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A843E008A;
	Tue, 21 Jul 2026 22:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674319; cv=none; b=RvxZSQ7c7000sYMvMF43IprQARVv/nzTxHtTJrHkcZXc39hpDuWRo2cpHi1oiOanNTaSg/4fMdWgMlus6kpOlzWRMe2osnoUodca8YdW1p/P+krwEjVnimDvcAtpbt9EmvsjPUbkE+bdgBLeI5fcuzHyKSbCgFKYueYdGxt0k34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674319; c=relaxed/simple;
	bh=Q2dBDLfnqyqwkwXSQrL1fhx6cl0ZduGyi0bPyvXevoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuqigwsVoSTJcNoh5W1JDW+OtBWez95WaddxhQehrLC11rH+SrafaOeKn7sm1LDYwZnrZU6u7LHK5R2+Ijk+fZhYiWBlhcS6U4rxklz8/Uufy9oSbnHKZQsGKBWrLqtM4TBs1qYacbFYbWdzczqvaBB9TC8P6BCSylaLCxn6L4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqQi8/Cs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqQi8/Cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D730F1F000E9;
	Tue, 21 Jul 2026 22:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674318;
	bh=jX2wT/qwBuXxAJehKzF84VkdmxRQx+DcPMtLpFZpD5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqQi8/CsLZ1ocHtbdPWE+KQqzW6z+TE4cuMlBs7QcRA+8d+Hcrm5UocaZQmHvOy43
	 kZ0wiHP0jfwyMHYqNpGTrFsyrBBO/S6u/q2RQsggaNS1E/l3iCxTwAIM8z36K4sq36
	 0tsmjTgX37tcHZ2fMKUkSdpBaLWoHRfcdhKRtBAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 494/699] xen/gntdev: fix error handling in ioctl
Date: Tue, 21 Jul 2026 17:24:13 +0200
Message-ID: <20260721152406.839779566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 45ca1afe2fd14c04e37227e79d3f8455831d8408 upstream.

When gntdev_ioctl_map_grant_ref() fails to copy the operation result
back to userspace after successfully adding the mapping to the list,
the error path returns -EFAULT without releasing the reference
acquired by gntdev_alloc_map(). The mapping remains in priv->maps
with a refcount of 1, causing a memory leak and a dangling list
entry.

Additionally, gntdev_add_map() may modify map->index to avoid overlap
with existing mappings. Therefore, the index returned to userspace
must be obtained after gntdev_add_map() completes.

Fix this by holding the mutex across gntdev_add_map(), retrieving
the correct index, and copy_to_user(). If copy_to_user() fails,
remove the mapping from the list and release the reference while
still holding the lock.

Cc: stable@vger.kernel.org

Fix these issues by properly handling all error cases.

Fixes: 1401c00e59ea ("xen/gntdev: convert priv->lock to a mutex")
Fixes: 68b025c813c2 ("xen-gntdev: Add reference counting to maps")

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260622112541.38194-1-vulab@iscas.ac.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/gntdev.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -668,11 +668,15 @@ static long gntdev_ioctl_map_grant_ref(s
 	mutex_lock(&priv->lock);
 	gntdev_add_map(priv, map);
 	op.index = map->index << PAGE_SHIFT;
-	mutex_unlock(&priv->lock);
 
-	if (copy_to_user(u, &op, sizeof(op)) != 0)
+	if (copy_to_user(u, &op, sizeof(op)) != 0) {
+		list_del(&map->next);
+		mutex_unlock(&priv->lock);
+		gntdev_put_map(priv, map);
 		return -EFAULT;
+	}
 
+	mutex_unlock(&priv->lock);
 	return 0;
 }
 


