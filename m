Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5BB3B6C06;
	Tue, 21 Jul 2026 20:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667420; cv=none; b=Kpcp2vkFWv75VpsKKundOEZjQbZ25ipF1P4nvDlVZji0PtaAe2Os+TJbgsEEwp4kbwEn4rHlchplkKljJWvf8RoNz6WxVT/ujQ6W8BfxpYkkFYhHMleS7g1p+dOrxCrEZEWvlQ9mnIAHlvA3y3fFC49rd9d0gpSOFikVn5ngX+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667420; c=relaxed/simple;
	bh=ixi8GtMFdOP4Mb7GnhZ2nzPiwASGAbK8N6fnV4ITPhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRP3eqajfD2h+wHsBPeEUtTJxOOLGlxxnc8W9yUmKliChBJd3RijHELU7opEuKL9VyTd5AVXAOXnKSDExUSFV5lGloXkcOTC7nBJQgIZr79MjxFiwNNIIJfTHx6lzDEGHUsinO3UvXtv0kXsJcHvxo5U/DkW2C0J33kNLHmqXSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEuRyPAG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEuRyPAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7E31F000E9;
	Tue, 21 Jul 2026 20:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667419;
	bh=AmEjEmG8ajPQ82V5Z9EjBgbxfu3aKBBstjE6Ufn9Ofg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yEuRyPAGo+yOW4iL/4PmYmf0WXG4JmHlVG3amDgU/PZNYzpkJ4op7e0sTzQzxxJbL
	 UeZPZ9utDGPGxIP3G4ruzzxxmIPDL32M6ErpSHnO0HHq3V1zKc/ROVr/4bvA1sCzFh
	 IzjSPsaYKZdovRBD/wRXUC939AodG+xBd+zQrzuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 1052/1266] dm_early_create: fix freeing used table on dm_resume failure
Date: Tue, 21 Jul 2026 17:24:49 +0200
Message-ID: <20260721152505.358589908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 366665416f20527ff7cad548a32d1ddf23195740 upstream.

If dm_resume fails, the kernel attempts to free table with
dm_table_destroy, but the table was already instantiated with
dm_swap_table. This commit skips the call to dm_table_destroy in this
case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 6bbc923dfcf5 ("dm: add support to directly boot to a mapped device")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -2340,7 +2340,7 @@ int __init dm_early_create(struct dm_ioc
 	/* resume device */
 	r = dm_resume(md);
 	if (r)
-		goto err_destroy_table;
+		goto err_hash_remove;
 
 	DMINFO("%s (%s) is ready", md->disk->disk_name, dmi->name);
 	dm_put(md);


