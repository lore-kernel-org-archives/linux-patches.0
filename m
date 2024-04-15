Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0773A762FF;
	Mon, 15 Apr 2024 14:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191034; cv=none; b=QiU2SdR52L95rPeERtJHBELkX8GLiUE+Li6XQv7Dvma3kfwoFsreHRGDL0GV9gGmuB0BEHwEjSRIOmSWtY3XcvOVe1PDpBtCB+/FPC4PXbha2Osx6yz9NW0uG2IgZ1RjcZGT6fs3vSgjxELt3NbdAktPfpiCf4xcZkEkDYSL1AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191034; c=relaxed/simple;
	bh=Fw0GsefvYHmKQq+ij2SPO1c0B+ABNOcZZw1a5Z5+q4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8q+lI20+1NSquO4g2kR/kVvgnU4zR2vEGLZpwAqm6Y9M8/r1MbBt6pfbqhIJurc+5aqVNMO2VTolyL2CGRlVpoURptIhz8436dTogBTwgEoOl7kyRZJvisHLIughNG/UjyqXvinI0j+ewsR+dqb112w4sg5rC/o2A5DycfkCB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHpd2zL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHpd2zL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C01C2BD11;
	Mon, 15 Apr 2024 14:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191033;
	bh=Fw0GsefvYHmKQq+ij2SPO1c0B+ABNOcZZw1a5Z5+q4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHpd2zL6HuPzjDp+hPXOPSwJlYy4s6/hUzlqX5zZKfLWL4/Yyj+fmiZea6p9tKMgr
	 mzdZbsgSNZkFJWs0iYDLqcOKiGxQMNxRx/0Hm17F1+jMQ0ECBrPowF+251Abu7sLTc
	 /MYpimPNmLMcsehoyw9PMObW/O2iQ+xfADMMEGfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.8 003/172] ata: libata-scsi: Fix ata_scsi_dev_rescan() error path
Date: Mon, 15 Apr 2024 16:18:22 +0200
Message-ID: <20240415142000.079749071@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4745,7 +4745,7 @@ void ata_scsi_dev_rescan(struct work_str
 			 * bail out.
 			 */
 			if (ap->pflags & ATA_PFLAG_SUSPENDED)
-				goto unlock;
+				goto unlock_ap;
 
 			if (!sdev)
 				continue;
@@ -4758,7 +4758,7 @@ void ata_scsi_dev_rescan(struct work_str
 			if (do_resume) {
 				ret = scsi_resume_device(sdev);
 				if (ret == -EWOULDBLOCK)
-					goto unlock;
+					goto unlock_scan;
 				dev->flags &= ~ATA_DFLAG_RESUMING;
 			}
 			ret = scsi_rescan_device(sdev);
@@ -4766,12 +4766,13 @@ void ata_scsi_dev_rescan(struct work_str
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


