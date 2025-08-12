Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B42221FAC;
	Tue, 12 Aug 2025 17:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020876; cv=none; b=k4KjjJT48aFGetufpCSzjaPfA/OgRQXbO1UIMI5ghZ22kXwJD85fBqPZJU7kRbfQVoQkzpbwbiuavUCWA8ji22SFWTPHT7op4QPHYYQqtzXxOI/rJKEi1KD/nMEacAdsDgPCnq0e2fUBLNRLdOn9DDML+0MnwE/JaVto0e8R0WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020876; c=relaxed/simple;
	bh=1WoYnugmbp6iWRHxZthgA83odREM1UMh2X1EAlOIJYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hcw4dCsLWr3jYZX5YkPYGNEP1aWrvw9/helVW4J8HsAiOiOn45CHImO4HMIDZiUpzpVF/NaktjyAiGKfcHxsrTLPi1wpytoha1ZyKnh0O28Kfn/gIGEV+xGW6h7T32uNWy9tseSP8GYQsPGECmThLheLz81jTLi1+tojT+T6bZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/kNBYjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/kNBYjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEC7C4CEF0;
	Tue, 12 Aug 2025 17:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020876;
	bh=1WoYnugmbp6iWRHxZthgA83odREM1UMh2X1EAlOIJYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/kNBYjge+mcOChMX9y+GoUZe/eJB5POWkLIIp/eyEmfiVv10pCvUvZgMt6iTwGsD
	 3xrXxB6HyGyrKptcR/7DAKmcK0iqv6oIDL7YUZ8ql8MReYDoRkmiTXVDWGqTEH51Lx
	 un0ZBjIzpFGAMHqnZk4pk+t5XugFIm1FL29699us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/253] vhost-scsi: Fix log flooding with target does not exist errors
Date: Tue, 12 Aug 2025 19:29:29 +0200
Message-ID: <20250812172956.467668062@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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
index 87f2f56fd20a..de6f108a50a9 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -913,10 +913,8 @@ vhost_scsi_get_req(struct vhost_virtqueue *vq, struct vhost_scsi_ctx *vc,
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



