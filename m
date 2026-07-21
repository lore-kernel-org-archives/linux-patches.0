Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AEE35C682;
	Tue, 21 Jul 2026 22:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672590; cv=none; b=o3ICaNBnwszi5VJFuK/fYLgCxNTIoziDM4/u29RaUN+XZEhu+JLBATTfBCeE6usUv6Te2Wl8hXc6nlDyumMGLMlTr7nGXUeNMdbFDZkmqLKC0WmdoSmQK7v721cKwErdhzmWrAbD7di0eibFTwzVsoVFRsvQ+vVZyfXD1pEHo4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672590; c=relaxed/simple;
	bh=GMw+2zR/7B7pVX4QKLxQZkSzttE/xKeCVfOnmQ/OAAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfjhKKJhe8J7QvR/jngsSE9kv1teSD/yWIEGXqyQiKLjmtjuIiJPT3U3CIzZzsE5/1rHByqW/mxmRsCFva3te+DhY/VtqwUoqV8Ys3trA/VwFBYzWhOWyk2rc98ygRZvbW7dnk5OvNkHJY9g9JSuyCLqYL/ATSlu0zDKQN55iIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hh5ijWuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hh5ijWuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D9E1F000E9;
	Tue, 21 Jul 2026 22:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672589;
	bh=RzcwJZ2oPHIhrcG2M1utCzdu4naHBSFwg7HWcpasz+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hh5ijWuVtYa0xixo2w62qT/ProUN9c1D3wV51KKhKIPISBPnd/jyoeJ58XCSjbntj
	 8yCETGKz3NlXpXyQuolV4TpGakJqpAABk2Hc4iCu/xnHlamzJS8yfQC/rMKIeqC5tR
	 3uvS0lhTq5QE0ZPE8aDMfzvB9vYPCZzUhknbhk8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 638/843] xen/gntdev: fix error handling in ioctl
Date: Tue, 21 Jul 2026 17:24:33 +0200
Message-ID: <20260721152420.418813139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
@@ -678,11 +678,15 @@ static long gntdev_ioctl_map_grant_ref(s
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
 


