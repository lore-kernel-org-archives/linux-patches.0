Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697E71DE8BE;
	Tue, 26 Aug 2025 14:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217445; cv=none; b=MGZdNPTRKwyCi/tV29czpttH85aq12bqDmkogAUTi/ylujS+dLA6eV7XcP5N02N4JNbV1b67YDQhjcEHtYi5BJ+F1GUQPJje1SDm+YxHTtRN2VOT/GVpDz2IXv/Wc+h0OD/rmvMDK8ZEvAXvQsc6kBM0RU561LYi6ON6hh/d6K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217445; c=relaxed/simple;
	bh=URbDu4VSppy4Jj9AhI471FLY5m+uHxWAp70/FFrS3gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4ggjPM7/L3UXdkvz236fjnoPIkbke4cANbJUpuFYcLL3NIwAIZhcDSxsT79R0aQMtiC3jLwp39g5ipeynH8hgV2eAhDHhVM3WPR7ALxKUNOyA8E+u90H1gNNQpXAcaxk017yU9eQKtWaiGASMcmzR7C4OX1sXHRBH2++mkKue8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8bdzWWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8bdzWWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65E9C19421;
	Tue, 26 Aug 2025 14:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217445;
	bh=URbDu4VSppy4Jj9AhI471FLY5m+uHxWAp70/FFrS3gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8bdzWWdeR3J71MUGg4Zi2ZjYa7k6MbVCjvvAs2EQ6AUm+omLgIC6EbMtdSJF9gBe
	 q28gGr3utBUAdk94xgyuDp31OLCdfPr0a04eElP3hBrPN9+plkkdBp6mfumKg+DxNI
	 8GrHPhLd2oBG6G3x+GxCpkjNvKT2DaNBMIHdqDGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/523] vhost-scsi: Fix log flooding with target does not exist errors
Date: Tue, 26 Aug 2025 13:05:56 +0200
Message-ID: <20250826110928.090187812@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 69cd720a8a5e9ef0f05ce5dd8c9ea6e018245c82 ]

As part of the normal initiator side scanning the guest's scsi layer
will loop over all possible targets and send an inquiry. Since the
max number of targets for virtio-scsi is 256, this can result in 255
error messages about targets not existing if you only have a single
target. When there's more than 1 vhost-scsi device each with a single
target, then you get N * 255 log messages.

It looks like the log message was added by accident in:

commit 3f8ca2e115e5 ("vhost/scsi: Extract common handling code from
control queue handler")

when we added common helpers. Then in:

commit 09d7583294aa ("vhost/scsi: Use common handling code in request
queue handler")

we converted the scsi command processing path to use the new
helpers so we started to see the extra log messages during scanning.

The patches were just making some code common but added the vq_err
call and I'm guessing the patch author forgot to enable the vq_err
call (vq_err is implemented by pr_debug which defaults to off). So
this patch removes the call since it's expected to hit this path
during device discovery.

Fixes: 09d7583294aa ("vhost/scsi: Use common handling code in request queue handler")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20250611210113.10912-1-michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index fcde3752b4f1..6956b4e0b9be 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -927,10 +927,8 @@ vhost_scsi_get_req(struct vhost_virtqueue *vq, struct vhost_scsi_ctx *vc,
 			/* validated at handler entry */
 			vs_tpg = vhost_vq_get_backend(vq);
 			tpg = READ_ONCE(vs_tpg[*vc->target]);
-			if (unlikely(!tpg)) {
-				vq_err(vq, "Target 0x%x does not exist\n", *vc->target);
+			if (unlikely(!tpg))
 				goto out;
-			}
 		}
 
 		if (tpgp)
-- 
2.39.5



