Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5289129E81;
	Tue, 30 Apr 2024 10:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473769; cv=none; b=iriZSGYyegJtaWT1kqBrZ7YHWxCEpJzyeRav3C5DPavpIBn9+FwI6IusOBjZ9rYoXvhCvOprj/SFY+YapzqygL3wAm5Hmjpi3iOwmE/D6BgqrJ4fqkwcEL5n5PsOSLu4D+N+pYKxmHBlKa1Ccxpa/p+X+qRAGn7ceEIcyRxOQIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473769; c=relaxed/simple;
	bh=hAy7FjLwADrv2uPEm3Nt5fkA/tSsAE3YTCrmRXVOOFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiHV2SdK6/UsCvE7XFWxWPQQTc5I5H2xbkCv4e458eRnxETGjZMEFcfLcSB6M6vmeTe8vGJN6PS8KogwKnM5EANmzWw79eWdDevOVg80bBBcnjSLrnSAyGNCigMY6/4OCgGIxOGBBwxDgxNWzarmh9WTFcKNjhKynnrCbbnV+yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yC6S1QBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yC6S1QBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F01EC2BBFC;
	Tue, 30 Apr 2024 10:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473769;
	bh=hAy7FjLwADrv2uPEm3Nt5fkA/tSsAE3YTCrmRXVOOFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yC6S1QBc7iT6QVhvMFRVZZYbQDIjZkBtrHr8NmAMwL8H5ytNRbzD+cu+UOeHVSfUn
	 EvbDHcouGC5xV3VGSyhhA2YXGQ3WAKzIq/KFDqD6rBMCurcbiY2a35Qp7tYucID3+g
	 N/hy19GXn+3+vkX6Dg0x4GGmUevsQCdH4m2y6AWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Bart Van Assche <bvanassche@acm.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.19 33/77] fs: sysfs: Fix reference leak in sysfs_break_active_protection()
Date: Tue, 30 Apr 2024 12:39:12 +0200
Message-ID: <20240430103042.109430405@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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


