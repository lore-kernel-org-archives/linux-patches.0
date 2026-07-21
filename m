Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3393F825C;
	Tue, 21 Jul 2026 17:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654827; cv=none; b=XgUN9csDSIBEqLeG/Gf1BA2+seFkekLcon9aIXJMRWWtaV8MCh+tJwwi4E5fnZCeKcwBYL709z6m4CCeS+0QOlr+YqoSSo5gVlxUqSkzdapfwnCCiiYP3YIgRJPhy3rPqxZKdS5bopO0on/gDAxepxD/n0UGFrtdqbJKVXvvgDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654827; c=relaxed/simple;
	bh=YIs5MLPG5i9PFCaIm+x9d/WJdEDKnV/65SP0d2a8W28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmOpht4JlDvQJNOVx0vwtBi1xVJUQY5rLgwU7UQKHtt5cao3tpzVatDAOMToS28biGSb6FfpREwJy7DpzToKYoCymWDS4pGMFoOCLdsIPEIrW+Ggqh4HyRO1dIIkPVB7VPKGqTEqCldp4XeHUOJryvaGsCw6BZYyIvoskpblZVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgsOaBMU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgsOaBMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315B31F000E9;
	Tue, 21 Jul 2026 17:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654825;
	bh=DJLW1XHEb+l6g8ko8BOCxORaKQ1YQuzOuBxNFbN1o+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgsOaBMUedC0Bp2+sczbpYT6eA5elMOPqH8g7LW6mqpMV0VIKNIKHsw4CS3S8K36j
	 mcbzLt15HTduqe96/o9mDnWruc0mGBkKZcAxfFjQaGhD+BzynPUcAfa2pfcAdCVVGN
	 Cn09+McJdmJVblfxBPTJgnT1pTjZYfjAFK1wo4rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1853/2077] dm_early_create: fix freeing used table on dm_resume failure
Date: Tue, 21 Jul 2026 17:25:26 +0200
Message-ID: <20260721152636.440566628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2351,7 +2351,7 @@ int __init dm_early_create(struct dm_ioc
 	/* resume device */
 	r = dm_resume(md);
 	if (r)
-		goto err_destroy_table;
+		goto err_hash_remove;
 
 	DMINFO("%s (%s) is ready", md->disk->disk_name, dmi->name);
 	dm_put(md);


