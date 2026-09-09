Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AE8568FA3;
	Wed,  9 Sep 2026 14:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962875; cv=none; b=ey/jwzkVDThfWeJeCtPNpwQFZoKmoDfAAcJkJC8tIch2YWzaJOv65+uXw3SFA9QGG0doUFb3L4N9/2nR1WqyL7yPXSFr7yIOwXRavRECLn77zmf+kMCG8zvbfiPjGlWkFGt0iEk/Ump53hxMVi/ensxHEK5ocBQkZGwagg2qPq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962875; c=relaxed/simple;
	bh=iXN7YW5D8LWiG8hC4mTdS9Eow8S64Ltzh+6X+VAyVe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6zcLDOKM4GR4tk80p3ChKXAxn5NHW/eZ9KOrhWPKKzZA0mjU1cZP4XPiPcgHbSdCmGKDcCnUAUgv3YtGdyWehqOeLYcq6/zAQdjVzH+Upu2G/2KWtYX7ANZVW6ig8D3ubc8pprOkEZF8cLD6t5r+XjJAPa2IG6lXYKsLMZR5lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQbQLmG4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQbQLmG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509851F00A3A;
	Wed,  9 Sep 2026 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962873;
	bh=U7HxmMnqm08C0sFaGkt+htGLqq1B6uB6fY9LjfNJ6f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQbQLmG4kIlJ5IFT9NYYnr1fDntBajzAFiHfdwn0m+oY8edPsLgYHuB/GUJqdTYKP
	 MF3xdart3mPHrgCE92NqjplxblHN7/6PVzuPx4WfcEI2o3CvX05reUNR2M9yVoi4FP
	 kTjci9DyL4FUH+njYZMgtRmGEc1Pfv5t14MIq2tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 442/556] scsi: qla2xxx: Hold vport_slock for host map update in report ID acquisition
Date: Wed,  9 Sep 2026 15:42:02 +0200
Message-ID: <20260909134246.152312729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit 7944039ba9cb5c3a935d17c91004e3b8649ff58e upstream.

qla24xx_report_id_acquisition() format-1 handling drops vport_slock after
taking the vport reference and then calls qla_update_host_map() without
the lock. That reaches qla_update_vp_map(), which mutates the ha->host_map
btree via btree_insert32()/btree_update32()/btree_remove32() and is
documented to require vport_slock to be held by the caller. Running it
unlocked can race concurrent host_map updates and corrupt the btree.

The format-2 path in the same function already wraps its host_map update
(SET_AL_PA) in vport_slock; the format-1 path is the lone outlier.

Hold vport_slock across the format-1 qla_update_host_map() call to honor
the documented locking contract. The vref_count taken in the loop keeps
the vport valid, so this only adds the missing host_map serialization.

Fixes: 430eef03a763 ("scsi: qla2xxx: Relocate/rename vp map")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-24-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4214,7 +4214,9 @@ qla24xx_report_id_acquisition(scsi_qla_h
 			if (!found)
 				return;
 
+			spin_lock_irqsave(&ha->vport_slock, flags);
 			qla_update_host_map(vp, id);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 			/*
 			 * Cannot configure here as we are still sitting on the


