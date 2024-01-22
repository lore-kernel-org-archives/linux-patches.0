Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4B256B89;
	Tue, 23 Jan 2024 00:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969798; cv=none; b=Zx1qQMKTiWWtSyKWcrZ8vCEUSU7P/QwV9gFucQlqNpCCAH/9a9hYeIT/wARQqRxpErEeuNXXsCwfRpUvh3d1+gqPPlV0JfvC5W4r81xB2+P4e6b4fZChEg0cSZqXbzic2MeoU77SeYiD35/RBsSrY/Y2uKRkJLUP6w4jbA4OJVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969798; c=relaxed/simple;
	bh=lUdm9mMY0vIkZsBZ06VmV3fl9AZnbFf3GYZ6i/GrBAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCK09bvn9us15PUMC7Cy27whiSN/Q9Vyh1BNUJrlN+gFdBTG/9N81wEccMzibTc+kbm1C7wLlMITh8x7uOcpNlKnGed7s1IPBYZDP4UvbOEc+vArXUC9+w3I1evRaYL4ljeAsvFq2WOvCxeRmbDlvIZ+cXdhhSfMbqbe3r9lJps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amdeR5JH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amdeR5JH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0262CC433F1;
	Tue, 23 Jan 2024 00:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969798;
	bh=lUdm9mMY0vIkZsBZ06VmV3fl9AZnbFf3GYZ6i/GrBAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amdeR5JHmnxNHEituRPlbi2gb9gadJ4AkyTZoPARLoG14uWYD4PXolZ7dVA1VfV6w
	 SChY3MxzWWBF3+43jiUD3kgdtdrff/GmJhRDzzt8XQfFtFlS5tKb9b0x+9C33OXLGP
	 aO3UY8bORzXEuesu+4ghagi6+v7QQNKWr+F0kz9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Landley <rob@landley.net>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.7 448/641] rootfs: Fix support for rootfstype= when root= is given
Date: Mon, 22 Jan 2024 15:55:52 -0800
Message-ID: <20240122235832.043974292@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Berger <stefanb@linux.ibm.com>

commit 21528c69a0d8483f7c6345b1a0bc8d8975e9a172 upstream.

Documentation/filesystems/ramfs-rootfs-initramfs.rst states:

  If CONFIG_TMPFS is enabled, rootfs will use tmpfs instead of ramfs by
  default.  To force ramfs, add "rootfstype=ramfs" to the kernel command
  line.

This currently does not work when root= is provided since then
saved_root_name contains a string and rootfstype= is ignored. Therefore,
ramfs is currently always chosen when root= is provided.

The current behavior for rootfs's filesystem is:

   root=       | rootfstype= | chosen rootfs filesystem
   ------------+-------------+--------------------------
   unspecified | unspecified | tmpfs
   unspecified | tmpfs       | tmpfs
   unspecified | ramfs       | ramfs
    provided   | ignored     | ramfs

rootfstype= should be respected regardless whether root= is given,
as shown below:

   root=       | rootfstype= | chosen rootfs filesystem
   ------------+-------------+--------------------------
   unspecified | unspecified | tmpfs  (as before)
   unspecified | tmpfs       | tmpfs  (as before)
   unspecified | ramfs       | ramfs  (as before)
    provided   | unspecified | ramfs  (compatibility with before)
    provided   | tmpfs       | tmpfs  (new)
    provided   | ramfs       | ramfs  (new)

This table represents the new behavior.

Fixes: 6e19eded3684 ("initmpfs: use initramfs if rootfstype= or root= specified")
Cc: <stable@vger.kernel.org>
Signed-off-by: Rob Landley <rob@landley.net>
Link: https://lore.kernel.org/lkml/8244c75f-445e-b15b-9dbf-266e7ca666e2@landley.net/
Reviewed-and-Tested-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Link: https://lore.kernel.org/r/20231120011248.396012-1-stefanb@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/do_mounts.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -510,7 +510,10 @@ struct file_system_type rootfs_fs_type =
 
 void __init init_rootfs(void)
 {
-	if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
-		(!root_fs_names || strstr(root_fs_names, "tmpfs")))
-		is_tmpfs = true;
+	if (IS_ENABLED(CONFIG_TMPFS)) {
+		if (!saved_root_name[0] && !root_fs_names)
+			is_tmpfs = true;
+		else if (root_fs_names && !!strstr(root_fs_names, "tmpfs"))
+			is_tmpfs = true;
+	}
 }


