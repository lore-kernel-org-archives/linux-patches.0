Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FE842902A;
	Tue, 25 Aug 2026 13:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665945; cv=none; b=If34wYLKF2GzCIaTmE3aXyFSO39hkVuFxOxs6VhwLj/BtQGK5cLW1U0/f5VwMIww2i3TYo2C9W4citdNeEzi46HlCyKD0OqXwiCeMflortqjrI2ahDaApRZQsEkkYA6aH1b1UL60UjCQrCBjV2zh4QVFy5mNP8SBZycjy3ae6cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665945; c=relaxed/simple;
	bh=0/0wQJqatOCSc0yAO+IgwyW94IgXQclQCvYm7iIE7j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFz9e+Y2q0DapBaVHwZyn8b7wOOcK2p0QznPbAsh4V+wGWCWFF73qGNyQeKl4YTsV3NKoRMuTHKBD7C3vYoGtxjXd0vR50yXD1hw6A+zY/bYQSYI9sJ+qCgHC9NEHU40iL56hlrEQ/JAraCmUySkuy8J2a9kVRPcdqS9/um6uWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxvAswqH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxvAswqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D6A1F000E9;
	Tue, 25 Aug 2026 13:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665944;
	bh=/ZXIdjpgcEN10gQKmKC3uFc1RxPOePhd7wSUyPotlbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxvAswqHPwbwpJe9jW+ErHw1UKMjMtZk5vueGi9PbCQYo/3v3qC91Ehuo/UjMK4Zf
	 aA968DEm3ZSbl7l/rrssMi7wCA6Xn4udb7pb92BiM896hUQ8wpsw9N7oeSAVph/vsp
	 5CA49zl4L+O27g+QU4D1OsuTulSeflILlENi3tcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 30/79] s390/vfio_ccw: Cancel existing workqueues
Date: Tue, 25 Aug 2026 15:26:10 +0200
Message-ID: <20260825132542.876624116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 79c60b2c61105368dcc8444eb45847e21734f7c4 ]

The initialization of the io_work and crw_work workqueues begs the
question of whether they should be un-initialized. Add the corresponding
cleanup tags in _release_dev to ensure work isn't dispatched after
the private struct is free'd.

Suggested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Fixes: e5f84dbaea59 ("vfio: ccw: return I/O results asynchronously")
Fixes: 3f02cb2fd9d2 ("vfio-ccw: Wire up the CRW irq and CRW region")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
[ Inserted the two cancel_work_sync() calls before the memset/complete pair in 6.1's release_dev instead of upstream's destructor body, which doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_ops.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -87,6 +87,13 @@ static void vfio_ccw_mdev_release_dev(st
 		container_of(vdev, struct vfio_ccw_private, vdev);
 
 	/*
+	 * Ensure these work items are fully drained, so none can
+	 * fire after being released.
+	 */
+	cancel_work_sync(&private->io_work);
+	cancel_work_sync(&private->crw_work);
+
+	/*
 	 * We cannot free vfio_ccw_private here because it includes
 	 * parent info which must be free'ed by css driver.
 	 *
@@ -162,6 +169,14 @@ static void vfio_ccw_mdev_close_device(s
 		container_of(vdev, struct vfio_ccw_private, vdev);
 
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
+
+	/*
+	 * Ensure these work items are drained, in the event the
+	 * device is re-opened instead of released.
+	 */
+	cancel_work_sync(&private->io_work);
+	cancel_work_sync(&private->crw_work);
+
 	vfio_ccw_unregister_dev_regions(private);
 }
 


