Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1376354670;
	Wed, 23 Apr 2025 15:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421716; cv=none; b=pcLWw48WWz38dldQejo8/6bP88T+e94OhpxmHyNalhOlRRd0kLOL25JwJA08hJkES/REqzHAR7xFp5bqNZG1NMA7l/yiEWRTztslj0zQQ0zPKDOa/ue8JmebK3YVy3d/vszWGR8cJ98gRDRD6zHzyrOWk2Z7MU/P8FnhVl/NxDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421716; c=relaxed/simple;
	bh=N0fspCMpZSHZihjY2whUSfny333Kv7rePkE+dJNHskI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNkNM3hSbiKJZVThJzkgadlZQ66CjARPhidJu/V4tLEi1cSed4014mmsa88xJ3MfOeqToxet8VHaeVop2ymGvmp8YxgYvnhqH3azO9A+3XXIUPj9+//IxIC4Dqe+LW6RNhhEa2DG37dcRfK0+74VldQ9zTYbAlxPPlTHWyFCMfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvAJK4Kb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvAJK4Kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A162C4CEE2;
	Wed, 23 Apr 2025 15:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421716;
	bh=N0fspCMpZSHZihjY2whUSfny333Kv7rePkE+dJNHskI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvAJK4KbxFQGwb8XSxY+7Ya6ywfLVMKRXHpSFklqBmHKKwO0wc/gpgrgRSxJXLjU/
	 QbqfofzpOkwb0OH9rM66RZeCV9al6kxfWkbihdiLbJZmrHwnI6ROxCcQ0jCPhl2Lcr
	 wqS3P5sS/6b/OpRQDLk4E7PVUbSkQWkAI6ac6j/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 211/393] dm-verity: fix prefetch-vs-suspend race
Date: Wed, 23 Apr 2025 16:41:47 +0200
Message-ID: <20250423142652.099171366@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -836,6 +836,13 @@ static int verity_map(struct dm_target *
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
@@ -1557,6 +1564,7 @@ static struct target_type verity_target
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
 	.map		= verity_map,
+	.postsuspend	= verity_postsuspend,
 	.status		= verity_status,
 	.prepare_ioctl	= verity_prepare_ioctl,
 	.iterate_devices = verity_iterate_devices,


