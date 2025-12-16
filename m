Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BBB224AEF;
	Tue, 16 Dec 2025 12:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887426; cv=none; b=pGxFzBUBXAMztV7cCXDgOYARIkjb9YRKTJz+jdmIVOWS+GaGpSmRLFISTT0cU6uXqInb2XUizXUQrqsWiZ+8XncmFFnqKkFb0wmACR3BDNKObdFYYecvK3h36QZ/N6trMxgkVD1FmwpRO0qkpcchhZK93Mj79DfB+p/VJ7nd7b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887426; c=relaxed/simple;
	bh=JR+7uvxOIkdkyMXMkLJgsaSjFYTo64O35z2JSj3Ilbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afus3a4lZxqyS8ALdVbwopuy6BhSrw2ZLGRLOb5006Jakk8wvl451xBvh/FI/MT2jTXNvUtmjP/TZEXHdLuPunuDEmtuPh56gKfouYVFDJ5e4WmrYu3de5C5F6aNGjHtT+Cy0sBfgKZywKq4zrC1btK0MORno7MaXSm79hvaERM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oG+1IEzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oG+1IEzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A05C4CEF1;
	Tue, 16 Dec 2025 12:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887426;
	bh=JR+7uvxOIkdkyMXMkLJgsaSjFYTo64O35z2JSj3Ilbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oG+1IEzJz9xZSxruWB7zPDNYa0ZxlxPYDe3YATK3GM1seKd8oEoAnP+xXkLZxMrKj
	 ajIMNTMvkozy7D8wKPhpNkT7MMfXoXXJ+vRQzU17ule7MLkp+LVOkQq6GxMGNFvrx1
	 xEF1iR/ht0qRnMXVDuJ8PUWLmIyDfwzb50QIxp+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 226/614] md: delete mddev kobj before deleting gendisk kobj
Date: Tue, 16 Dec 2025 12:09:53 +0100
Message-ID: <20251216111409.561000679@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Xiao Ni <xni@redhat.com>

[ Upstream commit cc394b94dc40b661efc9895665abf03640ffff2d ]

In sync del gendisk path, it deletes gendisk first and the directory
/sys/block/md is removed. Then it releases mddev kobj in a delayed work.
If we enable debug log in sysfs_remove_group, we can see the debug log
'sysfs group bitmap not found for kobject md'. It's the reason that the
parent kobj has been deleted, so it can't find parent directory.

In creating path, it allocs gendisk first, then adds mddev kobj. So it
should delete mddev kobj before deleting gendisk.

Before commit 9e59d609763f ("md: call del_gendisk in control path"), it
releases mddev kobj first. If the kobj hasn't been deleted, it does clean
job and deletes the kobj. Then it calls del_gendisk and releases gendisk
kobj. So it doesn't need to call kobject_del to delete mddev kobj. After
this patch, in sync del gendisk path, the sequence changes. So it needs
to call kobject_del to delete mddev kobj.

After this patch, the sequence is:
1. kobject del mddev kobj
2. del_gendisk deletes gendisk kobj
3. mddev_delayed_delete releases mddev kobj
4. md_kobj_release releases gendisk kobj

Link: https://lore.kernel.org/linux-raid/20250928012424.61370-1-xni@redhat.com
Fixes: 9e59d609763f ("md: call del_gendisk in control path")
Signed-off-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 41c476b40c7a3..8128c8839a082 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -941,8 +941,10 @@ void mddev_unlock(struct mddev *mddev)
 		 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
 		 * doesn't need to check MD_DELETED when getting reconfig lock
 		 */
-		if (test_bit(MD_DELETED, &mddev->flags))
+		if (test_bit(MD_DELETED, &mddev->flags)) {
+			kobject_del(&mddev->kobj);
 			del_gendisk(mddev->gendisk);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(mddev_unlock);
-- 
2.51.0



