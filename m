Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1483E49DD;
	Tue, 21 Jul 2026 17:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654808; cv=none; b=W8w1vrMr+5Bi73vh9pdKyuI3MdI1VipPSFrCv9nKQTVp8K3W+oeIlWWPR+0eYc/svyv07K+ClrSuG9FqUqJ1vtwQLJJP1Z76QTCOs99YH1ex6bCwkAePmfc7DKK5rUnD8cLIAIvP/WJ1zSQncDlwb43+rO71x7DdRFof6pdLiqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654808; c=relaxed/simple;
	bh=acM/rC0awacpNuDW4RABQD2fOwHyh6R53P3fmjn1sRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWWz9UmZcByOH1K4ciu+XbpuahecJKMzlrVko50WumvUzNOFAEetl7+rIzb/r6qkbqYUp8FO/k+KfUF4NeIGXlev0kJ8xIZSYtvRpVK9jfeu7GzVPOZEcFFTO6ETrJF6YtiP9Y+M9xl/lD/qfN62amUu7L0a3dBHBCU1mf0nR7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRqzETyG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRqzETyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31B21F000E9;
	Tue, 21 Jul 2026 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654807;
	bh=KWgiXXQslPnFZ7uPDrim5pQcFNvI0SgSLA1wpnC60A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SRqzETyGyTQxe8OyvfNfynHpoW5IAj3NwyWUjU6uoTfYv7sEUyEjcKDb7Dlj1xiK6
	 O9f1O2SPuX4sLAhRUSGSPxU82bsUtwTzBPkRTrgiLZVQOy35mNPb+4Hcrw7lGt7Jft
	 NHI3V1ggPMQrnl1uT9HBEN7cqzm4webtkqI2eFq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 7.1 1802/2077] xen/gntdev: fix error handling in ioctl
Date: Tue, 21 Jul 2026 17:24:35 +0200
Message-ID: <20260721152635.252501892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -670,11 +670,15 @@ static long gntdev_ioctl_map_grant_ref(s
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
 


