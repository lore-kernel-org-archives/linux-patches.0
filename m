Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B613FB1B;
	Mon, 23 Jun 2025 21:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715773; cv=none; b=uxbJe1VgMZ97ymPKNkJlC9TZ91jY4FIESCqGsHXYOYcGAuo7wOfeQx9XGF9sxEvSRBbkIBntHjymL3twYuBl0IfmhyGJKALj+bwAx0caXINq42CXB1VVCergFY2Hn0IW+3MPMVSrILzaHT3PXox6k8Tp9jZFVNhWxaO26IK295Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715773; c=relaxed/simple;
	bh=2NWD/f368jNiEthahlyNJcUi3X/KqshjhN0FwP0XE8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQ43/4hCL+dkJb3VPaK6L8JT1aiqgwpYScy/O7hEiJk+X/EaXOtSAX8oIr4yOh5TNHlKBoncCaTqkUfkalEr+9TyV52H+hDVSMUPDrS5EF6q8hqtX4grcY//AiketjyHubcA9seqgrZTfaizCHeAAUOqk0cd5gOdDgBUenIPuhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1U/bNnj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1U/bNnj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC904C4CEEA;
	Mon, 23 Jun 2025 21:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715773;
	bh=2NWD/f368jNiEthahlyNJcUi3X/KqshjhN0FwP0XE8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1U/bNnj2/cjHjclm+66l3JVoh81YU+9XU5YcBHZEz6kF5gbhPadd+Z8L7f3wC59Ty
	 lBFaYMFfPDMPcm9h4C2pxLJw9SGI1ToUoAjlXZMCF1+QwSgoPnpTwu00HMEjtisXU8
	 7zmrnrvgmwKUPwSQkBUnnrHC5dSSUZGoflc+MJiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	M Nikhil <nikh1092@linux.ibm.com>,
	Nihar Panda <niharp@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 220/290] scsi: s390: zfcp: Ensure synchronous unit_add
Date: Mon, 23 Jun 2025 15:08:01 +0200
Message-ID: <20250623130633.545777897@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


