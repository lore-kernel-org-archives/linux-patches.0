Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA398148FE8;
	Tue, 23 Apr 2024 21:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908813; cv=none; b=Ek3g0u5ivt0hSyNXXsrisdUHEaSwfScFJzA1Snqg8MKt59+iVKN/UCMZMwrGYGM4AJgaNz4MrplXUdaDFrNWTh0hxK4vtliEyjOes81AwcP7lFCXXGRlmp6F3gEgAlOwPPuVktpi6bmmCQd7l4mz/byp5oIuHHm0iNSZuhpQ8iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908813; c=relaxed/simple;
	bh=ToKAijTIBu0tu/KBwJq6jIM7tAiTnI9/n504kclbZHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfBvyVRd3kldYKT6OukTqRIYcMu9n+GdBhjZaSLwO/XmqKGqyyi/qYrURceiNzlV8jcUF8Vrk89OQVKQ2qpwlsIyUqT9uaEbqGKFIJE1X7HUI2kEQPjbfcSvIq1nlevz5x7FH0oBhXd+58gDHxiTwoFdi5MAuJXRnx2l7U6BpSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLxvE72D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLxvE72D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CF5C32782;
	Tue, 23 Apr 2024 21:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908813;
	bh=ToKAijTIBu0tu/KBwJq6jIM7tAiTnI9/n504kclbZHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLxvE72D6l0ncf4EL3sjjyEFS8P0zxg6Jd5K2LJO+ehpCTuICTOaYdyA0JVNQ/fJQ
	 uZuYEfH5Xxqrf6yAKfh9P69lMGCTSNg/hOw/WZ/1+boxcpZBIrNpJ1pWRjK+RQr9uq
	 KP5YXWswIbSaa3nQ3Wf3rBOLcF9tdm7Xo0XVe7ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Bart Van Assche <bvanassche@acm.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.15 58/71] fs: sysfs: Fix reference leak in sysfs_break_active_protection()
Date: Tue, 23 Apr 2024 14:40:11 -0700
Message-ID: <20240423213846.182611869@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -440,6 +440,8 @@ struct kernfs_node *sysfs_break_active_p
 	kn = kernfs_find_and_get(kobj->sd, attr->name);
 	if (kn)
 		kernfs_break_active_protection(kn);
+	else
+		kobject_put(kobj);
 	return kn;
 }
 EXPORT_SYMBOL_GPL(sysfs_break_active_protection);


