Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A752F28FC;
	Sat, 12 Sep 2026 14:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221994; cv=none; b=F3V7r34dOJO937Zg9QJeSi0xYUZ+lz7AsyJ73yz/cf+SNfN6oCniPSsR1+/8JwFhtj7y0aQMFkkIxoiHHQSUfTTXmQaJ0kxXfZHpKAqBlluO7rIUre6krxWkPf1IDXyYEG/dzHc5G2ymBwdjL8CFfBT0uxegjPCKHKJ5gpIDqSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221994; c=relaxed/simple;
	bh=rDpTqmBcAK7uUMn4s+OPmEmhDla9+PvXp4N5fIFmeVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLutRGzZ0LCN3ig5PM3mAzlt4SIhbsoBMMTlKNPhiXvSIIHX+qthwV5yqjiKMZQ6PZPFxTRgB8IIOlP+gqjlcWNYvzd9VUGeqCdPgtgVLrerHoiKM/2YBUcCTYlk1DuyddLv6Sd3ThROwmkF9rG2rtMhM0B8HcrBIZTHFqltpgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6JJ3VSz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6JJ3VSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC361F000FF;
	Sat, 12 Sep 2026 14:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221992;
	bh=Wc6inQmwsGmCyp8EgtXfkedqTwTQCLsa/VbNL/F8rR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6JJ3VSzmqHL2KvNT61WgN5VmJrajKT8zzhBSjrQu+RC3XeupPk7VEwMF+tk5jWOV
	 F2u6FncouO0J1KaOoyG9fu0lA2O90MMX+QQSW8i/aMNM7eUA4hXUxukhBDWnplycQ6
	 m0IvuEe50Gd+AF6pgwzfqg1EJ1k7+zJuH64BQ05U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 0497/1424] scsi: qla2xxx: Hold vport_slock for host map update in report ID acquisition
Date: Sat, 12 Sep 2026 08:48:49 +0200
Message-ID: <20260912065618.421907028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4157,7 +4157,9 @@ qla24xx_report_id_acquisition(scsi_qla_h
 			if (!found)
 				return;
 
+			spin_lock_irqsave(&ha->vport_slock, flags);
 			qla_update_host_map(vp, id);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 			/*
 			 * Cannot configure here as we are still sitting on the


