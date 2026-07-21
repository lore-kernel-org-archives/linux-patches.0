Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712C13B4E9B;
	Tue, 21 Jul 2026 20:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667425; cv=none; b=ifL3cPtugkktw2lwWkupOrXSxrGfDe4iUGojp+z8CvPiCEJw2mRKfdrooluPAq+S50MJrZUs2QBykiBwLqwEzVFe3I09/qmXqErCjJgKHJzRTNH/LXwSmdSP18Y6wXM5N0eH3dsdl6Or6auaW7rDw21F5TzNa/aGLkt3RnD2ens=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667425; c=relaxed/simple;
	bh=qXS6nWqzQ7qJ5A5jQ8YDGHU9GbFNDbsqgxKB3/N5PlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jz/MfjEnFizJfXUY08YdzfzCoIrUslW2NSLuDx1Th5wwrpwIbOxGUHuhDPNaSihTehUQVHnyLa374QGeF8jhSte3nM8AwwG7/K2xWYwWkJiG/VK9jNuTzHTLuf2CSACFMeM1nPY/8GpCO29r5CQY0cdAr+OjgMswSUF1CLxJsu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1i1Lzd3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1i1Lzd3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73751F000E9;
	Tue, 21 Jul 2026 20:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667424;
	bh=92aQuIfUNK1nCyL+1Sh2m1r+sa+X85l9wV3Munzg1Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1i1Lzd3WtmcPOTqiHc5pHX0ZZXc5kqY2AM1ZqpGLmtFBdzdykAAbx8yA9oncZqB3F
	 FJvJCu8n78WyhGA8CbNQFviERsIrv7JKTz6P+L0BZ7qK+qfstSfbqCmdFugxg13Xas
	 HbIuNFfjdkbQ5OeiTRliCpIyKhxXkj/uDo11aAc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 1054/1266] dm-verity: fix a possible NULL pointer dereference
Date: Tue, 21 Jul 2026 17:24:51 +0200
Message-ID: <20260721152505.404387713@linuxfoundation.org>
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

commit e72b793ae440f6900fb17a4b8518c707b5cd3e17 upstream.

Fix a possible NULL pointer dereference dm_verity_loadpin_is_bdev_trusted
if the device has no table.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-loadpin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-verity-loadpin.c
+++ b/drivers/md/dm-verity-loadpin.c
@@ -70,7 +70,7 @@ bool dm_verity_loadpin_is_bdev_trusted(s
 
 	table = dm_get_live_table(md, &srcu_idx);
 
-	if (table->num_targets != 1)
+	if (!table || table->num_targets != 1)
 		goto out;
 
 	ti = dm_table_get_target(table, 0);


