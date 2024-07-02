Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33321BD51B;
	Tue,  2 Jul 2024 17:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940003; cv=none; b=L1J/tl+K3VZZb1t6ngfgD7vIkFpLRJ+IzKO8vc1IBJWxFbQprDYaxTXa4i418GiTiKphkMI7Ql63bfSSQ8Gof/sqM0vfpAs/TZW0DyAkpDXJGquwgUBO7i9cYB5ia9uHIJnCA/Lb2g+Cb/XEbjdZvKBCIKERfKyLJILL78gbDsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940003; c=relaxed/simple;
	bh=w4iqkxGd3bOOiGzDH9v/APCfXUQ0FMUi1qfmcJa8pI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmvFfHopwWdszocwb0l4ThnGRA3q69h/vTlPXJGRCUuCQTiMf3PJLQvWWBW0mRJNr4wTnG39fSDJJ6v1BxB2QHMeq5Kum7eCFlv4iKjextaVWCsDlKVDGgWlU2sBlC460ujbObVcaBOMOIihB86Yh8d2mQK1nPUfDkYSUfUMZl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SUx1CiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SUx1CiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE094C116B1;
	Tue,  2 Jul 2024 17:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940003;
	bh=w4iqkxGd3bOOiGzDH9v/APCfXUQ0FMUi1qfmcJa8pI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SUx1CiRAG9relAG/s4X45HsnJJKfNZjQkFJ0jSN05NbwkgM/tySKM5w91nViM+8d
	 gIQKYYW12fI5l3XuHFYNFjXaHRYi7cY95igpMSa8BQkQeXROPOsaZA+u+7u9ey7sN6
	 x0AtUXKa2zysjQN4teHdZaQWBJSiSFNfPxM1rb0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqiao Fu <bfu@redhat.com>,
	Sebastian Mitterle <smitterl@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 024/222] s390/virtio_ccw: Fix config change notifications
Date: Tue,  2 Jul 2024 19:01:02 +0200
Message-ID: <20240702170244.902497233@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit d8354a1de2c4cc693812f6130fc922537a59217d ]

Commit e3e9bda38e6d ("s390/virtio_ccw: use DMA handle from DMA API")
broke configuration change notifications for virtio-ccw by putting the
DMA address of *indicatorp directly into ccw->cda disregarding the fact
that if !!(vcdev->is_thinint) then the function
virtio_ccw_register_adapter_ind() will overwrite that ccw->cda value
with the address of the virtio_thinint_area so it can actually set up
the adapter interrupts via CCW_CMD_SET_IND_ADAPTER.  Thus we end up
pointing to the wrong object for both CCW_CMD_SET_IND if setting up the
adapter interrupts fails, and for CCW_CMD_SET_CONF_IND regardless
whether it succeeds or fails.

To fix this, let us save away the dma address of *indicatorp in a local
variable, and copy it to ccw->cda after the "vcdev->is_thinint" branch.

Fixes: e3e9bda38e6d ("s390/virtio_ccw: use DMA handle from DMA API")
Reported-by: Boqiao Fu <bfu@redhat.com>
Reported-by: Sebastian Mitterle <smitterl@redhat.com>
Closes: https://issues.redhat.com/browse/RHEL-39983
Tested-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Link: https://lore.kernel.org/r/20240611214716.1002781-1-pasic@linux.ibm.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/virtio/virtio_ccw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index d7569f3955591..d6491fc84e8c5 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -698,6 +698,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	dma64_t *indicatorp = NULL;
 	int ret, i, queue_idx = 0;
 	struct ccw1 *ccw;
+	dma32_t indicatorp_dma = 0;
 
 	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw), NULL);
 	if (!ccw)
@@ -725,7 +726,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	*/
 	indicatorp = ccw_device_dma_zalloc(vcdev->cdev,
 					   sizeof(*indicatorp),
-					   &ccw->cda);
+					   &indicatorp_dma);
 	if (!indicatorp)
 		goto out;
 	*indicatorp = indicators_dma(vcdev);
@@ -735,6 +736,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			/* no error, just fall back to legacy interrupts */
 			vcdev->is_thinint = false;
 	}
+	ccw->cda = indicatorp_dma;
 	if (!vcdev->is_thinint) {
 		/* Register queue indicators with host. */
 		*indicators(vcdev) = 0;
-- 
2.43.0



