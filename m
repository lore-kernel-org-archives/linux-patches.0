Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF60762E0;
	Mon, 15 Apr 2024 14:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191926; cv=none; b=qg6kH93ja8fqwv6HchkEVJDX5dyUl09tMO/CWCsVq+/heso48bzI9EGImSvwRnBTynOXOBhxuRcCDdj1GdPZaNDmzlmfEW77CTDaKi4owX3gmwfKnnpeLzh8RpoM962tQN5ZYF3HA/1u9/NhOFlcji1w77cwzBXRlFPlVpuGSeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191926; c=relaxed/simple;
	bh=6FoFArPLSuLafYOgRc7yhRjNiQbkWkWPFyVV7ou2KYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isqfWt9bie/5NpTL8CAu1ECpeEenC83oSK4TX2/kxKxM+VVHHgJ7Ekerw7nuG5bIIsLgv0Pe1D0WLfyeUYHXAea8qlrVuQZDrlsng090TGsmgJn9J9zNWrSyuaLz96jELYpVgHMPD4lO0moUudCfMD+dNHYHbJlYrXyEGqlG0z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmPIyPks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmPIyPks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27510C113CC;
	Mon, 15 Apr 2024 14:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191926;
	bh=6FoFArPLSuLafYOgRc7yhRjNiQbkWkWPFyVV7ou2KYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmPIyPksDPnG28/g+oY4uZMBVEjKMxfjWqW/CeXtkHJEay6uduaiJL0W1pk1YvYp1
	 g3m0zU7l7uyHNXzH0X5wK1DILS4cF0mCO+xkVx4+S2sr3VGwVG40LkNg09Ej9e46WS
	 1xOfQQCEZfF9uit8wEWChto3ABrVXDGLbhh+rhdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.1 02/69] ata: libata-scsi: Fix ata_scsi_dev_rescan() error path
Date: Mon, 15 Apr 2024 16:20:33 +0200
Message-ID: <20240415141946.242468089@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 79336504781e7fee5ddaf046dcc186c8dfdf60b1 upstream.

Commit 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
incorrectly handles failures of scsi_resume_device() in
ata_scsi_dev_rescan(), leading to a double call to
spin_unlock_irqrestore() to unlock a device port. Fix this by redefining
the goto labels used in case of errors and only unlock the port
scsi_scan_mutex when scsi_resume_device() fails.

Bug found with the Smatch static checker warning:

	drivers/ata/libata-scsi.c:4774 ata_scsi_dev_rescan()
	error: double unlocked 'ap->lock' (orig line 4757)

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4667,7 +4667,7 @@ void ata_scsi_dev_rescan(struct work_str
 			 * bail out.
 			 */
 			if (ap->pflags & ATA_PFLAG_SUSPENDED)
-				goto unlock;
+				goto unlock_ap;
 
 			if (!sdev)
 				continue;
@@ -4680,7 +4680,7 @@ void ata_scsi_dev_rescan(struct work_str
 			if (do_resume) {
 				ret = scsi_resume_device(sdev);
 				if (ret == -EWOULDBLOCK)
-					goto unlock;
+					goto unlock_scan;
 				dev->flags &= ~ATA_DFLAG_RESUMING;
 			}
 			ret = scsi_rescan_device(sdev);
@@ -4688,12 +4688,13 @@ void ata_scsi_dev_rescan(struct work_str
 			spin_lock_irqsave(ap->lock, flags);
 
 			if (ret)
-				goto unlock;
+				goto unlock_ap;
 		}
 	}
 
-unlock:
+unlock_ap:
 	spin_unlock_irqrestore(ap->lock, flags);
+unlock_scan:
 	mutex_unlock(&ap->scsi_scan_mutex);
 
 	/* Reschedule with a delay if scsi_rescan_device() returned an error */


