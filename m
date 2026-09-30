Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24DB3AE1BD;
	Wed, 30 Sep 2026 18:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791344; cv=none; b=DM4p/Y/ujA+PPlxeTRHsq/K20j5/0xqX3wkFUsBvku0nsXYu2F8XtAkDsEgvGgn0o0akrZ9lDg+eGwOOEZaXDKTgCqWZ9o+frqP6wjApfMlNbqAWLKpqpxp64aPex1pOGNxRDkbADKYT6RODB1SBDAUO6gV4+7eSRsRXvt/1Bcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791344; c=relaxed/simple;
	bh=aBRyGeFF+S9+5R/R4d7+WgIiH8V6wmlgDUkUdN4TXJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLKQEDYueaVYTZVdvG+XMxizH9ETK7feDTl2RyqlgcWOMV4aCeZ/mQLoupZUpVNRB10MvXysBdRregAAyxo6JjNQMn1EoWTvo+k00qQvux3w5Nfvcyg48YX7Ws+uR1tzDGGuK5YjQGraR/eoHdzTcPqI9OR81MMiAsnrT5qDgBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy3p97y/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy3p97y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083A41F000FF;
	Wed, 30 Sep 2026 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791343;
	bh=Dtm2P33/E0JFRD3f0RN10sySUJNXEZM2swoMFFHriX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hy3p97y/e1Ls2QaDUXemLb4U6OfFSjgrXQVApRysXFcnfo4snpCOW1MFpi8HWIwHG
	 8qsmCf8y+U5xbsxoIpLJRjwO/UPxBaXCyojpeLFIdFcRIALAsXUlMZCjlZeMNLKPJ/
	 BTa91cdUEkorhXFvVV5NYfeF2oB4lqnpW5i4SUhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/752] btrfs: detach failed sprout device from transaction update list
Date: Wed, 30 Sep 2026 17:22:17 +0200
Message-ID: <20260930152404.059094033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit c93b3c43df561cd9f592cee20ae058b563f9e5b6 ]

When creating the first metadata chunk for a sprout filesystem,
create_chunk() adds the new device to the transaction dev_update_list
through device->post_commit_list.

If the subsequent system chunk creation fails, btrfs_init_new_device()
aborts the transaction and releases the device while post_commit_list is
still linked. This triggers a warning in btrfs_free_device() and leaves
the transaction list referencing freed memory.

Detach the device while holding chunk_mutex before releasing it.

Fixes: bbbf7243d62d ("btrfs: combine device update operations during transaction commit")
Assisted-by: Codex:gpt-5
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 459dd6da41af5..e62faf34cf877 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2886,6 +2886,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_sysfs_remove_device(device);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
+	if (!list_empty(&device->post_commit_list))
+		list_del_init(&device->post_commit_list);
 	list_del_rcu(&device->dev_list);
 	list_del(&device->dev_alloc_list);
 	fs_info->fs_devices->num_devices--;
-- 
2.53.0



