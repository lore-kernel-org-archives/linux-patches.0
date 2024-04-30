Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67A112D75F;
	Tue, 30 Apr 2024 11:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474891; cv=none; b=HiJAOO34cD5WaA+rs1egkbkAjVwYFZmH0yBBH1vU9BHDAyYwhmFLFFJc+vDP2t74ZfsLdlUdYG+B7yw9mhdKTmiXTTlY4x8J5NG5tdYMIlxaUkulB06cudui4CJH5NOEHzJ/hAMTvu7ovVyNa9altDI4Q6klTlXus9LA03fOIsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474891; c=relaxed/simple;
	bh=ZEg2wi0ow7XFoc01/pZecB55cAm48N7PNOUioE82NvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFymSZCiMXrI/3tRNn643/lNezuIhT4EbuA1jGOJZg+9DXFlaL+8s383reOINOx2S+OXM1fq09vEpER3y9HvggLuR359VeeFA+AlbxR5NnF0HNXLoEjoyxs4nToVVYBrpAu8BWo9OIJXEAc2AbgHKdcZFqtIXfs8LgGxOf6sW0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZfpOyy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZfpOyy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCC4C4AF18;
	Tue, 30 Apr 2024 11:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474891;
	bh=ZEg2wi0ow7XFoc01/pZecB55cAm48N7PNOUioE82NvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZfpOyy8BBgnejQZopCMEC6CH54Q/ul75RxBHL4AM2GpRXS13QREMtbBaGD/prHds
	 N6On88zoQwbRpDuGoJldqHpbMHt3AHkDKjLdB+RbF6gu9kx750JTNz1e9oeY7oLX5p
	 noLCjBYrXaiHornwVMsranoNnlCSnrSDNJOxSon0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Bart Van Assche <bvanassche@acm.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.10 067/138] fs: sysfs: Fix reference leak in sysfs_break_active_protection()
Date: Tue, 30 Apr 2024 12:39:12 +0200
Message-ID: <20240430103051.394681282@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alan Stern <stern@rowland.harvard.edu>

commit a90bca2228c0646fc29a72689d308e5fe03e6d78 upstream.

The sysfs_break_active_protection() routine has an obvious reference
leak in its error path.  If the call to kernfs_find_and_get() fails then
kn will be NULL, so the companion sysfs_unbreak_active_protection()
routine won't get called (and would only cause an access violation by
trying to dereference kn->parent if it was called).  As a result, the
reference to kobj acquired at the start of the function will never be
released.

Fix the leak by adding an explicit kobject_put() call when kn is NULL.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 2afc9166f79b ("scsi: sysfs: Introduce sysfs_{un,}break_active_protection()")
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/8a4d3f0f-c5e3-4b70-a188-0ca433f9e6f9@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -429,6 +429,8 @@ struct kernfs_node *sysfs_break_active_p
 	kn = kernfs_find_and_get(kobj->sd, attr->name);
 	if (kn)
 		kernfs_break_active_protection(kn);
+	else
+		kobject_put(kobj);
 	return kn;
 }
 EXPORT_SYMBOL_GPL(sysfs_break_active_protection);


