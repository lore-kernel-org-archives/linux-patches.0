Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BBEBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81021C433EF;
	Tue,  7 Mar 2023 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209778;
	bh=elTlS6OZ8Q7sYaextTko3o/z7ZV4jcPULcHMeR8P0xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6nUeesPgr3Ilp3+e9yqzIGvHQk2N4TzvwaY5BFsMMMSRzeq2Ct6h3SPaE7DhxNlk
	 mHB+pNYmW9USSf8o1ok0a7ntObTrMNdx3sDz1jfQRjdhzky1RblnvwZFqjka+Grkwq
	 Aaibrjn5QGOaGI4hSeS3vpjSvvAUA+PFCv36iSjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Farman <farman@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0297/1001] vfio/ccw: remove WARN_ON during shutdown
Date: Tue,  7 Mar 2023 17:51:09 +0100
Message-Id: <20230307170034.473437171@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 1c06bb87afb2d95b8e9f4f2e3d0d6772c68f3e76 ]

The logic in vfio_ccw_sch_shutdown() always assumed that the input
subchannel would point to a vfio_ccw_private struct, without checking
that one exists. The blamed commit put in a check for this scenario,
to prevent the possibility of a missing private.

The trouble is that check was put alongside a WARN_ON(), presuming
that such a scenario would be a cause for concern. But this can be
triggered by binding a subchannel to vfio-ccw, and rebooting the
system before starting the mdev (via "mdevctl start" or similar)
or after stopping it. In those cases, shutdown doesn't need to
worry because either the private was never allocated, or it was
cleaned up by vfio_ccw_mdev_remove().

Remove the WARN_ON() piece of this check, since there are plausible
scenarios where private would be NULL in this path.

Fixes: 9e6f07cd1eaa ("vfio/ccw: create a parent struct")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Link: https://lore.kernel.org/r/20230210174227.2256424-1-farman@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 54aba7cceb33f..ff538a086fc77 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -225,7 +225,7 @@ static void vfio_ccw_sch_shutdown(struct subchannel *sch)
 	struct vfio_ccw_parent *parent = dev_get_drvdata(&sch->dev);
 	struct vfio_ccw_private *private = dev_get_drvdata(&parent->dev);
 
-	if (WARN_ON(!private))
+	if (!private)
 		return;
 
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
-- 
2.39.2



