Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0072442DFEC;
	Tue, 21 Jul 2026 22:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674362; cv=none; b=jezUUUSTBIpw/y/izl9b1nqXFNhojx8BhjraRrxNPtGssDmzqjLWc6gXrThPWSPbzdnF8fgDDD7703337TMbPKWKayA8tYoxIGAG61T/z/U1NVNiZieeMaoZi5zfYT/zVa9hI+uHJEVyH5UZS/dbztOc90ryaNlvMNlRdVmUGXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674362; c=relaxed/simple;
	bh=HedNMNNf524bYKvLIzChFlIXYdkrBdnyCwXfGC1+TkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZM1mlh0oDFgd1XTTjvle3+tGLe2W+xLSQqVsC8j4qPlhQSy/VSdAxOETqsyiVd6dJ7zxXfehk8JCXOuEham3jKB9hwrqaf+kZ+YppyIvWf1XNHg+6FdDnC0s8YPlBr3lr0UAvj9vu3d1CetfHpIcNFojIpMYeEuQ0t8lWQ3k8+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xda4TknE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xda4TknE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C201F00A3A;
	Tue, 21 Jul 2026 22:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674360;
	bh=8E2UDVY5tgeRDasKVe7n5xN7IJjOmSakFT1fQ914A+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xda4TknEcJS06UlCp+XB87DxBQ/sbiqzShY8CjIrEZ9/YaddJzBgm7bSRsbk2tx9b
	 FLMSZ/sXWUq1q1j7wND74BitkwH+vxtXFf7iLwBmagDhqer+TQJPt6Dsu1pnlAKOCb
	 5qqSMq9jNjShIp/MSdxk+mDlnWJ1AtfmcZnzXSq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 513/699] dm_early_create: fix freeing used table on dm_resume failure
Date: Tue, 21 Jul 2026 17:24:32 +0200
Message-ID: <20260721152407.266654667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2164,7 +2164,7 @@ int __init dm_early_create(struct dm_ioc
 	/* resume device */
 	r = dm_resume(md);
 	if (r)
-		goto err_destroy_table;
+		goto err_hash_remove;
 
 	DMINFO("%s (%s) is ready", md->disk->disk_name, dmi->name);
 	dm_put(md);


