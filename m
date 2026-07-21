Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277482135AD;
	Tue, 21 Jul 2026 18:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658993; cv=none; b=G7OMgV2LsUWv52rfSibCYAjiXIImvhEANTPECbAZiCrgbvHXaQ7Mefq/V8a2XgbypHM0tm9o2j3/sUWSQmR+nn8LCLyczS3jfEG13NjAVKrX47i1jMWGD7tZ5G4Yl8+Ea3JZ2cNneu/mchzVuSy2LIjik0eyaF8hCgFR1nB1hdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658993; c=relaxed/simple;
	bh=VVhpPS/rwv7CPjh9+8xoekQ0xIE2oN7joMZC1uY8I0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e148nXgZVdfQJd935J3uX9K8HFio40ACVfL/mNrMqLUMergq40DaG9aKdRa4F45c5DxEgO9OSnxkOS0SLkY77WcsO/GxNjXlFrtL2iBXhy4dzLFj/iJsNkz0Mnl2dQIIdBYT1hHxkLJVsqzz3IZdDnGZcCYGBdivtLMPJzQlFco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzRoZJzr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzRoZJzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862751F000E9;
	Tue, 21 Jul 2026 18:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658992;
	bh=GvyNFT7ueUbHVcu62dWRWjsArfMGCopHzaJVXwx0svI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzRoZJzr2aUk8AZXTKyA802735tDWbKr/2vxz8gsdKmzG1AR4MwZhBIsqAkgDI8MS
	 5oLZpGeYDj/N5IILEt0FewR2SIntks2naUEnTjk6Qcsyop9ysZkfxN8Y1xZSLSQz+j
	 LGs1a6FwWHM2i7sVSIapQasIT4kjjDOBjAZfgCPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1354/1611] dm_early_create: fix freeing used table on dm_resume failure
Date: Tue, 21 Jul 2026 17:24:30 +0200
Message-ID: <20260721152545.911240669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -2341,7 +2341,7 @@ int __init dm_early_create(struct dm_ioc
 	/* resume device */
 	r = dm_resume(md);
 	if (r)
-		goto err_destroy_table;
+		goto err_hash_remove;
 
 	DMINFO("%s (%s) is ready", md->disk->disk_name, dmi->name);
 	dm_put(md);


