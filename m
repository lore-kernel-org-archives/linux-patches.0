Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4C028A1FB;
	Wed, 23 Apr 2025 15:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421505; cv=none; b=o1PYeDUVTodPAbj/LZjaFcwOmhn1EexjhhKA5eaB6wrtz7nxbsu/kU0N8DzgCld9anq1oLHR+OsurHKaLxMES/b0bz6NCPqO811jhmD1f7aptqfW+/SWHSbUYXLTQXpG8W6xepICS/9E5Aq9f8z5rk0d9ebkO8COk+DBHC8ZRlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421505; c=relaxed/simple;
	bh=7YqCY2XUyoXaIzcIF2tcNYCxKJh2QnjMGgego7EhR9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yjs8mddY76ztlfMHNs5S1UZUqVywAO1rjypjDcCZHqqMEqDEGMc9OrcjWZTXMJdpYqHsL9HT3AIwiG+qVVya1+VEo7c1fRd8soA5IZy2Zh4BiD9CNNbc5Dgv6soBgz/G8KVOjoo5e9ehwLVcrHAwcYEmeKBA7ntkedTJWezy/bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=roSgJbfT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="roSgJbfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7836C4CEE2;
	Wed, 23 Apr 2025 15:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421505;
	bh=7YqCY2XUyoXaIzcIF2tcNYCxKJh2QnjMGgego7EhR9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roSgJbfTsmPuqo/knSB85tDKsDHXRJbZYQ6s1HuPcm+36k/+flQneAGNS92EMzzVj
	 g/Pgt1/5JOYSAXmNuQoUWbJnscU8YhE5so3pJihgehx9UdYmpMoXW41wRIZNR3+a4U
	 qxa4OM3rNhkHn7dUeMUU28TpTpHidp6h2I+Ze4+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 144/291] dm-verity: fix prefetch-vs-suspend race
Date: Wed, 23 Apr 2025 16:42:13 +0200
Message-ID: <20250423142630.292285660@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 2de510fccbca3d1906b55f4be5f1de83fa2424ef upstream.

There's a possible race condition in dm-verity - the prefetch work item
may race with suspend and it is possible that prefetch continues to run
while the device is suspended. Fix this by calling flush_workqueue and
dm_bufio_client_reset in the postsuspend hook.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -823,6 +823,13 @@ static int verity_map(struct dm_target *
 	return DM_MAPIO_SUBMITTED;
 }
 
+static void verity_postsuspend(struct dm_target *ti)
+{
+	struct dm_verity *v = ti->private;
+	flush_workqueue(v->verify_wq);
+	dm_bufio_client_reset(v->bufio);
+}
+
 /*
  * Status: V (valid) or C (corruption found)
  */
@@ -1542,6 +1549,7 @@ static struct target_type verity_target
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
 	.map		= verity_map,
+	.postsuspend	= verity_postsuspend,
 	.status		= verity_status,
 	.prepare_ioctl	= verity_prepare_ioctl,
 	.iterate_devices = verity_iterate_devices,


