Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BF4224B1F;
	Mon, 23 Jun 2025 22:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717546; cv=none; b=ny91E7/Y14eSaCrXRIJRX0xm6IC8mw99+wXDn04PGfONNJPFEB37NNQmRCU/PyZsk6wM2S2wVsFUzynQvB89Q4t6/EOLG7udIDPSTJHg2QgLhbZ0FntqJRyWY9eoktHE8qybg3b/5T/T+EEpPiU5XuWfxPR5dM21g/DK4Qm44WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717546; c=relaxed/simple;
	bh=G6eFs3bscI3n55CppDBs1sWBW3Wo69ZKtdtlNwI7TFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6P8OYWQKuwPLb4H1hrEujvf7qS3u5T8ugVet8hTUadJGBYra/PmEIpu/G0+4NJ9T4JsdjUhi1f5YDkWbRjLNx7+pFtKSTqgAcz1aoy+tRYcgdR33SXU9+soC9AkLAQi4Smea4/N1wqHfmEpNQX2FAiS3RVtl4gJ/ZxPhGFkHFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAUjUkS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAUjUkS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636A0C4CEEA;
	Mon, 23 Jun 2025 22:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717545;
	bh=G6eFs3bscI3n55CppDBs1sWBW3Wo69ZKtdtlNwI7TFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAUjUkS/A/0xCKkMsFUtx7QE+eE4Ds/KjusZCKW4RxP6z2lmAoDfNLYX5a4EodsTE
	 nmjIsfi6QVDcJQRnWKmfSEBm5MqbRIgPFgyjkueBNtsXgPMrCtwFSNLBeiOPKS6+J2
	 4rFmhPuDrRA6Ep+hGz7RWmOcGUekWR3RiQl9oHpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	M Nikhil <nikh1092@linux.ibm.com>,
	Nihar Panda <niharp@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 450/508] scsi: s390: zfcp: Ensure synchronous unit_add
Date: Mon, 23 Jun 2025 15:08:15 +0200
Message-ID: <20250623130656.222510808@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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


