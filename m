Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D645119049B;
	Mon, 23 Jun 2025 21:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715650; cv=none; b=nJFQ0MiaBgk+sZu9L6dFQvamiYL/nLDTXkU6SekRW9oWkWutD4B1LWU2vT8i4lTvtv5oe94I2hbjiRjjSEuBlfVG1qMByxgizWzbQVMBlVmB2FwC2XQvCORYy2QU/xis1+iW6q4sf5h8SmVfZHPltY+CRcRG5/bp8RUrab82xjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715650; c=relaxed/simple;
	bh=4ltBQJwblXA0q2YQKypRf/mIeuQQleayDS2VVM2UmFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZKMwtOrCffeqAeHK41+/8d8NGuhyxx+8P+x1WaHhd2WL7ZSBe6iEWOhcAPZFY+y68YEi36nep8TPcCCPj9PRWepA5ohRrgS0wgDaPGIEdCyLKz6p/JfguYVWDbzIPKhNuZONHNlTQxBGNUeVZoR6h8WnjhLgnFio1nDWfqZ4h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01vR6ar1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01vR6ar1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70565C4CEEA;
	Mon, 23 Jun 2025 21:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715650;
	bh=4ltBQJwblXA0q2YQKypRf/mIeuQQleayDS2VVM2UmFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=01vR6ar1EF6iQg2gDrh9ujAx7DKhbpRJElZoZxvrNGrC4PJbd5/F//E660lt98ZT2
	 uXIo/IGhEvn458Bek8WmY77ghvdoipGLv5MP9dbDK76F7eHjjUYnnw/q0Pv3oC4lMp
	 KEcsriJRLzqOr+sZMYjazzl1hjHySn9g+CmGii1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	M Nikhil <nikh1092@linux.ibm.com>,
	Nihar Panda <niharp@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 288/355] scsi: s390: zfcp: Ensure synchronous unit_add
Date: Mon, 23 Jun 2025 15:08:09 +0200
Message-ID: <20250623130635.432262617@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit 9697ca0d53e3db357be26d2414276143c4a2cd49 upstream.

Improve the usability of the unit_add sysfs attribute by ensuring that
the associated FCP LUN scan processing is completed synchronously.  This
enables configuration tooling to consistently determine the end of the
scan process to allow for serialization of follow-on actions.

While the scan process associated with unit_add typically completes
synchronously, it is deferred to an asynchronous background process if
unit_add is used before initial remote port scanning has completed.  This
occurs when unit_add is used immediately after setting the associated FCP
device online.

To ensure synchronous unit_add processing, wait for remote port scanning
to complete before initiating the FCP LUN scan.

Cc: stable@vger.kernel.org
Reviewed-by: M Nikhil <nikh1092@linux.ibm.com>
Reviewed-by: Nihar Panda <niharp@linux.ibm.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Nihar Panda <niharp@linux.ibm.com>
Link: https://lore.kernel.org/r/20250603182252.2287285-2-niharp@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/scsi/zfcp_sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -450,6 +450,8 @@ static ssize_t zfcp_sysfs_unit_add_store
 	if (kstrtoull(buf, 0, (unsigned long long *) &fcp_lun))
 		return -EINVAL;
 
+	flush_work(&port->rport_work);
+
 	retval = zfcp_unit_add(port, fcp_lun);
 	if (retval)
 		return retval;


