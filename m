Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46119446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAABC433C7;
	Sun, 13 Aug 2023 21:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962783;
	bh=+im8byIl+RMO+w3biTHnjEptTZ2eV+w0Yh+fcS+KPto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIdGQgEZNGGDXYk13U9RyMfk2jY2UyPdzVY2QL0gSN3/jdPGDOf4RL5wmtG/bGiKy
	 V5AIxWkiZBaV2IoD3Ia0EUyYxcfsuH20BO1RGdXaaZjGJaKU85ILUXCFmHT57Qlobr
	 M26IEbaLS5O4fnpRCdSpdLKmMKFkQ9wKoSpmeWSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 137/149] scsi: storvsc: Fix handling of virtual Fibre Channel timeouts
Date: Sun, 13 Aug 2023 23:19:42 +0200
Message-ID: <20230813211722.812313385@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Kelley <mikelley@microsoft.com>

commit 175544ad48cbf56affeef2a679c6a4d4fb1e2881 upstream.

Hyper-V provides the ability to connect Fibre Channel LUNs to the host
system and present them in a guest VM as a SCSI device. I/O to the vFC
device is handled by the storvsc driver. The storvsc driver includes a
partial integration with the FC transport implemented in the generic
portion of the Linux SCSI subsystem so that FC attributes can be displayed
in /sys.  However, the partial integration means that some aspects of vFC
don't work properly. Unfortunately, a full and correct integration isn't
practical because of limitations in what Hyper-V provides to the guest.

In particular, in the context of Hyper-V storvsc, the FC transport timeout
function fc_eh_timed_out() causes a kernel panic because it can't find the
rport and dereferences a NULL pointer. The original patch that added the
call from storvsc_eh_timed_out() to fc_eh_timed_out() is faulty in this
regard.

In many cases a timeout is due to a transient condition, so the situation
can be improved by just continuing to wait like with other I/O requests
issued by storvsc, and avoiding the guaranteed panic. For a permanent
failure, continuing to wait may result in a hung thread instead of a panic,
which again may be better.

So fix the panic by removing the storvsc call to fc_eh_timed_out().  This
allows storvsc to keep waiting for a response.  The change has been tested
by users who experienced a panic in fc_eh_timed_out() due to transient
timeouts, and it solves their problem.

In the future we may want to deprecate the vFC functionality in storvsc
since it can't be fully fixed. But it has current users for whom it is
working well enough, so it should probably stay for a while longer.

Fixes: 3930d7309807 ("scsi: storvsc: use default I/O timeout handler for FC devices")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1690606764-79669-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/storvsc_drv.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1670,10 +1670,6 @@ static int storvsc_host_reset_handler(st
  */
 static enum blk_eh_timer_return storvsc_eh_timed_out(struct scsi_cmnd *scmnd)
 {
-#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
-	if (scmnd->device->host->transportt == fc_transport_template)
-		return fc_eh_timed_out(scmnd);
-#endif
 	return BLK_EH_RESET_TIMER;
 }
 


