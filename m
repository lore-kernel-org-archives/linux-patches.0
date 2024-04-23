Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D309914387C;
	Tue, 23 Apr 2024 21:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908746; cv=none; b=IG5CfRbN0dzd4a7oPRvVLgTtJD5MdXVo2IAA/qqVjr7a4FoqFOotT07P/PRYbMBSytucROfrI6Eiru+xTXDZaQDL13czo9cZuCKDu/Nw5y6B0ENPjFQV4w8iOkNRv1MQgK6J7WDCjcwzfuX64lqwytrGxQCbMZLJDIVvHtH1Yzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908746; c=relaxed/simple;
	bh=mwR9Di9KgzlqBUcaaX5zX9aKjbql/vHV0u88pcu9Xzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHQQtWx4LdbLdLgPwlSsh9Mp01e/gCy1jeH8mTx4m8si87D4JSyCIuixIOjhjZsuWUJ3Z/YkhgOwQqIqPsiRS7s9g6vN2i8wx3PlTkyBVZlwq3rTfbLA5v4iu9xWzYnyvYxY5s1u3y7EsAIuueEG9yFdHR5M94zuEBEeKKvmQLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOr995nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOr995nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FA7C3277B;
	Tue, 23 Apr 2024 21:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908746;
	bh=mwR9Di9KgzlqBUcaaX5zX9aKjbql/vHV0u88pcu9Xzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOr995nzEeahDCTVja78wge1globRmlvXEM3p6XmE3bmRUviv1MUoRFfJR+FO0Y9b
	 LuVPz2kipMdkRFBO4eoob1YOaY/4CfQC15BVVA+ygG59S6ranCsEvflYBv2ii2tEoS
	 N1086GugakxqGctSTTBCLkBOq4NUQzraqnA1gJco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Bart Van Assche <bvanassche@acm.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.1 120/141] fs: sysfs: Fix reference leak in sysfs_break_active_protection()
Date: Tue, 23 Apr 2024 14:39:48 -0700
Message-ID: <20240423213857.103954183@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -450,6 +450,8 @@ struct kernfs_node *sysfs_break_active_p
 	kn = kernfs_find_and_get(kobj->sd, attr->name);
 	if (kn)
 		kernfs_break_active_protection(kn);
+	else
+		kobject_put(kobj);
 	return kn;
 }
 EXPORT_SYMBOL_GPL(sysfs_break_active_protection);


